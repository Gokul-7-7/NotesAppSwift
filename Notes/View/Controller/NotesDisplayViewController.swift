//
//  File.swift
//  Notes
//
//  Created by Gokul on 17/05/22.
//

import Foundation
import UIKit
import TinyConstraints
import Kingfisher

class NotesDisplayViewController: UIViewController {
    
    //MARK: - Properties
    
    private let note: Note
    
    init(note: Note) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        setupViews()
        configure(with: note)
    }
    
    
    //MARK: - view
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(36)
        view.numberOfLines = 0
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(16)
        return view
    }()
    
    lazy var descriptionView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = .systemFont(ofSize: 24)
        return view
    }()
    
    //MARK: - Setup Views
    
    private func setupViews() {
        addViews()
        setupConstraints()
    }
    
    private func addViews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(descriptionView)
    }
    
    private func setupConstraints() {
        
        imageView.topToSuperview(usingSafeArea: true)
        imageView.leadingToSuperview()
        imageView.trailingToSuperview()
        imageView.height(100)
        
        titleLabel.topToBottom(of: imageView, offset: 20)
        titleLabel.leadingToSuperview(offset: 20)
        titleLabel.trailingToSuperview(offset: 20)
        
        dateLabel.topToBottom(of: titleLabel, offset: 20)
        dateLabel.leadingToSuperview(offset: 20)
        dateLabel.trailingToSuperview(offset: 20)
        
        descriptionView.topToBottom(of: dateLabel, offset: 20)
        descriptionView.leadingToSuperview(offset: 20)
        descriptionView.trailingToSuperview(offset: 20)
        descriptionView.bottomToSuperview()
    }
    
}

extension NotesDisplayViewController {
    func configure(with note: Note) {
        self.titleLabel.text = note.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        let myStringDate = formatter.string(from: note.date ?? Date())
        self.dateLabel.text = myStringDate
        self.descriptionView.text = note.body
        
        if let imageUrl = note.image {
            let url = URL(string: imageUrl)
            imageView.kf.setImage(with: url)
        }
        
        
    }
}
