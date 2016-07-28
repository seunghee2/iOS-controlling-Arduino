//
//  MusicTableViewController.m
//  LEDController
//
//  Created by 이승희 on 2016. 2. 1..
//  Copyright © 2016년 이승희. All rights reserved.
//

#import "MusicTableViewController.h"
#import "ViewController.h"
@interface MusicTableViewController ()

@end

@implementation MusicTableViewController{
    NSMutableArray *musicArray;
    int index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    musicArray = [[NSMutableArray alloc]init];
    [musicArray addObject:@"Music1"];
    [musicArray addObject:@"Music2"];
    [musicArray addObject:@"Music3"];
    [musicArray addObject:@"Music4"];
    [musicArray addObject:@"None"];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"음악";
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return musicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [musicArray objectAtIndex:indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    index = (int)indexPath.row;
    [self.delegate receiveData:index];
    [self.navigationController popViewControllerAnimated:YES];
}

@end