import Foundation
import AVFoundation

@objc public class UVCDeviceMonitor: NSObject {
    private var devices: [AVCaptureDevice] = []
    private var discoverySession: AVCaptureDevice.DiscoverySession?
    private var timer: Timer?
    
    @objc public override init() {
        super.init()
        NSLog("UVCDeviceMonitor: Initializing")
        setupDiscoverySession()
        startMonitoring()
    }
    
    private func setupDiscoverySession() {
        // Try all possible video device types to see what's available
        NSLog("UVCDeviceMonitor: Setting up discovery session")
        
        // First, let's see what devices would be found with all device types
        discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes:  [.external],
            mediaType: .video,
            position: .unspecified
        )
        
        NSLog("UVCDeviceMonitor: All devices available on system:")
        discoverySession?.devices.forEach { device in
            NSLog("UVCDeviceMonitor: - \(device.localizedName) (Type: \(device.deviceType.rawValue), ID: \(device.uniqueID))")
        }

        
        updateDevices()
    }
    
    private func updateDevices() {
        // For now, get all video devices and filter for external ones
        let currentDevices = discoverySession?.devices.filter { device in
            (device.deviceType == .external)
        } ?? []
        
        // Only update if the device list has actually changed
        if Set(currentDevices.map { $0.uniqueID }) != Set(devices.map { $0.uniqueID }) {
            let oldCount = devices.count
            devices = currentDevices
            NSLog("UVCDeviceMonitor: Device count changed from \(oldCount) to \(devices.count)")
            
            if devices.count > 0 {
                NSLog("UVCDeviceMonitor: Current devices:")
                devices.forEach { device in
                    NSLog("UVCDeviceMonitor: - \(device.localizedName) (ID: \(device.uniqueID))")
                }
            }
        }
    }
    
    @objc public func refreshDevices() {
        NSLog("UVCDeviceMonitor: Explicitly refreshing devices after permission change")
        
        // Re-create the discovery session to ensure we get fresh results
        setupDiscoverySession()
        
        // Force an update of devices
        updateDevices()
        
        // Log the current state
        NSLog("UVCDeviceMonitor: After refresh - device count: \(devices.count)")
        if devices.count > 0 {
            devices.forEach { device in
                NSLog("UVCDeviceMonitor: - \(device.localizedName) (ID: \(device.uniqueID))")
            }
        } else {
            NSLog("UVCDeviceMonitor: No devices found after refresh")
        }
    }
    
    private func startMonitoring() {
        NSLog("UVCDeviceMonitor: Starting monitoring timer")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateDevices()
        }
    }
    
    @objc public func getDeviceCount() -> Int {
        NSLog("UVCDeviceMonitor: getDeviceCount called, returning \(devices.count)")
        return devices.count
    }
    
    @objc public func getDeviceName(at index: Int) -> String {
        guard index >= 0 && index < devices.count else {
            NSLog("UVCDeviceMonitor: getDeviceName called with invalid index \(index)")
            return "Invalid device index"
        }
        let name = devices[index].localizedName
        NSLog("UVCDeviceMonitor: getDeviceName at \(index) returning \(name)")
        return name
    }
    
    @objc public func getDeviceUniqueID(at index: Int) -> String {
        guard index >= 0 && index < devices.count else {
            NSLog("UVCDeviceMonitor: getDeviceUniqueID called with invalid index \(index)")
            return "Invalid device index"
        }
        let id = devices[index].uniqueID
        NSLog("UVCDeviceMonitor: getDeviceUniqueID at \(index) returning \(id)")
        return id
    }
    
    deinit {
        NSLog("UVCDeviceMonitor: Deinitializing")
        timer?.invalidate()
    }
}
