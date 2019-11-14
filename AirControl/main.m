//
//  main.m
//  AirControl
//
//  Created by Vetle Økland on 14/11/2019.
//  Copyright © 2019 Vetle Økland. All rights reserved.
//

#define NSLog(FORMAT, ...) fprintf(stderr, "%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>

@interface AirPodsDevice : IOBluetoothDevice

- (bool)isANCSupported;
- (void)setListeningMode:(int)mode;

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray *pairedDevices = [IOBluetoothDevice pairedDevices];
        AirPodsDevice *airpods = nil;
        
        for (IOBluetoothDevice *device in pairedDevices) {
            if ([device respondsToSelector:@selector(isANCSupported)]) {
                if ([(AirPodsDevice*)device isANCSupported]) {
                    airpods = (AirPodsDevice*)device;
                }
            }
        }
        
        if (airpods == nil) {
            NSLog(@"Could not find any AirPods Pro");
            return 0;
        }
        
        if (argc < 2) {
            NSLog(@"Usage: %s <mode>", argv[0]);
            NSLog(@"\t1: Off");
            NSLog(@"\t2: Active Noise Cancellation (ANC)");
            NSLog(@"\t3: Transparency");
            return 0;
        }
        
        NSString *listeningModeName = nil;
        
        switch (atoi(argv[1])) {
            case 1: listeningModeName = @"Off"; break;
            case 2: listeningModeName = @"Active Noise Cancelling"; break;
            case 3: listeningModeName = @"Transparency"; break;
            default: NSLog(@"Listening mode must be a non-zero value"); return 0;
        }
        
        NSLog(@"Setting listening mode: %@", listeningModeName);
        [airpods setListeningMode:atoi(argv[1])];
    }
    
    return 0;
}
