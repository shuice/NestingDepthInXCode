//
//  ViewController.m
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import "ViewController.h"
#import "NestingScan.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)onTouchUpInsideScan:(id)sender
{
    NSString *path = _tfPath.stringValue;
    path = @"/Code/Nesting/Nesting/Nesting/";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ScanedData *nestingScan = [NestingScan scanFolder:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateResult:nestingScan];
        });
    });
}


- (void) updateResult:(ScanedData *)nestingScan
{
    
}
@end
