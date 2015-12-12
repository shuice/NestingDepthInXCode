//
//  LinesViewController.m
//  Nesting
//
//  Created by liuyan on 15/3/21.
//  Copyright (c) 2015年 liuyan. All rights reserved.
//

#import "DuplicatedCodeViewController.h"
#import "ScanedData.h"
#import "FileItem.h"

@implementation DuplicatedCodeViewController

- (void)viewDidLoad
{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [super viewDidLoad];
}

- (void)refresh
{
    [_tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    ScanedData *scanedData = [ScanedData getScanedData];
    return scanedData.scropeItems.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    ScanedData *scanedData = [ScanedData getScanedData];
    ScropeItem *scropeItem = scanedData.scropeItems[row];
    NSString *cellId = [tableColumn identifier];
    NSString *str = @"Unknown";
    if ([cellId isEqualToString:@"score"])
    {
        str = [NSString stringWithFormat:@"%tu", scropeItem.score];
    }
    else if ([cellId isEqualToString:@"count"])
    {
        str = [NSString stringWithFormat:@"%tu", scropeItem.charRanges.count];
    }
    else if ([cellId isEqualToString:@"text"])
    {
        str = scropeItem.compactText;
    }
    return str;
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return NO;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger row = _tableView.selectedRow;
    ScanedData *scanedData = [ScanedData getScanedData];
    if ((row < 0) || (row >= scanedData.scropeItems.count))
    {
        return;
    }
    ScropeItem *scropeItem = scanedData.scropeItems[row];
    NSString *fileNames = [scropeItem.fileNames componentsJoinedByString:@"\n"];
    _code.string = [NSString stringWithFormat:@"Files:\n%@\n\nCode:\n%@\n}", fileNames, scropeItem.innerText];
}

@end
