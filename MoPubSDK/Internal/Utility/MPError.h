//
//  MPAdRequestError.h
//  MoPub
//
//  Copyright (c) 2012 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kMPErrorDomain;

typedef enum {
    MPMPErrorUnknown = -1,
    MPMPErrorNoInventory = 0,
    MPMPErrorAdUnitWarmingUp = 1,
    MPMPErrorNetworkTimedOut = 4,
    MPMPErrorServerError = 8,
    MPMPErrorAdapterNotFound = 16,
    MPMPErrorAdapterInvalid = 17,
    MPMPErrorAdapterHasNoInventory = 18
} MPMPErrorCode;

@interface MPError : NSError

+ (MPError *)errorWithCode:(MPMPErrorCode)code;

@end
