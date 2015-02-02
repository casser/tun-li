//
//  HomeAnnotationView.h
//  ArmZillow
//
//  Created by Gevorg Ghukasyan on 12/26/14.
//  Copyright (c) 2014 Gevorg Ghukasyan. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface HomeAnnotationView : MKAnnotationView

@property UIImageView *imageView;

-(id)initWithAnnotation:(id<MKAnnotation>)annotation;
-(void)annotationSelected;
-(void)annotationDeselected;

@end
