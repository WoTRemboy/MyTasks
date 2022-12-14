//
//  EditViewController.swift
//  ToDo_YaSchool
//
//  Created by Roman Tverdokhleb on 16.08.2022.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate {
    
    var placeholder = "Что нужно сделать?"

    
    public var completionHandler: ((String?) -> Void)?
    
    

    @IBOutlet weak var taskTitle: UILabel!
    
    @IBOutlet weak var editTextView: UITextView!

    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        completionHandler?(editTextView.text)
        dismiss(animated: true)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor(named: "textColor")
            self.saveButton.isEnabled = true
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            self.saveButton.isEnabled = false
        }
    }
    
    func textViewPlaceholder(_ textView: UITextView) {
        if placeholder == "Что нужно сделать?" {
            textView.delegate = self
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            self.saveButton.isEnabled = false
        } else {
            textView.text = placeholder
            textView.textColor = UIColor(named: "textColor")
        }
        
    }
    
    func editTextAction(_ textView: UITextView) {
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 10
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if placeholder == "Что нужно сделать?" {
            taskTitle.text = "Создание дела"
        } else {
            taskTitle.text = "Редактирование дела"
        }
        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10

        textViewPlaceholder(editTextView)
        editTextAction(editTextView)
        
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
