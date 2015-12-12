//
//  FilesViewController.h
//  Nesting
//
//  Created by liuyan on 15/3/22.
//  Copyright (c) 2015年 liuyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface DuplicatedCodeViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (unsafe_unretained) IBOutlet NSTextView *code;

- (void)refresh;
@end
