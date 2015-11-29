//
//  FunctionItem.h
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CharPos.h"

@interface FunctionItem : NSObject
@property (assign) struct CharPos funNamePos;
@property (assign) struct CharPos startPos;
@property (assign) struct CharPos endPos;

@property (strong) NSString *funName;
@property (strong) NSString *funContent;
@property (assign) int32_t funContentLineCount;
@property (assign) int32_t maxDepth;

@property (strong) NSString *filename;

- (FunctionItem *)clone;
- (NSComparisonResult)compareRangeByLineCount:(FunctionItem *)other;
- (NSComparisonResult)compareRangeByDepth:(FunctionItem *)other;
- (BOOL)isValidByFunctionName;
@end
