import Foundation
import UIKit

protocol PokemonListViewModelDelegate: AnyObject {
    func pokemonListDidUpdate()
    func pokemonListDidFail(with error: String)
    func navigateToPokemonDetail(with detailUrl: URL?)
}

class PokemonListViewModel {

    private var pokemons: [Pokemon] = [] {
        didSet {
            self.delegate?.pokemonListDidUpdate()
        }
    }

    weak var delegate: PokemonListViewModelDelegate?

    private let pokemonService: PokemonServiceProtocol

    init(pokemonService: PokemonServiceProtocol = PokemonAPIService()) {
        self.pokemonService = pokemonService
    }

    func fetchPokemons() {
        pokemonService.fetchPokemonList { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedPokemons):
                    self.pokemons = fetchedPokemons
                case .failure(let error):
                    print("ViewModel: Erro ao buscar Pokémon: \(error.localizedDescription)")
                    self.delegate?.pokemonListDidFail(with: error.localizedDescription)
                }
            }
        }
    }

    func didSelectPokemon(at indexPath: IndexPath) {
        guard indexPath.row >= 0 && indexPath.row < pokemons.count else { return }
        let selectedPokemon = pokemons[indexPath.row]

        delegate?.navigateToPokemonDetail(with: selectedPokemon.detailApiUrl)
    }

    func numberOfPokemons(in section: Int) -> Int {
        return pokemons.count
    }

    func pokemon(at indexPath: IndexPath) -> Pokemon? {
        guard indexPath.row >= 0 && indexPath.row < pokemons.count else { return nil }
        return pokemons[indexPath.row]
    }

    func getPokemonCellViewModel(at indexPath: IndexPath) -> PokemonCellViewModel? {
        guard let pokemon = pokemon(at: indexPath) else { return nil }
        
        return PokemonCellViewModel(pokemon: pokemon)
    }
}

struct PokemonCellViewModel {
    let name: String
    let number: String
    let imageUrl: String

    init(pokemon: Pokemon) {
        self.name = pokemon.name
        self.number = String(format: "#%03d", pokemon.number)
        self.imageUrl = pokemon.imageUrl
    }
}

extension PokemonType {
    func getLocalizedTitle() -> String {
        switch self {
        case .normal: return "Normal"
        case .fire: return "Fogo"
        case .water: return "Água"
        case .electric: return "Elétrico"
        case .grass: return "Planta"
        case .ice: return "Gelo"
        case .fighting: return "Lutador"
        case .poison: return "Venenoso"
        case .ground: return "Terrestre"
        case .flying: return "Voador"
        case .psychic: return "Psíquico"
        case .bug: return "Inseto"
        case .rock: return "Pedra"
        case .ghost: return "Fantasma"
        case .dragon: return "Dragão"
        case .dark: return "Sombrio"
        case .steel: return "Aço"
        case .fairy: return "Fada"
        }
    }

    func uiColor() -> UIColor {
        switch self {
        case .normal:   return UIColor(hex: "#A8A77A")
        case .fire:     return UIColor(hex: "#EE8130")
        case .water:    return UIColor(hex: "#6390F0")
        case .electric: return UIColor(hex: "#F7D02C")
        case .grass:    return UIColor(hex: "#7AC74C")
        case .ice:      return UIColor(hex: "#96D9D6")
        case .fighting: return UIColor(hex: "#C22E28")
        case .poison:   return UIColor(hex: "#A33EA1")
        case .ground:   return UIColor(hex: "#E2BF65")
        case .flying:   return UIColor(hex: "#A98FF3")
        case .psychic:  return UIColor(hex: "#F95587")
        case .bug:      return UIColor(hex: "#A6B91A")
        case .rock:     return UIColor(hex: "#B6A136")
        case .ghost:    return UIColor(hex: "#735797")
        case .dragon:   return UIColor(hex: "#6F35FC")
        case .dark:     return UIColor(hex: "#705746")
        case .steel:    return UIColor(hex: "#B7B7CE")
        case .fairy:    return UIColor(hex: "#D685AD")
        }
    }
}
