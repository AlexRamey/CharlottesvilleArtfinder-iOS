//
//  ARTTransportationViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 7/24/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTTransportationViewController.h"
#import "ARTTransportationView.h"

@interface ARTTransportationViewController ()

@end

@implementation ARTTransportationViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        //custom initialization
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [scrollView addSubview:[[ARTTransportationView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 600)]];
    [scrollView setContentSize:CGSizeMake(320, 600)];
}

-(void)awakeFromNib
{
    [super awakeFromNib];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
