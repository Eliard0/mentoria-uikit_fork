//
//  PokemonStatViewCell.swift
//  Mentoria UIKit básico
//
//  Created by Eliardo Venancio on 04/06/25.
//

import UIKit

class StatCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.trackTintColor = .systemGray5
        progress.progressTintColor = .systemBlue
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        selectionStyle = .none
        hStack.addArrangedSubview(nameLabel)
        hStack.addArrangedSubview(valueLabel)
        
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(progressBar)
        
        contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with stat: PokemonStat, color: UIColor) {
        nameLabel.text = stat.stat.name.capitalized
        valueLabel.text = "\(stat.base_stat)%"
        let progress = min(Float(stat.base_stat) / 100.0, 1.0)
        progressBar.setProgress(progress, animated: false)
        progressBar.progressTintColor = color
    }
}
