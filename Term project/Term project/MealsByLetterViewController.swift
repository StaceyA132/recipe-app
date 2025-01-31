//
//  RecipesByLetterViewController.swift
//  Term project
//
//  Created by Stacey A on 4/25/24.
//

import UIKit

class MealsByLetterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var startingLetter: String?
    var recipes: [Meal] = [] // Define recipes array
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(recipes.count)
        return recipes.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowRecipesByLetter", for: indexPath)
        
        let recipe = recipes[indexPath.row]
        cell.textLabel?.text = recipe.strMeal
        
        return cell
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            if let startingLetter = startingLetter {
                fetchRecipes(startingLetter: startingLetter)
            }
            tableView.dataSource = self
            tableView.delegate = self
        }
    
    // added this
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowRecipeDetails" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let selectedMeal = recipes[indexPath.row]
                    let destinationViewController = segue.destination as! RecipeInformation
                    destinationViewController.mealName = selectedMeal.strMeal
                    destinationViewController.recipeImageURL = URL(string: selectedMeal.strMealThumb)
                    destinationViewController.recipeDescription = selectedMeal.strInstructions
                }
            }
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowRecipeDetails", sender: nil)
    }
    
    
        func fetchRecipes(startingLetter: String) {
            guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?f=\(startingLetter)")
            else {
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
                    print(recipesData.meals[0])
                    // Access the meals array from recipesData
                    self?.recipes = recipesData.meals
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }.resume()
        }
    
    
    @IBAction func tapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    }

