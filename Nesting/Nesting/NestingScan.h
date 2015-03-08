//
//  ViewController.h
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScanedData.h"

@interface NestingScan : NSObject
+ (ScanedData *)scanFolder:(NSString *)path;
@end
