import Foundation
import AVFoundation

@objc public class UVCDeviceMonitor: NSObject {
    private var devices: [AVCaptureDevice] = []
    private var discoverySession: AVCaptureDevice.DiscoverySession?
    private var timer: Timer?
    
    @objc public override init() {
        super.init()
        setupDiscoverySession()
        startMonitoring()
    }
    
    private func setupDiscoverySession() {
        // Try all possible video device types to see what's available
        discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [
                .external
            ],
            mediaType: .video,
            position: .unspecified
        )
        
        updateDevices()
    }
    
    private func updateDevices() {
        // For now, get all video devices and filter for external ones
        let currentDevices = discoverySession?.devices.filter { device in
            (device.deviceType == .external || device.deviceType == .builtInWideAngleCamera)
        } ?? []
        
        // Only update if the device list has actually changed
        if Set(currentDevices.map { $0.uniqueID }) != Set(devices.map { $0.uniqueID }) {
            devices = currentDevices
        }
    }
    
    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateDevices()
        }
    }
    
    @objc public func getDeviceCount() -> Int {
        return devices.count
    }
    
    @objc public func getDeviceName(at index: Int) -> String {
        guard index >= 0 && index < devices.count else {
            return "Invalid device index"
        }
        return devices[index].localizedName
    }
    
    @objc public func getDeviceUniqueID(at index: Int) -> String {
        guard index >= 0 && index < devices.count else {
            return "Invalid device index"
        }
        return devices[index].uniqueID
    }
    
    deinit {
        timer?.invalidate()
    }
}