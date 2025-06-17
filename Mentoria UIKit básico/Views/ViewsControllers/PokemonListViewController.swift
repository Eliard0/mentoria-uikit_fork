import Foundation
import UIKit

class PokemonListViewController: UIViewController {
    private lazy var viewModel: PokemonListViewModel = {
        let vm = PokemonListViewModel()
        vm.delegate = self
        return vm
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.rowHeight = 80
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        activityIndicator.startAnimating()
        viewModel.fetchPokemons()
    }

    private func setupUI() {
        self.title = "Pokémons"
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension PokemonListViewController: PokemonListViewModelDelegate {
    func pokemonListDidUpdate() {

        activityIndicator.stopAnimating()
        tableView.reloadData()
    }

    func pokemonListDidFail(with error: String) {
        activityIndicator.stopAnimating()
        print("ViewController: Erro recebido do ViewModel: \(error)")
        let alert = UIAlertController(title: "Erro", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func navigateToPokemonDetail(with detailUrl: URL?) {
        guard let url = detailUrl else {
            print("URL de detalhe inválida para navegação.")
            return
        }

        let detailVC = PokemonDetailViewController(url: url)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPokemons(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        
        if let cellViewModel = viewModel.getPokemonCellViewModel(at: indexPath) {

            cell.setViewModel(cellViewModel)
        }
        return cell
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        viewModel.didSelectPokemon(at: indexPath)
    }
}
