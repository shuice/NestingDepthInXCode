//
//  FunctionItem.m
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import "FunctionItem.h"

@implementation FunctionItem
- (FunctionItem *)clone
{
    FunctionItem *item = [[FunctionItem alloc] init];
    item.funNamePos     = self.funNamePos;
    item.startPos       = self.startPos;
    item.endPos         = self.endPos;
    item.funName        = self.funName;
    item.funContent     = self.funContent;
    item.funContentLineCount = self.funContentLineCount;
    item.maxDepth       = self.maxDepth;
    item.filename       = self.filename;
    return item;
}

- (NSComparisonResult)compareIntegerDesc:(int32_t)first second:(int32_t)second
{
    if (first < second)
    {
        return NSOrderedDescending;
    }
    else if (first == second)
    {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

- (NSComparisonResult)compareRangeByLineCount:(FunctionItem *)other
{
    return [self compareIntegerDesc:_funContentLineCount second:other.funContentLineCount];
}

- (NSComparisonResult)compareRangeByDepth:(FunctionItem *)other
{
    return [self compareIntegerDesc:_maxDepth second:other.maxDepth];
}

- (BOOL)isValidByFunctionName
{
    BOOL isValid = NO;
    NSUInteger nameLen = [_funName length];
    for (NSUInteger nameIndex = 1; nameIndex < nameLen; nameIndex ++)
    {
        unichar c = [_funName characterAtIndex:nameIndex];
        if ((' ' == c) || ('\t' == c))
        {
            continue;
        }
        isValid = ('(' == c);
        break;
    }
    return isValid;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"line count:%d, depth:%d name:%@",
            _funContentLineCount, _maxDepth, _funName];
}
@end
