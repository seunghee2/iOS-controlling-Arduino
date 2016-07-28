//
//  ViewController.h
//  LEDController
//
//  Created by 이승희 on 2016. 2. 1..
//  Copyright © 2016년 이승희. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mBlunoManager.h"

@protocol ViewControllerDelegate <NSObject>

- (void)receiveData:(int)index;

@end


@interface ViewController : UIViewController<mBlunoDelegate, UINavigationControllerDelegate, ViewControllerDelegate>

@property(strong, nonatomic) mBlunoManager* blunoManager;
@property(strong, nonatomic) BlunoDevice* blunoDev;
@property(strong, nonatomic) NSMutableArray* aryDevices;
@property int indexTest;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain,nonatomic) IBOutlet UIButton *OnButton;
@property (retain,nonatomic) IBOutlet UIButton *OffButton;

-(IBAction)OnAction:(id)sender;
-(IBAction)OffAction:(id)sender;
-(IBAction)WhatColorIsIt:(UIButton*)sender;
-(IBAction)showMusic:(id)sender;
-(void)receiveData:(int)index;
-(IBAction)sendBrightness:(UIButton*)sender;
@end
