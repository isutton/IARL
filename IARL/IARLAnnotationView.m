//
//  IARLAnnotationView.m
//  IARL
//
//  Created by Igor Sutton on 3/26/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLAnnotationView.h"
#import "IARLDataController.h"
#import "IARLRadio.h"
#import "NSNumber+IARL.h"

@implementation IARLAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]))
        return nil;
    
    if ([annotation isKindOfClass:[IARLRadio class]]) {
        NSString *band = [((IARLRadio *)annotation).tx bandFromFrequency];
        
        if ([band isEqualToString:IARLHFBandKey])
            self.image = [UIImage imageNamed:IARLHFAnnotationImageName];
        else if ([band isEqualToString:IARLVHFBandKey])
            self.image = [UIImage imageNamed:IARLVHFAnnotationImageName];
        else if ([band isEqualToString:IARLUHFBandKey])
            self.image = [UIImage imageNamed:IARLUHFAnnotationImageName];

        
        
    }
    
    return self;
}

- (void)prepareForReuse
{
    self.image = nil;
    self.annotation = nil;
}

@end
