//
//  PokemonListResponse.swift
//  Mentoria UIKit básico
//
//  Created by Eliardo Venancio on 04/06/25.
//

import Foundation
import UIKit

struct PokemonListResponse: Decodable {
    let results: [PokemonResponse]
}

struct PokemonResponse: Decodable {
    let name: String
    let pokemonUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case pokemonUrl = "url"
    }
    
    func toDomainModel() -> Pokemon {
        let number = pokemonUrl.extractPokemonNumber() ?? 0
        let pokemonImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(number).png"
        let url: URL? = URL(string: pokemonUrl)
         return Pokemon(
            name: name.capitalized,
            number: pokemonUrl.extractPokemonNumber() ?? 0,
            pokemonImage: pokemonImage,
            pokemonUrl: url
        )
    }
}

extension String {
    func extractPokemonNumber() -> Int? {
        let components = self.split(separator: "/")
        if let lastComponent = components.last, lastComponent.isEmpty, components.count > 1 {
            return Int(components[components.count - 2])
        } else if let lastComponent = components.last {
            return Int(lastComponent)
        }
        return nil
    }
}
