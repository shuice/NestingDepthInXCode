//
//  FileItem.h
//  Nesting
//
//  Created by liuyan on 15/3/22.
//  Copyright (c) 2015年 liuyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileItem : NSObject
@property NSString *filePath;
@property int32_t lineCount;
- (instancetype)initWithFilePath:(NSString *)filePath lineCount:(int32_t)lineCount;
- (NSComparisonResult)compareByLineCount:(FileItem *)fileItem;
@end
