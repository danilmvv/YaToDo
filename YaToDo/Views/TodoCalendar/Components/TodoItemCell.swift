//
//  Dot.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 06/07/24.
//

import UIKit

class TodoItemCell: UITableViewCell {

    static let reuseIdentifier = "TodoItemCell"

    private let dotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(dotView)
        contentView.addSubview(label)

        dotView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dotView.widthAnchor.constraint(equalToConstant: 10),
            dotView.heightAnchor.constraint(equalToConstant: 10),
            dotView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dotView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: dotView.leadingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with attributedText: NSAttributedString, categoryColor: UIColor) {
        label.attributedText = attributedText
        dotView.backgroundColor = categoryColor
    }
}
