//
//  ScanedData.m
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import "ScanedData.h"

static ScanedData *g_scanedData;

@implementation ScanedData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _functionItems = [NSMutableArray array];
        _fileItems = [NSMutableArray array];
        _scropeItems = [NSMutableArray array];
    }
    return self;
}

+ (void)setScanedData:(ScanedData *)scanedData
{
    g_scanedData = scanedData;
}

+ (ScanedData *)getScanedData
{
    if (nil == g_scanedData)
    {
        g_scanedData = [ScanedData getEmptyData];
    }
    return g_scanedData;
}

+ (ScanedData *)getEmptyData
{
    static ScanedData *scanData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scanData = [[ScanedData alloc] init];
        
        FunctionItem *functionItem = [[FunctionItem alloc] init];
        functionItem.funName = @"no function founded.";
        functionItem.funContentLineCount = 0;
        functionItem.maxDepth = 0;
        
        scanData.scanPath = @"";
        scanData.functionItems                      = [@[functionItem] mutableCopy];
        scanData.depthDescOrderedFunctionItems      = [@[functionItem] mutableCopy];
        scanData.lineCountDescOrderedFunctionItems  = [@[functionItem] mutableCopy];
    });
    return scanData;
}

@end
