import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favorites"

    // Method to save favorite meals
    func saveFavoriteMeals(_ meals: [FavoriteMeal]) {
        // Encode the array of meals
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(meals) {
            // Save the encoded data to UserDefaults
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }

    // Method to fetch favorite meals
    func fetchFavoriteMeals() -> [FavoriteMeal] {
        if let favoritesData = userDefaults.data(forKey: favoritesKey) {
            let decoder = JSONDecoder()
            if let favorites = try? decoder.decode([FavoriteMeal].self, from: favoritesData) {
                return favorites
            }
        }
        return []
    }

    // Method to check if a meal is a favorite
    func isRecipeFavorite(recipeName: String) -> Bool {
        let favorites = fetchFavoriteMeals()
        return favorites.contains { $0.name == recipeName }
    }

    // Method to remove a meal from favorites
    func removeFavoriteMeal(withName name: String) {
        var favorites = fetchFavoriteMeals()
        favorites.removeAll { $0.name == name }
        saveFavoriteMeals(favorites)
    }
}
