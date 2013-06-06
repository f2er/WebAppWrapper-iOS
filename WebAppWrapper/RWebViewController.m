//
//  RWebViewController.m
//  WebAppWrapper
//
//  Created by Alex Rezit on 22/05/2013.
//  Copyright (c) 2013 Seymour Dev. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "RWebViewController.h"

@interface RWebViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) UIBarButtonItem *stopButton;
@property (nonatomic, strong) UIBarButtonItem *moreActionButton;

@property (nonatomic, weak) UIActionSheet *moreActionSheet;

- (void)dismiss;
- (void)showMoreActionSheet;

- (void)loadStartPage;
- (void)refresh;
- (void)stopLoading;
- (void)goBack;
- (void)goForward;

- (void)setButtonWithLoadingStatus:(BOOL)loading;
- (void)refreshNavigationButtonStatus;

- (void)doneButtonPressed:(id)sender;
- (void)backButtonPressed:(id)sender;
- (void)forwardButtonPressed:(id)sender;
- (void)refreshButtonPressed:(id)sender;
- (void)stopButtonPressed:(id)sender;
- (void)moreActionButtonPressed:(id)sender;

@end

@implementation RWebViewController

#pragma mark - View control

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showMoreActionSheet
{
    UIActionSheet *moreActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"Copy link", nil), NSLocalizedString(@"Open in Safari", nil), nil];
    self.moreActionSheet = moreActionSheet;
    [moreActionSheet showFromBarButtonItem:self.moreActionButton animated:YES];
}

#pragma mark - Web view control

- (void)loadStartPage
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.startURL];
    [self.webView loadRequest:request];
}

- (void)refresh
{
    [self.webView reload];
}

- (void)stopLoading
{
    [self.webView stopLoading];
}

- (void)goBack
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

- (void)goForward
{
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

#pragma mark - Toolbar items control

- (void)setButtonWithLoadingStatus:(BOOL)loading
{
    NSUInteger buttonIndex = ([self.toolbarItems indexOfObject:self.refreshButton] ^ NSNotFound |
                              [self.toolbarItems indexOfObject:self.stopButton] ^ NSNotFound) ^ NSNotFound;
    NSMutableArray *toolbarItems = self.toolbarItems.mutableCopy;
    [toolbarItems replaceObjectAtIndex:buttonIndex withObject:(loading ? self.stopButton : self.refreshButton)];
    [self setToolbarItems:toolbarItems animated:NO];
}

- (void)refreshNavigationButtonStatus
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

#pragma mark - Actions

- (void)doneButtonPressed:(id)sender
{
    [self dismiss];
}

- (void)backButtonPressed:(id)sender
{
    [self goBack];
}

- (void)forwardButtonPressed:(id)sender
{
    [self goForward];
}

- (void)refreshButtonPressed:(id)sender
{
    [self refresh];
}

- (void)stopButtonPressed:(id)sender
{
    [self stopLoading];
}

- (void)moreActionButtonPressed:(id)sender
{
    [self showMoreActionSheet];
}

#pragma mark - Life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init navigation items.
    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    
    // Add navigation items.
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    // Init toolbar items.
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavForward"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonPressed:)];
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
    self.stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopButtonPressed:)];
    self.moreActionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moreActionButtonPressed:)];
    
    // Add toolbar & toolbar items.
    
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceItem.width = 12.0f;
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[
                          fixedSpaceItem,
                          self.backButton,
                          flexibleSpaceItem,
                          self.forwardButton,
                          flexibleSpaceItem,
                          self.refreshButton,
                          flexibleSpaceItem,
                          self.moreActionButton,
                          fixedSpaceItem
                          ];
    [self refreshNavigationButtonStatus];
    
    // Init & add web view.
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadStartPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        [self setButtonWithLoadingStatus:YES];
        [self refreshNavigationButtonStatus];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        self.navigationItem.prompt = webView.request.URL.absoluteString;
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [self setButtonWithLoadingStatus:NO];
        [self refreshNavigationButtonStatus];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView == self.webView) {
        [self setButtonWithLoadingStatus:NO];
        [self refreshNavigationButtonStatus];
    }
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.moreActionSheet) {
        switch (buttonIndex) {
            case 0: // Copy link
                [[UIPasteboard generalPasteboard] setValue:self.webView.request.URL forPasteboardType:(NSString *)kUTTypeURL];
                break;
            case 1: // Open in Safari
                [[UIApplication sharedApplication] openURL:self.webView.request.URL];
                break;
            default:
                break;
        }
    }
}

@end
