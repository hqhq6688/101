//
//  CRViewController.h
//  Crazy Run
//

//  Copyright (c) 2014 Vladimir Vinnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAD.h>
#import <Twitter/Twitter.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>

@interface CRViewController : UIViewController <FBInterstitialAdDelegate,ADBannerViewDelegate> {
    ADBannerView *adView;
    FBInterstitialAd *interstitialAd;
}

-(void)showBanner;
-(void)hidesBanner;

@end
