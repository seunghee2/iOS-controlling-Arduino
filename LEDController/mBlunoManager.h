//
//  mBlunoManager.h
//  LEDController
//
//  Created by 이승희 on 2016. 2. 1..
//  Copyright © 2016년 이승희. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEUtility.h"
#import "BLEDevice.h"
#import "BlunoDevice.h"

@protocol mBlunoDelegate <NSObject>
@required

-(void) bleDidUpdateState:(BOOL)bleSupported;
-(void) didDiscoverDevice:(BlunoDevice*)dev;
-(void) readyToCommunicate:(BlunoDevice*)dev;
//-(void) didDisconnectDevice:(BlunoDevice*)dev;
//-(void) didWriteData:(BlunoDevice*)dev;
//-(void) didReceiveData:(NSData*)data Device:(BlunoDevice*)dev;

@end

@interface mBlunoManager : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,weak) id<mBlunoDelegate> delegate;

+ (id)sharedInstance;
- (void)scan;
- (void)stop;
- (void)clear;
- (void)connectToDevice:(BlunoDevice*) dev;
- (void)disconnectToDevice:(BlunoDevice*) dev;
- (void)writeDataToDevice:(NSData*)data Device:(BlunoDevice*)dev;

@end
