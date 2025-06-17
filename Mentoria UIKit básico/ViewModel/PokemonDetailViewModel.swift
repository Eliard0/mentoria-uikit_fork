import Foundation
import UIKit

protocol PokemonDetailViewModelDelegate: AnyObject {
    func pokemonDetailDidUpdate(viewModel: PokemonDetailDisplayData)
    func pokemonDetailDidFail(with error: String)
    func pokemonDetailLoadingStateChanged(isLoading: Bool)
}

struct PokemonDetailDisplayData {
    let name: String
    let number: String
    let imageUrl: String
    let height: String
    let weight: String
    let types: [PokemonTypeDisplayData]
    let moves: [String]
    let stats: [PokemonStatDisplayData]
}

struct PokemonTypeDisplayData {
    let title: String
    let color: UIColor
}

struct PokemonStatDisplayData {
    let name: String
    let baseStat: String
    let effort: String
}

class PokemonDetailViewModel {

    weak var delegate: PokemonDetailViewModelDelegate?
    private let pokemonService: PokemonServiceProtocol
    private let pokemonDetailUrl: URL

    init(pokemonDetailUrl: URL, pokemonService: PokemonServiceProtocol = PokemonAPIService()) {
        self.pokemonDetailUrl = pokemonDetailUrl
        self.pokemonService = pokemonService
    }

    func fetchPokemonDetails() {
        delegate?.pokemonDetailLoadingStateChanged(isLoading: true)
        
        pokemonService.fetchPokemonDetail(url: pokemonDetailUrl) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.delegate?.pokemonDetailLoadingStateChanged(isLoading: false)
                switch result {
                case .success(let detail):
                    let displayData = self.mapToDisplayData(detail: detail)
                    self.delegate?.pokemonDetailDidUpdate(viewModel: displayData)
                case .failure(let error):
                    print("ViewModel: Erro ao buscar detalhes do Pokémon: \(error.localizedDescription)")
                    self.delegate?.pokemonDetailDidFail(with: error.localizedDescription)
                }
            }
        }
    }

    private func mapToDisplayData(detail: PokemonDetail) -> PokemonDetailDisplayData {
        let formattedNumber = String(format: "#%03d", detail.id)
        let formattedHeight = String(format: "Alura: %.1f m", detail.height)
        let formattedWeight = String(format: "Peso: %.1f kg", detail.weight)

        let displayTypes = detail.types.map { type -> PokemonTypeDisplayData in
            return PokemonTypeDisplayData(title: type.getTitleBR(), color: type.uiColor())
        }
        
        let displayMoves = detail.moves.map { $0.move.name.capitalized }

        let displayStats = detail.stats.map { stat -> PokemonStatDisplayData in
            return PokemonStatDisplayData(
                name: stat.stat.name.capitalized,
                baseStat: String(stat.base_stat),
                effort: String(stat.effort)
            )
        }

        return PokemonDetailDisplayData(
            name: detail.name.capitalized,
            number: formattedNumber,
            imageUrl: detail.imageUrl,
            height: formattedHeight,
            weight: formattedWeight,
            types: displayTypes,
            moves: displayMoves,
            stats: displayStats
        )
    }
}
