import Foundation
// import UIKit // UIKit não é necessário neste arquivo, pois ele lida apenas com dados de rede

struct PokemonListResponse: Decodable {
    let results: [PokemonResponse]
}

struct PokemonResponse: Decodable {
    let name: String
    let url: String // Renomeado para 'url' para corresponder ao JSON da API

    private enum CodingKeys: String, CodingKey {
        case name
        case url = "url" // Mapeia "url" do JSON para a propriedade 'url'
    }

    // Mapeia o DTO (PokemonResponse) para o modelo de domínio (Pokemon)
    func toDomainModel() -> Pokemon {
        let number = url.extractPokemonNumber() ?? 0
        let pokemonImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(number).png"
        let detailApiUrl: URL? = URL(string: url) // Mapeia para o URL de detalhe no modelo de domínio

        return Pokemon(
            id: number, // O 'id' do modelo de domínio é o número do Pokémon
            name: name.capitalized,
            number: number,
            imageUrl: pokemonImageUrl, // Passando a propriedade imageUrl
            detailApiUrl: detailApiUrl // Passando a propriedade detailApiUrl
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
