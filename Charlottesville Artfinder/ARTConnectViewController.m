//
//  ARTConnectViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/1/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTConnectViewController.h"

@interface ARTConnectViewController ()

@end

@implementation ARTConnectViewController

static NSString * const BLOG_URL = @"http://charlottesvillearts.org/blog/";
static NSString * const FACEBOOK_URL = @"https://www.facebook.com/charlottesvillearts";
static NSString * const TWITTER_URL = @"https://twitter.com/PCA_Arts";

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        UIBarButtonItem *backArrow = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nb_back"] style:UIBarButtonItemStylePlain target:self action:@selector(navigateBack:)];
        
        UIBarButtonItem *forwardArrow = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nb_forward"] style:UIBarButtonItemStylePlain target:self action:@selector(navigateForward:)];
        
        NSArray *rightBarButtonItems = @[forwardArrow, backArrow];
        
        self.navigationItem.rightBarButtonItems = rightBarButtonItems;
        
        loadStack = 0;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
    [_webView addGestureRecognizer:tapRecognizer];
    
    [_webView setDelegate:self];
    [_webView setScalesPageToFit:YES];
    
    [_activityIndicator setHidesWhenStopped:YES];
    
    _segmentedControl.selectedSegmentIndex = 0;
    [self selectionMade:_segmentedControl];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self updateControlStates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateControlStates
{
    if ([_webView canGoForward])
    {
        [(self.navigationItem.rightBarButtonItems[0]) setEnabled: YES];
    }
    else
    {
        [(self.navigationItem.rightBarButtonItems[0]) setEnabled: NO];
    }
    
    if ([_webView canGoBack])
    {
        [(self.navigationItem.rightBarButtonItems[1]) setEnabled: YES];
    }
    else
    {
        [(self.navigationItem.rightBarButtonItems[1]) setEnabled: NO];
    }
    
    //Segmented Control
    if ([[_webView.request.URL absoluteString] rangeOfString:@"facebook.com"].location != NSNotFound)
    {
        _segmentedControl.selectedSegmentIndex = 0;
    }
    else if ([[_webView.request.URL absoluteString] rangeOfString:@"twitter.com"].location != NSNotFound)
    {
        _segmentedControl.selectedSegmentIndex = 1;
    }
    else if ([[_webView.request.URL absoluteString] rangeOfString:@"charlottesvillearts.org"].location != NSNotFound)
    {
        _segmentedControl.selectedSegmentIndex = 2;
    }
    
    NSArray *navTitles = @[@"Facebook", @"Twitter", @"PCA Blog"];
    self.navigationItem.title = navTitles[_segmentedControl.selectedSegmentIndex];
}

-(IBAction)tapReceived:(id)sender
{
    [self updateControlStates];
}

-(IBAction)selectionMade:(id)sender
{
    NSArray *navTitles = @[@"Facebook", @"Twitter", @"PCA Blog"];
    self.navigationItem.title = navTitles[_segmentedControl.selectedSegmentIndex];
    
    NSURL *url = nil;
    switch ([sender selectedSegmentIndex])
    {
        case 0:
            url = [NSURL URLWithString:FACEBOOK_URL];
            break;
        case 1:
            url = [NSURL URLWithString:TWITTER_URL];
            break;
        case 2:
            url = [NSURL URLWithString:BLOG_URL];
            break;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

-(IBAction)navigateBack:(id)sender
{
    if ([_webView canGoBack])
    {
        [_webView goBack];
    }
}

-(IBAction)navigateForward:(id)sender
{
    if ([_webView canGoForward])
    {
        [_webView goForward];
    }
}

-(IBAction)refresh:(id)sender
{
    [_webView reload];
}

#pragma mark - UIWebViewDelegate Methods

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if (loadStack++ == 0)
    {
        [_activityIndicator startAnimating];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (--loadStack == 0)
    {
        [_activityIndicator stopAnimating];
        [self updateControlStates];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] == -1009) //internet failure
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Load Attempt Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    [self webViewDidFinishLoad:_webView];
}

#pragma mark - UIGestureRecognizer Delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
