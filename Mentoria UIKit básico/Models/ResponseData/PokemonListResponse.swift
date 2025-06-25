import Foundation

struct PokemonListResponse: Decodable {
    let results: [PokemonResponse]
}

struct PokemonResponse: Decodable {
    let name: String
    let url: String

    private enum CodingKeys: String, CodingKey {
        case name
        case url = "url"
    }

    func toDomainModel() -> Pokemon {
        let number = url.extractPokemonNumber() ?? 0
        let pokemonImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(number).png"
        let detailApiUrl: URL? = URL(string: url)

        return Pokemon(
            id: number,
            name: name.capitalized,
            number: number,
            imageUrl: pokemonImageUrl,
            detailApiUrl: detailApiUrl
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
