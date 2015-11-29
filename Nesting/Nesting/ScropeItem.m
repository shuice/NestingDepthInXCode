//
//  FunctionItem.m
//  Nesting
//
//  Created by liuyan on 15/11/28.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import "ScropeItem.h"

@interface ScropeItem()
@end

@implementation ScropeItem
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _charRanges = [NSMutableArray array];
    }
    return self;
}

- (void)calcScore
{
    self.score = self.charRanges.count * self.wordCount;
}

- (NSComparisonResult)compare:(ScropeItem *)scoreItem
{
    if (self.score < scoreItem.score)
    {
        return NSOrderedDescending;
    }
    else if (self.score == scoreItem.score)
    {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

-(NSString *)description
{
    NSMutableString *fileName = [NSMutableString new];
    for (CharRange *charRange in self.charRanges)
    {
        [fileName appendString:charRange.filePath];
        [fileName appendString:@"\n"];
    }
    return [NSString stringWithFormat:@"\nscore:(%tu)\n出现次数::(%tu)\nfiles:\n%@片段内容:(%@)", self.score, self.charRanges.count, fileName, self.innerText];
}
@end
