//
//  SliderViewController.m
//  MBXMapKit
//
//  Created by Gevorg Ghukasyan on 1/16/15.
//  Copyright (c) 2015 MapBox. All rights reserved.
//

#import "SliderViewController.h"
#import "UIImageSliderViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SliderViewController () <UIPageViewControllerDataSource>

@property (nonatomic) UIPageViewController *pageViewController;
//@property (nonatomic) UILabel *label;

@end

@implementation SliderViewController

@synthesize annotation;
@synthesize up = _up;

- (void)viewDidLoad {
    [super viewDidLoad];
 //   _homeImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2);
    
    _homeImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2);
    _homeImageView.image = [UIImage imageNamed:@"defoult.jpg"];
    
 //   _homeImageView.contentMode = UIViewContentModeScaleAspectFit;
    
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

-(void)setUp:(BOOL)up
{
    _up = up;
    if(up)
    {
        [self buildImageSlider];
    }else{
        [self removeImageSlider];
    }
}
-(BOOL)up
{
    return _up;
}

-(void)buildImageSlider
{
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    _pageViewController.dataSource = self;
    
    _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2);
    
    UIImageSliderViewController *initialViewController = [self viewControllerWithImagePath:[annotation.homeImagesURL firstObject] andIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction: UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
 //   _label = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, 0, 40, 20)];
//    _label.text = [NSString stringWithFormat:@"(%i/%i)",1,annotation.homeImagesURL.count];
    
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    

}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((UIImageSliderViewController*)viewController).index;
    
 //   [self changedPageViewWithIndex:index];
    
    if(index == 0){
        return [self viewControllerWithImagePath:[annotation.homeImagesURL lastObject] andIndex:annotation.homeImagesURL.count-1];//skzbic gnac verj
    }
    
    index--;
    
    return [self viewControllerWithImagePath:[annotation.homeImagesURL objectAtIndex:index] andIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = ((UIImageSliderViewController*)viewController).index;
    
//    [self changedPageViewWithIndex:index];
    
    index++;
    
    if(index == annotation.homeImagesURL.count){
        return [self viewControllerWithImagePath:[annotation.homeImagesURL firstObject] andIndex:0];//verjic gnac skizb
    }
    
    return [self viewControllerWithImagePath:[annotation.homeImagesURL objectAtIndex:index] andIndex:index];
}

-(UIImageSliderViewController*)viewControllerWithImagePath:(id)url andIndex:(NSInteger)index
{
    UIImageSliderViewController *childView = [self.storyboard instantiateViewControllerWithIdentifier:@"imageSliderID"];
    childView.imageURL = url;
    childView.index = index;
    childView.labelText = [NSString stringWithFormat:@"(%i/%i)",index+1,annotation.homeImagesURL.count];
    return childView;
}
/*
-(void)changedPageViewWithIndex:(NSInteger)index
{
    _label.text = [NSString stringWithFormat:@"(%i/%i)",index+1,annotation.homeImagesURL.count];
}*/

-(void)removeImageSlider
{
    [_pageViewController.view removeFromSuperview];
    [_pageViewController removeFromParentViewController];
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
