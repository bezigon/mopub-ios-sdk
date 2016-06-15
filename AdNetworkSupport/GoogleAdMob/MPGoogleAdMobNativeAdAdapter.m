//
//  MPGoogleAdMobNativeAdAdapter.m
//  9GAG
//
//  Created by Jacky Wang on 6/5/2016.
//  Copyright © 2016 9GAG. All rights reserved.
//

#import "MPGoogleAdMobNativeAdAdapter.h"
#import "MoPub.h"
#import "MPAdDestinationDisplayAgent.h"

@interface MPGoogleAdMobNativeAdAdapter() <GADNativeAdDelegate, MPAdDestinationDisplayAgentDelegate>
@property(nonatomic, strong) GADNativeAd *nativeAd;
@property(nonatomic, strong) NSDictionary *properties;
@property(nonatomic, strong) MPAdDestinationDisplayAgent *destinationDisplayAgent;
@end

@implementation MPGoogleAdMobNativeAdAdapter

- (instancetype)initWithGADNativeAd:(GADNativeAd *)nativeAd;
{
    self = [super init];
    if (self) {
        self.nativeAd = nativeAd;
        self.nativeAd.delegate = self;
        self.properties = [self convertAssetsToProperties:nativeAd];
        self.destinationDisplayAgent = [MPAdDestinationDisplayAgent agentWithDelegate:self];
    }
    return self;
}

- (NSDictionary *)convertAssetsToProperties:(GADNativeAd *)nativeAd
{
    if([nativeAd isKindOfClass:[GADNativeContentAd class]]){
        GADNativeContentAd *nativeContentAd = (GADNativeContentAd *)nativeAd;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        if (nativeContentAd.headline) {
            dictionary[kAdTitleKey] = nativeContentAd.headline;
        }
        if (nativeContentAd.body) {
            dictionary[kAdTextKey] = nativeContentAd.body;
        }
        if ([nativeContentAd.images count] > 0){
            if(nativeContentAd.images[0]) {
                dictionary[kAdMainImageKey] = ((GADNativeAdImage *)nativeContentAd.images[0]).imageURL.absoluteString;
            }
        }
        if (nativeContentAd.callToAction) {
            dictionary[kAdCTATextKey] = nativeContentAd.callToAction;
        }
        if(nativeAd){
            dictionary[@"nativeAd"] = nativeAd;
        }
        return dictionary;
    } else if([nativeAd isKindOfClass:[GADNativeAppInstallAd class]]){
        GADNativeAppInstallAd *nativeAppInstallAd = (GADNativeAppInstallAd *)nativeAd;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        if (nativeAppInstallAd.headline) {
            dictionary[kAdTitleKey] = nativeAppInstallAd.headline;
        }
        if (nativeAppInstallAd.body) {
            dictionary[kAdTextKey] = nativeAppInstallAd.body;
        }
        if ([nativeAppInstallAd.images count] > 0){
            if(nativeAppInstallAd.images[0]) {
                dictionary[kAdMainImageKey] = ((GADNativeAdImage *)nativeAppInstallAd.images[0]).imageURL.absoluteString;
            }
        }
        if (nativeAppInstallAd.callToAction) {
            dictionary[kAdCTATextKey] = nativeAppInstallAd.callToAction;
        }
        if (nativeAppInstallAd.starRating) {
            dictionary[kAdStarRatingKey] = nativeAppInstallAd.starRating;
        }
        if(nativeAd){
            dictionary[@"nativeAd"] = nativeAd;
        }
        return dictionary;
    }
    return nil;
}

#pragma mark - MPNativeAdAdapter

- (NSTimeInterval)requiredSecondsForImpression
{
    return 0.0;
}

- (BOOL)enableThirdPartyClickTracking
{
    return YES;
}

- (NSURL *)defaultActionURL
{
    if([self.nativeAd isKindOfClass:[GADNativeContentAd class]]){
        return [NSURL URLWithString: [@"http://" stringByAppendingString:((GADNativeContentAd *)self.nativeAd).advertiser]];
    }
    return nil;
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

- (void)willAttachToView:(UIView *)view
{
    self.nativeAd.rootViewController = [self.delegate viewControllerForPresentingModalView];
    [self.delegate nativeAdWillLogImpression:self];
}

- (void)didDetachFromView:(UIView *)view
{
    self.nativeAd.rootViewController = nil;
}

#pragma mark GADNativeAdDelegate

- (void)nativeAdWillPresentScreen:(GADNativeAd *)nativeAd
{
    if ([self.delegate respondsToSelector:@selector(nativeAdWillPresentModalForAdapter:)]) {
        [self.delegate nativeAdWillPresentModalForAdapter:self];
    }
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
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
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    }
}

#pragma mark - MPAdDestinationDisplayAgentDelegate

- (UIViewController *)viewControllerForPresentingModalView
{
    return self.nativeAd.rootViewController;
}

- (void)displayAgentWillPresentModal
{
    if ([self.delegate respondsToSelector:@selector(nativeAdWillPresentModalForAdapter:)]) {
        [self.delegate nativeAdWillPresentModalForAdapter:self];
    }
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    }
}

- (void)displayAgentWillLeaveApplication
{
    if ([self.delegate respondsToSelector:@selector(nativeAdWillLeaveApplicationFromAdapter:)]) {
        [self.delegate nativeAdWillLeaveApplicationFromAdapter:self];
    }
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    }
}

- (void)displayAgentDidDismissModal
{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidDismissModalForAdapter:)]) {
        [self.delegate nativeAdDidDismissModalForAdapter:self];
    }
}

@end
