//
//  ViewController.h
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak) IBOutlet NSTextField *tfPath;
- (IBAction)onTouchUpInsideScan:(id)sender;
@end

