//
//  BreedCharacteristicsViewModel.swift
//  TheCatAPISwiftUI
//
//  Created by Jorge Luis Rivera Ladino on 11/04/25.
//

import Foundation

class BreedCharacteristicsViewModel: ObservableObject {
    let breed: Breed

    @Published var showExplanation = true
    @Published var selectedCharacteristic: String? = nil
    @Published var isLoaded = false

    init(breed: Breed) {
        self.breed = breed
    }

    let categoryGroups: [(String, [String])] = [
        ("Socialización", ["Amigable con Extraños", "Amigable con Perros", "Amigable con Niños", "Necesidades Sociales", "Nivel de Afecto"]),
        ("Cuidados", ["Aseo", "Nivel de Muda", "Problemas de Salud"]),
        ("Personalidad", ["Adaptabilidad", "Nivel de Energía", "Inteligencia"])
    ]

    func iconForCharacteristic(_ characteristic: String) -> String {
        switch characteristic {
        case "Adaptabilidad": return "arrow.triangle.2.circlepath"
        case "Nivel de Energía": return "bolt.fill"
        case "Necesidades Sociales": return "person.2.fill"
        case "Nivel de Muda": return "scissors"
        case "Problemas de Salud": return "heart.text.square"
        case "Amigable con Extraños": return "person.fill.questionmark"
        case "Amigable con Perros": return "dog.fill"
        case "Inteligencia": return "brain.head.profile"
        case "Amigable con Niños": return "figure.and.child.holdinghands"
        case "Aseo": return "comb.fill"
        case "Nivel de Afecto": return "heart.fill"
        default: return "pawprint.fill"
        }
    }

    let explanations: [String: String] = [
        "Adaptabilidad": "Facilidad con la que el gato se adapta a cambios en su entorno o rutina.",
        "Nivel de Energía": "Cantidad de actividad física y juego que necesita diariamente.",
        "Necesidades Sociales": "Cuánta atención e interacción requiere de sus humanos.",
        "Nivel de Muda": "Cantidad de pelo que pierde, especialmente en temporadas de muda.",
        "Problemas de Salud": "Predisposición genética a enfermedades o condiciones específicas.",
        "Amigable con Extraños": "Cómo reacciona ante personas desconocidas en su territorio.",
        "Amigable con Perros": "Tendencia a llevarse bien con perros u otras mascotas.",
        "Inteligencia": "Capacidad para aprender comandos, resolver problemas y adaptarse.",
        "Amigable con Niños": "Tolerancia y comportamiento alrededor de niños pequeños.",
        "Aseo": "Necesidad de cepillado, baños y otros cuidados estéticos.",
        "Nivel de Afecto": "Cuánto disfruta y busca las caricias y el afecto físico."
    ]

    func getValue(for characteristic: String) -> Int {
        switch characteristic {
        case "Adaptabilidad": return breed.adaptability ?? 0
        case "Nivel de Energía": return breed.energyLevel ?? 0
        case "Necesidades Sociales": return breed.socialNeeds ?? 0
        case "Nivel de Muda": return breed.sheddingLevel ?? 0
        case "Problemas de Salud": return breed.healthIssues ?? 0
        case "Amigable con Extraños": return breed.strangerFriendly ?? 0
        case "Amigable con Perros": return breed.dogFriendly ?? 0
        case "Inteligencia": return breed.intelligence ?? 0
        case "Amigable con Niños": return breed.childFriendly ?? 0
        case "Aseo": return breed.grooming ?? 0
        case "Nivel de Afecto": return breed.affectionLevel ?? 0
        default: return 0
        }
    }
}
