//
//  ARTEventFilterViewController.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/4/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTEventFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
