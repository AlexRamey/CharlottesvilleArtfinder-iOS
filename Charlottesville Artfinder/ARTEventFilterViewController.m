//
//  ARTEventFilterViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/4/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTEventFilterViewController.h"
#import "ARTEventCategoryToggleCell.h"
#import "ARTObjectStore.h"
#import "AppDelegate.h"

@interface ARTEventFilterViewController ()
@property BOOL initialDanceToggleState;
@property BOOL initialGalleryToggleState;
@property BOOL initialMusicToggleState;
@property BOOL initialTheatreToggleState;
@property BOOL initialVenueToggleState;
@end

@implementation ARTEventFilterViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    _initialDanceToggleState = [[NSUserDefaults standardUserDefaults] boolForKey:ART_DANCE_TOGGLE_KEY];
    _initialGalleryToggleState = [[NSUserDefaults standardUserDefaults] boolForKey:ART_GALLERY_TOGGLE_KEY];
    _initialMusicToggleState = [[NSUserDefaults standardUserDefaults] boolForKey:ART_MUSIC_TOGGLE_KEY];
    _initialTheatreToggleState = [[NSUserDefaults standardUserDefaults] boolForKey:ART_THEATRE_TOGGLE_KEY];
    _initialVenueToggleState = [[NSUserDefaults standardUserDefaults] boolForKey:ART_VENUE_TOGGLE_KEY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dismiss:(id)sender
{
    BOOL finalDanceToggleState = [[NSUserDefaults standardUserDefaults] boolForKey:ART_DANCE_TOGGLE_KEY];
    BOOL finalGalleryToggleState = [[NSUserDefaults standardUserDefaults] boolForKey:ART_GALLERY_TOGGLE_KEY];
    BOOL finalMusicToggleState = [[NSUserDefaults standardUserDefaults] boolForKey:ART_MUSIC_TOGGLE_KEY];
    BOOL finalTheatreToggleState = [[NSUserDefaults standardUserDefaults] boolForKey:ART_THEATRE_TOGGLE_KEY];
    BOOL finalVenueToggleState = [[NSUserDefaults standardUserDefaults] boolForKey:ART_VENUE_TOGGLE_KEY];
    
    if (!(_initialDanceToggleState == finalDanceToggleState && _initialGalleryToggleState == finalGalleryToggleState && _initialMusicToggleState == finalMusicToggleState && _initialTheatreToggleState == finalTheatreToggleState && _initialVenueToggleState == finalVenueToggleState))
    {
        NSString *isDanceEnabled = @"DISABLED";
        NSString *isGalleryEnabled = @"DISABLED";
        NSString *isMusicEnabled = @"DISABLED";
        NSString *isTheatreEnabled = @"DISABLED";
        NSString *isVenueEnabled = @"DISABLED";
        
        if (finalDanceToggleState)
        {
            isDanceEnabled = @"ENABLED";
        }
        if (finalGalleryToggleState)
        {
            isGalleryEnabled = @"ENABLED";
        }
        if (finalMusicToggleState)
        {
            isMusicEnabled = @"ENABLED";
        }
        if (finalTheatreToggleState)
        {
            isTheatreEnabled = @"ENABLED";
        }
        if (finalVenueToggleState)
        {
            isVenueEnabled = @"ENABLED";
        }
        
        NSDictionary *params = @{
                                 @"Dance" : isDanceEnabled,
                                 @"Gallery" : isGalleryEnabled,
                                 @"Music" : isMusicEnabled,
                                 @"Theatre" : isTheatreEnabled,
                                 @"Venue" : isVenueEnabled
                                 };
        
        [Flurry logEvent:@"Event Filter Applied" withParameters:params];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //do nothing
}

#pragma mark - UITableViewDataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Toggle Categories";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ARTObjectStore primaryCategories] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARTEventCategoryToggleCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"EventCategoryToggle"];
    
    NSString *category = [ARTObjectStore primaryCategories][indexPath.row];
    [cell.category setText: category];
    
    UIImage *thumbnail = [ARTObjectStore defaultImageForCategory:category];
    [cell.thumbnail setImage:thumbnail];
    
    cell.toggle.on = [[NSUserDefaults standardUserDefaults] boolForKey:[AppDelegate toggleKeyForCategory:category]];
    
    return cell;
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
