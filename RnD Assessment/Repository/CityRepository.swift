//
//  CityRepository.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

typealias FetchCitiesCompletionBlock = (_ success: [City]) -> Void
typealias CompletionFailureBlock = (_ error: NSError) -> Void

protocol CityRepository: AnyObject {

    func fetchCities(with success: @escaping FetchCitiesCompletionBlock,
                     failure: @escaping CompletionFailureBlock)
    
    func searchForCities(with searchString: String) -> [City]
}

class TrieNode {
    var key: String?
    weak var parent: TrieNode?
    var children: [String: TrieNode] = [:]
    var isTerminating = false
    var terminatingNode: City? = nil

    init(key: String?, parent: TrieNode?) {
        self.key = key
        self.parent = parent
    }
}

 class Trie {
    
    private let root = TrieNode(key: nil, parent: nil)
  
    init() {}
    
    func insert(_ city: City) {
        var current = root
        let cityName = city.cityName?.lowercased() ?? ""
        for (_, element) in cityName.enumerated() {
            if current.children[String(element)] == nil {
              current.children[String(element)] = TrieNode(key: String(element), parent: current)
            }
            current = current.children[String(element)]!
        }
        current.isTerminating = true
        current.terminatingNode = city
    }
        
        
    var isEmpty: Bool {
        return root.children.isEmpty
    }
    
    func getAllCities() -> [City] {
        return search(with: "")
    }
    
    func search(with keyword: String) -> [City] {
        let keyword = keyword.lowercased()
        var current = root
        for (_, element) in keyword.enumerated()  {
            guard let child = current.children[String(element)] else { return [] }
            current = child
        }
        return getCities(startingWith: keyword, after: current).sorted(by: { $0.cityName?.compare($1.cityName ?? "") == .orderedAscending })
    }
    
    private func getCities(startingWith keyword: String,
                             after node: TrieNode) -> [City] {
      var results: [City] = []
      
        if node.isTerminating,
           let terminatingNode = node.terminatingNode {
        
        results.append(terminatingNode)
      }
      
      for child in node.children.values {
        var keyword = keyword
        keyword.append(child.key!)
        results.append(contentsOf: getCities(startingWith: keyword,
                                               after: child))
      }
      
      return results
    }
}
