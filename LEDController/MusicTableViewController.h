//
//  MusicTableViewController.h
//  LEDController
//
//  Created by 이승희 on 2016. 2. 1..
//  Copyright © 2016년 이승희. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface MusicTableViewController : UITableViewController

@property (retain, nonatomic) ViewController *view;
@property (weak, nonatomic) id<ViewControllerDelegate> delegate;

@end
