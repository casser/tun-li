//
//  UIImageSliderViewController.m
//  MBXMapKit
//
//  Created by Gevorg Ghukasyan on 2/16/15.
//  Copyright (c) 2015 MapBox. All rights reserved.
//

#import "UIImageSliderViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface UIImageSliderViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLaber;

@end

@implementation UIImageSliderViewController

@synthesize imageURL,labelText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _numberLaber.text = labelText;
    _imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2);
    if(imageURL != nil)
    {
        if ([imageURL isKindOfClass:[UIImage class]]) {
            _imageView.image = imageURL;
        }else{
            _imageView.image = [UIImage imageNamed:@"defoult.jpg"];
            
            if ( [imageURL isKindOfClass:[NSString class] ] ){
                dispatch_async(kBgQueue, ^{
                    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                    if (imgData) {
                        UIImage *image = [UIImage imageWithData:imgData];
                        if (image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                imageURL = image;
                                _imageView.image = image;
                            });
                        }
                    }
                });
            }
        }
    }

    
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
