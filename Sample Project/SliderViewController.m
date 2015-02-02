//
//  SliderViewController.m
//  MBXMapKit
//
//  Created by Gevorg Ghukasyan on 1/16/15.
//  Copyright (c) 2015 MapBox. All rights reserved.
//

#import "SliderViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SliderViewController ()

@end

@implementation SliderViewController

@synthesize annotation;

- (void)viewDidLoad {
    [super viewDidLoad];
 //   _homeImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2);
    
    
    _homeImageView.image = [UIImage imageNamed:@"defoult.jpg"];
    
    _homeImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (annotation.homeImagesURL != nil){
        if ( [[annotation.homeImagesURL objectAtIndex:0] isKindOfClass:[NSString class] ] ){
            dispatch_async(kBgQueue, ^{
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString: [annotation.homeImagesURL objectAtIndex:0] ]];
                if (imgData) {
                    UIImage *image = [UIImage imageWithData:imgData];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [annotation.homeImagesURL replaceObjectAtIndex:0 withObject:image];
                            _homeImageView.image = image;
                        });
                    }
                }
            });
        }else if ([[annotation.homeImagesURL objectAtIndex:0] isKindOfClass:[UIImage class] ]){
            _homeImageView.image = [annotation.homeImagesURL objectAtIndex:0];
        }
    }

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
