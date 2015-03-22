//
//  LinesViewController.m
//  Nesting
//
//  Created by liuyan on 15/3/21.
//  Copyright (c) 2015年 liuyan. All rights reserved.
//

#import "FilesViewController.h"
#import "ScanedData.h"
#import "FileItem.h"

@implementation FilesViewController

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
    return scanedData.lineCountDescOrderedFileItems.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    ScanedData *scanedData = [ScanedData getScanedData];
    FileItem *fileItem = scanedData.lineCountDescOrderedFileItems[row];
    NSString *cellId = [tableColumn identifier];
    NSString *str = @"Unknown";
    if ([cellId isEqualToString:@"lines"])
    {
        str = [NSString stringWithFormat:@"%d", fileItem.lineCount];
    }
    else if ([cellId isEqualToString:@"path"])
    {
        str = [fileItem.filePath lastPathComponent];
    }
    return str;
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return NO;
}
@end
