import UIKit
import Foundation

class PokemonDetailViewController: UIViewController {
    
    private lazy var viewModel: PokemonDetailViewModel = {
        
        guard let url = pokemonUrl else {
            
            fatalError("Pokemon URL is missing for Detail ViewModel initialization.")
        }
        let vm = PokemonDetailViewModel(pokemonDetailUrl: url)
        vm.delegate = self
        return vm
    }()
    
    let pokemonDetailView = PokemonDetailView()
    
    private let pokemonUrl: URL?
    
    
    init(url: URL?) {
        self.pokemonUrl = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detalhes do Pokémon"
        setupUI()
        
        viewModel.fetchPokemonDetails()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        self.view.addSubview(pokemonDetailView)
        
        pokemonDetailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pokemonDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pokemonDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pokemonDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pokemonDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tag = 100
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showLoadingIndicator(_ show: Bool) {
        if let indicator = view.viewWithTag(100) as? UIActivityIndicatorView {
            if show {
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        }
    }
}

extension PokemonDetailViewController: PokemonDetailViewModelDelegate {
    func pokemonDetailDidUpdate(viewModel: PokemonDetailDisplayData) {
        pokemonDetailView.configure(with: viewModel)
        showLoadingIndicator(false)
    }
    
    func pokemonDetailDidFail(with error: String) {
        showLoadingIndicator(false)
        print("ViewController: Erro recebido do ViewModel para detalhes: \(error)")
        let alert = UIAlertController(title: "Erro", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func pokemonDetailLoadingStateChanged(isLoading: Bool) {
        showLoadingIndicator(isLoading)
    }
}
