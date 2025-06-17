//
//  PokemonStat.swift
//  Mentoria UIKit básico
//
//  Created by Eliardo Venancio on 04/06/25.
//

import UIKit

class PokemonStatsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private var stats: [PokemonStat] = []
    private var currentTypeColor: UIColor = .systemBlue
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(StatCell.self, forCellReuseIdentifier: "StatCell")
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with stats: [PokemonStat], color: UIColor) {
        self.stats = stats
        self.currentTypeColor = color
        tableView.reloadData()
    }
    
    func configure(with stats: [PokemonStat]) {
        self.stats = stats
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stat = stats[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as! StatCell
        cell.configure(with: stat, color: currentTypeColor)
        return cell
    }
}
