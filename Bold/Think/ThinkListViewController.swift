//
//  ThinkListViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/8/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class ThinkListViewController: ActionsListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ActionsListViewController{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if actions[indexPath.row].type == .action {
            let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
            navigationController?.present(vc, animated: true, completion: nil)
        }
        
    }
}


//extension ThinkListViewController: ActionTableViewCellDelegate {
//    
//    override func tapAddActionPlanButton() {
//        performSegue(withIdentifier: StoryboardSegue.Think.addActionIdentifier.rawValue, sender: nil)
//    }
//    
//}
