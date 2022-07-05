//
//  CustomCollectionViewCell.swift
//  Notes
//
//  Created by Gokul on 16/05/22.
//

import Foundation
import UIKit
import TinyConstraints

struct CustomCollectionViewCellViewData {
    let title: String
    let date: Date
}

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        setupHierarchy()
        setupConstraints()
        setupUI()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
    }
    
    private func setupConstraints() {
        titleLabel.edgesToSuperview(excluding: .bottom, insets: .init(top: 20, left: 20, bottom: 0, right: 20))
        dateLabel.topToBottom(of: titleLabel, offset: 10)
        dateLabel.edgesToSuperview(excluding: .top, insets: .init(top: 0, left: 20, bottom: 20, right: 20))
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        let colorArray: [UIColor] = [.systemYellow, .systemOrange, .systemGreen, .systemCyan, .systemPink, .systemMint, .systemTeal]
        contentView.backgroundColor = colorArray.randomElement()
    }
    
}

extension CustomCollectionViewCell {
    func configure(with note: Note) {
        titleLabel.text = note.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        let myStringDate = formatter.string(from: note.date ?? Date())
        
        dateLabel.text = myStringDate
    }
}
