//
//  RecipeInformation.swift
//  Term project
//
//  Created by Stacey A on 4/30/24.
//

import UIKit

class RecipeInformation: UIViewController {
   
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeInfoLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
        var mealName: String = ""
        var recipeImageURL: URL?
        var recipeDescription: String = ""
    
    let favoritesKey = "FavoriteRecipes"
    var favoriteManager = FavoriteManager.shared


    override func viewDidLoad() {
            super.viewDidLoad()

            mealNameLabel.text = mealName
            recipeInfoLabel.text = recipeDescription
        

            if let imageURL = recipeImageURL {
                // Load meal image asynchronously
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: imageURL) {
                        DispatchQueue.main.async {
                            self.recipeImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        
        
        if favoriteManager.isRecipeFavorite(recipeName: mealName) {
                   favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
               }
           }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func saveAsFavoriteButtonTapped(_ sender: Any) {
        let isFavorite = favoriteManager.isRecipeFavorite(recipeName: mealName)
        
        if isFavorite {
            favoriteManager.removeFavoriteMeal(withName: mealName)
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            let favoriteMeal = FavoriteMeal(name: mealName, imageURL: recipeImageURL, description: recipeDescription)
            var currentFavorites = favoriteManager.fetchFavoriteMeals()
            currentFavorites.append(favoriteMeal)
            favoriteManager.saveFavoriteMeals(currentFavorites)
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
}
    

