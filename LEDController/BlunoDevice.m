//
//  BlunoDevice.m
//  LEDController
//
//  Created by 이승희 on 2016. 2. 1..
//  Copyright © 2016년 이승희. All rights reserved.
//

#import "BlunoDevice.h"

@implementation BlunoDevice

@synthesize bReadyToWrite = _bReadyToWrite;

-(id)init
{
    self = [super init];
    _bReadyToWrite = NO;
    return self;
}

@end