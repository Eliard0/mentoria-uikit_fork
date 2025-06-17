import Foundation

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let height: Double
    let weight: Double
    let types: [PokemonType]
    let imageUrl: String
    let moves: [PokemonMove]
    let stats: [PokemonStat]
}

struct PokemonMove: Decodable {
    let move: MoveInfo
}

struct MoveInfo: Decodable {
    let name: String
    let url: String
}

struct PokemonStat: Decodable {
    let base_stat: Int
    let effort: Int
    let stat: StatInfo
}

struct StatInfo: Decodable {
    let name: String
    let url: String
}
