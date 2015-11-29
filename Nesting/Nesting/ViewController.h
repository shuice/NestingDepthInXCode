//
//  ViewController.h
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak) IBOutlet NSButton *scanBtn;
@property (weak) IBOutlet NSTextField *tfPath;
@property (weak) IBOutlet NSButton *btnFiles;
@property (weak) IBOutlet NSView *placeholderView;
@property (weak) IBOutlet NSButton *btnLinesInFunction;
@property (weak) IBOutlet NSButton *btnDepth;
@property (weak) IBOutlet NSView *topBgView;
@property (weak) IBOutlet NSButton *btnCode;
- (IBAction)onTouchUpInsideCode:(id)sender;
@property (weak) IBOutlet NSProgressIndicator *process;
- (IBAction)onTouchUpInsideScan:(id)sender;
@end

