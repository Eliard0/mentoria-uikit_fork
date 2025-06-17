import UIKit

class PokemonDetailView: UIView {
    
    private var currentTypeColor: UIColor = .systemGray
    
    private lazy var movesView = PokemonMovesView()
    private lazy var statsView = PokemonStatsView()
    
    private enum SelectedTab {
        case moves, stats
    }
    
    private var selectedTab: SelectedTab = .moves {
        didSet {
            updateTabSelection()
        }
    }
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let pokemonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.2
        iv.layer.shadowOffset = CGSize(width: 0, height: 2)
        iv.layer.shadowRadius = 4
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabelText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Tipo:"
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var typeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [typeLabelText, typeLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heightLabel, weightLabel])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var cardTwoDetail: UIView = {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    private lazy var movesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Movimentos"
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var statsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Estatísticas"
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var infoDetailStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            movesLabel,
            statsLabel
        ])
        stack.axis = .horizontal
        stack.spacing = 50
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            pokemonImageView,
            nameLabel,
            numberLabel,
            typeStackView,
            infoStackView
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setConstraints()
        
        movesLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMoves)))
        statsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapStats)))
        
        selectedTab = .moves
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(cardView)
        addSubview(cardTwoDetail)
        cardView.addSubview(mainStackView)
        cardTwoDetail.addSubview(infoDetailStackView)
        
        cardTwoDetail.addSubview(movesView)
        movesView.translatesAutoresizingMaskIntoConstraints = false
        
        cardTwoDetail.addSubview(statsView)
        statsView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyTopCurveMask(to: cardTwoDetail)
    }
    
    public func configure(with displayData: PokemonDetailDisplayData) {
        nameLabel.text = displayData.name
        numberLabel.text = displayData.number
        typeLabel.text = displayData.types.map { $0.title }.joined(separator: ", ")
        heightLabel.text = displayData.height
        weightLabel.text = displayData.weight
        
        if let primaryType = displayData.types.first {
            typeLabel.backgroundColor = primaryType.color
            backgroundColor = primaryType.color
            currentTypeColor = primaryType.color
        } else {
            typeLabel.backgroundColor = .systemGray
            backgroundColor = .systemBackground
            currentTypeColor = .systemGray
        }
    
        pokemonImageView.image = UIImage(systemName: "photo")
        if let imageUrl = URL(string: displayData.imageUrl) {
            loadImage(from: imageUrl, for: pokemonImageView, placeholder: UIImage(systemName: "photo")!)
        } else {
            pokemonImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        }
        
        movesView.configure(with: displayData.moves)
        statsView.configure(with: displayData.stats, color: currentTypeColor)
        
        updateTabSelection()
    }
    
    private func loadImage(from url: URL, for imageView: UIImageView, placeholder: UIImage) {
        imageView.image = placeholder
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Erro ao carregar imagem para detalhes: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Erro de status HTTP ao carregar imagem para detalhes: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Dados de imagem inválidos para detalhes.")
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: "xmark.circle.fill")
                }
                return
            }
            
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    private func applyTopCurveMask(to view: UIView) {
        let width = view.bounds.width
        let height = view.bounds.height
        let curveDepth: CGFloat = 30
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addQuadCurve(to: CGPoint(x: 0, y: 0), controlPoint: CGPoint(x: width / 2, y: curveDepth))
        path.close()
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        view.layer.mask = mask
    }
    
    private func updateTabSelection() {
        let allLabels = [movesLabel, statsLabel]
        
        allLabels.forEach { label in
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
        
        movesView.isHidden = true
        statsView.isHidden = true
        
        switch selectedTab {
        case .moves:
            movesLabel.textColor = currentTypeColor
            movesLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            movesView.isHidden = false
            
        case .stats:
            statsLabel.textColor = currentTypeColor
            statsLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            statsView.isHidden = false
        }
    }
    
    @objc private func didTapMoves() {
        selectedTab = .moves
    }
    
    @objc private func didTapStats() {
        selectedTab = .stats
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            
            cardView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
          
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            pokemonImageView.heightAnchor.constraint(equalToConstant: 200),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            typeLabel.heightAnchor.constraint(equalToConstant: 30),
            typeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            cardTwoDetail.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20),
            cardTwoDetail.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardTwoDetail.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardTwoDetail.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infoDetailStackView.topAnchor.constraint(equalTo: cardTwoDetail.topAnchor, constant: 40),
            infoDetailStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
          
        ])
   
        NSLayoutConstraint.activate([
            movesView.topAnchor.constraint(equalTo: infoDetailStackView.bottomAnchor, constant: 20),
            movesView.leadingAnchor.constraint(equalTo: cardTwoDetail.leadingAnchor, constant: 20),
            movesView.trailingAnchor.constraint(equalTo: cardTwoDetail.trailingAnchor, constant: -20),
            movesView.bottomAnchor.constraint(equalTo: cardTwoDetail.bottomAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            statsView.topAnchor.constraint(equalTo: infoDetailStackView.bottomAnchor, constant: 20),
            statsView.leadingAnchor.constraint(equalTo: cardTwoDetail.leadingAnchor, constant: 20),
            statsView.trailingAnchor.constraint(equalTo: cardTwoDetail.trailingAnchor, constant: -20),
            statsView.bottomAnchor.constraint(equalTo: cardTwoDetail.bottomAnchor, constant: -20),
        ])
    }
}
