#import <Foundation/Foundation.h>
#include "UnityFramework/UnityFramework-Swift.h"

extern "C" {
    
#pragma mark - Functions
    
    int _addTwoNumberInVisionOS(int a , int b) {
        int result = [[UnityPlugin shared] AddTwoNumberWithA:(a) b:(b)];
        return result;
    }
    
    int _getConnectedDeviceCount() {
        int count = [[UnityPlugin shared] GetConnectedDeviceCount];
        return count;
    }
    
    const char* _getDeviceName(int index) {
        NSString *deviceName = [[UnityPlugin shared] GetDeviceNameAt:index];
        // Create a C string that Unity can use
        const char* cString = [deviceName UTF8String];
        return cString;
    }
    
    const char* _getDeviceUniqueID(int index) {
        NSString *deviceID = [[UnityPlugin shared] GetDeviceUniqueIDAt:index];
        // Create a C string that Unity can use
        const char* cString = [deviceID UTF8String];
        return cString;
    }
}
