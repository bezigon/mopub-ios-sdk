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
@property(nonatomic, strong) GADNativeContentAd *nativeContentAd;
@property(nonatomic, strong) NSDictionary *properties;
@property(nonatomic, strong) MPAdDestinationDisplayAgent *destinationDisplayAgent;
@end

@implementation MPGoogleAdMobNativeAdAdapter

- (instancetype)initWithGADNativeContentAd:(GADNativeContentAd *)nativeContentAd
{
    self = [super init];
    if (self) {
        self.nativeContentAd = nativeContentAd;
        self.nativeContentAd.delegate = self;
        self.properties = [self convertAssetsToProperties:nativeContentAd];
        self.destinationDisplayAgent = [MPAdDestinationDisplayAgent agentWithDelegate:self];
    }
    return self;
}

- (NSDictionary *)convertAssetsToProperties:(GADNativeContentAd *)nativeContentAd
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
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
    return [dictionary copy];
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
    return [NSURL URLWithString: [@"http://" stringByAppendingString:self.nativeContentAd.advertiser]];
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
    self.nativeContentAd.rootViewController = [self.delegate viewControllerForPresentingModalView];
    [self.delegate nativeAdWillLogImpression:self];
}

- (void)didAttachToView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        if([subview isKindOfClass:[GADNativeContentAdView class]]){
            ((GADNativeContentAdView *)subview).nativeContentAd = self.nativeContentAd;
            break;
        }
    }
}

- (void)didDetachFromView:(UIView *)view
{
    self.nativeContentAd.rootViewController = nil;
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
    return self.nativeContentAd.rootViewController;
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
