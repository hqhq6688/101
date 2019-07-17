//
//  CRSound.m
//  Crazy Run
//
//  Created by Vladimir Vinnik on 09.09.14.
//  Copyright (c) 2014 Vladimir Vinnik. All rights reserved.
//

#import "CRSound.h"

@implementation CRSound

-(void)initSound{
    //Init sounds
    NSURL *buttonClickURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"buttonClick" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)buttonClickURL, &buttonClick);
    NSURL *getOnePointURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"getPoint" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)getOnePointURL, &getOnePoint);
}

//Play sound methods

-(void)playSoundButtonClick {
    //If buttonClick initial play sound if not initial him and play.
    if (buttonClick) {
        AudioServicesPlaySystemSound(buttonClick);
    }
    else {
        [self initSound];
        [self playSoundButtonClick];
    }
}

-(void)playGetOnePoint {
    //If getOnePoint initial play sound if not initial him and play.
    if (getOnePoint) {
        AudioServicesPlaySystemSound(getOnePoint);
    }
    else {
        [self initSound];
        [self playGetOnePoint];
    }
}

@end
