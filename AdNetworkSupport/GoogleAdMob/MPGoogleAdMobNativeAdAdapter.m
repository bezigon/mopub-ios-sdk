//
//  MPGoogleAdMobNativeAdAdapter.m
//  9GAG
//
//  Created by Jacky Wang on 6/5/2016.
//  Copyright © 2016 9GAG. All rights reserved.
//

#import "MPGoogleAdMobNativeAdAdapter.h"
#import "MoPub.h"

@interface MPGoogleAdMobNativeAdAdapter()<GADNativeAdDelegate>
@property(nonatomic, strong)NSDictionary *properties;
@end

@implementation MPGoogleAdMobNativeAdAdapter

- (instancetype)initWithGADNativeContentAd:(GADNativeContentAd *)contentAD
{
    self = [super init];
    if (self) {
        self.contentAd = contentAD;
        self.contentAd.delegate = self;
        self.properties = [self convertAssetsToProperties:contentAD];
    }
    return self;
}

- (NSDictionary *)convertAssetsToProperties:(GADNativeContentAd *)adNative
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if (adNative.headline) {
        dictionary[kAdTitleKey] = adNative.headline;
    }
    if (adNative.body) {
        dictionary[kAdTextKey] = adNative.body;
    }
    if (adNative.images[0]) {
        dictionary[kAdMainImageKey] = ((GADNativeAdImage *)adNative.images[0]).imageURL.absoluteString;
    }
    if (adNative.callToAction) {
        dictionary[kAdCTATextKey] = adNative.callToAction;
    }
    return [dictionary copy];
}

#pragma mark MPNativeAdAdapter

- (void)trackClick {
    
    [self.delegate nativeAdDidClick:self];
}

- (void)trackImpression
{
    [self.delegate nativeAdWillLogImpression:self];
}

- (void)displayContentForURL:(NSURL *)URL rootViewController:(UIViewController *)controller
{
    if (!controller) {
        return;
    }
    
    if (!URL || ![URL isKindOfClass:[NSURL class]] || ![URL.absoluteString length]) {
        return;
    }
    
    [self.destinationDisplayAgent displayDestinationForURL:URL];
}


- (NSURL *)defaultActionURL
{
    return nil;
}

#pragma mark GADNativeAdDelegate

- (void)nativeAdWillPresentScreen:(GADNativeAd *)nativeAd
{
    if ([self.delegate respondsToSelector:@selector(nativeAdWillPresentModalForAdapter:)]) {
        [self.delegate nativeAdWillPresentModalForAdapter:self];
    }
}

- (void)nativeAdDidDismissScreen:(GADNativeAd *)nativeAd
{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidDismissModalForAdapter:)]) {
        [self.delegate nativeAdDidDismissModalForAdapter:self];
    }
}

- (void)nativeAdWillLeaveApplication:(GADNativeAd *)nativeAd
{
    if ([self.delegate respondsToSelector:@selector(nativeAdWillLeaveApplicationFromAdapter:)]) {
        [self.delegate nativeAdWillLeaveApplicationFromAdapter:self];
    }
}
@end
