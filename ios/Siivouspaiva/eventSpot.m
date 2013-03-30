#import "eventSpot.h"

@implementation eventSpot
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize identi = _identifier;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate identifier:(NSNumber*)identifier {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        _identifier = [identifier copy];
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]]) 
        return @"Unknown title";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}


@end