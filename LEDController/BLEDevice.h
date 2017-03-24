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

@property (strong,nonatomic) CBPeripheral* peripheral;
@property (strong,nonatomic) CBCentralManager* centralManager;
@property (strong,nonatomic) NSMutableDictionary* dicSetupData;
@property (strong,nonatomic) NSMutableArray* aryResources;

@end
