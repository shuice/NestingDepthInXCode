//
//  FileItem.m
//  Nesting
//
//  Created by liuyan on 15/3/22.
//  Copyright (c) 2015年 liuyan. All rights reserved.
//

#import "FileItem.h"

@implementation FileItem

- (instancetype) initWithFilePath:(NSString *)filePath lineCount:(int32_t)lineCount
{
    self = [super init];
    if (self)
    {
        _filePath = filePath;
        _lineCount = lineCount;
    }
    return self;
}

- (NSComparisonResult)compareByLineCount:(FileItem *)fileItem
{
    if (self.lineCount < fileItem.lineCount)
    {
        return NSOrderedDescending;
    }
    else if (self.lineCount == fileItem.lineCount)
    {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

@end
