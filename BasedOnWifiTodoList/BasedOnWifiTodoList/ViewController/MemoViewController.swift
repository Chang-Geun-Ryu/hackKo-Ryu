//
//  ViewController.swift
//  TodoListHackathon
//
//  Created by Daisy on 26/06/2019.
//  Copyright © 2019 고정아. All rights reserved.
//

import UIKit

class MemoViewController: UIViewController {
    
    let tableView = UITableView()
    let bottomView = BottomView()
//  var reservatingWiFisAlarm: 
    var doneTodoList: [TodoList]?
    var todoList: [TodoList]?
    var locationToDoInfo: LocationTodoInfo? {
        didSet {
          guard let todoList = locationToDoInfo?.todoList else { return }
          
          DataManager.shared.setTotalTodoList(todoList: todoList)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        configureViews()
        configNotifications()
        autolayout()
        

    }
    
    private func configureViews() {
        view.addSubview(tableView)
        view.addSubview(bottomView)
      
      bottomView.wifiButton.addTarget(self, action: #selector(showWifiSettingView(_:)), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(AddListItemCell.self, forCellReuseIdentifier: "AddListItemCell")
        tableView.register(ContentsCell.self, forCellReuseIdentifier: "ContentsCell")
        tableView.register(DoneTaskCell.self, forCellReuseIdentifier: "DoneTaskCell")
        
        //tableView의 default height 값 설정
        tableView.estimatedRowHeight = 60
        tableView.allowsSelection = false
        // FIXME: - seperate 어쩌고 없애기
    }
    
    private func configNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name("getTitle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name(rawValue: "didTapAddList"), object: nil)
        
        noti.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name("checkButtonDidTapped"), object: nil)
    }
    
    @objc private func reloadTableView(_ sender: Any) {
        print("haha")
        UIView.animate(withDuration: 1.5) {
            self.tableView.reloadData()
        }
    }
    
    
    private func autolayout() {
        
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 30
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: margin * 2).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: view.frame.height / 5 ).isActive = true
        
    }
  
  @objc private func showWifiSettingView(_ sender: UIButton) {
    let memoVC = SetupWiFiVC()
    navigationController?.pushViewController(memoVC, animated: true)
  }
}


extension MemoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CellType.allCases.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CellType.title.rawValue == section {
            return 1
        } else if CellType.contents.rawValue == section {
            return DataManager.shared.getUnCompletedTodoList().count
        } else if CellType.doneTask.rawValue == section {
            return DataManager.shared.getCompletedTodoList().count
        } else {
            return 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if CellType.title.rawValue == indexPath.section {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            cell.memoTitleTextfield.text = DataManager.shared.getTitle()
            cell.heightAnchor.constraint(equalToConstant: 100).isActive = true
            return cell
        } else if CellType.contents.rawValue == indexPath.section {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell", for: indexPath) as! ContentsCell
            cell.contentsTextfield.text = DataManager.shared.getUnCompletedTodoList()[indexPath.row].todo
            
            cell.th = indexPath.row
            return cell
        }   else if CellType.addList.rawValue == indexPath.section{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddListItemCell", for: indexPath) as! AddListItemCell
            return cell
        } else {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoneTaskCell", for: indexPath) as! DoneTaskCell
            // FIXME: - 여기 if 문 빼고 상단에 배열 사용
            cell.doneTaskTextfield.text = DataManager.shared.getCompletedTodoList()[indexPath.row].todo
            
            return cell
        }
    }
}

// TableView cell 높이 유동적으로 변경하기
extension MemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 1) {
//            cell.alpha = 0
//            UIView.animate(withDuration: 1) {
//                cell.alpha = 1
//            }
        }
    }
}
