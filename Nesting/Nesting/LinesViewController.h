//
//  LinesViewController.h
//  Nesting
//
//  Created by liuyan on 15/3/21.
//  Copyright (c) 2015年 liuyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface LinesViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *tableView;
- (void)refresh;
@end
