import UIKit

class CellViewController: UIViewController {
    
    private let customCell = PokemonTableViewCell(style: .default, reuseIdentifier: "CustomCell")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(customCell.contentView)
        customCell.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customCell.contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customCell.contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customCell.contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customCell.contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

//        customCell.configure(with: Pokemon.mock())
    }
}
