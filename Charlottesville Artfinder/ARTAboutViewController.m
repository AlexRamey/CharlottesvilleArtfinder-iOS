//
//  ARTAboutViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/6/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTAboutViewController.h"
#import "AppDelegate.h"

@interface ARTAboutViewController ()

@property (nonatomic, weak) IBOutlet UILabel *organizationDescription;

@end

@implementation ARTAboutViewController

- (id)initWithCoder:(NSCoder *)aDecoder
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
    NSString *pcaDescription = [[NSUserDefaults standardUserDefaults] objectForKey:ART_PCA_DESCRIPTION_KEY];
    [_organizationDescription setText:pcaDescription];
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
