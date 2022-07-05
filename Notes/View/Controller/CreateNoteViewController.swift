//
//  ViewController.swift
//  Notes
//
//  Created by Gokul on 15/05/22.
//

import UIKit
import TinyConstraints
import CoreData

class CreateNoteViewController: UIViewController, UITextViewDelegate {
    
    //MARK: - Properties
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Views
    
    lazy var saveBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBarButtonItemTapped))
    lazy var attachBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperclip"), style: .plain, target: self, action: #selector(attachBarButtonItemTapped))
    
    lazy var titleField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your title here"
        textField.font = .systemFont(ofSize: 28)
        textField.becomeFirstResponder()
        return textField
    }()
    
    lazy var bodyView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .gray.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = .systemFont(ofSize: 24)
        view.text = "Enter description here..."
        view.textColor = UIColor.lightGray
        return view
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyView.delegate = self
        textViewDidBeginEditing(bodyView)
        textViewDidEndEditing(bodyView)
        
        setupNavigation()
        setupViews()
    }
    
    //MARK: - Setup Navigation
    
    private func setupNavigation() {
        title = "Notes"
        self.navigationItem.rightBarButtonItems = [saveBarButtonItem, attachBarButtonItem]
    }
    
    //MARK: - Setup Views
    
    private func setupViews() {
        addViews()
        setupConstraints()
    }
    
    private func addViews() {
        
        view.addSubview(titleField)
        view.addSubview(bodyView)
    }
    
    private func setupConstraints() {
        titleField.edgesToSuperview(excluding: .bottom, insets: .horizontal(20), usingSafeArea: true)
        
        titleField.height(50)
        bodyView.topToBottom(of: titleField)
        bodyView.edgesToSuperview(excluding: .top, insets: .horizontal(20), usingSafeArea: true)
    }
    
    
    //MARK: - Handlers
    
    @objc fileprivate func saveBarButtonItemTapped() {
        print("Bar Button Tapped")
        saveItems()
    }
    
    @objc fileprivate func attachBarButtonItemTapped() {
        print("Attach Button Tapped")
    }
    
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if bodyView.textColor == UIColor.lightGray {
            bodyView.text = nil
            bodyView.textColor = .white
        }
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        if bodyView.text.isEmpty {
            bodyView.text = "Enter description here..."
            bodyView.textColor = UIColor.lightGray
        }
    }
    
}

//MARK: - Extension

extension CreateNoteViewController {
    
    func saveItems() {
        
        if titleField.text != "" && bodyView.text != "" {
            let note = Note(context: context)
            note.title = titleField.text
            note.body = bodyView.text
            note.date = Date()
            
            do {
                try context.save()
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Error saving context, \(error)")
            }
        } else {
            print("Cannot save to DB")
        }
        
    }
}

