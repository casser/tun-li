//
//  MBXViewController.m
//  MBXMapKit iOS Demo v030
//
//  Copyright (c) 2014 Mapbox. All rights reserved.
//

#import "MBXViewController.h"
#import "HomeAnnotationView.h"
#import "SliderViewController.h"
//#import "MBXMapKit.h"


@interface MBXViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) MBXRasterTileOverlay *rasterOverlay;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *annotations;
@property (nonatomic) BOOL isAnnotastionSelected;

@property (nonatomic)  BOOL up;

@end

@implementation MBXViewController

@synthesize annotations,isAnnotastionSelected;

@synthesize up ;

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //------------------------------------MapBox Initialization-----------------------------------------------------------------

    // Set the Mapbox access token for API access if on iOS 8+
    //.
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 8)
    {
        [MBXMapKit setAccessToken:@"pk.eyJ1IjoiY2Fzc2VyIiwiYSI6IkNtZnBuaEUifQ.0FePYB2J3uyQz-F_d2CDqw"];
    }

    // Configure the amount of storage to use for NSURLCache's shared cache: You can also omit this and allow NSURLCache's
    // to use its default cache size. These sizes determines how much storage will be used for performance caching of HTTP
    // requests made by MBXOfflineMapDownloader and MBXRasterTileOverlay. Please note that these values apply only to the
    // HTTP cache, and persistent offline map data is stored using an entirely separate mechanism.
    //
    NSUInteger memoryCapacity = 4 * 1024 * 1024;
    NSUInteger diskCapacity = 40 * 1024 * 1024;
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:nil];
    //[urlCache removeAllCachedResponses];
    [NSURLCache setSharedURLCache:urlCache];

    // Let the shared offline map downloader know that we want to be notified of changes in its state. This will allow us to
    // update the download progress indicator and the begin/cancel/suspend/resume buttons
    //
//    MBXOfflineMapDownloader *sharedDownloader = [MBXOfflineMapDownloader sharedOfflineMapDownloader];

    // Turn off distracting MKMapView features which aren't relevant to this demonstration
    _mapView.rotateEnabled = NO;
    _mapView.pitchEnabled = NO;

    // Let the mapView know that we want to use delegate callbacks to provide customized renderers for tile overlays and views
    // for annotations. In order to make use of MBXRasterTileOverlay and MBXPointAnnotation, it is essential for your app to set
    // this delegate and implement MKMapViewDelegate's mapView:rendererForOverlay: and mapView:(MKMapView *)mapView viewForAnnotation:
    // methods.
    //
    _mapView.delegate = self;

    // Show the network activity spinner in the status bar
    //
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    // Configure a raster tile overlay to use the initial sample map
    //
    _rasterOverlay = [[MBXRasterTileOverlay alloc] initWithMapID:@"casser.koj2gpd5"];

    // Let the raster tile overlay know that we want to be notified when it has asynchronously loaded the sample map's metadata
    // (so we can set the map's center and zoom) and the sample map's markers (so we can add them to the map).
    //
    _rasterOverlay.delegate = self;

    // Add the raster tile overlay to our mapView so that it will immediately start rendering tiles. At this point the MKMapView's
    // default center and zoom don't match the center and zoom of the sample map, but that's okay. Adding the layer now will prevent
    // a percieved visual glitch in the UI (an empty map), and we'll fix the center and zoom when tileOverlay:didLoadMetadata:withError:
    // gets called to notify us that the raster tile overlay has finished asynchronously loading its metadata.
    //
    [_mapView addOverlay:_rasterOverlay];
    
    //----------------------------------------------------------------------------------------------------------------------------------
    
    isAnnotastionSelected = NO;
    
    
    NSDictionary *dic1 = @{ @"long":@40.19,
                           @"lat":@44.29,
                           @"homeImages":@[@"http://bostondesignguide.com/sites/default/files/styles/frontpage-slideshow/public/carter-and-company-microsite.jpg",
                                      @"http://mosteleganthomes.com/wp-content/uploads/2013/03/Minimal-Home-Interior-Ideas.jpg",
                                      @"http://bostondesignguide.com/sites/default/files/styles/frontpage-slideshow/public/now-interior-design-microsite.jpg"],
                           @"markerImage":[UIImage imageNamed:@"home"]};
    
    NSDictionary *dic2 = @{ @"long":@40.22,
                           @"lat":@44.25,
                           @"homeImages":@[@"http://updatedhome.com/wp-content/uploads/2010/10/Modern-Designs-Interiors-Home-by-Paola-Lenti9.jpg",
                                           @"http://st.houzz.com/simgs/74416c9b0091630c_4-5359/traditional-home-theater.jpg",
                                           @"http://bostondesignguide.com/sites/default/files/styles/frontpage-slideshow/public/Barbara-Bahr-Sheehan-Barn-Wide--microsite.jpg"],
                           @"markerImage":[UIImage imageNamed:@"home"]};
    
    NSDictionary *dic3 = @{ @"long":@40.35,
                           @"lat":@44.8,
                           @"homeImages":@[@"http://st.houzz.com/simgs/e5917f3601fed75c_4-5786/traditional-bedroom.jpg",
                                           @"http://www.hotnick.com/wp-content/uploads/2014/10/Nail-Salon-Ideas1.jpg",
                                           @"http://imgs.propguru.com/admin/knowledgebase/files/articleimgs/interior-design-ideas-for-indian-homes.jpg"],
                           @"markerImage":[UIImage imageNamed:@"home"]};
    
    NSDictionary *dic4 = @{ @"long":@40.43,
                           @"lat":@44.3,
                           @"homeImages":@[@"http://cdn.homemakeover.in/wblob/544B94D4E1EB5D/26/1709/Kqt4c1_OvhCDo1WIVl9ASA/Master-Bedroom-Interior-Design-2-640x320.jpg",
                                           @"http://cdn.homemakeover.in/wblob/544B94D4E1EB5D/26/1709/Kqt4c1_OvhCDo1WIVl9ASA/Master-Bedroom-Interior-Design-2-640x320.jpg" ],
                           @"markerImage":[UIImage imageNamed:@"home"]};
    
    NSDictionary *dic5 = @{ @"long":@40.14,
                           @"lat":@44.52,
                           @"homeImages":@[@"http://2.bp.blogspot.com/-lzVbN6L7jRU/TZpoi3LYCGI/AAAAAAAAB7I/_vn0019R5V4/s640/Park+Ave+Apartment%252C+New+York9.jpg",
                                           @"http://st.houzz.com/simgs/dd813e17009162fd_4-5343/contemporary-home-office.jpg",
                                           @"http://3.bp.blogspot.com/-rvoqrbfC9T0/UqwXR7ehkUI/AAAAAAAAJTQ/R2RZnOJNF6Q/s1600/Traditional+Japanese+Interior+Home+Design.jpg"],
                           @"markerImage":[UIImage imageNamed:@"home"]};
    
    NSDictionary *dic6 = @{ @"long":@40.32,
                           @"lat":@44.5,
                           @"homeImages":@[@"http://st.houzz.com/simgs/c8611f07009162d4_4-5333/contemporary-family-room.jpg" ],
                           @"markerImage":[UIImage imageNamed:@"home"]};
    
    NSArray *data = @[dic1, dic2, dic3, dic4, dic5, dic6 ];
    
    annotations = [[NSMutableArray alloc]init];
    
    for (NSDictionary *annInfo in data) {
        MBXPointAnnotation *ann = [[MBXPointAnnotation alloc]init];
        ann.coordinate = CLLocationCoordinate2DMake([[annInfo objectForKey:@"long"] doubleValue], [[annInfo objectForKey:@"lat"] doubleValue]);
        ann.markerImage = [annInfo objectForKey:@"markerImage"];
        ann.homeImagesURL = [NSMutableArray arrayWithArray:[annInfo objectForKey:@"homeImages"]];
        [_mapView addAnnotation:ann];
        [annotations addObject:ann];
    }
    

}
#pragma mark - Build Swiped View
-(void)buildImageViewFromDownWithAnnotation:(MBXPointAnnotation*)ann//-----------------------------------BUILD Page View Controller-------------
{
    
    CGFloat laynutyun = [[UIScreen mainScreen] bounds].size.width;
    CGFloat bardzrutyun = laynutyun/2;
    
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    _pageViewController.view.frame = CGRectMake(0, self.view.frame.size.height, laynutyun, self.view.frame.size.height);
    
    
    SliderViewController *initialViewController = [self viewControllerWithAnnotation:ann];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction: UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //---------added panGestureRecognizer------
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    gesture.minimumNumberOfTouches = 1;
    gesture.maximumNumberOfTouches = 1;
    up = NO;
    [_pageViewController.view addGestureRecognizer:gesture];
    
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, bardzrutyun/2-20, 40, 40)];
    leftImageView.image = [UIImage imageNamed:@"next"];
    leftImageView.transform = CGAffineTransformMakeRotation(M_PI);
    [_pageViewController.view addSubview:leftImageView];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(laynutyun - 40, bardzrutyun/2-20, 40, 40)];
    rightImageView.image = [UIImage imageNamed:@"next"];
    [_pageViewController.view addSubview:rightImageView];
    
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    
    
    
    
    [UIView animateWithDuration:1 animations:^{
        
        CGRect rect = _pageViewController.view.frame;
        rect.origin.y = [UIScreen mainScreen].bounds.size.height - bardzrutyun;
        _pageViewController.view.frame = rect;
    }];
    
    isAnnotastionSelected = YES;
    
}

-(void)panGestureRecognizerAction:(UIPanGestureRecognizer*)pan//----------------------------------PAN Gesture Action----------------
{
    NSLog(@"class`` %hhd",[pan.view isMemberOfClass:[SliderViewController class]]);
    
    SliderViewController *view=(SliderViewController*)pan.view;
    
    NSLog(@"supercalss` %@", pan.view.superclass);
    
  //  UIImage *img = view.homeImageView.image;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            _mapView.hidden = NO;
            for (UIScrollView *view in self.pageViewController.view.subviews) {
                
                if ([view isKindOfClass:[UIScrollView class]]) {
                    
                    view.scrollEnabled = YES;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if(pan.view.frame.origin.y<0)
            {
                break;
            }
            
            CGPoint translation = [pan translationInView:self.view];
            NSLog(@"%f",translation.y);
            pan.view.center = CGPointMake(pan.view.center.x,
                                          pan.view.center.y + translation.y);
            [pan setTranslation:CGPointMake(0, 0) inView:self.view];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            __block BOOL hidden = NO;
            __block float bardzrutyun = self.view.frame.size.width/2;
            
            [UIView animateWithDuration:0.5 animations:^{
                //  (a > b) ? a : b
                //     BOOL b =  up ? (pan.view.frame.origin.y+pan.view.frame.size.height > self.view.frame.size.height/2) : (pan.view.frame.origin.y > self.view.frame.size.height/2);
                if( pan.view.frame.origin.y-20 > self.view.frame.size.height - bardzrutyun )
                {
                    up = NO;
                    pan.view.frame = CGRectMake(0, self.view.frame.size.height, pan.view.frame.size.width, bardzrutyun);
                    hidden = YES;
                }else{
                    if ( up ? (pan.view.frame.origin.y+bardzrutyun > self.view.frame.size.height/2) : (pan.view.frame.origin.y > self.view.frame.size.height/2) )
                    {
                        up = NO;
                        pan.view.frame = CGRectMake(0, self.view.frame.size.height - bardzrutyun, pan.view.frame.size.width,pan.view.frame.size.height);
                    }else{
                        up = YES;
                        pan.view.frame = CGRectMake(0, 0, pan.view.frame.size.width, self.view.frame.size.height);
                        
                    
                    }
                }
            } completion:^(BOOL finished){
                
                if(up){
                    _mapView.hidden = YES;
                    for (UIScrollView *view in self.pageViewController.view.subviews) {
                        
                        if ([view isKindOfClass:[UIScrollView class]]) {
                            
                            view.scrollEnabled = NO;
                        }
                    }
                }
                
                if(hidden){
                    [self deletePageViewController];
                }
                    
            }];
            break;
        }
        default:
            break;
    }
}



-(SliderViewController*)viewControllerWithAnnotation:(MBXPointAnnotation*)ann//-------------------Return PageViewControllers views------------------
{
    SliderViewController *childView = [self.storyboard instantiateViewControllerWithIdentifier:@"childID"];
    childView.annotation = ann;
    return childView;
}



#pragma mark - UIPageViewControllerDataSource protocol implementation


-(void)deletePageViewController //--------------------------------------Delete PageViewController--------
{
    up = NO;
    [_pageViewController.view removeFromSuperview];
    [_pageViewController removeFromParentViewController];
    isAnnotastionSelected = NO;
    
    //------------deselect all selected annotation
    for (MBXPointAnnotation *ann in _mapView.selectedAnnotations) {
        [_mapView deselectAnnotation:ann animated:NO];
    }
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    NSLog(@"Current Page = %@", pageViewController.viewControllers);
    
 //   SliderViewController *currentView = [pageViewController.viewControllers lastObject];
    
    
    /*
    if( ![_mapView viewForAnnotation:currentView.annotation].selected )
        [_mapView selectAnnotation:currentView.annotation animated:NO];
    */
    
    
    
}

-(void)selectAnnotation:(MBXPointAnnotation*)ann//---------------Select Annotation when sliding---------
{
    if( ![_mapView viewForAnnotation:ann].selected )
    {
        [_mapView selectAnnotation:ann animated:NO];
        [_mapView mbx_setCenterCoordinate:ann.coordinate zoomLevel:[_mapView mbx_zoomLevel] animated:YES];
        //change mapView region
    }
    
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [annotations indexOfObject:((SliderViewController*)viewController).annotation];
    
    
    [self selectAnnotation:((SliderViewController*)viewController).annotation];
        
    if(index == 0){
        return [self viewControllerWithAnnotation:[annotations lastObject]];//skzbic gnac verj
    }
    
    index--;
    
    return [self viewControllerWithAnnotation:[annotations objectAtIndex:index]];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSInteger index = [annotations indexOfObject:((SliderViewController*)viewController).annotation];
    

    [self selectAnnotation:((SliderViewController*)viewController).annotation];

    
    index++;
    
    if(index == annotations.count){
        return [self viewControllerWithAnnotation:[annotations firstObject]];//verjic gnac skizb
    }
    
    return [self viewControllerWithAnnotation:[annotations objectAtIndex:index]];
}

#pragma mark - MKMapViewDelegate protocol implementation

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [(HomeAnnotationView*)view annotationDeselected];
/*
    BOOL isAllDeselected = YES;
    for (MBXPointAnnotation *ann in _mapView.annotations) {
        
         UIImage *img = ((HomeAnnotationView*)[_mapView viewForAnnotation:ann]).imageView.image;
        
        if( [((HomeAnnotationView*)[_mapView viewForAnnotation:ann]).imageView.image isEqual:[UIImage imageNamed:@"opened.png"]] )
        {
         //   UIImage *img = ((HomeAnnotationView*)[_mapView viewForAnnotation:ann]).image;
            isAllDeselected = NO;
            break;
        }
    }
    
    
    if(isAllDeselected)
    {
        [self deletePageViewController];
    }
    
    */
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    NSArray *arr =[[NSArray alloc]init];
    arr = mapView.selectedAnnotations;
    
    if([view isKindOfClass:[HomeAnnotationView class]])
    {
        if(!isAnnotastionSelected){
            [self buildImageViewFromDownWithAnnotation:(MBXPointAnnotation*)(view.annotation)];
        }else{
            
            SliderViewController *initialViewController = [self viewControllerWithAnnotation:(MBXPointAnnotation*)(view.annotation)];
            NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
            [_pageViewController setViewControllers:viewControllers direction: UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

        }
        [(HomeAnnotationView*)view annotationSelected];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    // This is boilerplate code to connect tile overlay layers with suitable renderers
    //
    if ([overlay isKindOfClass:[MBXRasterTileOverlay class]])
    {
        MKTileOverlayRenderer *renderer = [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
        return renderer;
    }
    return nil;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // This is boilerplate code to connect annotations with suitable views
    //
    
    if (annotation == mapView.userLocation) {
        return nil;
    }
    if ([annotation isKindOfClass:[MBXPointAnnotation class]]) {
        HomeAnnotationView * ann = [[HomeAnnotationView alloc]initWithAnnotation:(MBXPointAnnotation*)annotation];
        return ann;
    }
    
    /*if ([annotation isKindOfClass:[MBXPointAnnotation class]])
    {
        static NSString *MBXSimpleStyleReuseIdentifier = @"MBXSimpleStyleReuseIdentifier";
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:MBXSimpleStyleReuseIdentifier];
        if (!view)
        {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MBXSimpleStyleReuseIdentifier];
        }
        view.image = ((MBXPointAnnotation *)annotation).markerImage;
   //     view.canShowCallout = YES;
        return view;
    }*/
    return nil;
}


#pragma mark - MBXRasterTileOverlayDelegate implementation

- (void)tileOverlay:(MBXRasterTileOverlay *)overlay didLoadMetadata:(NSDictionary *)metadata withError:(NSError *)error
{
    // This delegate callback is for centering the map once the map metadata has been loaded
    //
    if (error)
    {
        NSLog(@"Failed to load metadata for map ID %@ - (%@)", overlay.mapID, error?error:@"");
    }
    else
    {
        [_mapView mbx_setCenterCoordinate:CLLocationCoordinate2DMake(40.3, 44.6) zoomLevel:7 animated:NO];
    }
}


- (void)tileOverlay:(MBXRasterTileOverlay *)overlay didLoadMarkers:(NSArray *)markers withError:(NSError *)error
{
    // This delegate callback is for adding map markers to an MKMapView once all the markers for the tile overlay have loaded
    //
    if (error)
    {
        NSLog(@"Failed to load markers for map ID %@ - (%@)", overlay.mapID, error?error:@"");
    }
    else
    {
        [_mapView addAnnotations:markers];
    }
}

- (void)tileOverlayDidFinishLoadingMetadataAndMarkers:(MBXRasterTileOverlay *)overlay
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
