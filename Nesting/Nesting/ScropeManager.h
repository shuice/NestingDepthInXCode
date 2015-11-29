//
//  FunctionItem.h
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScropeItem.h"

@interface ScropeManager : NSObject
-(void)addScrope:(NSString *)innerText charRange:(CharRange *)charRange;
@property NSMutableDictionary<NSString *, ScropeItem *> *md5_2_ScroptItem;
- (NSArray<ScropeItem *> *)removeUnDuplicatedAndSort;
@end
