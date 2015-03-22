//
//  FilesViewController.h
//  Nesting
//
//  Created by liuyan on 15/3/22.
//  Copyright (c) 2015年 liuyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface FilesViewController : NSViewController<NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
- (void)refresh;
@end
