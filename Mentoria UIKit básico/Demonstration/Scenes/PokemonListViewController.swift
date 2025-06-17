import Foundation
import UIKit

class PokemonListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var pokemons: [Pokemon] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        view.addSubview(tableView)
        fetchPokemonList()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    private func fetchPokemonList() {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=151"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else {
                print("Erro na requisição: \(error?.localizedDescription ?? "desconhecido")")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                DispatchQueue.main.async {
                    self.pokemons = decoded.results.compactMap { $0.toDomainModel() }
                    self.tableView.reloadData()
                }
            } catch {
                print("Erro ao decodificar JSON: \(error)")
            }
        }.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        let pokemon = pokemons[indexPath.row]
        cell.configure(with: pokemon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath ){
        let pokemon = pokemons[indexPath.row]
        let pokemonUrl = pokemon.pokemonUrl
        print("\(pokemon)")
        
        navigationController?.pushViewController(PokemonDetailViewController(url: pokemonUrl), animated: true)
    }
}




