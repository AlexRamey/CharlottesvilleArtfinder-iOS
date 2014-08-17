//
//  ARTLoadViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/23/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTLoadViewController.h"
#import "AppDelegate.h"
#import "ARTObjectStore.h"

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
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [activityIndicator startAnimating];
    
    ARTObjectStore *store = [ARTObjectStore sharedStore];
    
    void (^completion)(NSError *) = ^(NSError *error){
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download Failed" message:@"Some data was unable to be downloaded." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:ART_LAST_REFRESH_KEY];
        }
        
        [activityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"ARTLoadCompleteSegue" sender:self];
    };
    
    if (([store eventCount] == 0 && [store venueCount] == 0) || ([[NSDate date] timeIntervalSince1970] - [[[NSUserDefaults standardUserDefaults] objectForKey:ART_LAST_REFRESH_KEY] integerValue] > 7 * 24 * 60 * 60))
    {
        __block NSError *error = nil;
        
        [store loadLatestVenuesWithCompletion:^(NSError *err) {
            
            error = err;
            
            [store loadAllEventsWithCompletion:^(NSError *e) {
                
                if (e)
                {
                    error = e;
                }
                
                [store loadPCAInformationWithCompletion:^(NSError *ARTError) {
                    if (ARTError)
                    {
                        error = ARTError;
                    }
                    
                    completion(error);
                }];
            }];
        }];
    }
    else if ([store venueCount] == 0)
    {
        [store loadLatestVenuesWithCompletion:completion];
    }
    else if ([store eventCount] == 0)
    {
        [store loadAllEventsWithCompletion:completion];
    }
    else
    {
        completion(nil);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((UITabBarController *)[segue destinationViewController]).delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ((UITabBarController *)[segue destinationViewController]).selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:ART_SELECTED_TAB_KEY];
}


@end
