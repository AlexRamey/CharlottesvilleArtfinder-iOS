//
//  ARTDirectoryViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/26/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTDirectoryViewController.h"
#import "ARTVenueDetailViewController.h"
#import "ARTObjectStore.h"
#import "ARTVenue.h"
#import "ARTVenueCell.h"

@interface ARTDirectoryViewController ()

@end

@implementation ARTDirectoryViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        _store = [ARTObjectStore sharedStore];
        
        UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [aboutButton addTarget:self action:@selector(aboutSelected:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *aboutBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];
        self.navigationItem.leftBarButtonItem = aboutBarButtonItem;
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
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)aboutSelected:(id)sender
{
    [self performSegueWithIdentifier:@"DirectoryToAbout" sender:self];
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *venues = [_store allVenuesOfPrimaryCategory:[ARTObjectStore primaryCategories][indexPath.section]];
    
    NSArray *sortedVenues = [venues sortedArrayUsingComparator:^NSComparisonResult(ARTVenue *a, ARTVenue *b) {
        return [a.organizationName caseInsensitiveCompare:b.organizationName];
    }];
    
    selectedVenue = sortedVenues[indexPath.row];
    
    [self performSegueWithIdentifier:@"MasterToDetail" sender:self];
}

#pragma mark - UITableViewDataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[ARTObjectStore primaryCategories] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [ARTObjectStore primaryCategories][section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_store allVenuesOfPrimaryCategory:[ARTObjectStore primaryCategories][section]] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *venues = [_store allVenuesOfPrimaryCategory:[ARTObjectStore primaryCategories][indexPath.section]];
    
    NSArray *sortedVenues = [venues sortedArrayUsingComparator:^NSComparisonResult(ARTVenue *a, ARTVenue *b) {
        return [a.organizationName caseInsensitiveCompare:b.organizationName];
    }];
    
    ARTVenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtVenueCell"];
    
    [cell.titleLabel setText: [sortedVenues[indexPath.row] organizationName]];
    
    UIImage *thumbnail = [UIImage imageWithData:[sortedVenues[indexPath.row] getThumbnailData]];
    
    [cell.thumbnailView setImage:thumbnail];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] caseInsensitiveCompare:@"MasterToDetail"] == NSOrderedSame)
    {
        [(ARTVenueDetailViewController *)[segue destinationViewController] setVenue:selectedVenue];
    }
}

@end
