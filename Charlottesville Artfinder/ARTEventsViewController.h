//
//  ARTEventsViewController.h
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/29/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarKit.h"
#import "ARTObjectStore.h"

@class ARTEvent;
@interface ARTEventsViewController : UIViewController <CKCalendarViewDataSource, CKCalendarViewDelegate>
{
    ARTEvent *selectedEvent;
    NSDate *selectedDate;
}

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) ARTObjectStore *store;

@end
