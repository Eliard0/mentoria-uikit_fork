import UIKit

class PokemonCellView: UIView {
    
    private lazy var cardView: UIView = {
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

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var numberItem: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.textAlignment = .center

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupLayout()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(cardView)
        cardView.addSubview(imageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(numberItem)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            numberItem.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            numberItem.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
        ])

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: numberItem.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: numberItem.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: numberItem.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8)
        ])
        
    }
    
    public func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name
        
        if let url = URL(string: pokemon.pokemonImage) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    guard let data = data, error == nil else { return }
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }.resume()
            }
        
        numberItem.text = "#\(pokemon.number)"
    }
}
