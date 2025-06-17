import UIKit

class PokemonStatsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private var stats: [PokemonStatDisplayData] = []
    private var currentTypeColor: UIColor = .systemBlue
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(StatCell.self, forCellReuseIdentifier: "StatCell")
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.rowHeight = 30
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
    
    public func configure(with stats: [PokemonStatDisplayData], color: UIColor) {
        self.stats = stats
        self.currentTypeColor = color
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as? StatCell else {
            return UITableViewCell()
        }
        let statDisplayData = stats[indexPath.row]
        cell.configure(with: statDisplayData, color: currentTypeColor)
        cell.selectionStyle = .none
        return cell
    }
}
