//
//  TodoList.swift
//  TestCollectionView
//
//  Created by CHANGGUEN YU on 26/06/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import Foundation

let noti = NotificationCenter.default

struct WifiInfoList {
  var anotherName: String
  var wifiSSID: String
  var wifiBSSID: String
  var wifiSSIDData: String
  
  mutating func editAnotherName(_ anotherName: String) {
    self.anotherName = anotherName
  }
}

struct TodoList {
  var todo: String
  var complete: Bool
}

struct LocationTodoInfo {
  var reservatingWiFisAlarm: [String]
  var isAlarm: Bool
  var todoList: [TodoList]
  
  func getUsingList() -> String {
    
    return reservatingWiFisAlarm.reduce("") {$0 + $1 + ","}
  }
}

struct NetworkInfo {
  var interface: String
  var success: Bool = false
  var ssid: String?
  var bssid: String?
}

func sampleData() -> [LocationTodoInfo] {
  var info: [LocationTodoInfo] = []
  
  let firstLocal = LocationTodoInfo(reservatingWiFisAlarm: ["집"], isAlarm: true, todoList: [1,2,].map { TodoList(todo: "\($0)", complete: false) })
  info.append(firstLocal)
  
  let secondLocal = LocationTodoInfo(reservatingWiFisAlarm: ["어니언", "대림창고"], isAlarm: false, todoList: ["일", "이", "삼", "사", "오", "육", "칠", "팔"].map { TodoList(todo: $0, complete: false) })
  info.append(secondLocal)
  
  let thirdLocal = LocationTodoInfo(reservatingWiFisAlarm: ["회사"], isAlarm: false, todoList: [])
  info.append(thirdLocal)
  
  return info
}

func sampleWifis() -> [WifiInfoList] {
  var wifi: [WifiInfoList] = []
  
  wifi.append(WifiInfoList(anotherName: "집", wifiSSID: "wifi", wifiBSSID: "12:34:56:78", wifiSSIDData: "ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹ"))
  wifi.append(WifiInfoList(anotherName: "회사", wifiSSID: "company", wifiBSSID: "ab:cd:ef:12", wifiSSIDData: "sdfgdshcvb"))
  wifi.append(WifiInfoList(anotherName: "어니언", wifiSSID: "onion", wifiBSSID: "aa:bb:cc:dd", wifiSSIDData: "ertwertwertwer"))
  wifi.append(WifiInfoList(anotherName: "대림창고", wifiSSID: "derim Store", wifiBSSID: "11:22:33:44", wifiSSIDData: "htysdfnasdofin"))
  wifi.append(WifiInfoList(anotherName: "멀라wifi", wifiSSID: "what", wifiBSSID: "55:44:33:22", wifiSSIDData: "hyhoidusafiub"))
  
  return wifi
}


class DataManager {
  static let shared = DataManager()
  private init() { }
  
  private var todoList: [TodoList] = []
  
  private var title: String = ""
  
  func addTodoList(_ list:TodoList) {
    todoList.append(list)
  }
  
  func removeTodoList() {
    _ = todoList.popLast()
  }
  ///////////////////////
  
  func getAllTodoList() -> [TodoList] {
    return todoList
  }
  
  func getCompletedTodoList() -> [TodoList] {
    return todoList.filter{ $0.complete == true }
  }
  
  func getUnCompletedTodoList() -> [TodoList] {
    return todoList.filter{ $0.complete == false }
  }
  
  func setTodoListTodo(_ th: Int, _ todo: String) {
    todoList[th].todo = todo
  }
  
  func setTodoListIsComplete(_ th: Int, _ complete: Bool) {
    todoList[th].complete = complete
  }
  
  
  
  //////////////////////
  
  func getTitle() -> String {
    return title
  }
  
  func setTitle(_ title: String) {
    self.title = title
    NotificationCenter.default.post(name: NSNotification.Name("getTitle"),
                                    object: nil)
  }
}