//
//  String+Extensions.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 21.11.2025.
//

public extension String {
    
    @inline(__always)
    static var empty: String { "" }
    
    @inline(__always)
    static var space: String { " " }
    
    @inline(__always)
    var wrappedIntoBrackets: String { "[\(self)]" }
}

import Foundation

public extension String {
    
    @inline(__always)
    var nsString: NSString {
        self as NSString
    }
    
    var urlValue: URL? {
        isEmpty ? nil : URL(string: self)
    }
}
