//
//  PokemonService.swift
//  Mentoria UIKit básico
//
//  Created by Guilerme Barciki on 14/05/25.
//
import Foundation

enum PokemonAPIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "A URL fornecida é inválida."
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Erro ao decodificar dados: \(error.localizedDescription)"
        case .unknownError:
            return "Ocorreu um erro desconhecido."
        }
    }
}

protocol PokemonServiceProtocol {
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], PokemonAPIError>) -> Void)
    func fetchPokemonDetail(url: URL, completion: @escaping (Result<PokemonDetail, PokemonAPIError>) -> Void)
}

class PokemonAPIService: PokemonServiceProtocol {
    
    private let baseURL = "https://pokeapi.co/api/v2/"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], PokemonAPIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)pokemon?limit=151") else {
            completion(.failure(.invalidURL))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                
                let pokemons = decodedResponse.results.compactMap { $0.toDomainModel() }
                completion(.success(pokemons))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    func fetchPokemonDetail(url: URL, completion: @escaping (Result<PokemonDetail, PokemonAPIError>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(PokemonDetailResponse.self, from: data)
                
                let pokemonDetail = decodedResponse.toDomainModel()
                completion(.success(pokemonDetail))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
