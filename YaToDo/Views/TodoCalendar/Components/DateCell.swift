//
//  DateCell.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 04/07/24.
//

import UIKit

class DateCell: UICollectionViewCell {

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        contentView.layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("coder")
    }

    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 1 : 0
            contentView.layer.borderColor = isSelected ? UIColor.gray.cgColor : UIColor.clear.cgColor
            contentView.backgroundColor = isSelected ? UIColor.lightGray : UIColor.clear
        }
    }
}
