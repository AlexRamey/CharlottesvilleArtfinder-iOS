//
//  ARTEventsDetailViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/31/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTEventsDetailViewController.h"
#import "ARTEventDetailView.h"
#import "ARTEvent.h"
#import "EventKit/EventKit.h"

@implementation ARTEventsDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        calendarEventStore = [[EKEventStore alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [calendarActionButton setTitle:@"Add To Calendar" forState:UIControlStateNormal];
    calendarActionButton.enabled = YES;
    
    [calendarEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
        if (!granted)
        {
            calendarPermission = NO;
        }
        else if (!error)
        {
            calendarPermission = YES;
            
            NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:_event.eventID];
            
            EKEvent *eventCheck = [calendarEventStore eventWithIdentifier:identifier];
            
            if (eventCheck)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [calendarActionButton setTitle:@"Remove From Calendar" forState:UIControlStateNormal];
                });
            }
        }
        else
        {
            calendarActionButton.enabled = NO;
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ARTEventDetailView *detail = [[ARTEventDetailView alloc] initWithEvent:_event selectedOnDate:_selectedDate];
    
    [scrollView setContentSize:CGSizeMake(detail.frame.size.width, detail.frame.size.height)];
    [scrollView addSubview:detail];
    
    calendarActionButton = detail.calendarButton;
    
    [calendarActionButton addTarget:self action:@selector(calendarAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)calendarAction:(id)sender
{
    if (!calendarPermission)
    {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Need Permission" message:@"Enable calendar access in device privacy settings to use this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [a show];
    }
    else
    {
        NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:_event.eventID];
        EKEvent *eventCheck = [calendarEventStore eventWithIdentifier:identifier];
        
        if (eventCheck)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL success = [calendarEventStore removeEvent:eventCheck span:EKSpanThisEvent commit:YES error:nil];
                if (success)
                {
                    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The event was removed from your calendar." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [a show];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:_event.eventID];
                    
                    [calendarActionButton setTitle:@"Add To Calendar" forState:UIControlStateNormal];
                }
                else
                {
                    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"The event was unable to be removed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [a show];
                }
            });
        }
        else
        {
            [Flurry logEvent:@"Add to Calendar Selected"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                EKEvent *eventToAdd = [EKEvent eventWithEventStore:calendarEventStore];
                
                eventToAdd.title = [_event title];
                
                if (_event.startDate)
                {
                    eventToAdd.startDate = _event.startDate;
                    eventToAdd.endDate = _event.endDate;
                }
                else //All Day Event
                {
                    //current locale is eastern time (-04:00 offset from GMT)
                    uint32_t UNIX = (int)[_selectedDate timeIntervalSince1970];
                    uint32_t extraSeconds = UNIX % (24 * 60 * 60);
                    eventToAdd.startDate = [NSDate dateWithTimeIntervalSince1970:UNIX - extraSeconds + 4 * 60 * 60];
                    eventToAdd.endDate = [NSDate dateWithTimeIntervalSince1970:UNIX - extraSeconds + 28 * 60 * 60 - 1];
                }
                
                eventToAdd.location = _event.location;
                eventToAdd.timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
                
                [eventToAdd setCalendar:[calendarEventStore defaultCalendarForNewEvents]];
                
                NSError *error = nil;
                BOOL success = [calendarEventStore saveEvent:eventToAdd span:EKSpanThisEvent commit:YES error:&error];
                
                if (success)
                {
                    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The event was added to your calendar." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [a show];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[eventToAdd eventIdentifier] forKey:_event.eventID];
                    
                    [calendarActionButton setTitle:@"Remove From Calendar" forState:UIControlStateNormal];
                }
                else
                {
                    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"The event was unable to be added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [a show];
                }
            });
        }
    }
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
