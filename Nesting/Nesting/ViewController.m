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

@interface ViewController()
@property DepthViewController *depthVC;
@property LinesViewController *linesVC;

@property NSArray *tabViews;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _placeholderView.hidden = YES;
    // Do any additional setup after loading the view.
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.depthVC = [storyboard instantiateControllerWithIdentifier:@"Depth"];
    _depthVC.view.frame = _placeholderView.frame;
    [self.view addSubview:_depthVC.view];
    
    self.linesVC = [storyboard instantiateControllerWithIdentifier:@"Lines"];
    _linesVC.view.frame = _placeholderView.frame;
    [self.view addSubview:_linesVC.view];
    
    self.tabViews = @[_depthVC.view, _linesVC.view];
    
    [self onTouchUpInsideDepth:nil];
}

- (IBAction)onTouchUpInsideDepth:(id)sender
{
    [self hideAllTabViews];
    [_depthVC.view setHidden:NO];
}

- (IBAction)onTouchUpInsideLines:(id)sender
{
    [self hideAllTabViews];
    [_linesVC.view setHidden:NO];
}

- (void)hideAllTabViews
{
    for (NSView *view in _tabViews)
    {
        [view setHidden:YES];
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
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
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ScanedData *nestingScan = [NestingScan scanFolder:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ScanedData setScanedData:nestingScan];
            [self updateResult:nestingScan];
        });
    });
}


- (void) updateResult:(ScanedData *)nestingScan
{
    [_linesVC refresh];
    [_depthVC refresh];
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
