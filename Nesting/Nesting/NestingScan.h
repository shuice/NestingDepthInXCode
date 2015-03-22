//
//  ViewController.h
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScanedData.h"

// progress [0-100]
// *stop :YES stop scan ,NO: continue scan
typedef void(^ScanProgressBlock)(CGFloat progress, BOOL *stop);

@interface NestingScan : NSObject
+ (ScanedData *)scanFolder:(NSString *)path block:(ScanProgressBlock)block;
@end
