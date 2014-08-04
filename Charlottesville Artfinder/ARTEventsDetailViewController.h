//
//  ARTEventsDetailViewController.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/31/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@class ARTEvent;
@interface ARTEventsDetailViewController : UIViewController
{
    __weak IBOutlet UIScrollView *scrollView;
    UIButton *calendarActionButton;
    EKEventStore *calendarEventStore;
    BOOL calendarPermission;
}

@property (nonatomic, strong) ARTEvent *event;
@property (nonatomic, strong) NSDate *selectedDate;

@end
