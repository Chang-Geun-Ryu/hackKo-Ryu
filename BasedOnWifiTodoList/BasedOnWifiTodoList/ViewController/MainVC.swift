//
//  ViewController.swift
//  TestCollectionView
//
//  Created by CHANGGUEN YU on 26/06/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit
import CoreLocation

final class MainVC: UIViewController {
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: FlexibleLayout())
  private let searchController = UISearchController(searchResultsController: nil)
  private let todoListUpButton = UIButton(type: .custom)
  
  private let notiManger = UNNotificationManager()
  
  private var localTodoList: [LocationTodoInfo] = sampleData() // test data
  static var registedWifis: [WifiInfoList] = sampleWifis()
  
  private var lastRequestDate = Date()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    viewsConfigure()
    setupNavigationItem()
    searchMethod()
    viewsAutoLayout()
  }
  
  // view setting
  private func viewsAutoLayout() {
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: todoListUpButton.topAnchor).isActive = true
    
    todoListUpButton.translatesAutoresizingMaskIntoConstraints = false
    todoListUpButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
    todoListUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
    todoListUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    todoListUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
  }

  private func viewsConfigure() {
    
    if let flecibleLayout = collectionView.collectionViewLayout as? FlexibleLayout {
      flecibleLayout.delegate = self
    }
    
    collectionView.backgroundColor = .white
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
    collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: TodoCollectionViewCell.identifier)
    view.addSubview(collectionView)
    
    todoListUpButton.setTitle("Todo List Up", for: .normal)
    todoListUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
    todoListUpButton.setTitleColor(.black, for: .normal)
    todoListUpButton.layer.borderWidth = 1
    todoListUpButton.layer.borderColor = UIColor.darkGray.cgColor
    todoListUpButton.addTarget(self, action: #selector(showTodoViewControl(_:)), for: .touchUpInside)
    view.addSubview(todoListUpButton)
    
  }
  
  private func setupNavigationItem() {
    navigationItem.title = "배고파"
  }
  
  private func searchMethod() {
    if #available(iOS 11.0, *) {
      let searchBar = searchController.searchBar
      searchBar.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
      searchBar.barTintColor = .white
      searchController.searchResultsUpdater = self
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.delegate = self
      definesPresentationContext = true
      
      if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
        textfield.textColor = UIColor.blue
        textfield.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        if let backgroundview = textfield.subviews.first {
          
          // Background color
          backgroundview.backgroundColor = UIColor.white
          
          // Rounded corner
          backgroundview.layer.cornerRadius = 10;
          backgroundview.clipsToBounds = true;
        }
      }
      
      if let navigationbar = self.navigationController?.navigationBar {
        navigationbar.barTintColor = .white
      }
      navigationItem.searchController = searchController
      navigationItem.hidesSearchBarWhenScrolling = false
    }
  }
  
  @objc private func showTodoViewControl(_ sender: UIButton) {
    let memoVC = MemoViewController()
//    memoVC.reservatingWiFisAlarm = localTodoList[indexPath.item].reservatingWiFisAlarm
//    memoVC.locationToDoInfo
    navigationController?.pushViewController(memoVC, animated: true)
  }
  
  private func findSameWifiInfo(bssid: String) -> Bool {
    for wifi in MainVC.registedWifis {
      if wifi.wifiBSSID == bssid { return true }
    }
    
    return false
  }
  
}

extension MainVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return localTodoList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.identifier, for: indexPath) as! TodoCollectionViewCell
    
    cell.locationTodoInfo = localTodoList[indexPath.item]
    cell.title = localTodoList[indexPath.item].getUsingList()
    
    return cell
  }
}

extension MainVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //let wifiVC = SetupWiFiVC()
    let memoVC = MemoViewController()
//    memoVC.reservatingWiFisAlarm = localTodoList[indexPath.item].reservatingWiFisAlarm
    memoVC.locationToDoInfo = localTodoList[indexPath.item]
    navigationController?.pushViewController(memoVC, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
  }
}

extension MainVC: FlexibleLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
    if localTodoList[indexPath.item].todoList.count < 7 {
      return (CGFloat(localTodoList[indexPath.item].todoList.count + 1) * TodoCollectionViewCell.cellSize + 10)
    }
    return (CGFloat(7) * TodoCollectionViewCell.cellSize + 10)
  }
}

extension MainVC: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    print("검색중")
    let searchBar = searchController.searchBar
//    filterContentForSearchText(searchController.searchBar.text!)
  }
  
}

extension MainVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//    filterContentForSearchText(searchBar.text!)
  }
}

extension MainVC: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let current = locations.last!
    if (abs(current.timestamp.timeIntervalSinceNow) < 1) {
      let coordnate = current.coordinate
      
      print("coordnate: ", coordnate)
      
      let currentDate = Date()
      if abs(lastRequestDate.timeIntervalSince(currentDate)) > 10 {
        if let workInfo = notiManger.fetchNetworkInfo(),
          let ssid = workInfo.ssid,
          let bssid = workInfo.bssid,
        findSameWifiInfo(bssid: bssid) == false {
          notiManger.triggerTimeIntervalNotification(with: ssid, timeInterval: 0.01)
          lastRequestDate = currentDate
        }
      }
    }
  }
}
