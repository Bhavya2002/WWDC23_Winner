//
//  LastTutorialViewController.swift
//  Find3
//
//  Created by Bhavya Bhatia
//

import UIKit

/// Final page of tutorial; appears after user finds one Connect 3
class LastTutorialViewController: UIViewController {
    
// MARK: - Navigation

    @IBAction func startButtonTapped(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "Level1Segue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Level1Segue" {
            if let gameVC = segue.destination as? GameViewController {
                gameVC.level = 1
            }
        }
    }
}
