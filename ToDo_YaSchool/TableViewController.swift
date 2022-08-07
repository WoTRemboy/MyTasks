//
//  TableViewController.swift
//  ToDo_YaSchool
//
//  Created by Roman Tverdokhleb on 03.08.2022.
//

import UIKit

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
    
    let imageCheck = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
    
    let imageUncheck = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))?.withTintColor(.gray, renderingMode: .alwaysOriginal)
    
    var checkCount = 0

    
    @IBOutlet weak var checkCountLabel: UILabel!
    
    @IBOutlet weak var pushEditOutlet: UIButton!

    @IBAction func pushEditAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func pushAddAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Создать новую запись", message: nil, preferredStyle: .alert)
        alertController.addTextField {(textField) in
            textField.placeholder = "Название задачи"
    }
    
        let alertAction1 = UIAlertAction(title: "Отменить", style: .cancel) { alert in
            
        }
        
        let alertAction2 = UIAlertAction(title: "Создать", style: .default) { alert in
            let newItem = alertController.textFields![0].text
            addItem(nameItem: newItem!)
            self.checkCount -= self.checkCount
            self.tableView.reloadData()
        }
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.systemGroupedBackground
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(pushAddAction), for: .touchUpInside)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        //floatingButton.frame = CGRect(x: view.frame.midX - 30, y: view.frame.midY + 100, width: 60, height: 60)
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
            checkCount += 1
            checkCountLabel.text = "Выполнено - \(checkCount)"
        } else {
            cell.imageView?.image = imageUncheck
        }
        
        if tableView.isEditing {
            pushEditOutlet.setTitle("Принять", for: .normal)
            checkCountLabel.text = "Выполнено - 0"
            cell.textLabel?.alpha = 0.4
            cell.imageView?.alpha = 0.4
            checkCount -= checkCount
  
        } else {
            pushEditOutlet.setTitle("Изменить", for: .normal)
            cell.textLabel?.alpha = 1
            cell.imageView?.alpha = 1
        }
        
        return cell
    }
    
   /* override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action: UIContextualAction
        
        if changeState(at: indexPath.row) {
            tableView.cellForRow(at: indexPath)?.imageView?.image = imageCheck
        } else {
            tableView.cellForRow(at: indexPath)?.imageView?.image = imageUncheck
        }
        
        action.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [action])
    }
*/
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
        
        if changeState(at: indexPath.row) {
            tableView.cellForRow(at: indexPath)?.imageView?.image = imageCheck
            checkCount += 1
            checkCountLabel.text = "Выполнено - \(checkCount)"
        } else {
            tableView.cellForRow(at: indexPath)?.imageView?.image = imageUncheck
            checkCount -= 1
            checkCountLabel.text = "Выполнено - \(checkCount)"
        }
        
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
