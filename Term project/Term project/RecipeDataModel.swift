//
//  RecipeList.swift
//  Term project
//
//  Created by Stacey A on 4/25/24.
//

import Foundation

struct RecipesData: Decodable {
    let meals: [Meal]
}

struct FavoriteMeal: Codable {
    let name: String
    let imageURL: URL?
    let description: String
}


struct Meal: Decodable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strTags: String?
    let strYoutube: String?
    
    // Remove ingredients and measures properties
    // var ingredients: [String] { }
    // var measures: [String] { }
    
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strMealThumb, strCategory, strArea, strInstructions, strTags, strYoutube
        // Remove strIngredient1, ..., strIngredient20 and strMeasure1, ..., strMeasure20
    }
}
