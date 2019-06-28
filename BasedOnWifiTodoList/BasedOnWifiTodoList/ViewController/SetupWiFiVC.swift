//
//  SetupWiFiVC.swift
//  TestCollectionView
//
//  Created by CHANGGUEN YU on 27/06/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class SetupWiFiVC: UIViewController {
  
  private let wifiAlarmSwitch = UISwitch()
  private let tableView = UITableView()
//  var registedWifis: [WifiInfoList] = MainVC.registedWifis
  var reservatingWiFisAlarm: [WifiInfoList]?
  private var isButtonClick = false
  private let notiManger = UNNotificationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewsConfigure()
    setupNavigationItem()
    viewsAutoLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    reservatingWiFisAlarm = MainVC.localTodoList[MainVC.indexLocalTodoList].reservatingWiFisAlarm
  }
  
  private func viewsConfigure() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.rowHeight = 40
    tableView.dataSource = self
    tableView.delegate = self
    tableView.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
    view.addSubview(tableView)
  }
  
  private func viewsAutoLayout() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
  }
  
  private func setupNavigationItem() {
    navigationItem.title = "Setting"
    
    let backButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(dismissSetupWiFiView(_:)))
    backButton.tintColor = UIColor.darkGray
    navigationItem.leftBarButtonItem = backButton
  }
  
  @objc private func dismissSetupWiFiView(_ sender: UIBarButtonItem) {
    
    if let wifiList =  reservatingWiFisAlarm {
      MainVC.localTodoList[MainVC.indexLocalTodoList].reservatingWiFisAlarm = wifiList
    }
    
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func setWiFi(_ sender: UIButton) {
    print("setWiFi")
  }
  
  private func alertSameWifi() {
    let alert = UIAlertController(title: "Same Wifi Infomation", message: "같은 Wifi 정보가 등록되어 있습니다.", preferredStyle: .alert)
    let okAlert = UIAlertAction(title: "ok", style: .default)
    alert.addAction(okAlert)
    
    present(alert, animated: true)
  }
  
  @objc private func addWifi(_ sender: UIButton) {
    let alert = UIAlertController(title: "WiFi Naming", message: "Wifi 이름을 설정해 주세요", preferredStyle: .alert)
    alert.addTextField()
    alert.textFields![0].placeholder = "Enter Wifi Name"
    
    guard let wifiInfo = self.notiManger.fetchNetworkInfo(),
      wifiInfo.success
    else { return print("get wifi Info fail")}
    
    guard let bssid = wifiInfo.bssid,
    findSameWifiInfo(bssid: bssid) == false
    else { return alertSameWifi() }
    
    let okAlert = UIAlertAction(title: "확인", style: .default) { (action) in
      let wifiname = alert.textFields![0].text
      let wifi = WifiInfoList(anotherName: wifiname ?? "", wifiSSID: wifiInfo.ssid ?? "", wifiBSSID: wifiInfo.bssid ?? "", wifiSSIDData: "3")
      MainVC.registedWifis.append(wifi)
      self.isButtonClick = true
      self.tableView.reloadSections([1], with: .automatic)
    }
    
    let cancel = UIAlertAction(title: "취소", style: .cancel)
    
    alert.addAction(okAlert)
    alert.addAction(cancel)
    
    present(alert, animated: true)
  }
  
  private func findSameWifiInfo(bssid: String) -> Bool {
    for wifi in MainVC.registedWifis {
      if wifi.wifiBSSID == bssid { print(bssid); return true }
    }
    print("bssid 성공!: \(bssid)")
    return false
  }
}

extension SetupWiFiVC: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? (reservatingWiFisAlarm?.count ?? 0) : MainVC.registedWifis.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "알람 설정한 와이파이" : "등록된 와이파이 리스트"
  }
  
  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return section == 0 ? "" : "+ 지금 위치 와이파이 등록"
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      cell.textLabel?.text = " " + (reservatingWiFisAlarm?[indexPath.row].anotherName ?? "alarm #\(indexPath.row)")
      
      return cell
      
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      cell.textLabel?.text = " " + MainVC.registedWifis[indexPath.row].anotherName
      
      return cell
    }
  }
}

extension SetupWiFiVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 30)
    label.text = self.tableView(tableView, titleForHeaderInSection: section)
    
    let headerView = UIView()
    headerView.backgroundColor = .white
    headerView.addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true
    label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
    label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15).isActive = true
    label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard section == 1 else { return UIView() }
    
    let button = UIButton(type: .system)
    button.setTitle(self.tableView(tableView, titleForFooterInSection: section), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .light)
    button.setTitleColor(.darkGray, for: .normal)
    button.addTarget(self, action: #selector(addWifi(_:)), for: .touchUpInside)
    
    let footerView = UIView()
    footerView.backgroundColor = .white
    footerView.addSubview(button)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 5).isActive = true
    button.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 0).isActive = true
    button.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -15).isActive = true
    button.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -10).isActive = true
    
    return footerView
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if isButtonClick{
     if indexPath.row == MainVC.registedWifis.count - 1 {
        cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.alpha = 0.3
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
          cell.layer.transform = CATransform3DIdentity
          cell.alpha = 0.8
        }, completion: nil)
      }
      return
    }
    
    cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
    cell.alpha = 0.3
    UIView.animate(withDuration: 0.3, delay: TimeInterval((CGFloat(indexPath.row) * 0.2)), options: .curveEaseInOut, animations: {
      cell.layer.transform = CATransform3DIdentity
      cell.alpha = 0.8
    }, completion: nil)
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//    if reservatingWiFisAlarm {
    if reservatingWiFisAlarm == nil {
      reservatingWiFisAlarm = [MainVC.registedWifis[indexPath.row]]
    } else {
      reservatingWiFisAlarm?.append(MainVC.registedWifis[indexPath.row])
      
//    }
    }
    tableView.reloadSections([0], with: .automatic)
  }
}
