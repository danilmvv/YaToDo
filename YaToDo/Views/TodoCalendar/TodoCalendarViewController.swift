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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        groupTodos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupViews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TodoCalendarViewController {
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
        let sectionTitle = sectionTitles[section]
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
}

