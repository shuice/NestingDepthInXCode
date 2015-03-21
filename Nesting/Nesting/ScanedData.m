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
    }
    return self;
}

+ (void)setScanedData:(ScanedData *)scanedData
{
    g_scanedData = scanedData;
}

+ (ScanedData *)getScanedData
{
    return g_scanedData;
}

@end
