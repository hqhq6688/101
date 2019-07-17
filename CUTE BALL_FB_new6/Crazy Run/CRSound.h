//
//  CRSound.h
//  Crazy Run
//
//  Created by Vladimir Vinnik on 09.09.14.
//  Copyright (c) 2014 Vladimir Vinnik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface CRSound : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    SystemSoundID buttonClick;
    SystemSoundID endGame;
    SystemSoundID getOnePoint;
    
    AVAudioPlayer *audioPlayer;
}

-(void)initSound;

-(void)playSoundButtonClick;
-(void)playGetOnePoint;

@end
