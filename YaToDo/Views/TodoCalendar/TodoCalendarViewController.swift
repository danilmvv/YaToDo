//
//  TodoCalendarViewController.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 04/07/24.
//

import UIKit
import SwiftUI

class TodoCalendarViewController: UIViewController, UITableViewDelegate {
    var todos: [TodoItem] = []
    var grouped: [Date?: [TodoItem]] = [:]
    var sectionTitles: [String] = []
    var sections: [Date?] = []
    
    private var selectedSectionIndex: Int?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    
    private var isScrollingTableView = false
    
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sectionTitle = sections[indexPath.section]
        if let todo = grouped[sectionTitle]?[indexPath.row] {
            cell.textLabel?.text = todo.text
        }
        return cell
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        cell.dateLabel.text = sectionTitles[indexPath.item]
        return cell
    }
}


