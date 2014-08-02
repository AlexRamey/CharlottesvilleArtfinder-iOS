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
        UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [aboutButton addTarget:self action:@selector(aboutSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateControlStates
{
    //Back Button
    if ([_webView canGoBack])
    {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    else
    {
        self.navigationItem.leftBarButtonItem.enabled = NO;
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
}

-(IBAction)tapReceived:(id)sender
{
    [self updateControlStates];
}

-(IBAction)selectionMade:(id)sender
{
    NSURL *url = nil;
    
    switch ([sender selectedSegmentIndex])
    {
        case 0:
        {
            url = [NSURL URLWithString:FACEBOOK_URL];
            break;
        }
        case 1:
        {
            url = [NSURL URLWithString:TWITTER_URL];
            break;
        }
        case 2:
        {
            url = [NSURL URLWithString:BLOG_URL];
            break;
        }
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    loadStack = 0;
    [_webView loadRequest:request];
}

-(IBAction)navigateBack:(id)sender
{
    if ([_webView canGoBack])
    {
        [_webView goBack];
    }
    
    [self updateControlStates];
}

-(IBAction)aboutSelected:(id)sender
{
    [self performSegueWithIdentifier:@"ConnectToAbout" sender:self];
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
    
    //Error Code -999 gets returned if the webview cancels it's own load
    //This happens if you quickly click around on the segmented control
    //The webview cancels its prior engagement, calls this method, and start its new one
    
    [_activityIndicator stopAnimating];
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
