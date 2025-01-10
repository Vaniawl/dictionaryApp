//
//  HeaderView.swift
//  dictionaryApp
//
//  Created by Ivan Dovhosheia on 10.01.25.
//

import SwiftUI

struct SearchBarView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Пошуковий рядок
                    HStack {
                        HStack {
                            Image("Flag")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .clipShape(Circle())
                                .padding(8)
                            
                            TextField("Пошук", text: $viewModel.word)
                                .padding(1)
                                .onSubmit {
                                    Task {
                                        if !viewModel.word.isEmpty {
                                            await viewModel.searchWordData()
                                            navigationToDetails = true
                                        }
                                    }
                                }
                        }
                        .background(Color.gray.opacity(0.12))
                        .cornerRadius(34)
                        
                        Button("Скасувати") {
                            viewModel.word = ""
                            navigationToDetails = false
                        }
                        .padding(.trailing)
                    }
                    .padding()
                    
                    NavigationLink(
                        destination: DefinitionWordWindow(
                            viewModel: viewModel,
                            favorites: $favorites
                        ),
                        isActive: $navigationToDetails
                    ) {
                        EmptyView()
                    }
                    
                    // Синоніми
                    if !viewModel.synonyms.isEmpty {
                        HStack {
                            Text("Synonyms:")
                                .font(.headline)
                        }
                        
                        ForEach(viewModel.synonyms, id: \.self) { synonym in
                            HStack {
                                Text(synonym)
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        Task {
                                            await viewModel.searchSynonymData(for: synonym)
                                        }
                                    }
                                
                                Spacer()
                                
                                Button(action: {
                                    addToFavorites(word: synonym)
                                }) {
                                    Image(systemName: favorites.contains(synonym) ? "heart.fill" : "heart")
                                        .foregroundColor(favorites.contains(synonym) ? .red : .gray)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}


#Preview {
    SearchBarView()
}
