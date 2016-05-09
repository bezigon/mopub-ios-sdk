//
//  MPGoogleAdMobCustomEvent.m
//  9GAG
//
//  Created by Jacky Wang on 6/5/2016.
//  Copyright © 2016 9GAG. All rights reserved.
//

#import "MPGoogleAdMobCustomEvent.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MPLogging.h"
#import "MoPub.h"
#import "MPNativeAd.h"
#import "MPGoogleAdMobNativeAdAdapter.h"

@interface MPGoogleAdMobCustomEvent()
@property(nonatomic, strong)GADAdLoader *loader;
@property(nonatomic, strong)NSString *url;
@end

@implementation MPGoogleAdMobCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    MPLogInfo(@"MOPUB: requesting AdMob Native Ad");
    
    NSString *adUnitID = [info objectForKey:@"adUnitID"];
    
//    if (!adUnitID) {
//        adUnitID = @"ca-app-pub-0268871989845966/1853944109";
//    }
//    
//#ifdef DEBUG
    adUnitID = @"ca-app-pub-3940256099942544/3986624511";
//#endif
    
    self.loader = [[GADAdLoader alloc] initWithAdUnitID:adUnitID rootViewController:nil  adTypes:@[kGADAdLoaderAdTypeNativeContent] options:nil];
    self.loader.delegate = self;
    GADRequest *request = [GADRequest request];
//    request.testDevices = @[ kGADSimulatorID ];
    CLLocation *location = [[CLLocationManager alloc] init].location;
    if (location) {
        [request setLocationWithLatitude:location.coordinate.latitude
                               longitude:location.coordinate.longitude
                                accuracy:location.horizontalAccuracy];
    }
    
    NSString *clickURL = info[@"clk"];
    self.url = clickURL;

    request.requestAgent = @"MoPub";
    [self.loader loadRequest:request];
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd
{
    MPLogDebug(@"MOPUB: Did receive nativeAd");

    MPGoogleAdMobNativeAdAdapter *adapter = [[MPGoogleAdMobNativeAdAdapter alloc] initWithGADNativeContentAd:nativeContentAd];
    adapter.url = self.url;
    MPNativeAd *interfaceAd = [[MPNativeAd alloc] initWithAdAdapter:adapter];
    [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
    
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error
{
    MPLogDebug(@"MOPUB: AdMob ad failed to load with error (customEvent): %@", error.description);
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
}

@end
