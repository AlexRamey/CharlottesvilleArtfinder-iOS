//
//  ARTAboutViewController.m
//  Charlottesville Artfinder
//
//  Created by Alex Ramey on 8/6/14.
//  Copyright (c) 2014 HooApps. All rights reserved.
//

#import "ARTAboutViewController.h"
#import "ARTHooAppsParseClient.h"
#import "AppDelegate.h"

@interface ARTAboutViewController ()

@property (nonatomic, weak) IBOutlet UILabel *organizationDescription;
@property (nonatomic, weak) IBOutlet UIImageView *attribution;

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
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:pcaDescription];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [pcaDescription length])];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica Neue" size:16] range:NSMakeRange(0, [pcaDescription length])];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, [pcaDescription length])];
    
    [_organizationDescription setAttributedText:attrString];
    
    ARTHooAppsParseClient *sharedClient = [ARTHooAppsParseClient sharedClient];
    [sharedClient loadAttributionURLWithCompletion:^(NSError * error) {
        //do nothing
    }];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchHooAppsPage:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [_attribution addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)launchHooAppsPage:(id)sender
{
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:ART_ATTRIBUTION_URL_KEY];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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
