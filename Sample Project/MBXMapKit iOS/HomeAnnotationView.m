//
//  HomeAnnotationView.m
//  ArmZillow
//
//  Created by Gevorg Ghukasyan on 12/26/14.
//  Copyright (c) 2014 Gevorg Ghukasyan. All rights reserved.
//

#import "HomeAnnotationView.h"
#import "MBXPointAnnotation.h"

NSString * const HomeAnnotationReuseIdentifier = @"HomeAnnotationReuseIdentifier";

@interface HomeAnnotationView()


@end

@implementation HomeAnnotationView


-(id)initWithAnnotation:(id<MKAnnotation>)annotation
{
    self = [super initWithAnnotation:annotation reuseIdentifier:HomeAnnotationReuseIdentifier];
    if(self)
    {
        self.frame = CGRectMake(0, 0, 30, 30);
        self.backgroundColor = [UIColor clearColor];
        [self buildViewWithImage:((MBXPointAnnotation*)annotation).markerImage];
    }
    return self;
}

-(void)buildViewWithImage:(UIImage *)img
{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _imageView.image = img;
    [self addSubview:_imageView];
}

-(void)annotationSelected
{
    [UIView animateWithDuration:1
                     animations:^{
    
                         //self.frame = CGRectMake(0, 0, 30, 30);
                         //self.centerOffset = CGPointMake(self.centerOffset.x,self.centerOffset.y);
                         self.imageView.image = [UIImage imageNamed:@"opened.png"];
                    }
     ];
    
}
-(void)annotationDeselected
{
    [UIView animateWithDuration:1
                     animations:^{
                         
                         //self.frame = CGRectMake(0, 0, 30, 30);
                         //self.centerOffset = CGPointMake(self.centerOffset.x,self.centerOffset.y);
                         self.imageView.image = [UIImage imageNamed:@"home"];
                     }
     ];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
