//
//  ARTLoadViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTLoadViewController.h"
#import "ARTObjectStore.h"
#import "ARTVenue.h"
#import "ARTEvent.h"

@interface ARTLoadViewController ()

@end

@implementation ARTLoadViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        //custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        // iPhone Classic
        imageView.image = [UIImage imageNamed:@"cvilleartfinderlaunchimage"];
    }
    else
    {
        // iPhone 5 or maybe a larger iPhone ??
        imageView.image = [UIImage imageNamed:@"cvilleartfinderlaunchimage-1136"];
    }
    
    [activityIndicator setHidesWhenStopped:YES];
    
    ARTObjectStore *store = [ARTObjectStore sharedStore];
    
    __block NSError *loadError = nil;
    
    [store loadLatestVenuesWithCompletion:^(NSError *error) {
        if (error)
        {
            loadError = error;
        }
        else
        {
            NSArray *venues = [ARTVenue MR_findAll];
            NSLog(@"Venues in Core Data: %d", [venues count]);
        }
        
        [store loadAllEventsWithCompletion:^(NSError *err) {
            if (err)
            {
                loadError = err;
            }
            else
            {
                NSArray *events = [ARTEvent MR_findAll];
                NSLog(@"Events in Core Data: %d", [events count]);
            }
            
            [activityIndicator stopAnimating];
            [self performSegueWithIdentifier:@"ARTLoadCompleteSegue" sender:self];
        }];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [activityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
