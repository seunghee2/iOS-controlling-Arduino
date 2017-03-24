//
//  BlunoDevice.h
//  LEDController
//
//  Created by 이승희 on 2016. 2. 1..
//  Copyright © 2016년 이승희. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlunoDevice : NSObject {
    @public BOOL _bReadyToWrite;
}

@property(strong, nonatomic) NSString* identifier;
@property(strong, nonatomic) NSString* name;
@property(assign, nonatomic, readonly) BOOL bReadyToWrite;

@end

