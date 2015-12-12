//
//  FunctionItem.h
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CharPos.h"

@interface ScropeItem : NSObject
@property NSString *innerText;
@property NSString *compactText;
@property NSString *checksum;
@property NSUInteger score;
@property NSUInteger wordCount;
@property NSMutableArray<CharRange *> *charRanges;
@property NSMutableArray<NSString *> *fileNames;

- (void)calcScore;
- (NSComparisonResult)compare:(ScropeItem *)scoreItem;
@end
