//
//  ARTEventsViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/29/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTEventsViewController.h"
#import "CalendarKit.h"
#import "UIColor+Theme.h"
#import "ARTObjectStore.h"
#import "ARTEvent.h"
#import "ARTEventsDetailViewController.h"

@interface ARTEventsViewController ()

@end

@implementation ARTEventsViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        //custom initialization
        _store = [ARTObjectStore sharedStore];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithMode:1];
    [calendar setDelegate:self];
    [calendar setDataSource:self];
    
    [self.containerView addSubview:calendar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)filterAction:(id)sender
{
    //TODO: Present Modal Filter Controller
}

#pragma mark - CKCalendarViewDataSource

-(NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    NSArray *artEvents = [_store allEventsOnDate:date];
    NSMutableArray *eventItems = [[NSMutableArray alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    for (ARTEvent *e in artEvents)
    {
        if (e.startDate) //non-spanning event
        {
            NSString *time = [formatter stringFromDate:e.startDate];
            
            NSDictionary *info = [@{@"EVENT_ID" : e.eventID, @"EVENT_START_TIME" : time} mutableCopy];
            
            if (e.location)
            {
                [info setValue:e.location forKey:@"EVENT_LOCATION"];
            }
            else
            {
                [info setValue:@"No Location Listed" forKey:@"EVENT_LOCATION"];
            }
            
            [eventItems addObject:[CKCalendarEvent eventWithTitle:e.title andDate:e.startDate andInfo:info andColor:[UIColor ARTThemeColorForCategory:e.category]]];
        }
        else //spanning event
        {
            NSDictionary *info = [@{@"EVENT_ID" : e.eventID, @"EVENT_START_TIME" : @"All Day"} mutableCopy];
            
            if (e.location)
            {
                [info setValue:e.location forKey:@"EVENT_LOCATION"];
            }
            else
            {
                [info setValue:@"No Location Listed" forKey:@"EVENT_LOCATION"];
            }
            
            [eventItems addObject:[CKCalendarEvent eventWithTitle:e.title andDate:date andInfo:info andColor:[UIColor ARTThemeColorForCategory:e.category]]];
        }
        
    }
    
    return eventItems;
}

#pragma mark - CKCalendarViewDelegate

-(void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event
{
    NSArray *events = [_store eventsWithEventID:[event.info objectForKey:@"EVENT_ID"]];
    
    selectedEvent = (ARTEvent *)(events[0]);
    selectedDate = event.date;
    
    [self performSegueWithIdentifier:@"EventsToDetail" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [(ARTEventsDetailViewController *)[segue destinationViewController] setEvent:selectedEvent];
    [(ARTEventsDetailViewController *)[segue destinationViewController] setSelectedDate:selectedDate];
}


@end
