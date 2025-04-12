//
//  BreedCharacteristicsView.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 8/04/25.
//

import SwiftUI

struct BreedCharacteristicsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel: BreedCharacteristicsViewModel

    init(breed: Breed) {
        _viewModel = StateObject(wrappedValue: BreedCharacteristicsViewModel(breed: breed))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Características de la Raza")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .opacity(viewModel.isLoaded ? 1 : 0)
                    .offset(y: viewModel.isLoaded ? 0 : 10)

                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.showExplanation.toggle()
                        feedbackGenerator()
                    }
                }) {
                    Image(systemName: viewModel.showExplanation ? "xmark.circle.fill" : "info.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.secondary)
                        .font(.title3)
                        .scaleEffect(viewModel.showExplanation ? 1.1 : 1.0)
                }
                .opacity(viewModel.isLoaded ? 1 : 0)
                .offset(y: viewModel.isLoaded ? 0 : 10)
            }
            .padding(.bottom, 2)
            
            if viewModel.showExplanation {
                HStack {
                    Text("Más huellas rosadas = mayor nivel. Toca para ver detalles.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 16) {
                    ForEach(viewModel.categoryGroups, id: \.0) { category, characteristics in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: category == "Socialización" ? "person.2.fill" :
                                        category == "Cuidados" ? "heart.fill" : "brain.head.profile")
                                .foregroundColor(colorForCategory(category))
                                
                                Text(category)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(colorForCategory(category))
                            }
                            .padding(.leading, 8)
                            .opacity(viewModel.isLoaded ? 1 : 0)
                            .offset(y: viewModel.isLoaded ? 0 : 10)

                            ForEach(characteristics, id: \.self) { characteristic in
                                characteristicRow(
                                    title: characteristic,
                                    value: viewModel.getValue(for: characteristic),
                                    category: category
                                )
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        if viewModel.selectedCharacteristic == characteristic {
                                            viewModel.selectedCharacteristic = nil
                                        } else {
                                            viewModel.selectedCharacteristic = characteristic
                                            feedbackGenerator()
                                        }
                                    }
                                }
                                
                                if viewModel.selectedCharacteristic == characteristic {
                                    Text(viewModel.explanations[characteristic] ?? "")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)
                                        .padding(.bottom, 6)
                                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.tertiarySystemBackground))
                                .shadow(color: colorForCategory(category).opacity(0.1), radius: 3, x: 0, y: 2)
                        )
                        .opacity(viewModel.isLoaded ? 1 : 0)
                        .offset(y: viewModel.isLoaded ? 0 : 20)
                    }
                }
                .padding()
            }
            .opacity(viewModel.isLoaded ? 1 : 0)
            .offset(y: viewModel.isLoaded ? 0 : 20)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) {
                viewModel.isLoaded = true
            }
        }
    }

    private func characteristicRow(title: String, value: Int, category: String) -> some View {
        HStack {
            Image(systemName: viewModel.iconForCharacteristic(title))
                .foregroundColor(colorForCategory(category))
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { index in
                    PawPrintView(
                        isActive: index <= value,
                        color: colorForCategory(category),
                        index: index,
                        totalPaws: value
                    )
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
    
    private struct PawPrintView: View {
        let isActive: Bool
        let color: Color
        let index: Int
        let totalPaws: Int
        @State private var isAnimated = false
        
        var body: some View {
            Image(systemName: "pawprint.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 16))
                .foregroundColor(isActive ? color : Color.gray.opacity(0.3))
                .shadow(color: isActive ? color.opacity(0.3) : Color.clear,
                        radius: 2, x: 0, y: 1)
                .scaleEffect(isAnimated ? 1.0 : 0.5)
                .opacity(isAnimated ? 1.0 : 0.0)
                .onAppear {
                    let baseDelay = 0.1
                    let indexDelay = Double(index) * 0.1
                    
                    withAnimation(
                        .spring(response: 0.6, dampingFraction: 0.7)
                        .delay(baseDelay + indexDelay)
                    ) {
                        isAnimated = true
                    }
                }
        }
    }
    
    private func feedbackGenerator() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }


    func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Socialización": return Color(red: 1.0, green: 0.4, blue: 0.6)
        case "Cuidados": return Color(red: 0.6, green: 0.4, blue: 1.0)
        case "Personalidad": return Color(red: 1.0, green: 0.6, blue: 0.2)
        default: return Color.pink
        }
    }
}
