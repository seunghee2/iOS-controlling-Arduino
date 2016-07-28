//
//  BLEDevice.h
//  LEDController
//
//  Created by 이승희 on 2016. 2. 1..
//  Copyright © 2016년 이승희. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface BLEDevice : NSObject

/// Pointer to CoreBluetooth peripheral
@property (strong,nonatomic) CBPeripheral* peripheral;
/// Pointer to CoreBluetooth manager that found this peripheral
@property (strong,nonatomic) CBCentralManager* centralManager;
/// Pointer to dictionary with device setup data
@property (strong,nonatomic) NSMutableDictionary* dicSetupData;
/// Current Devic has some resources
@property (strong,nonatomic) NSMutableArray* aryResources;

@end
