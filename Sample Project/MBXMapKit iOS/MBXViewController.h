//
//  MBXViewController.h
//  MBXMapKit iOS Demo v030
//
//  Copyright (c) 2014 Mapbox. All rights reserved.
//

@import UIKit;
@import MapKit;

#import "MBXMapKit.h"

@interface MBXViewController : UIViewController <MKMapViewDelegate, MBXRasterTileOverlayDelegate, UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@end
