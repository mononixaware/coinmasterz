//
//  FavoriteAsset.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//


import Foundation
import CoreData

@objc(FavoriteAsset)
public class FavoriteAsset: NSManagedObject {
    
    @NSManaged public var assetID: String
    @NSManaged public var addedAt: Date
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteAsset> {
        return NSFetchRequest<FavoriteAsset>(entityName: "FavoriteAsset")
    }
}