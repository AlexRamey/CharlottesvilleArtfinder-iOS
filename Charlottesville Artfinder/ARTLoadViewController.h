//
//  ARTLoadViewController.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTLoadViewController : UIViewController
{
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    __weak IBOutlet UIImageView *imageView;
}

@end
