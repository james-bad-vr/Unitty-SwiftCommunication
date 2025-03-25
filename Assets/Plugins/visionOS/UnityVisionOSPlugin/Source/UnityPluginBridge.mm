
#import <Foundation/Foundation.h>
#include "UnityFramework/UnityFramework-Swift.h"

extern "C" {
    
#pragma mark - Functions
    
    int _addTwoNumberInVisionOS(int a , int b) {
       
        int result = [[UnityPlugin shared] AddTwoNumber:(a) b:(b)];
        return result;
    }
}
