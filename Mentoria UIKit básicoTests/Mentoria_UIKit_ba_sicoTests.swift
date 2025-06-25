//  Mentoria_UIKit_ba_sicoTests.swift
//  Mentoria UIKit básicoTests
//
//  Created by Eliardo Venancio on 25/06/25.
//

import XCTest
import UIKit
import Foundation
@testable import Mentoria_UIKit_básico

final class PokemonTableViewCellTests: XCTestCase {

    var cel: PokemonTableViewCell!

    override func setUpWithError() throws {

        cel = PokemonTableViewCell(style: .default, reuseIdentifier: "TestCell")
        
        _ = cel.cardView
        _ = cel.pokemonImageView
        _ = cel.nameLabel
        _ = cel.numberLabel
    }

    override func tearDownWithError() throws {
        cel = nil
    }

    func testInit_AddsSubviews() throws {
        XCTAssertTrue(cel.contentView.subviews.contains(cel.cardView))
        XCTAssertTrue(cel.cardView.subviews.contains(cel.pokemonImageView))
        XCTAssertTrue(cel.cardView.subviews.contains(cel.nameLabel))
        XCTAssertTrue(cel.cardView.subviews.contains(cel.numberLabel))
    }

    func testInit_SetsInitialProperties() throws {
        XCTAssertEqual(cel.contentView.backgroundColor, .clear)
        XCTAssertEqual(cel.selectionStyle, .none)
        XCTAssertEqual(cel.cardView.layer.cornerRadius, 10)
        XCTAssertEqual(cel.nameLabel.font, UIFont.boldSystemFont(ofSize: 18))
    }

    func testPrepareForReuse_ResetsContent() throws {
        cel.pokemonImageView.image = UIImage(systemName: "star.fill")
        cel.nameLabel.text = "Pikachu"
        cel.numberLabel.text = "#025"
        cel.cardView.backgroundColor = .red
        
        cel.prepareForReuse()

        XCTAssertNil(cel.pokemonImageView.image, "A imagem deveria ser nil após prepareForReuse.")
        XCTAssertNil(cel.nameLabel.text, "O nome deveria ser nil após prepareForReuse.")
        XCTAssertNil(cel.numberLabel.text, "O número deveria ser nil após prepareForReuse.")
        XCTAssertEqual(cel.cardView.backgroundColor, .white, "A cor de fundo do card deveria ser resetada para branco.")
    }

    func testSetViewModel_SetsTextLabelsCorrectly() throws {
        let testViewModel = PokemonCellViewModel(pokemon: Pokemon(
            id: 1,
            name: "Bulbasaur",
            number: 1,
            imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
            detailApiUrl: nil
        ))

        cel.setViewModel(testViewModel)

        XCTAssertEqual(cel.nameLabel.text, "Bulbasaur")
        XCTAssertEqual(cel.numberLabel.text, "#001")
        XCTAssertEqual(cel.pokemonImageView.image, UIImage(systemName: "photo"), "A imagem deveria ser o placeholder inicial.")
    }
}
