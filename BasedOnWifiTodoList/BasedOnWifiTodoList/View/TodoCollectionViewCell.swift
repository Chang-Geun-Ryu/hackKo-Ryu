//
//  TodoCollectionViewCell.swift
//  TestCollectionView
//
//  Created by CHANGGUEN YU on 26/06/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class TodoCollectionViewCell: UICollectionViewCell {
  static let identifier = "TodoCell"
  static let cellSize: CGFloat = 30
  static let cellCount: Int = 6
  
  let tableView = UITableView()
  
  
  var locationTodoInfo: LocationTodoInfo?
  var title: String?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.borderColor = UIColor.darkGray.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 10
    
    setupTableView()
    setupTableViewAutolayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupTableView() {
    tableView.backgroundColor = .clear
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.dataSource = self
    tableView.rowHeight = TodoCollectionViewCell.cellSize
    tableView.allowsSelection = false
    
//    addSubview(tableView)
    backgroundView = tableView
  }
  
  private func setupTableViewAutolayout() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
}

extension TodoCollectionViewCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = locationTodoInfo?.todoList.count {
      return count + 1 > 7 ? 7 : count + 1
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    if indexPath.row == 0 {
      cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
      let texts = title?.split(separator: ",").reduce("위치: ") { $0 + String($1) + " "}
      
      cell.textLabel?.text = texts ?? "제목"
      return cell
    } else if indexPath.row == 6 {
      cell.textLabel?.text = "•••"
      cell.textLabel?.alpha = 0.3
      return cell
    }
    
    cell.textLabel?.alpha = 0.8
    cell.textLabel?.text = locationTodoInfo?.todoList[indexPath.row - 1].todo ?? "Todo"
    cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
    
    return cell
  }
  
  
}
