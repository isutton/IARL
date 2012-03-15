#import "NSString+IARL.h"

@implementation NSString (IARL)

- (CLLocationCoordinate2D)coordinateFromGridSquareLocator
{
    NSString *locator = [self uppercaseString];
    
    const char *cLocator = [locator cStringUsingEncoding:NSASCIIStringEncoding];
    
    float latitude = (cLocator[1] - 65) * 10.0 + (cLocator[3] - '0') * 1.0 + 0.5;
    float longitude = (cLocator[0] - 65) * 20.0 + (cLocator[2] - '0') * 2.0 + 1.0;
    
    if ([locator length] > 4) {
        latitude += -0.5 + (cLocator[5] - 65) / 24.0 + 1.24 / 60.0;
        longitude += -1.0 + (cLocator[4] - 65) / 12.0 + 2.5 / 60.0;
    }
    latitude = latitude - 90.0;
    longitude = longitude - 180.0;

    return CLLocationCoordinate2DMake(latitude, longitude);
}

@end