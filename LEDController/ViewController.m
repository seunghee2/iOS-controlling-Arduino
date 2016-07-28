//
//  ViewController.m
//  LEDController
//
//  Created by 이승희 on 2016. 2. 1..
//  Copyright © 2016년 이승희. All rights reserved.
//

#import "ViewController.h"
#import "MusicTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSMutableArray *valueArray;
    MusicTableViewController *music;
}

@synthesize OffButton, OnButton;
@synthesize scrollView =_scrollView;
@synthesize pageControl =_pageControl;


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark- LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    music = [[MusicTableViewController alloc]init];
    music.delegate = self;
    self.blunoManager = [mBlunoManager sharedInstance];
    self.blunoManager.delegate = self;
    self.aryDevices = [[NSMutableArray alloc] init];
    
    self.scrollView.contentSize = CGSizeMake(750,390);
    self.pageControl.currentPage=0;
    self.pageControl.numberOfPages=2;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    valueArray = [[NSMutableArray alloc]init];
    for(int i = 0; i < 30; i++){
        NSString *value = [[NSString alloc]initWithFormat:@"%c", (char)(i + 97)];
        [valueArray addObject:value];
    }
    
    [self.blunoManager scan];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:22/255.0 green:151/255.0 blue:236/255.0 alpha:1.0]];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"LED Controller";
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    [OnButton setSelected:YES];
}

-(IBAction)WhatColorIsIt:(UIButton*)sender{
    const CGFloat *components = CGColorGetComponents(sender.backgroundColor.CGColor);
    CGFloat redValue = components[0] * 255.0;
    CGFloat greenValue = components[1] * 255.0;
    CGFloat blueValue = components[2] * 255.0;
    
    NSLog(@"%f %f %f", redValue, greenValue, blueValue);
    
    NSString* strTemp = [valueArray objectAtIndex:(int)(sender.tag-1)];
    NSData* data = [strTemp dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@ at %@", strTemp, data);
    [self.blunoManager writeDataToDevice:data Device:self.blunoDev];
}

-(IBAction)sendBrightness:(UIButton*)sender{
    char c = (char)((int)sender.tag + 65);
    NSString *strTemp = [NSString stringWithFormat:@"%c", c];
    NSData *data = [strTemp dataUsingEncoding:NSUTF8StringEncoding];
    [self.blunoManager writeDataToDevice:data Device:self.blunoDev];
}


- (void)receiveData:(int)index{
    NSLog(@"%d", index);
    self.indexTest = index;
    NSString *musicIndex = [[NSString alloc]initWithFormat:@"%d", index];
    NSData *data = [musicIndex dataUsingEncoding:NSUTF8StringEncoding];
    [self.blunoManager writeDataToDevice:data Device:self.blunoDev];
}

#pragma mark- DFBlunoDelegate

-(void)bleDidUpdateState:(BOOL)bleSupported{
    if(bleSupported)
        [self.blunoManager scan];
}

-(void)didDiscoverDevice:(BlunoDevice*)dev{
    BOOL bRepeat = NO;
    
    for (BlunoDevice* bleDevice in self.aryDevices){
        if ([bleDevice isEqual:dev]) {
            bRepeat = YES;
            break;
        }
    }
    
    if (!bRepeat){
        [self.aryDevices addObject:dev];
    }
}

-(void)readyToCommunicate:(BlunoDevice*)dev{
    self.blunoDev = dev;
}

-(void)didDisconnectDevice:(BlunoDevice*)dev{
}

-(void)didWriteData:(BlunoDevice*)dev{
    
}

-(void)didReceiveData:(NSData*)data Device:(BlunoDevice*)dev{
    
}



- (IBAction)OnAction:(id)sender {
    if([OnButton isSelected]==YES){
        if([OffButton isSelected]==NO){
            [OnButton setSelected:YES];
            [OnButton setTitleColor:[UIColor colorWithRed:47/255.0 green:232/255.0 blue:158/255.0 alpha:1 ]forState: UIControlStateNormal];
        }
    }else{
        [OnButton setSelected:YES];
        [OffButton setSelected:NO];
        [OnButton setTitleColor:[UIColor colorWithRed:47/255.0 green:232/255.0 blue:158/255.0 alpha:1 ]forState: UIControlStateNormal];
        [OffButton setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1 ]forState: UIControlStateNormal];
    }
}

- (IBAction)OffAction:(id)sender {
    if([OffButton isSelected]==YES){
        if([OnButton isSelected]==NO){
            [OffButton setSelected:YES];
            [OnButton setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1 ]forState: UIControlStateNormal];
            
        }
    }else{
        [OffButton setSelected:YES];
        [OnButton setSelected:NO];
        [OffButton setTitleColor:[UIColor colorWithRed:47/255.0 green:232/255.0 blue:158/255.0 alpha:1 ]forState: UIControlStateNormal];
        [OnButton setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1 ]forState: UIControlStateNormal];
        
    }
    
    NSData *data = [[NSString stringWithFormat:@"E"] dataUsingEncoding:NSUTF8StringEncoding];
    [self.blunoManager writeDataToDevice:data Device:self.blunoDev];
}
-(IBAction)showMusic:(id)sender{
    [self.navigationController pushViewController:music animated:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)sender{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth ) + 1;
    self.pageControl.currentPage = page;
    
}
@end