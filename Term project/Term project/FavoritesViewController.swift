//
//  FavoritesViewController.swift
//  Term project
//
//  Created by Stacey A on 4/24/24.
//

import UIKit


class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteMeals: [FavoriteMeal] = []
    var favoriteRecipes: [FavoriteMeal] = [] // Declare favoriteRecipes array
    private let favoritesKey = "FavoriteRecipes"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        favoriteMeals = FavoriteManager.shared.fetchFavoriteMeals()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteMeals = FavoriteManager.shared.fetchFavoriteMeals()
        tableView.reloadData()
    }

    
    func saveFavoriteRecipes() {
        if let favoritesData = try? JSONEncoder().encode(favoriteRecipes) {
            UserDefaults.standard.set(favoritesData, forKey: favoritesKey)
        }
    }
    
    @IBAction func resetButton(_ sender: Any) {
        // Show confirmation dialog
        print("Reset button tapped")
        // Show confirmation dialog
        let alertController = UIAlertController(title: "Reset Favorites", message: "Are you sure you want to reset your list?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            // Clear the list of favorite meals
            self.favoriteMeals.removeAll()
            // Save the empty list to UserDefaults
            FavoriteManager.shared.saveFavoriteMeals([])
            // Reload table view
            self.tableView.reloadData()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
    }
}
    

    // Move the extension outside of the class body
// Inside FavoritesViewController

extension FavoritesViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMeals.count // Use favoriteMeals instead of favoriteRecipes
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMealCell", for: indexPath)
        
        let meal = favoriteMeals[indexPath.row] // Use favoriteMeals array
        cell.textLabel?.text = meal.name
        
        // Load image if imageURL is available
        if let imageURL = meal.imageURL {
            cell.imageView?.loadImage(from: imageURL)
        }
        
        return cell
    }
}


// dont touch
extension FavoritesViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Details", sender: indexPath)
    }
}

// dont touch
// MARK: - Navigation
extension FavoritesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Details" {
            guard let indexPath = sender as? IndexPath else { return }
            let selectedMeal = favoriteMeals[indexPath.row]
            let destinationViewController = segue.destination as! RecipeInformation
            destinationViewController.mealName = selectedMeal.name
            destinationViewController.recipeImageURL = selectedMeal.imageURL
            destinationViewController.recipeDescription = selectedMeal.description
        }
        
        
    }
    
    
}

