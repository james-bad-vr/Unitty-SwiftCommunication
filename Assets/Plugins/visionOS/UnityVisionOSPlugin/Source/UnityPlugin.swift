import Foundation
import AVFoundation

@objc public class UnityPlugin : NSObject {
    
    @objc public static let shared = UnityPlugin()
    private let deviceMonitor = UVCDeviceMonitor()
    
    @objc public func AddTwoNumber(a:Int,b:Int ) -> Int {
        let result = a+b;
        return result;
    }
    
    @objc public func GetConnectedDeviceCount() -> Int {
        return deviceMonitor.getDeviceCount()
    }
    
    @objc public func GetDeviceName(at index: Int) -> String {
        return deviceMonitor.getDeviceName(at: index)
    }
    
    @objc public func GetDeviceUniqueID(at index: Int) -> String {
        return deviceMonitor.getDeviceUniqueID(at: index)
    }
}
