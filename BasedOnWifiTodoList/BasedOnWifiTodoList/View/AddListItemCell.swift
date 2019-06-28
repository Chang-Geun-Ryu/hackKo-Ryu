//
//  AddListItemCell.swift
//  TodoListHackathon
//
//  Created by Daisy on 26/06/2019.
//  Copyright © 2019 고정아. All rights reserved.
//

import UIKit

class AddListItemCell: UITableViewCell {
    
    let listItemButton = UIButton(type: .custom)
    let lineLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(listItemButton)
        addSubview(lineLabel)
        setupLayout()
        configureObjects()
        
        //        let string = "+ List item"
        //        let attributedString = NSMutableAttributedString(string: string)
        //
        //        let secondAttributes: [NSAttributedString.Key: Any] = [
        //            .foregroundColor: UIColor.red,
        //            .backgroundColor: UIColor.blue,
        //            .strikethroughStyle: 1]
        //
        //        attributedString.addAttributes(secondAttributes, range: NSRange(location: 8, length: 11))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureObjects() {
        
        listItemButton.setTitle("+ List Item", for: .normal)
        listItemButton.setTitleColor(.lightGray, for: .normal)
        listItemButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        lineLabel.backgroundColor = .lightGray
        
    }
    
    @objc func didTapButton() {
        print("tapped Button")
        let todoList = TodoList(todo: "", complete: false)
        DataManager.shared.addTodoList(todoList)
        
        NotificationCenter.default.post(name: NSNotification.Name("didTapAddList"), object: nil)
        
    }
    
    private func setupLayout() {
        let margin: CGFloat = 20
        
        listItemButton.translatesAutoresizingMaskIntoConstraints = false
        listItemButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5).isActive = true
        listItemButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin).isActive = true
        listItemButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        listItemButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        lineLabel.translatesAutoresizingMaskIntoConstraints = false
        lineLabel.topAnchor.constraint(equalTo: listItemButton.bottomAnchor, constant: -10).isActive = true
        lineLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
}
