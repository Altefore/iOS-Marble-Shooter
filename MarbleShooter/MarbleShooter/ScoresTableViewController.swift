//
//  ScoresTableViewController.swift
//  MarbleShooter
//
//  Created by Sam Knepper on 11/8/16.
//  Copyright © 2016 Apress. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ScoresTableViewController: UITableViewController {

   // var scoreList = [Score]()
    var items: [Score] = []
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "High Scores"
        fetchScores()
    }

    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = String(describing: items[indexPath.row].scoreVal)
        cell.detailTextLabel?.text = items[indexPath.row].username
        return cell
    }
    
    func fetchScores(){
        
        let ref = FIRDatabase.database().reference(fromURL: "https://marble-shooter.firebaseio.com/")
        let scoresRef = ref.child("scores")
        scoresRef.queryOrdered(byChild: "scoreVal").queryLimited(toLast: 10).observe(.value, with: {(snapshot) in
            var newItems: [Score] = []

            for item in snapshot.children {
                
                let score = Score(snapshot: item as! FIRDataSnapshot)
                newItems.append(score)
            }
        
            self.items = newItems
            self.tableView.reloadData()
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return scoreList.count
    }*/

    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
