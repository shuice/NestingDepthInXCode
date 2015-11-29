//
//  CharPos.h
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import <Foundation/Foundation.h>

struct CharPos
{
    int32_t lineIndex;
    int32_t colIndex;
};


@interface CharRange : NSObject
@property NSString *filePath;
@property struct CharPos startPos;
@property struct CharPos endPos;
@end
