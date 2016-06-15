//
//  MPGoogleAdMobNativeAdAdapter.h
//  9GAG
//
//  Created by Jacky Wang on 6/5/2016.
//  Copyright © 2016 9GAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPNativeAdAdapter.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MPGoogleAdMobNativeAdAdapter : NSObject<MPNativeAdAdapter>

@property(nonatomic, weak) id<MPNativeAdAdapterDelegate> delegate;

- (instancetype)initWithGADNativeAd:(GADNativeAd *)nativeAd;

@end
