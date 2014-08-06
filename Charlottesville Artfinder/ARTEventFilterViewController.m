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

@interface ARTEventFilterViewController ()

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    NSArray *categories = [ARTObjectStore primaryCategories];
    NSString *category = categories[indexPath.row];
    [cell.category setText: category];
    
    UIImage *thumbnail = nil;
    
    if ([category caseInsensitiveCompare:@"Dance"] == NSOrderedSame)
    {
        thumbnail = [UIImage imageNamed:@"dancedefault"];
    }
    else  if ([category caseInsensitiveCompare:@"Gallery"] == NSOrderedSame)
    {
        thumbnail = [UIImage imageNamed:@"gallerydefault"];
    }
    else  if ([category caseInsensitiveCompare:@"Music"] == NSOrderedSame)
    {
        thumbnail = [UIImage imageNamed:@"musicdefault"];
    }
    else  if ([category caseInsensitiveCompare:@"Theatre"] == NSOrderedSame)
    {
        thumbnail = [UIImage imageNamed:@"theatredefault"];
    }
    else
    {
        thumbnail = [UIImage imageNamed:@"venuedefault"];
    }
    
    [cell.thumbnail setImage:thumbnail];
    
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
