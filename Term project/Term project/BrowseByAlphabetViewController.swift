//
//  AlphabetViewController.swift
//  Term project
//
//  Created by Stacey A on 4/24/24.
//

import UIKit

class BrowseByAlphabetViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BrowseByAlphabetSegue")
        }

    }

extension BrowseByAlphabetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alphabet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseByAlphabetSegue", for: indexPath)
        cell.textLabel?.text = alphabet[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedLetter = alphabet[indexPath.row]
        // Perform segue with identifier "ShowRecipesByLetter" and pass selected letter as sender
        performSegue(withIdentifier: "ShowRecipesByLetter", sender: selectedLetter)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecipesByLetter" {
            if let selectedLetter = sender as? String {
                if let recipesByLetterVC = segue.destination as? MealsByLetterViewController {
                    recipesByLetterVC.startingLetter = selectedLetter
                }
            }
        }
    }
    
    
    
}
