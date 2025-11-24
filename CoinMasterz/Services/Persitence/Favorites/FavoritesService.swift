//
//  FavoritesService.swift
//  CoinMasterz
//
//  Created by Dumitru Paraschiv on 23.11.2025.
//


import Foundation
import CoreData
import Combine

protocol FavoritesService {
    
    var favoritesPublisher: AnyPublisher<Set<String>, Never> { get }
    
    func isFavorite(assetID: String) -> Bool
    func toggleFavorite(assetID: String)
    func addFavorite(assetID: String)
    func removeFavorite(assetID: String)
    func getAllFavoriteIDs() -> Set<String>
}

final class DefaultFavoritesService: FavoritesService {
    
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // Publisher for real-time favorites updates
    private let favoritesSubject = CurrentValueSubject<Set<String>, Never>([])
    var favoritesPublisher: AnyPublisher<Set<String>, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        loadFavorites()
    }
    
    func isFavorite(assetID: String) -> Bool {
        favoritesSubject.value.contains(assetID)
    }
    
    func toggleFavorite(assetID: String) {
        if isFavorite(assetID: assetID) {
            removeFavorite(assetID: assetID)
        } else {
            addFavorite(assetID: assetID)
        }
    }
    
    func addFavorite(assetID: String) {
        guard !isFavorite(assetID: assetID) else { return }
        
        let favorite = FavoriteAsset(context: context)
        favorite.assetID = assetID
        favorite.addedAt = Date()
        
        saveContext()
        
        var currentFavorites = favoritesSubject.value
        currentFavorites.insert(assetID)
        favoritesSubject.send(currentFavorites)
    }
    
    func removeFavorite(assetID: String) {
        let fetchRequest = FavoriteAsset.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "assetID == %@", assetID)
        
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { context.delete($0) }
            saveContext()
            
            var currentFavorites = favoritesSubject.value
            currentFavorites.remove(assetID)
            favoritesSubject.send(currentFavorites)
        } catch {
            trace("‼️ Error removing favoriteerror", error)
        }
    }
    
    func getAllFavoriteIDs() -> Set<String> {
        favoritesSubject.value
    }
}

private extension DefaultFavoritesService {
    
    func loadFavorites() {
        let fetchRequest = FavoriteAsset.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            let favoriteIDs = Set(results.map { $0.assetID })
            favoritesSubject.send(favoriteIDs)
        } catch {
            trace("‼️ Error loading favorites", error)
        }
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            trace("‼️ Error saving context", error)
        }
    }
}
