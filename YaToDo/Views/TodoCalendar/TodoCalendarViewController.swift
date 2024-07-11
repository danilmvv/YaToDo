//
//  TodoCalendarViewController.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 04/07/24.
//

import UIKit
import SwiftUI
import Combine

protocol TodoCalendarViewControllerDelegate: AnyObject {
    func didMarkTodoAsDone(_ todo: TodoItem)
}

class TodoCalendarViewController: UIViewController, UITableViewDelegate {
    var todos: [TodoItem] = [] {
        didSet {
            groupTodos()
        }
    }
    
    var grouped: [Date?: [TodoItem]] = [:]
    var sectionTitles: [String] = []
    var sections: [Date?] = []
    
    weak var delegate: TodoCalendarViewControllerDelegate?
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: TodoItemCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.bottom = 44
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 80, height: 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = UIColor.secondarySystemBackground
        return collectionView
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        groupTodos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(dividerView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            
            dividerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            tableView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func groupTodos() {        
        grouped = Dictionary(grouping: todos, by: { $0.deadline?.startOfDay })
        
        sections = grouped.keys.sorted {
            if let first = $0, let second = $1 {
                return first < second
            } else if $0 == nil {
                return false
            } else {
                return true
            }
        }
        
        sectionTitles = sections.map {
            $0 != nil ? $0!.formattedDayMonth() : "Другое"
        }
        
        tableView.reloadData()
    }
}


extension TodoCalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDate = sections[section]
        return grouped[sectionDate]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemCell.reuseIdentifier, for: indexPath) as? TodoItemCell else {
            return UITableViewCell()
        }
        
        let sectionDate = sections[indexPath.section]
        if let todo = grouped[sectionDate]?[indexPath.row] {
            configureCell(cell, with: todo)
        }
        
        addSwipeGestures(to: cell, at: indexPath)
        
        return cell
    }
    
    private func configureCell(_ cell: TodoItemCell, with todo: TodoItem) {
        let text = todo.text
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        if todo.isDone {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, attributedString.length))
        } else {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, attributedString.length))
        }
        
        cell.configure(with: attributedString, categoryColor: UIColor(todo.category.color))
    }
    
    private func addSwipeGestures(to cell: UITableViewCell, at indexPath: IndexPath) {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipe.direction = .left
        cell.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipe.direction = .right
        cell.addGestureRecognizer(rightSwipe)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard let cell = gesture.view as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }
        
        let sectionDate = sections[indexPath.section]
        guard let todo = grouped[sectionDate]?[indexPath.row] else { return }
        
        if (gesture.direction == .left && todo.isDone) || (gesture.direction == .right && !todo.isDone) {
            delegate?.didMarkTodoAsDone(todo)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let visibleIndexPaths = tableView.indexPathsForVisibleRows
            if let firstVisibleIndexPath = visibleIndexPaths?.first {
                let section = firstVisibleIndexPath.section
                collectionView.selectItem(at: IndexPath(item: section, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
}


extension TodoCalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.item
        tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: false)
    }
}


extension TodoCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCell else {
            return UICollectionViewCell()
        }
        cell.dateLabel.text = sectionTitles[indexPath.item]
        return cell
    }
}


