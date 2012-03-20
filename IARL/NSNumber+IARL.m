//
//  NSNumber+IARL.m
//  IARL
//
//  Created by Igor Sutton on 3/20/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "NSNumber+IARL.h"

NSUInteger Hz(NSUInteger freq) {
    return freq;
}

NSUInteger kHz(NSUInteger freq) {
    return freq / 1000l;
}

NSUInteger MHz(NSUInteger freq) {
    return freq / 1000000l;
}

NSUInteger GHz(NSUInteger freq) {
    return freq / 1000000000l;
}

@implementation NSNumber (IARL)

- (NSString *)bandFromFrequency
{
    NSUInteger tx = [self unsignedIntValue];
    
    if (Hz(tx) >= 3 && Hz(tx) < 30) {
        return @"ELF";
    } else if (Hz(tx) >= 30 && Hz(tx) < 300) {
        return @"SLF";
    } else if (Hz(tx) >= 300 && kHz(tx) < 3) {
        return @"ULF";
    } else if (kHz(tx) >= 3 && kHz(tx) < 30) {
        return @"VLF";
    } else if (kHz(tx) >= 30 && kHz(tx) < 300) {
        return @"LF";
    } else if (kHz(tx) >= 300 && MHz(tx) < 3) {
        return @"MF";
    } else if (MHz(tx) >= 3 && MHz(tx) < 30) {
        return @"HF";
    } else if (MHz(tx) >= 30 && MHz(tx) < 300) {
        return @"VHF";
    } else if (MHz(tx) >= 300 && GHz(tx) < 3) {
        return @"UHF";
    } else if (GHz(tx) >= 3 && GHz(tx) < 30) {
        return @"SHF";
    } else if (GHz(tx) >= 30 && GHz(tx) < 300) {
        return @"EHF";
    } else {
        return @"unknown";
    }
}

@end
