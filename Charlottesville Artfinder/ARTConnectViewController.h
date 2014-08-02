//
//  ARTConnectViewController.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/1/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTConnectViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>
{
    int loadStack;
}

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@end
