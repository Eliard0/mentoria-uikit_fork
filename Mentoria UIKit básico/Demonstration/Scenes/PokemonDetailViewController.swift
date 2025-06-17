import UIKit
import Foundation

class PokemonDetailViewController: UIViewController {
    let pokemonDetail = PokemonDetailView()
    let pokemonUrl: URL?
    var pokemonDetails: PokemonDetail?
    
    init(url: URL?){
        self.pokemonUrl = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = pokemonDetail
        
        fetchPokemonDetail(with: pokemonUrl)
    }
    
    func fetchPokemonDetail(with url: URL?){
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            
            do{
                let decoder = try JSONDecoder().decode(PokemonDetailResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.pokemonDetail.configure(with: decoder.toDomainModel())
                }
                
            }catch {
                print("error ao decodificar\(error)")
            }
        }.resume()
    }
}
