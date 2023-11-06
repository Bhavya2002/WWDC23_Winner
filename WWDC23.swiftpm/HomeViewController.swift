//
//  HomeViewController.swift
//  Find3
//
//  Created by Bhavya Bhatia
//

import UIKit
import QuartzCore
import GameKit

enum Tags: Int {
    case levelLabel     = 100
    case background     = 101
    case highScoreLabel = 102
    case star1          = 201
    case star2          = 202
    case star3          = 203
}

let LightBlue   = UIColor.systemBlue
let Green       = UIColor.systemRed
let Purple      = UIColor.systemPurple
let Pink        = UIColor.systemPink
let Orange      = UIColor.systemOrange
let OneStarScore    =  5  
let TwoStarScore    = 10
let ThreeStarScore  = 15

let NumLevels = 11

public class HomeViewController: UIViewController, UITableViewDataSource,
                            UITableViewDelegate, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var highScores: [Int] = [Int]()
    var unlockedLevels = 0
    let colors = [LightBlue, Green, Purple, Pink, Orange]
    
    var tutorialPageVC: PageDataSourceViewController?
    var gameVC: GameViewController?
    

    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        if #available(iOS 13.0, *) {
            tableView.separatorColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
        }
        
        let storyboard = self.storyboard
        
        tutorialPageVC = storyboard?.instantiateViewController(withIdentifier: "PageDataSourceVC")
            as? PageDataSourceViewController
        
        gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController")
            as? GameViewController
        
        // Trying to fix UITableView
        /// Put code here
        
      
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        
        let defaults = UserDefaults.standard

        if let scoresArray = defaults.array(forKey: "highScores") {
            
            highScores = scoresArray as! [Int]
            
            unlockedLevels = highScores.count - 1 // Subtract one for tutorial
            
            if highScores[unlockedLevels] >= 5 {
                unlockedLevels += 1 // Unlock additional level if last high score is greater than 5
                
                
            }
            
            
        }

        self.tableView.reloadData()
        
    }
    
// MARK: - TableView data source methods
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NumLevels
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LevelCell", for: indexPath)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let view = cell.viewWithTag(Tags.background.rawValue) as UIView?
        let levelLabel = cell.viewWithTag(Tags.levelLabel.rawValue) as! UILabel
        let scoreLabel = cell.viewWithTag(Tags.highScoreLabel.rawValue) as! UILabel
        
        let star1 = cell.viewWithTag(Tags.star1.rawValue) as! UIImageView
        let star2 = cell.viewWithTag(Tags.star2.rawValue) as! UIImageView
        let star3 = cell.viewWithTag(Tags.star3.rawValue) as! UIImageView
        
        view?.layer.borderColor = colors[indexPath.row % 5].cgColor
        view?.layer.borderWidth = 6.0
        
        
        if indexPath.row == 0 {
            
            // Tutorial Level
            
            view?.alpha = 1.0
            levelLabel.text = "Tutorial"
            
            star1.isHidden = true
            star2.isHidden = true
            star3.isHidden = true
            
            scoreLabel.text = ""

        } else if indexPath.row + 1 <= highScores.count {
            
            // Levels that have been played
            
            view?.alpha = 1.0
            levelLabel.text = "Level \(indexPath.row)"
            
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
            
            formatStars(highScores[indexPath.row], stars: [star1, star2, star3])
            
            scoreLabel.text = "High Score: \(highScores[indexPath.row])"
        } else {
            
            // Levels that have NOT been played
            
            view?.alpha = indexPath.row > unlockedLevels ? 0.5 : 1.0
            
            levelLabel.text = "Level \(indexPath.row)"
            
            star1.isHidden = true
            star2.isHidden = true
            star3.isHidden = true
            
            scoreLabel.text = ""

        }
      
        return cell
    }
    
    /// Display stars for each level on homepage
    public func formatStars(_ score: Int, stars: [UIImageView]) {
        
        switch score {
            
        case 0..<OneStarScore:
            stars[0].image = UIImage(named: "star-empty")
            stars[1].image = UIImage(named: "star-empty")
            stars[2].image = UIImage(named: "star-empty")
            
        case OneStarScore..<TwoStarScore:
            stars[0].image = UIImage(named: "star")
            stars[1].image = UIImage(named: "star-empty")
            stars[2].image = UIImage(named: "star-empty")
            
        case TwoStarScore..<ThreeStarScore:
            stars[0].image = UIImage(named: "star")
            stars[1].image = UIImage(named: "star")
            stars[2].image = UIImage(named: "star-empty")
            
        default:
            stars[0].image = UIImage(named: "star")
            stars[1].image = UIImage(named: "star")
            stars[2].image = UIImage(named: "star")
        }
        
    }

// MARK: - TableView delegate methods
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            self.present(tutorialPageVC!, animated: true, completion: nil)
            
        } else if indexPath.row <= unlockedLevels {
            
            gameVC!.level = indexPath.row
            self.present(gameVC!, animated: true, completion: nil)
            
            // performSegueWithIdentifier("LevelSegue", sender: self)
            
        }
        
    }
    
// MARK: - Game Center (Leaderboard)
    
    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showLeaderboard() {
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = GKGameCenterViewControllerState.leaderboards
        // gcViewController.leaderboardIdentifier = "mismatch_combined_leaderboard"
        
        self.present(gcViewController, animated: true, completion: nil)
        
    }
    
// MARK: - Navigation
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        print("unwind to home")
        
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LevelSegue" {
            if let gameVC = segue.destination as? GameViewController {
                if let index = tableView.indexPathForSelectedRow?.row {
                    gameVC.level = index
                }
            }
        }
        
    }
    
}
