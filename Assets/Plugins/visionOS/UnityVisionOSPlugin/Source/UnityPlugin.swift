import Foundation
import AVFoundation

@objc public class UnityPlugin : NSObject {
    
    @objc public static let shared = UnityPlugin()
    private let deviceMonitor = UVCDeviceMonitor()
    
    override init() {
        super.init()
        NSLog("UnityPlugin: Initializing")
        requestCameraPermissionExplicitly()
        
        // Log UVC entitlement status
        let hasEntitlement = hasUVCDeviceAccessEntitlement()
        NSLog("UnityPlugin: Has UVC device access entitlement: \(hasEntitlement)")
    }
    
    private func requestCameraPermissionExplicitly() {
        NSLog("UnityPlugin: Explicitly requesting camera permission")
        
        // First check current status
        let currentStatus = AVCaptureDevice.authorizationStatus(for: .video)
        NSLog("UnityPlugin: Current camera authorization status: \(currentStatus.rawValue)")
        
        // Always request explicitly regardless of current status
        // This ensures the permission dialog appears if not already determined
        AVCaptureDevice.requestAccess(for: .video) { granted in
            NSLog("UnityPlugin: Camera access explicitly requested, result: \(granted ? "granted" : "denied")")
            
            if granted {
                // Try to initialize device discovery after permission granted
                DispatchQueue.main.async {
                    self.deviceMonitor.refreshDevices()
                }
            }
        }
    }
    
    func hasUVCDeviceAccessEntitlement() -> Bool {
        guard let entitlements = Bundle.main.infoDictionary?["Entitlements"] as? [String: Any] else {
            NSLog("UnityPlugin: No Entitlements found in info dictionary")
            return false
        }
        
        let hasUVCAccess = entitlements["com.apple.developer.avfoundation.uvc-device-access"] as? Bool ?? false
        NSLog("UnityPlugin: UVC access entitlement value: \(hasUVCAccess)")
        return hasUVCAccess
    }
    
    @objc public func AddTwoNumber(a:Int,b:Int ) -> Int {
        let result = a+b;
        return result;
    }
    
    @objc public func GetConnectedDeviceCount() -> Int {
        NSLog("UnityPlugin: GetConnectedDeviceCount called")
        return deviceMonitor.getDeviceCount()
    }
    
    @objc public func GetDeviceName(at index: Int) -> String {
        NSLog("UnityPlugin: GetDeviceName called with index \(index)")
        return deviceMonitor.getDeviceName(at: index)
    }
    
    @objc public func GetDeviceUniqueID(at index: Int) -> String {
        NSLog("UnityPlugin: GetDeviceUniqueID called with index \(index)")
        return deviceMonitor.getDeviceUniqueID(at: index)
    }
    
    @objc public func HasUVCEntitlement() -> Bool {
        return hasUVCDeviceAccessEntitlement()
    }
    
    @objc public func RequestCameraPermission() -> Void {
        requestCameraPermissionExplicitly()
    }
}
