import UIKit

class StatCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.trackTintColor = .lightGray.withAlphaComponent(0.3)
        progressBar.layer.cornerRadius = 4
        progressBar.clipsToBounds = true
        return progressBar
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraints()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
        progressBar.progress = 0
        progressBar.progressTintColor = nil
    }
    
    private func setupLayout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(progressBar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 80),
            
            valueLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 40),
            
            progressBar.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 8),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 8)
        ])
    }

    public func configure(with stat: PokemonStatDisplayData, color: UIColor) {
        nameLabel.text = stat.name
        valueLabel.text = stat.baseStat
        progressBar.progressTintColor = color
        let maxStatValue: Float = 150.0 
        if let baseStatValue = Float(stat.baseStat) {
            progressBar.setProgress(baseStatValue / maxStatValue, animated: false)
        } else {
            progressBar.setProgress(0, animated: false)
        }
    }
}
