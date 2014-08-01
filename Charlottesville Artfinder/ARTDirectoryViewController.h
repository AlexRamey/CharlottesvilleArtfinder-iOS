//
//  ARTDirectoryViewController.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/26/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTObjectStore, ARTVenue;
@interface ARTDirectoryViewController : UITableViewController
{
    ARTVenue *selectedVenue;
}

@property (nonatomic, strong) ARTObjectStore *store;

@end
