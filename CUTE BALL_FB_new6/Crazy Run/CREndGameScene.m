//
//  CREndGameScene.m
//  Crazy Run
//
//  Created by Vladimir Vinnik on 09.09.14.
//  Copyright (c) 2014 Vladimir Vinnik. All rights reserved.
//

#import "CREndGameScene.h"

@implementation CREndGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //Set background color
        self.backgroundColor = COLOR_FOR_BACKGROUND;
        
        //Initial sound
        sound = [[CRSound alloc] init];
        [sound initSound];
        
        //Send message to RPViewController to show iAd.
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showInter" object:nil];
        
        //Set best score
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"score"] > [[NSUserDefaults standardUserDefaults] integerForKey:@"bestScore"]) {
            [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"score"] forKey:@"bestScore"];
        }
        
        //Set objects
        [self setButtonRestart];
        [self setButtonShare];
        [self setLabels];
    }
    return self;
}

#pragma mark Interface

- (void)setButtonRestart {
    //Set object image size and position.
    _buttonRestart = [SKSpriteNode spriteNodeWithImageNamed:@"buttonRestart"];
    _buttonRestart.size = CGSizeMake(SIZE_OF_BUTTON_RESTART, SIZE_OF_BUTTON_RESTART);
    _buttonRestart.position = CGPointMake(self.size.width / 2, self.size.height / 100 * 35);
    //Add object to scene
    [self addChild:_buttonRestart];
}

- (void)setButtonShare {
    //Set object image size and position.
    _buttonShare = [SKSpriteNode spriteNodeWithImageNamed:@"buttonTwitter"];
    _buttonShare.size = CGSizeMake(SIZE_OF_BUTTON_TWITTER, SIZE_OF_BUTTON_TWITTER);
    _buttonShare.hidden = YES;
    _buttonShare.position = CGPointMake(self.size.width / 2, self.size.height / 100 * 15);
    //Add object to scene
    [self addChild:_buttonShare];
}

- (void)setLabels {
    //Set font style
    _labelScore = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    //Set different font size to any device
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        _labelScore.fontSize = FONT_SIZE_4 * 2;
    }
    else {
        _labelScore.fontSize = FONT_SIZE_4;
    }
    //Set font color
    _labelScore.fontColor = FONT_COLOR_DARK;
    //Set positions of object
    _labelScore.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 100 * 65);
    _labelScore.zPosition = 40;
    //Set text to label
    _labelScore.text = [NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"score"]];
    //Add object to scene
    [self addChild:_labelScore];
    
    //Set font style
    _labelScoreText = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    //Set different font size to any device
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        _labelScoreText.fontSize = FONT_SIZE_2 * 2;
    }
    else {
        _labelScoreText.fontSize = FONT_SIZE_2;
    }
    //Set font color
    _labelScoreText.fontColor = FONT_COLOR_DARK;
    //Set positions of object
    _labelScoreText.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 100 * 75);
    _labelScoreText.zPosition = 40;
    //Set text to label
    _labelScoreText.text = @"You score";
    //Add object to scene
    [self addChild:_labelScoreText];
}

#pragma mark Programm

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //Get location
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        //If touch restart button
        if ([_buttonRestart containsPoint:location]) {
            //Change scene
            [self changeSceneToGame];
            //Play sound
            [sound playSoundButtonClick];
        }
        //If touch twitter button
        if ([_buttonShare containsPoint:location]) {
            //Call method from RPViewController.m for get twitter message
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendTwitter" object:nil];
            //Play sound
            [sound playSoundButtonClick];
        }
    }
}

#pragma mark Change Scene

- (void)changeSceneToGame {
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    // Create and configure the scene.
    SKTransition *reveal = [SKTransition pushWithDirection:SKTransitionDirectionDown duration:1];
    SKScene *level = [[CRGameScene alloc] initWithSize:skView.bounds.size];
    
    [self.view presentScene:level transition:reveal];
}

@end
