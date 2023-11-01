import Flutter
import UIKit

public class SwiftEraserPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "eraser", binaryMessenger: registrar.messenger())
    let instance = SwiftEraserPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method  == "clearAllAppNotifications") {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
        result(nil)
    } else if(call.method == "clearAppNotificationsByTag") {
        if #available(iOS 10.0, *) {
            let args = call.arguments as! Dictionary<String, String>
            let tag = args["tag"]! as String
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [tag])
        }
        result(nil)
    } else if(call.method == "clearSpecificAppNotifications") {
        if #available(iOS 10.0, *) {
            let args = call.arguments as! Dictionary<String, String>
            let dataKey = args["dataKey"]! as String
            let dataValue = args["dataValue"]! as String
            let center = UNUserNotificationCenter.current()
            
            center.getDeliveredNotifications { notifications in
                    let notificationsToRemove = notifications.filter { notification in
                        if let userInfo = notification.request.content.userInfo as? [String: Any],
                           let type = userInfo[dataKey] as? String,
                           type == dataValue {
                            return true
                        }
                        return false
                    }

                    if !notificationsToRemove.isEmpty {
                        let identifiersToRemove = notificationsToRemove.map { $0.request.identifier }
                        center.removeDeliveredNotifications(withIdentifiers: identifiersToRemove)
                        print("Removed notifications with \(dataKey) matching tag: \(dataValue)")
                    } else {
                        print("No notifications found with \(dataKey) matching tag: \(dataValue)")
                    }
                }
        }
        result(nil)
    } else if(call.method == "resetBadgeCountAndRemoveNotificationsFromCenter") {
        UIApplication.shared.applicationIconBadgeNumber = 0
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
        result(nil)
    } else if(call.method == "resetBadgeCountButKeepNotificationsInCenter") {
        UIApplication.shared.applicationIconBadgeNumber = -1
        result(nil)
    } else {
        result(FlutterMethodNotImplemented)
    }
  }
}
