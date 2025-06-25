import UIKit

class PokemonTableViewCell: UITableViewCell {
    lazy var cardView: UIView = {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 10
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.1
        card.layer.shadowOffset = CGSize(width: 0, height: 1)
        card.layer.shadowRadius = 4
        return card
    }()

    lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
      
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()

    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        selectionStyle = .none

        setupLayout()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonImageView.image = nil
        nameLabel.text = nil
        numberLabel.text = nil
        cardView.backgroundColor = .white
        currentViewModel = nil
    }

    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.addSubview(pokemonImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(numberLabel)
    }

    private func setConstraints(){
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])

        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            pokemonImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 60),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 60),
        ])

        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            numberLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            numberLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
        ])

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: numberLabel.trailingAnchor),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -16)
        ])
    }
    
    private var currentViewModel: PokemonCellViewModel?

    public func setViewModel(_ viewModel: PokemonCellViewModel) {
        self.currentViewModel = viewModel
        
        nameLabel.text = viewModel.name
        numberLabel.text = viewModel.number
    
        pokemonImageView.image = UIImage(systemName: "photo")

        guard let imageUrl = URL(string: viewModel.imageUrl) else {
            print("Erro: URL de imagem inválida para \(viewModel.name): \(viewModel.imageUrl)")
            return
        }

        URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
            guard let self = self else {
                print("Célula foi desalocada antes de carregar a imagem.")
                return
            }
           
            guard self.currentViewModel?.imageUrl == viewModel.imageUrl else {
                print("Célula reutilizada, ignorando imagem para \(viewModel.name).")
                return
            }

            if let error = error {
                print("Erro ao carregar imagem para \(viewModel.name) (\(viewModel.imageUrl)): \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.pokemonImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Erro de status HTTP para \(viewModel.name) (\(viewModel.imageUrl)): \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                DispatchQueue.main.async {
                    self.pokemonImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Dados de imagem inválidos para \(viewModel.name) (\(viewModel.imageUrl))")
                DispatchQueue.main.async {
                    self.pokemonImageView.image = UIImage(systemName: "xmark.circle.fill")
                }
                return
            }
          
            DispatchQueue.main.async {
                self.pokemonImageView.image = image
            }
        }.resume()
    }
}
