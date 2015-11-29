//
//  ViewController.h
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//
#import "NestingScan.h"
#import "CharPos.h"
#import "FunctionItem.h"
#import "FileItem.h"
#import <stack>
#import "ScropeManager.h"

using namespace std;

@implementation NestingScan


+ (NSArray *)MemoryContentFromFile:(NSString *) filePath
{
    NSError *error = nil;
    NSStringEncoding encoding = NSUTF8StringEncoding;
    NSString *string = [[NSString alloc] initWithContentsOfFile:filePath
                                                   usedEncoding:&encoding
                                                          error:&error];
    return [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

typedef void(^OnScropeFindedAtPos)(const CharPos& startPos, const CharPos& endPos);
+ (BOOL)        ParseChar:(const unichar&)c
                  charPos:(const CharPos&)charPos
                 curDepth:(int&)curDepth
                 maxDepth:(int&)maxDepth
             functionItem:(FunctionItem *)functionItem
           scropePosStack:(stack<CharPos>&)scropePosStack
      onScropeFindedBlock:(OnScropeFindedAtPos)onScropeFindedBlock
{
    if (NULL == onScropeFindedBlock)
    {
        onScropeFindedBlock = ^(const CharPos& startPos, const CharPos& endPos){};
    }
    
	const char leftFlag = '{';
	const char rightFlag = '}';
	const char funNamePos1 = '-';
	const char funNamePos2 = '+';
	if (c == leftFlag)
	{
		curDepth ++;
        if (curDepth > maxDepth)
        {
            maxDepth = curDepth;
        }
        scropePosStack.push(charPos);
		if (1 == curDepth)
		{
			// find a new function name
			functionItem.startPos = charPos;
		}
	}
	else if (c == rightFlag)
	{
		curDepth --;
//        NSAssert(scropePosStack.size() > 0, @"size empty");
        if (scropePosStack.size() > 0)
        {
            const CharPos startPos = scropePosStack.top();
            scropePosStack.pop();
            onScropeFindedBlock(startPos, charPos);
        }
		if (0 == curDepth)
		{
			// end of function
			functionItem.maxDepth = maxDepth;
			functionItem.endPos = charPos;
			maxDepth = 0;
			return true;
		}
	}
	else if ((c == funNamePos1) || (c == funNamePos2))
	{
		if (0 == curDepth)
		{
			functionItem.funNamePos = charPos;
		}
	}
	return false;
}

+ (NSArray *) ParseFunctionContentRange:(NSString *)fileName
                                  lines:(NSArray *)lines
                    onScropeFindedBlock:(OnScropeFindedAtPos)onScropeFindedBlock
{
    NSMutableArray *functionItems = [NSMutableArray array];
    stack<CharPos> scropePosStack;
    
	int depth = 0;
    FunctionItem *functionItem = [[FunctionItem alloc] init];
	functionItem.filename = fileName;
    NSUInteger lineCount = [lines count];
	int maxDepth = depth;
	for (NSUInteger lineIndex = 0; lineIndex < lineCount; lineIndex ++)
	{
        NSString *line = lines[lineIndex];
        NSUInteger colCount = [line length];
		for (NSUInteger colIndex = 0; colIndex < colCount; colIndex ++)
		{
            unichar c = [line characterAtIndex:colIndex];
            CharPos charPos = {(int32_t)lineIndex, (int32_t)colIndex};
            if ([self ParseChar:c
                        charPos:charPos
                       curDepth:depth
                       maxDepth:maxDepth
                   functionItem:functionItem
                 scropePosStack:scropePosStack
            onScropeFindedBlock:onScropeFindedBlock])
			{
                [functionItems addObject:[functionItem clone]];
			}
		}
	}
	
	return functionItems;
}

+ (NSString *)ContentByRange:(NSArray *)lines
                 charPosFrom:(CharPos)charPosFrom
                   charPosTo:(CharPos)charPosTo
{
	NSMutableString *content = [NSMutableString string];
	if (charPosFrom.lineIndex > charPosTo.lineIndex)
	{
		return content;
	}
	if ((charPosFrom.lineIndex == charPosTo.lineIndex)
        && (charPosFrom.colIndex >= charPosTo.colIndex))
	{
		return content;
	}
	
    NSString * line = lines[charPosFrom.lineIndex];
	if (charPosFrom.lineIndex == charPosTo.lineIndex)
	{
        NSRange range = NSMakeRange(charPosFrom.colIndex, charPosTo.colIndex - charPosFrom.colIndex);
        return [line substringWithRange:range];
	}
	
	[content appendString:[line substringFromIndex:charPosFrom.colIndex]];
	for (int32_t lineIndex = charPosFrom.lineIndex + 1; lineIndex < charPosTo.lineIndex; lineIndex ++)
	{
		[content appendString:@"\n"];
		NSString *curLine = lines[lineIndex];
		if (lineIndex != charPosTo.lineIndex)
		{
			[content appendString:curLine];
		}
		else 
		{	
			[content appendString:[curLine substringToIndex:charPosTo.colIndex]];
		}
	}
	
	return content;
}

+ (void)ParseRangeToString:(NSArray *)lines
             functionItems:(NSArray *)functionItems
{
    for (FunctionItem *functionItem in functionItems)
    {
        functionItem.funName = [self ContentByRange:lines
                                        charPosFrom:functionItem.funNamePos
                                          charPosTo:functionItem.startPos];
        
        functionItem.funContent = [self ContentByRange:lines
                                           charPosFrom:functionItem.startPos
                                             charPosTo:functionItem.endPos];
        
        functionItem.funContentLineCount = functionItem.endPos.lineIndex - functionItem.startPos.lineIndex + 1;
	}
}

typedef void(^OnFindedItem)(NSString *fullPath, BOOL isDirectory,  BOOL *skipThis, BOOL *stopAll);
+ (void)scanFolder:(NSString*)folder findedItemBlock:(OnFindedItem)findedItemBlock
{
    BOOL stopAll = NO;
    
    NSFileManager* localFileManager = [[NSFileManager alloc] init];
    NSDirectoryEnumerationOptions option = NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsPackageDescendants;
    NSDirectoryEnumerator* directoryEnumerator = [localFileManager enumeratorAtURL:[NSURL fileURLWithPath:folder]
                                                        includingPropertiesForKeys:nil
                                                                           options:option
                                                                      errorHandler:nil];
    for (NSURL* theURL in directoryEnumerator)
    {
        if (stopAll)
        {
            break;
        }
        
        NSString *fileName = nil;
        [theURL getResourceValue:&fileName forKey:NSURLNameKey error:NULL];
        
        NSNumber *isDirectory = nil;
        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
        BOOL skinThis = NO;
        
        BOOL directory = [isDirectory boolValue];
        
        findedItemBlock([theURL path], directory, &skinThis, &stopAll);
        
        if (skinThis)
        {
            [directoryEnumerator skipDescendents];
        }
    }
}




+ (NSMutableArray *)removeErrorFunctions:(NSArray *)functionItems
{
    NSMutableArray *functions = [NSMutableArray array];
    [functionItems enumerateObjectsUsingBlock:^(FunctionItem *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isValidByFunctionName])
        {
            [functions addObject:obj];
        }
    }];
    return functions;
}

+ (ScanedData *)scanFolder:(NSString *)path block:(ScanProgressBlock)block
{
#define CHECK_STOPED if (stop) {scanedData.eScanResult = eScanResultCancel; return scanedData;}
    if (NULL == block)
    {
        block = ^void(CGFloat progress, BOOL *stop){
            
        };
    }
    
    __block BOOL stop = NO;
    
    ScanedData *scanedData = [[ScanedData alloc] init];
    scanedData.scanPath = path;
    scanedData.eScanResult = eScanResultSuccess;
    
    ScropeManager *scropeManager = [ScropeManager new];
    
    BOOL isDirectory = NO;
    if ((NO == [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory])
        || (NO == isDirectory))
    {
        scanedData.eScanResult = eScanResultErrorPath;
        return scanedData;
    }
    
    NSMutableArray *filePaths = [NSMutableArray array];
    [self scanFolder:path findedItemBlock:^(NSString *fullPath, BOOL isDirectory, BOOL *skipThis, BOOL *stopAll) {
        block(0, &stop);
        if (stop)
        {
            *stopAll = YES;
            return;
        }
        
        if ([fullPath hasSuffix:@".m"] || [fullPath hasSuffix:@".mm"])
        {
            [filePaths addObject:fullPath];
        }
    }];
    
    CHECK_STOPED
    
    NSUInteger count = [filePaths count];
    
    for (NSUInteger index = 0; index < count; index ++)
    {
        block(index * 100.0 / count, &stop);
        if (stop)
        {
            break;
        }
        
        NSString *filePath = filePaths[index];
        
        NSArray *lines = [self MemoryContentFromFile:filePath];
        
        [scanedData.fileItems addObject:[[FileItem alloc] initWithFilePath:filePath lineCount:(int32_t)[lines count]]];
        
        NSArray *functionItems = [self ParseFunctionContentRange:filePath
                                                           lines:lines
                                             onScropeFindedBlock:^(const CharPos &startPos, const CharPos &endPos) {
                                                 CharRange *charRange = [CharRange new];
                                                 charRange.filePath = filePath;
                                                 charRange.startPos = startPos;
                                                 charRange.endPos = endPos;
                                                 NSString *innerText = [self ContentByRange:lines
                                                                                charPosFrom:startPos
                                                                                  charPosTo:endPos];
                                                 [scropeManager addScrope:innerText charRange:charRange];
                                             }];
        [self ParseRangeToString:lines functionItems:functionItems];
        [scanedData.functionItems addObjectsFromArray:functionItems];
	}
    
    CHECK_STOPED
    
    scanedData.functionItems = [self removeErrorFunctions:scanedData.functionItems];
    
    scanedData.lineCountDescOrderedFunctionItems = [scanedData.functionItems sortedArrayUsingComparator:^NSComparisonResult(FunctionItem *obj1, FunctionItem *obj2) {
        return [obj1 compareRangeByLineCount:obj2];
    }];
    
    scanedData.depthDescOrderedFunctionItems = [scanedData.functionItems sortedArrayUsingComparator:^NSComparisonResult(FunctionItem *obj1, FunctionItem *obj2) {
        return [obj1 compareRangeByDepth:obj2];
    }];
    
    scanedData.lineCountDescOrderedFileItems = [scanedData.fileItems sortedArrayUsingComparator:^NSComparisonResult(FileItem *obj1, FileItem *obj2) {
        return [obj1 compareByLineCount:obj2];
    }];
    
    scanedData.scropeItems = [scropeManager removeUnDuplicatedAndSort];
    block(100, &stop);
	return scanedData;
}

@end