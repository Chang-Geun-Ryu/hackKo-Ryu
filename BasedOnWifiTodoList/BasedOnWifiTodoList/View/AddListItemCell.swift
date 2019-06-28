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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(listItemButton)
        setupLayout()
        configureButton()
        backgroundColor = .green
        
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
    
    private func configureButton() {
        
//        listItemButton.setTitle(attributedString, for: .normal)
        listItemButton.setTitleColor(.lightGray, for: .normal)
        listItemButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton() {
        print("tapped Button")
        let todoList = TodoList(todo: "", complete: false)
        DataManager.shared.addTodoList(todoList)
        
        NotificationCenter.default.post(name: NSNotification.Name("didTapAddList"), object: nil)
        //print(self.superview as! UITableView)
        
    }
    
    private func setupLayout() {
        let guide = safeAreaLayoutGuide
        listItemButton.translatesAutoresizingMaskIntoConstraints = false
        listItemButton.widthAnchor.constraint(equalTo: guide.widthAnchor).isActive = true
        listItemButton.heightAnchor.constraint(equalToConstant: 70)
        
    }
    
}
