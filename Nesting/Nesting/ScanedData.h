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
    eScanResultCancel,
    eScanResultErrorPath,
};

@interface ScanedData : NSObject
@property (assign) EnumScanResult eScanResult;
@property (strong) NSString *scanPath;
@property (strong) NSMutableArray *functionItems;
@property (strong) NSMutableArray *fileItems;
@property (strong) NSArray *depthDescOrderedFunctionItems;
@property (strong) NSArray *lineCountDescOrderedFunctionItems;
@property (strong) NSArray *lineCountDescOrderedFileItems;


+ (void)setScanedData:(ScanedData *)scanedData;
+ (ScanedData *)getScanedData;
+ (ScanedData *)getEmptyData;
@end
