//
//  CRViewController.m
//  Crazy Run
//
//  Created by Vladimir Vinnik on 09.09.14.
//  Copyright (c) 2014 Vladimir Vinnik. All rights reserved.
//

#import "CRViewController.h"
#import "CRMenuScene.h"

@interface CRViewController ()
{
    IBOutlet SKView* _mySkView;
}
@end

@implementation CRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sizeRect = [UIScreen mainScreen].applicationFrame;
    float width = sizeRect.size.width;
    
//    //tạo PlacementID
//    FBAdView *adViewFB = [[FBAdView alloc] initWithPlacementID:@"335948646840271_335949130173556"
//                                                        adSize:kFBAdSizeHeight50Banner
//                                            rootViewController:self];
//
//    //vị trí của banner ở trên (TOP)
//    //adViewFB.frame = CGRectMake(0, 0, width, 50);
//
//    //vị trí banner ở dưới (BOTTOM)
//    adViewFB.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - adViewFB.frame.size.height, width, 50);
//
//    //Show banner
//    [adViewFB loadAd];
//    [self.view addSubview:adViewFB];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInterstital) name:@"showInter" object:nil];


    // Configure the view.
    SKView * skView = _mySkView;//(SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    SKScene * scene = [CRMenuScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    //Add view controller as observer
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showAd" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTwitter) name:@"sendTwitter" object:nil];
    
    //iAd View settings
//    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
//    adView.frame = CGRectOffset(adView.frame, 0, 0.0f);
//    adView.delegate=self;
//    [adView setAlpha:0];
//    [self.view addSubview:adView];
//    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark iAd banner methods

//Handle Notification
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"hideAd"]) {
        [self hidesBanner];
    }
    else if ([notification.name isEqualToString:@"showAd"]) {
        [self showBanner];
    }
}

//Hide iAd banner
-(void)hidesBanner {
    NSLog(@"Hide banner");
    [adView setAlpha:0];
}

//Show iAd banner
-(void)showBanner {
    NSLog(@"Show banner");
    [adView setAlpha:1];
}

#pragma mark Twitter

- (void)sendTwitter {
    //Initial object
    SLComposeViewController *tweetContent;
    tweetContent = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    //Set text of message
    [tweetContent setInitialText:[NSString stringWithFormat:@"See, I scored %ld points in Crazy Pixel!", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"score"]]];
    //See message to send
    [self presentViewController:tweetContent animated:YES completion:nil];
}

- (void) loadInterstital
{
    NSLog(@"LoadAD");
    interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:@"XXX"];
    interstitialAd.delegate = self;
    [interstitialAd loadAd];
}

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"Ad is loaded and ready to be displayed");
    
    // You can now display the full screen ad using this code:
    //[interstitialAd showAdFromRootViewController:self];
    [interstitialAd showAdFromRootViewController:self];
}


@end
