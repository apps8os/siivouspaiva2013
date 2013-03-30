#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface eventSpot : NSObject <MKAnnotation> {
    NSString *_name;
    NSString *_address;
    NSNumber *_identifier;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (copy) NSNumber *identi;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate identifier:(NSNumber*)identi;

@end
