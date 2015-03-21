//
//  DepthViewController.m
//  Nesting
//
//  Created by liuyan on 15/3/21.
//  Copyright (c) 2015年 liuyan. All rights reserved.
//

#import "DepthViewController.h"
#import "ScanedData.h"

@implementation DepthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.dataSource = self;
    [_tableView reloadData];
}

- (void)refresh
{
    [_tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    ScanedData *scanedData = [ScanedData getScanedData];
    return scanedData.depthDescOrderedFunctionItems.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    ScanedData *scanedData = [ScanedData getScanedData];
    FunctionItem *functionItem = scanedData.depthDescOrderedFunctionItems[row];
    NSString *cellId = [tableColumn identifier];
    NSString *str = @"Unknown";
    if ([cellId isEqualToString:@"depth"])
    {
        str = [NSString stringWithFormat:@"%d", functionItem.maxDepth];
    }
    else if ([cellId isEqualToString:@"name"])
    {
        str = functionItem.funName;
    }
    else if ([cellId isEqualToString:@"path"])
    {
        str = functionItem.filename;
    }
    
    return str;
}
@end
