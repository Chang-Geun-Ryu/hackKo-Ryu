//
//  TitleCell.swift
//  TodoListHackathon
//
//  Created by Daisy on 26/06/2019.
//  Copyright © 2019 고정아. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {


    let memoTitleTextfield = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(memoTitleTextfield)
        setupLayout()
        memoTitleTextfield.placeholder = "Title"
        memoTitleTextfield.font = UIFont.systemFont(ofSize: 40)
        backgroundColor = .red
        memoTitleTextfield.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        //let guide = safeAreaLayoutGuide
        memoTitleTextfield.translatesAutoresizingMaskIntoConstraints = false
        memoTitleTextfield.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        memoTitleTextfield.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        memoTitleTextfield.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        memoTitleTextfield.heightAnchor.constraint(equalTo:self.heightAnchor).isActive = true
        //memoTitleTextfield.heightAnchor.constraint(equalToConstant: 150)
        
    }
    
}

extension TitleCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text else { return false }
        
        DataManager.shared.setTitle(text)
        
        
        
        return true
    }
    
}
