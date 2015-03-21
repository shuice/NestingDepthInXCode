//
//  ScanedData.h
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionItem.h"

typedef NS_ENUM(NSInteger, EnumScanResult)
{
    eScanResultSuccess = 0,
    eScanResultErrorPath,
};

@interface ScanedData : NSObject
@property (assign) EnumScanResult eScanResult;
@property (strong) NSString *scanPath;
@property (strong) NSMutableArray *functionItems;
@property (strong) NSArray *depthDescOrderedFunctionItems;
@property (strong) NSArray *lineCountDescOrderedFunctionItems;

+ (void)setScanedData:(ScanedData *)scanedData;
+ (ScanedData *)getScanedData;
@end
