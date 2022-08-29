//
//  TableViewController.swift
//  ToDo_YaSchool
//
//  Created by Roman Tverdokhleb on 03.08.2022.
//

import UIKit

var access = true

class TableViewController: UITableViewController {
    

    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .systemBlue
        
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        
        button.setImage(image, for: .normal)
        
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 25
        return button
    }()
    
    let config = UIImage.SymbolConfiguration(paletteColors: [.systemRed, .systemGreen])
    
    let imageCheck = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.white, .systemGreen]))
    
    let imageCheckSwipe = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemGreen, .white]))
    
    let imageUncheckSwipe = UIImage(systemName: "x.circle.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemRed, .white]))
    
    
    let imageUncheck = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))?.withTintColor(.gray, renderingMode: .alwaysOriginal)
    
    var checkCount = 0

    
    @IBOutlet weak var checkCountLabel: UILabel!
    
    @IBOutlet weak var pushEditOutlet: UIButton!

    
    @IBAction func didPresentTap() {
        let vc = storyboard?.instantiateViewController(identifier: "other") as! EditViewController
        
        vc.completionHandler = { text in
            let newItem = text
            addItem(nameItem: newItem!)
            self.checkCount -= self.checkCount
            self.tableView.reloadData()
        }
        present(vc, animated: true)
    }
    
    @IBAction func pushEditAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didPresentTap), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentItem = toDoItems[indexPath.row]
        cell.textLabel?.text = currentItem["Name"] as? String

        if (currentItem["isCompleted"] as? Bool) == true {
            cell.imageView?.image = imageCheck
            cell.textLabel?.textColor = .lightGray
            checkCount += 1
            checkCountLabel.text = "Выполнено - \(checkCount)"
        } else {
            cell.imageView?.image = imageUncheck
            cell.textLabel?.textColor = UIColor(named: "textColor")
        }
        
        
        if tableView.isEditing {
            pushEditOutlet.setTitle("Принять", for: .normal)
            checkCountLabel.text = "Выполнено - 0"
            cell.textLabel?.alpha = 0.4
            cell.imageView?.alpha = 0.4
            
            if access {
                floatingButton.alpha = 1
                UIView.animate(withDuration: 0.3, animations: {
                    self.floatingButton.alpha = 0
                }) { (finished) in
                    self.floatingButton.isHidden = finished
                }
                access = false
            }
            checkCount -= checkCount
  
        } else {
            pushEditOutlet.setTitle("Изменить", for: .normal)
            cell.textLabel?.alpha = 1
            cell.imageView?.alpha = 1
            floatingButton.alpha = 0
            floatingButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.floatingButton.alpha = 1
            }
            access = true
        }
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
       let isChecked = !(toDoItems[indexPath.row]["isCompleted"] as! Bool)
       
       let action = UIContextualAction(style: .normal, title: "check") {(action, sourceView, completionHandler) in
           
           toDoItems[indexPath.row]["isCompleted"] = (toDoItems[indexPath.row]["isCompleted"] as! Bool)
           completionHandler(true)
           
           if changeState(at: indexPath.row) {
               tableView.cellForRow(at: indexPath)?.imageView?.image = self.imageCheck
               tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .lightGray
               
               action.backgroundColor = .green
               action.image = self.imageCheckSwipe
               
               self.checkCount += 1
               self.checkCountLabel.text = "Выполнено - \(self.checkCount)"
               
           } else {
               tableView.cellForRow(at: indexPath)?.imageView?.image = self.imageUncheck
               tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor(named: "textColor")
               
               action.backgroundColor = .lightGray
               action.image = self.imageUncheck
               
               self.checkCount -= 1
               self.checkCountLabel.text = "Выполнено - \(self.checkCount)"
           }
       }
       
       if isChecked {
           action.backgroundColor = .systemGreen
           action.image = self.imageCheckSwipe
       } else {
           action.backgroundColor = .systemGray3
           action.image = self.imageUncheckSwipe
       }
        return UISwipeActionsConfiguration(actions: [action])
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            checkCountLabel.text = "Выполнено - \(checkCount)"
            // Delete the row from the data source
            removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let vc = storyboard?.instantiateViewController(identifier: "other") as! EditViewController
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentItem = toDoItems[indexPath.row]

        cell.textLabel?.text = currentItem["Name"] as? String
        vc.placeholder = (cell.textLabel?.text)!

        vc.completionHandler = { text in
            let newItem = text
            addItem(nameItem: newItem!)
            
            removeItem(at: indexPath.row)
            moveItem(fromIndex: toDoItems.endIndex - 1, toIndex: indexPath.row)
            
            self.checkCount -= self.checkCount
            self.tableView.reloadData()
        }
        present(vc, animated: true)
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
        moveItem(fromIndex: fromIndexPath.row, toIndex: to.row)
        
        tableView.reloadData()

    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        } else {
            return .none
        }
    }
    
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
