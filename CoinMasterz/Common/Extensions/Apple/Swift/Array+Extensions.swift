//
//  Array+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

public extension Array {
    
    func appending(_ element: Element) -> Self {
        self + [element]
    }
    
    func appending(contentsOf collection: [Element]) -> Self {
        self + collection
    }
    
    func prepending(_ element: Element) -> Self {
        [element] + self
    }
    
    func prepending(contentsOf collection: [Element]) -> Self {
        collection + self
    }
    
    func mutating(_ mutation: (inout Element) -> Void) -> Self {
        var array = self
        array.mutate(mutation)
        return array
    }
}

public extension Array where Element: StringProtocol {
    
    func joined(_ separator: String) -> String {
        joined(separator: separator)
    }
}
