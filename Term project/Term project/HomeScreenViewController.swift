//
//  HomeScreenViewController.swift
//  Term project
//
//  Created by Stacey A on 4/24/24.
//

import UIKit

class HomeScreenViewController: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var suggestionsTableView: UITableView!
    
    var allRecipes: [Meal] = [] // meal from data model
    var filteredRecipes: [Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.delegate = self
        

    }
    
    @IBAction func browseByAlphabetTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "BrowseByAlphabetSegue", sender: nil)
    }
    @IBAction func favoritesTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Favorites", sender: nil)
    }
}
    
extension HomeScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Call API to fetch recipes based on the search text
        fetchRecipes(with: searchText)
    }
    
    func fetchRecipes(with searchText: String) {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(searchText)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let recipesData = try decoder.decode(RecipesData.self, from: data)
                self?.filteredRecipes = recipesData.meals
                DispatchQueue.main.async {
                    self?.suggestionsTableView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchingMeals", for: indexPath)
        cell.textLabel?.text = filteredRecipes[indexPath.row].strMeal
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeal = filteredRecipes[indexPath.row]
        performSegue(withIdentifier: "goToRecipeInfo", sender: selectedMeal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRecipeInfo", let selectedMeal = sender as? Meal {
            if let destinationViewController = segue.destination as? RecipeInformation {
                destinationViewController.mealName = selectedMeal.strMeal
                destinationViewController.recipeImageURL = URL(string: selectedMeal.strMealThumb)
                destinationViewController.recipeDescription = selectedMeal.strInstructions
            }
        }
    }
}


