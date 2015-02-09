//
//  HomeViewController.m
//  MBXMapKit
//
//  Created by Gevorg Ghukasyan on 2/9/15.
//  Copyright (c) 2015 MapBox. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureSliderMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureSliderMenu
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if( revealViewController )
    {
        [self.sideBarButton setTarget:self.revealViewController];
        [self.sideBarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
