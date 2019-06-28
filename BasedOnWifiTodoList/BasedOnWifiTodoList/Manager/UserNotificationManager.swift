//
//  UserNotificationManager.swift
//  TestCollectionView
//
//  Created by CHANGGUEN YU on 27/06/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit
import UserNotifications
import SystemConfiguration.CaptiveNetwork

final class UNNotificationManager: NSObject {
  
  private let center = UNUserNotificationCenter.current()
  
  func register() {
    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    center.delegate = self
    center.requestAuthorization(options: options) { (isGranted, error) in
      guard isGranted else {
        print(error?.localizedDescription ?? "")
        return self.requestAlertNotification()
      }
      self.setupNotificationCategories()
    }
  }
  
//  func getNotificationSettings(with completionHandler: @escaping (Bool) -> Void) {
//    center.getNotificationSettings {
//      completionHandler($0.authorizationStatus == .authorized)
//    }
//  }
  
  private func requestAlertNotification() {
    guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else { return }
    DispatchQueue.main.async {
      UIApplication.shared.open(settingUrl)
    }
  }
  
  
  /***************************************************
   SetupNotificationCategories
   ***************************************************/
  
  func setupNotificationCategories() {
    let repeatAction = UNNotificationAction(
      identifier: "Action",
      title: "Repeat",
      options: []
    )
    let basicCategory = UNNotificationCategory(
      identifier: "Category",
      actions: [repeatAction],
      intentIdentifiers: []
    )
    
    center.setNotificationCategories([basicCategory])
    
    /***************************************************
     - UNNotificationActionOptions
     .foreground : 버튼 눌렀을 때 앱을 실행하도록 함
     .destructive : delete, remove 등 주의해야 하는 작업에 적용
     .authenticationRequired : 디바이스 락이 걸린 상태로 사용 못 하도록 함
     ***************************************************/
    
//    let removeAction = UNNotificationAction(
//      identifier: Identifier.removeAction,
//      title: "Remove",
//      options: [.destructive, .foreground]
//    )
//
//    let textInputAction = UNTextInputNotificationAction(
//      identifier: Identifier.textInputAction,
//      title: "Change Title",
//      options: [.authenticationRequired],
//      textInputButtonTitle: "Save",
//      textInputPlaceholder: "Repeat with input message"
//    )
//
//    let anotherCategory = UNNotificationCategory(
//      identifier: Identifier.anotherCategory,
//      actions: [ removeAction, textInputAction],
//      intentIdentifiers: [],
//      options: [.customDismissAction]
//    )
//    center.setNotificationCategories(
//      [basicCategory, anotherCategory]
//    )
  }
  
  
  
  /***************************************************
   TimeIntervalNotification - TimeInterval로 지정한 시간(초) 이후로 알림 등록
   ***************************************************/
  
  func triggerTimeIntervalNotification(with title: String, timeInterval: TimeInterval = 3.0) {
    let content = UNMutableNotificationContent()
    content.categoryIdentifier = "Category"//Identifier.anotherCategory
    content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
    content.body = NSString.localizedUserNotificationString(forKey: "Alarm fired", arguments: nil)
    
    if #available(iOS 12.0, *) {
      content.sound = .defaultCritical
    } else {
      content.sound = .default
    }
    
//    // 미설정 시 사운드 X
//    let soundName = UNNotificationSoundName(rawValue: "sweetalertsound4.wav")
//    content.sound = UNNotificationSound(named: soundName)
//
    // badge
    content.badge = 1 // or nil
    
    // Image
    if let imageUrl = Bundle.main.url(forResource: "cat", withExtension: "jpeg") {
      let attachment = try! UNNotificationAttachment(identifier: "attachmentImage", url: imageUrl)
      
      content.attachments = [attachment]
    }
    
    // Audio : 5MB
    // Image : 10MB
    // Movie : 50MB
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false) // repeats: true  60 초 이하시 error
    
    let request = UNNotificationRequest(identifier: "timeIntervalRequest", content: content, trigger: trigger)
    center.add(request)
  }

  func fetchNetworkInfo() -> NetworkInfo? {
    if let interfaces: NSArray = CNCopySupportedInterfaces() {
      var networkInfos: NetworkInfo?
      for interface in interfaces {
        let interfaceName = interface as! String
        var networkInfo = NetworkInfo(interface: interfaceName,
                                      success: false,
                                      ssid: nil,
                                      bssid: nil)
        if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
          networkInfo.success = true
          networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
          networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
        }
        networkInfos = networkInfo
      }
      return networkInfos
    }
    return nil
  }
}


extension UNNotificationManager: UNUserNotificationCenterDelegate {
  
  ///// ForeGround 상태에서 Noti 받았을 대 동작
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("\n--------- willPresent ------------\n")
    print(notification)
    completionHandler([.alert, .sound])
  }
  
  //// ForeGround 상태가 아닐때 동작
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    print("\n--------- didReceive ------------\n")
    let content = response.notification.request.content
    let categoryID = content.categoryIdentifier
    
    if categoryID == "Category"{//Identifier.basicCategory {
      switch response.actionIdentifier {
      case UNNotificationDefaultActionIdentifier:
        print("Tap Notification")
      case "Action":
        print("Action")
        triggerTimeIntervalNotification(with: "Reminder")
      default:
        print("Unknown action")
      }
    }
//    } else if categoryID == Identifier.anotherCategory {
//      switch response.actionIdentifier {
//      // X 버튼 눌렀을 때의 Action
//      case UNNotificationDismissActionIdentifier:
//        print("Dissmiss Notification")
//      case Identifier.removeAction:
//        print("Remove Action")
//      // TODO: Remove data
//      case Identifier.textInputAction:
//        if let inputResponse = response as? UNTextInputNotificationResponse {
//          triggerTimeIntervalNotification(with: inputResponse.userText)
//        }
//      default:
//        print("Unknown Action")
//      }
//    }
    print(response)
    completionHandler()
  }
}
