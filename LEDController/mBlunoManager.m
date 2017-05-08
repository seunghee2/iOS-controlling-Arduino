//
//  mBlunoManager.m
//  LEDController
//
//  Created by 이승희 on 2016. 2. 1..
//  Copyright © 2016년 이승희. All rights reserved.
//

#import "mBlunoManager.h"

#define kBlunoService @"dfb0"
#define kBlunoDataCharacteristic @"dfb1"

@interface mBlunoManager () {
    BOOL _bSupported;
}

@property (strong,nonatomic) CBCentralManager *centralManager;
@property (strong,nonatomic) NSMutableDictionary *dicBleDevices;
@property (strong,nonatomic) NSMutableDictionary *dicBlunoDevices;

@end

@implementation mBlunoManager

# pragma mark- Functions

+(id) sharedInstance {
    static mBlunoManager* this	 = nil;
    
    if (!this) {
        this = [[mBlunoManager alloc] init];
        this.dicBleDevices = [[NSMutableDictionary alloc] init];
        this.dicBlunoDevices = [[NSMutableDictionary alloc] init];
        this->_bSupported = NO;
        this.centralManager = [[CBCentralManager alloc]initWithDelegate:this queue:nil];
    }
    
    return this;
}

-(void) configureSensorTag:(CBPeripheral*)peripheral {
    CBUUID *sUUID = [CBUUID UUIDWithString:kBlunoService];
    CBUUID *cUUID = [CBUUID UUIDWithString:kBlunoDataCharacteristic];
    
    [BLEUtility setNotificationForCharacteristic: peripheral sCBUUID:sUUID cCBUUID:cUUID enable:YES];
    NSString* key = [peripheral.identifier UUIDString];
    BlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
    blunoDev->_bReadyToWrite = YES;
    
    if ([((NSObject*)_delegate) respondsToSelector: @selector(readyToCommunicate:)]) {
        [_delegate readyToCommunicate:blunoDev];
    }
}

-(void) deConfigureSensorTag:(CBPeripheral*)peripheral {
    CBUUID *sUUID = [CBUUID UUIDWithString:kBlunoService];
    CBUUID *cUUID = [CBUUID UUIDWithString:kBlunoDataCharacteristic];
    
    [BLEUtility setNotificationForCharacteristic:peripheral sCBUUID:sUUID cCBUUID:cUUID enable:NO];
}

-(void) scan {
    [self.centralManager stopScan];
    //[self.dicBleDevices removeAllObjects];
    //[self.dicBlunoDevices removeAllObjects];
    if (_bSupported) {
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kBlunoService]] options:nil];
    }
}

- (void) stop {
    [self.centralManager stopScan];
}

- (void) clear {
    [self.dicBleDevices removeAllObjects];
    [self.dicBlunoDevices removeAllObjects];
}

- (void) connectToDevice:(BlunoDevice*)dev {
    BLEDevice* bleDev = [self.dicBleDevices objectForKey:dev.identifier];
    [bleDev.centralManager connectPeripheral:bleDev.peripheral options:nil];
    NSLog(@"connected");
}

- (void) disconnectToDevice:(BlunoDevice*)dev {
    BLEDevice* bleDev = [self.dicBleDevices objectForKey:dev.identifier];
    [self deConfigureSensorTag: bleDev.peripheral];
    [bleDev.centralManager cancelPeripheralConnection:bleDev.peripheral];
}

- (void) writeDataToDevice:(NSData*)data Device:(BlunoDevice*)dev {
    if (!_bSupported || data == nil) {
        return;
    } else if (!dev.bReadyToWrite) {
        return;
    }
    
    BLEDevice* bleDev = [self.dicBleDevices objectForKey:dev.identifier];
    [BLEUtility writeCharacteristic:bleDev.peripheral sUUID:kBlunoService cUUID:kBlunoDataCharacteristic data:data];
}

#pragma mark - CBCentralManager delegate
-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        _bSupported = NO;
        NSArray* aryDeviceKeys = [self.dicBlunoDevices allKeys];
        for (NSString* strKey in aryDeviceKeys) {
            BlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:strKey];
            blunoDev->_bReadyToWrite = NO;
        }
    } else {
        _bSupported = YES;
    }
    
    if ([((NSObject*)_delegate) respondsToSelector:@selector(bleDidUpdateState:)]) {
        [_delegate bleDidUpdateState:_bSupported];
    }
}

-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    //if([peripheral.identifier.UUIDString isEqualToString:@"8989C8C9-5F77-FF41-8D07-D95E7FEDB663"]){
        NSString *key = [peripheral.identifier UUIDString];
        BLEDevice* bleDev = [[BLEDevice alloc] init];
        bleDev.peripheral = peripheral;
        bleDev.centralManager = self.centralManager;
        [self.dicBleDevices setObject:bleDev forKey:key];
        BlunoDevice* blunoDev = [[BlunoDevice alloc] init];
        blunoDev.identifier = key;
        blunoDev.name = peripheral.name;
        [self.dicBlunoDevices setObject:blunoDev forKey:key];
        
        if ([((NSObject*)_delegate) respondsToSelector: @selector(didDiscoverDevice:)]) {
            [_delegate didDiscoverDevice:blunoDev];
            [self connectToDevice:blunoDev];
        }
    //}
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSString* key = [peripheral.identifier UUIDString];
    BlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
    blunoDev->_bReadyToWrite = NO;
    if ([((NSObject*)_delegate) respondsToSelector: @selector(didDisconnectDevice:)]) {
        [_delegate didDisconnectDevice:blunoDev];
    }
}

#pragma  mark - CBPeripheral delegate
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services)
        [peripheral discoverCharacteristics:nil forService:service];
}

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if ([service.UUID isEqual:[CBUUID UUIDWithString:kBlunoService]]) {
        [self configureSensorTag:peripheral];
    }
}


-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if ([((NSObject*)_delegate) respondsToSelector:@selector(didReceiveData:Device:)]) {
        NSString* key = [peripheral.identifier UUIDString];
        BlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
        [_delegate didReceiveData:characteristic.value Device:blunoDev];
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ([((NSObject*)_delegate) respondsToSelector:@selector(didWriteData:)]) {
        NSString* key = [peripheral.identifier UUIDString];
        BlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
        [_delegate didWriteData:blunoDev];
    }
}

@end
