import Flutter
import UIKit

let channelName = "in_app_file_view.io.channel/method"
let viewName = "in_app_file_view.io.view/local"

public class InAppFileViewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
      let instance = InAppFileViewPlugin()

      registrar.addMethodCallDelegate(instance, channel: channel)
      registrar.register(FileViewFactory.init(messenger: registrar.messenger()), withId: viewName)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch (call.method) {
        case "getTemporaryPath":
          let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).map(\.path).first
          result(path)
          break
        default:
          result(FlutterMethodNotImplemented)
          break
      }
    }
}
