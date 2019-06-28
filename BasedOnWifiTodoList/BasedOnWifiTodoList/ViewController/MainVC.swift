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
  
  private var collectionView: UICollectionView!  //= UICollectionView(frame: .zero, collectionViewLayout: FlexibleLayout())
  private let searchController = UISearchController(searchResultsController: nil)
  private let todoListUpButton = UIButton(type: .custom)
  
  private let notiManger = UNNotificationManager()
  
  var locationManager = CLLocationManager()
  
  static var isBackgound = false
  static var indexLocalTodoList = 0
  static var localTodoList: [LocationTodoInfo] = sampleData() // test data
  static var registedWifis: [WifiInfoList] = sampleWifis()
  
  private var lastRequestDate = Date()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
//    viewsConfigure()
//    searchMethod()
//    viewsAutoLayout()
    
    locationManager.delegate = self
    checkAuthorizationStatus()
  }
  
  func checkAuthorizationStatus() {
    print("checkAuthorizationStatus")
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      print("notDetermined")
      locationManager.requestAlwaysAuthorization()
    case .restricted, .denied:
      // Disable location features
      print("a")
      break
    case .authorizedWhenInUse:
      fallthrough
    case .authorizedAlways:
      print("startingUpdatingLocation")
      startingUpdatingLocation()
      break
    @unknown default: break
    }
  }
  
  func startingUpdatingLocation() {
    let status = CLLocationManager.authorizationStatus()
    guard status == .authorizedAlways || status == .authorizedWhenInUse, CLLocationManager.locationServicesEnabled() else { return }
    
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationManager.distanceFilter = 1
    locationManager.startUpdatingLocation()
    locationManager.startMonitoringSignificantLocationChanges()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: FlexibleLayout())
    
    viewsConfigure()
    searchMethod()
    viewsAutoLayout()
    
//    if let flecibleLayout = collectionView.collectionViewLayout as? FlexibleLayout {
//      flecibleLayout.invalidateLayout()
//    }
//    
//    collectionView.collectionViewLayout.invalidateLayout()
//    collectionView.reloadData()
    
  }
  
  // view setting
    
    var margin: CGFloat = 10
  private func viewsAutoLayout() {
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: todoListUpButton.topAnchor).isActive = true
    
    todoListUpButton.translatesAutoresizingMaskIntoConstraints = false
    // FIXME: - 여기여기
    todoListUpButton.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 12).isActive = true
    todoListUpButton.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -12).isActive = true
    todoListUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    todoListUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
  }

  private func viewsConfigure() {
    
    if let flecibleLayout = collectionView.collectionViewLayout as? FlexibleLayout {
      flecibleLayout.delegate = self
    }
    
//    collectionView.select
    collectionView.backgroundColor = .white
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.contentInset = UIEdgeInsets(top: 23, left: margin, bottom: margin, right: margin)
    collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: TodoCollectionViewCell.identifier)
    view.addSubview(collectionView)
    
//    todoListUpButton.setImage(UIImage(named: "takeanote"), for: .normal)
    todoListUpButton.setTitle("+ Take a note...", for: .normal)
    todoListUpButton.titleLabel?.alpha = 0.5
    todoListUpButton.backgroundColor = #colorLiteral(red: 0.9489938617, green: 0.948990047, blue: 0.9532188773, alpha: 1)
    todoListUpButton.layer.cornerRadius = 10
    todoListUpButton.setTitleColor(UIColor.darkGray, for: .normal)
    todoListUpButton.addTarget(self, action: #selector(showTodoViewControl(_:)), for: .touchUpInside)
    view.addSubview(todoListUpButton)
    
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
    navigationController?.pushViewController(memoVC, animated: true)
  }
  
  private func findSameWifiInfo(bssid: String) -> Bool {
    
    for list in MainVC.localTodoList {
      for wifi in list.reservatingWiFisAlarm {
        if wifi.wifiBSSID == bssid { return true }
      }
    }
    return false
  }
  
}

extension MainVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return MainVC.localTodoList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.identifier, for: indexPath) as! TodoCollectionViewCell
    
//    print("cellForItemAt : \(indexPath.item)")
    cell.locationTodoInfo = MainVC.localTodoList[indexPath.item]
    cell.title = MainVC.localTodoList[indexPath.item].getUsingList()
    cell.tableView.reloadData()
    return cell
  }
}

extension MainVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //let wifiVC = SetupWiFiVC()
    let memoVC = MemoViewController()
//    memoVC.reservatingWiFisAlarm = localTodoList[indexPath.item].reservatingWiFisAlarm
    MainVC.indexLocalTodoList =  indexPath.row
    memoVC.locationToDoInfo = MainVC.localTodoList[indexPath.item]
    navigationController?.pushViewController(memoVC, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item % 2 == 0 {
      cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
    } else {
      cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 500, 10, 0)
    }
    cell.alpha = 0
    
    UIView.animate(withDuration: 0.3, delay: TimeInterval(Double(indexPath.item) * 0.2), options: [], animations: {
      cell.alpha = 9
      cell.layer.transform = CATransform3DIdentity
    }, completion: nil)
  }
}

extension MainVC: FlexibleLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
    if MainVC.localTodoList[indexPath.item].todoList.count < 7 {
      print((CGFloat(MainVC.localTodoList[indexPath.item].todoList.count + 1) * TodoCollectionViewCell.cellSize + 10))
      return (CGFloat(MainVC.localTodoList[indexPath.item].todoList.count + 1) * TodoCollectionViewCell.cellSize + 10)
    }
    print("FlexibleLayoutDelegate: ",(CGFloat(7) * TodoCollectionViewCell.cellSize + 10))
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
    print("locationManager")
    if (abs(current.timestamp.timeIntervalSinceNow) < 1) , MainVC.isBackgound {
      let coordnate = current.coordinate
      
      print("coordnate: ", coordnate)
      
      let currentDate = Date()
      if abs(lastRequestDate.timeIntervalSince(currentDate)) > 10 {
        print("timeIntervalSince")
        if let workInfo = notiManger.fetchNetworkInfo(),
          let ssid = workInfo.ssid,
          let bssid = workInfo.bssid,
        findSameWifiInfo(bssid: bssid) {
          notiManger.triggerTimeIntervalNotification(with: ssid, timeInterval: 0.01)
          lastRequestDate = currentDate
          print("triggerTimeIntervalNotification")
        }
      }
    }
  }
}
