//
//  SearchBar.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 8/04/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    var suggestions: [BreedModel]
    
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 18, weight: .medium))
                
                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .padding(.vertical, 8)
                    .padding(.trailing, 10)
                    .background(Color.clear)
                    .onTapGesture {
                        isEditing = true
                        isFocused = true
                    }
                    .overlay(
                        HStack {
                            Spacer()
                            if !text.isEmpty {
                                Button(action: {
                                    text = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 4)
                                }
                            }
                        }
                    )
                
                if isEditing {
                    Button("Cancelar") {
                        withAnimation {
                            isEditing = false
                            isFocused = false
                            text = ""
                        }
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .foregroundColor(.accentColor)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemGray6).opacity(0.95))
                    .shadow(color: Color.blue.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            .animation(.easeInOut(duration: 0.25), value: isEditing)
            
            if isEditing && !text.isEmpty && !suggestions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(suggestions.prefix(5)) { breed in
                        Button(action: {
                            text = breed.name
                            isEditing = false
                            isFocused = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            HStack {
                                Image(systemName: "pawprint.fill")
                                    .foregroundColor(.accentColor)
                                    .padding(.trailing, 6)
                                Text(breed.name)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                        
                        if breed.id != suggestions.prefix(5).last?.id {
                            Divider().padding(.leading, 40)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                )
                .padding(.horizontal, 4)
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.25), value: suggestions)
            }
        }
        .padding(.horizontal)
    }
}
