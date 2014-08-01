//
//  ARTDetailViewController.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/26/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTVenue.h"

@interface ARTVenueDetailViewController : UIViewController <UIAlertViewDelegate>
{
    __weak IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, strong) ARTVenue *venue;

@end
