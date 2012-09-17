//
//  MapViewController.h
//  Run
//
//  Created by Albert Pascual on 9/14/12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <UIAlertViewDelegate,MKMapViewDelegate,MKOverlay>

@property (nonatomic, strong) IBOutlet MKMapView* mapView;

@end
