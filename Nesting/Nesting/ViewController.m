//
//  ViewController.m
//  Nesting
//
//  Created by liuyan on 15/3/8.
//  Copyright (c) 2015 liuyan. All rights reserved.
//

#import "ViewController.h"
#import "NestingScan.h"
#import "DepthViewController.h"
#import "LinesViewController.h"
#import "FilesViewController.h"

#define USER_DEFAULT_PATH_KEY @"UserDefault_Path"

typedef NS_ENUM(NSInteger, EnumScanStatus)
{
    eScanStatusStandBy = 0,
    eScanStatusScaning,
    eScanStatusTryStop,
};

typedef NS_ENUM(NSInteger, EnumTabIndex)
{
    eTabIndexDepth = 0,
    eTabIndexLineOfFunction,
    eTabIndexLineOfFile,
};

@interface ViewController()
@property DepthViewController *depthVC;
@property LinesViewController *linesVC;
@property FilesViewController *filesVC;
@property (nonatomic) EnumScanStatus eScanStatus;
@property EnumTabIndex eTabIndex;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_topBgView setWantsLayer:YES];
    
    NSColor *cr = [NSColor colorWithRed:191/255.0 green:240/255.0 blue:213/255.0 alpha:1];
    _topBgView.layer.backgroundColor = [cr CGColor];
    _tfPath.editable = NO;
    _tfPath.selectable = NO;
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PATH_KEY];
    if ([path length])
    {
        _tfPath.stringValue = path;
    }

    
    _placeholderView.hidden = YES;
    // Do any additional setup after loading the view.
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.depthVC = [storyboard instantiateControllerWithIdentifier:@"Depth"];
    _depthVC.view.frame = _placeholderView.frame;
    [self.view addSubview:_depthVC.view];
    
    self.linesVC = [storyboard instantiateControllerWithIdentifier:@"Lines"];
    _linesVC.view.frame = _placeholderView.frame;
    [self.view addSubview:_linesVC.view];
    
    self.filesVC = [storyboard instantiateControllerWithIdentifier:@"Files"];
    _filesVC.view.frame = _placeholderView.frame;
    [self.view addSubview:_filesVC.view];
    
    [self updateResult];
    
    [self onTouchUpInsideDepth:nil];
}

- (IBAction)onTouchUpInsideDepth:(id)sender
{
    _eTabIndex = eTabIndexDepth;
    [self updateTab];
}

- (IBAction)onTouchUpInsideLines:(id)sender
{
    _eTabIndex = eTabIndexLineOfFunction;
    [self updateTab];
}


- (IBAction)onTouchUpInsideFiles:(id)sender {
    _eTabIndex = eTabIndexLineOfFile;
    [self updateTab];
}

- (void)updateTab
{
    [@[_btnDepth, _btnLinesInFunction, _btnFiles] enumerateObjectsUsingBlock:^(NSButton *obj, NSUInteger idx, BOOL *stop) {
        [obj setHighlighted:(idx == _eTabIndex)];
    }];
    
    [@[_depthVC.view, _linesVC.view, _filesVC.view] enumerateObjectsUsingBlock:^(NSView *obj, NSUInteger idx, BOOL *stop) {
        [obj setHidden:(idx != _eTabIndex)];
    }];
}

- (IBAction)onTouchUpInsideSelectDirectory:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseDirectories = YES;
    openPanel.canChooseFiles = NO;
    openPanel.allowsMultipleSelection = NO;
    if (NSFileHandlingPanelOKButton != [openPanel runModal])
    {
        return;
    }
    
    NSArray *urls = [openPanel URLs];
    if ([urls count] == 0)
    {
        [self showErrorMessage:@"Error"];
        return;
    }
    
    NSURL *url = urls[0];
    _tfPath.stringValue = [url relativePath];
}

- (IBAction)onTouchUpInsideScan:(id)sender
{
    if (eScanStatusScaning == _eScanStatus)
    {
        self.eScanStatus = eScanStatusTryStop;
        return;
    }
    else if (eScanStatusTryStop == _eScanStatus)
    {
        return;
    }
    NSString *path = _tfPath.stringValue;
    BOOL isDirectory = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (NO == isExist)
    {
        [self showErrorMessage:@"Path not exist on disk"];
        return;
    }
    
    if (NO == isDirectory)
    {
        [self showErrorMessage:@"The path you selected is not a directory."];
        return;
    }
    self.eScanStatus = eScanStatusScaning;
    
    typeof(self) __weak weakself = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ScanedData *nestingScan = [NestingScan scanFolder:path block:^(CGFloat progress, BOOL *stop) {
            if (eScanStatusTryStop == weakself.eScanStatus)
            {
                *stop = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                _process.doubleValue = progress;
            });
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (eScanResultSuccess == nestingScan.eScanResult)
            {
                if (0 == nestingScan.functionItems.count)
                {
                    [self showErrorMessage:@"no function founded."];
                }
                [[NSUserDefaults standardUserDefaults] setObject:path forKey:USER_DEFAULT_PATH_KEY];
                [ScanedData setScanedData:nestingScan];
                [self updateResult];
            }
            weakself.eScanStatus = eScanStatusStandBy;
        });
    });
}

- (NSString *)btnTitleForStatus:(EnumScanStatus)eScanStatus
{
    NSString *title = @"Scan";
    if (eScanStatusScaning == eScanStatus)
    {
        title = @"Scaning";
    }
    else if (eScanStatusTryStop == eScanStatus)
    {
        title = @"Stoping";
    }
    return title;
}

- (void)setEScanStatus:(EnumScanStatus)eScanStatus
{
    [_scanBtn setTitle:[self btnTitleForStatus:eScanStatus]];
    _eScanStatus = eScanStatus;
}

- (void) updateResult
{
    [_linesVC refresh];
    [_depthVC refresh];
    [_filesVC refresh];
}

- (void)showErrorMessage:(NSString *)msg
{
    [[NSAlert alertWithMessageText:@"Error"
                     defaultButton:@"OK"
                   alternateButton:nil
                       otherButton:nil
         informativeTextWithFormat:@"%@", msg] runModal];
}
@end
