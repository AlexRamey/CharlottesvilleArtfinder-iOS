#import "_ARTVenue.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ARTVenue : _ARTVenue <MKAnnotation>
// Custom logic goes here.

-(void)createThumbnailData;


-(NSData *)getThumbnailData;
-(NSString *)getPrimaryCategory;

//Required property from MKAnnotation
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

//Optional properties from MKAnnotation
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
