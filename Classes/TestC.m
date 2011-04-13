//
//  TestC.m
//  IMIKit
//
//  Created by Travis on 11-4-13.
//  Copyright 2011年 imi.im. All rights reserved.
//

#import "TestC.h"
#import "TestBase.h"

@implementation TestC

#pragma mark - Table view data source

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"Select Lib to Test:";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"Test IMIBase";
            break;
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[TestBase new] autorelease] animated:YES];
}

@end
