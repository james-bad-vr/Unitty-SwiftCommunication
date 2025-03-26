import Foundation
import AVFoundation

@objc public class UnityPlugin : NSObject {
    
    @objc public static let shared = UnityPlugin()
    private let deviceMonitor = UVCDeviceMonitor()
    
    override init() {
        super.init()
        NSLog("UnityPlugin: Initializing")
        checkCameraPermissions()
        
        // Log UVC entitlement status
        let hasEntitlement = hasUVCDeviceAccessEntitlement()
        NSLog("UnityPlugin: Has UVC device access entitlement: \(hasEntitlement)")
    }
    
    private func checkCameraPermissions() {
        NSLog("UnityPlugin: Checking camera permissions")
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            NSLog("UnityPlugin: Camera access already authorized")
        case .notDetermined:
            NSLog("UnityPlugin: Camera access not determined, requesting...")
            AVCaptureDevice.requestAccess(for: .video) { granted in
                NSLog("UnityPlugin: Camera access \(granted ? "granted" : "denied")")
            }
        case .denied:
            NSLog("UnityPlugin: Camera access denied")
        case .restricted:
            NSLog("UnityPlugin: Camera access restricted")
        @unknown default:
            NSLog("UnityPlugin: Unknown camera access status")
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
}
