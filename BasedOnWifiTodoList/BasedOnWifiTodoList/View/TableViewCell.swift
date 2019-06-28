//
//  TableViewCell.swift
//  TodoListHackathon
//
//  Created by Daisy on 26/06/2019.
//  Copyright © 2019 고정아. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {
    
    let contentTextfield = UITextField()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contentTextfield)
        setupLayout()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentTextfield.text = "□  "
    }
    
    private func setupLayout() {
        let guide = safeAreaLayoutGuide
        let margin: CGFloat = 100
        contentTextfield.translatesAutoresizingMaskIntoConstraints = false
        contentTextfield.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        contentTextfield.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        contentTextfield.widthAnchor.constraint(equalTo: guide.widthAnchor).isActive = true
        contentTextfield.heightAnchor.constraint(equalToConstant: 70)
        
    }
}
