//
//  RootViewController.swift
//  Notes
//
//  Created by Gokul on 16/05/22.
//

import Foundation
import TinyConstraints
import UIKit
import CoreData

class MainPageViewController: UIViewController {
    
    var notesArray = [Note]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //MARK: - Properties
    
    lazy var titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var floatingAddButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.width(50)
        button.height(50)
        return button
    }()
    
    lazy var myCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (self.view.frame.width / 2 ) - 20, height: 140)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadNotes()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupCollectionView()
        loadNotes()
        saveDataFromServer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK: - Handlers
    @objc func floatingButtonTapped() {
        self.navigationController?.pushViewController(CreateNoteViewController(), animated: true)
    }
    
    //MARK: - Setup Views
    
    private func setupViews() {
        addViews()
        setupConstraints()
        setupUI()
    }
    
    private func addViews() {
        view.addSubview(myCollectionView)
        view.addSubview(titleView)
        view.addSubview(floatingAddButton)
    }
    
    private func setupConstraints() {
        
        myCollectionView.edgesToSuperview(usingSafeArea: true)
        
        
        floatingAddButton.trailingToSuperview(offset: 30, usingSafeArea: true)
        floatingAddButton.bottomToSuperview(offset: -30, usingSafeArea: true)
        floatingAddButton.layer.masksToBounds = true
        
        
    }
    
    private func setupUI() {
        floatingAddButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        
        self.title = "Notes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - Model Manipulation Methods
    
    
    func loadNotes(with request: NSFetchRequest<Note> = Note.fetchRequest()) {
        do {
            let notesArray = try context.fetch(request)
            self.notesArray = notesArray
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.myCollectionView.reloadData()
    }
}




//MARK: - Collection View

extension MainPageViewController {
    private func setupCollectionView() {
        
        myCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.description())
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
    }
}

//MARK: - Extensions to self

extension MainPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesArray.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.description(), for: indexPath) as? CustomCollectionViewCell
        guard let cell = myCell else {
            return UICollectionViewCell()
        }
        let item = notesArray[indexPath.row]
        
        cell.configure(with: item)
        return cell
    }
}

extension MainPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
        let selectedNote = notesArray[indexPath.row]
        self.navigationController?.pushViewController(NotesDisplayViewController(note: selectedNote ), animated: true)
    }
}

extension MainPageViewController {
    
    func saveDataFromServer() {
        
        let service = NetworkService()
        let url = "https://raw.githubusercontent.com/RishabhRaghunath/JustATest/master/posts"
        service.request(url: url, query: nil
                        , httpMethod: "GET") { result in
            switch result {
            case .success(let notes):
                self.saveData(notes: notes)
            case .failure(let error):
                print(error)
            }
        }
    }
    func saveData(notes: [BackendNotes]) {
        if !notes.isEmpty {
            for note in notes {
                if let firstElement = notesArray.first(where: {$0.title == note.title && note.body == $0.body}) {
                    print("\(firstElement.title ?? "") already exists")
                } else {
                    saveItems(serverNotes: note)
                }
            }
        }
    }
    
    func saveItems(serverNotes: BackendNotes) {
        
        let note = Note(context: context)
        note.title = serverNotes.title
        note.body = serverNotes.body
        let date = serverNotes.date ?? ""
        note.date = Date(timeIntervalSince1970: date.convertToTimeInterval())
        note.image = serverNotes.image
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        loadNotes()
    }
}
extension String {
    func convertToTimeInterval() -> TimeInterval {
        guard self != "" else {
            return 0
        }
        
        var interval:Double = 0
        
        let parts = self.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        
        return interval
    }
}
