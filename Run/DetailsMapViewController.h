//
//  DetailsMapViewController.h
//  Run
//
//  Created by Al Pascual on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DetailsProtocol.h"
#import "MyAnnotation.h"
#import "GpsDatabaseManager.h"
#import "SessionRunWithPoints.h"

@interface DetailsMapViewController : UIViewController <MKMapViewDelegate, MKOverlay>

@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, strong) id <DetailsProtocol> delegate;
@property (nonatomic, strong) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) GpsDatabaseManager *database;

@property (nonatomic, strong) NSTimer *uiTimer;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) MKPolyline *line;
@property (nonatomic, strong) MKPolylineView *routeLineView;

@property (nonatomic, strong) IBOutlet UILabel *summary;
@property (nonatomic, strong) IBOutlet UISlider *timeSlider;

@end
