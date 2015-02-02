//
//  SliderViewController.h
//  MBXMapKit
//
//  Created by Gevorg Ghukasyan on 1/16/15.
//  Copyright (c) 2015 MapBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBXPointAnnotation.h"

@interface SliderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;

@property (strong, nonatomic) MBXPointAnnotation *annotation;

@end
