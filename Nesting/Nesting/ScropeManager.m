//
//  FunctionItem.m
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import "ScropeManager.h"
#include <CommonCrypto/CommonDigest.h>

@interface ScropeManager()
@end

@implementation ScropeManager
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _md5_2_ScroptItem = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)addScrope:(NSString *)innerText charRange:(CharRange *)charRange
{
    if ([innerText length] == 0)
    {
        return;
    }
    
    if (charRange == nil)
    {
        return;
    }
    
    NSArray<NSString *> *components = [innerText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSUInteger wordCount = components.count;
    NSString *compactText = [components componentsJoinedByString:@""];
    NSString *checksum = [self calcCheckSum:compactText];
    ScropeItem *scropeItem = [self.md5_2_ScroptItem objectForKey:checksum];
    if (scropeItem == NULL)
    {
        scropeItem = [ScropeItem new];
        scropeItem.innerText = innerText;
        scropeItem.compactText = compactText;
        scropeItem.checksum = checksum;
        scropeItem.wordCount = wordCount;
        self.md5_2_ScroptItem[checksum] = scropeItem;
    }
    [scropeItem.charRanges addObject:charRange];
}

- (NSString *)toCompactText:(NSString *)innerText
{
    
    return innerText;
}

- (NSString *)calcCheckSum:(NSString *)compactText
{
        const char *cStr = [compactText UTF8String];
        unsigned char result[16];
        CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
        return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
}

- (NSArray<ScropeItem *> *)removeUnDuplicatedAndSort
{
    NSArray<ScropeItem *> *allValues = self.md5_2_ScroptItem.allValues;
    NSMutableArray *unDuplicated = [NSMutableArray new];
    for (ScropeItem * valueItem in allValues)
    {
        if ((valueItem.charRanges.count > 1) && (valueItem.innerText.length > 300))
        {
            [valueItem calcScore];
            [unDuplicated addObject:valueItem];
        }
    }
    return [unDuplicated sortedArrayUsingComparator:^NSComparisonResult(ScropeItem *  _Nonnull obj1, ScropeItem *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
}
@end
