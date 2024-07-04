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
    var grouped: [String: [TodoItem]] = [:]
    var sectionTitles: [String] = []
    
    private var selectedSectionIndex: Int?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        grouped = Dictionary(grouping: todos) { todo in
            todo.deadline != nil ? todo.deadline!.formattedDayMonth() : "Другое"
        }
        
        sectionTitles = grouped.keys.sorted()
        grouped = grouped.mapValues { $0.sorted(by: { $0.dateCreated < $1.dateCreated }) }
        
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
        return grouped[sectionTitle]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sectionTitle = sectionTitles[indexPath.section]
        if let todo = grouped[sectionTitle]?[indexPath.row] {
            cell.textLabel?.text = todo.text
        }
        return cell
    }
}

