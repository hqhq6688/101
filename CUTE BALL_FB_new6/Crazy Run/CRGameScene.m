//
//  CRGameScene.m
//  Crazy Run
//
//  Created by Vladimir Vinnik on 09.09.14.
//  Copyright (c) 2014 Vladimir Vinnik. All rights reserved.
//

#import "CRGameScene.h"

//For change setting see Classes -> CRSettingGame.h

//Physic contact category
static const uint32_t playerCategory = 0x1 << 0;
static const uint32_t checkerCategory = 0x1 << 1;
static const uint32_t targetCategory = 0x1 << 2;
static const uint32_t blockCategory = 0x1 << 3;

@implementation CRGameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //Send message to RPViewController to hide iAd.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
        
        //Initial sound
        sound = [[CRSound alloc] init];
        [sound initSound];
        
        //Set color background
        //self.backgroundColor = COLOR_FOR_BACKGROUND;
        
         //Set image background
         _bground = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        _bground.size = size;// 全屏
        _bground.position = CGPointMake(size.width/2, size.height/2);
        
        //Set gravity
        self.physicsWorld.gravity = CGVectorMake(0, 0.0);
        self.physicsWorld.contactDelegate = self;
        
        //Set interface objects
        [self setLabelScore];
        
        //Start game
        [self startGame];
        [self addChild:_bground];
    }
    return self;
}

#pragma mark Nodes

- (void)setPlayer {
    //If your need change color to image
    _player = [SKSpriteNode spriteNodeWithImageNamed:@"cute.png" ];
    //_player = [SKSpriteNode spriteNodeWithColor:COLOR_FOR_PLAYER size:CGSizeMake(SIZE_OF_PLAYER, SIZE_OF_PLAYER)];
    _player.position = CGPointMake(self.frame.size.width / 2, POSITION_OF_PLAYER_Y);
    _player.zPosition = 20;
    
    //Setting physicsBody stats
    //Initial physicsBody
    _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.size];
    
    //Setting bitMask
    _player.physicsBody.categoryBitMask = playerCategory;
    _player.physicsBody.collisionBitMask = targetCategory | blockCategory;
    _player.physicsBody.contactTestBitMask = targetCategory | blockCategory;
    
    //Set gravity stats
    _player.physicsBody.affectedByGravity = NO;
    _player.physicsBody.mass = 100000;
    
    //Add node to scene
    [self addChild:_player];
}

- (void)setBlockToPosition:(CGPoint)position {
    //If your need change color to image
    _block = [SKSpriteNode spriteNodeWithImageNamed:@"blue-ball.png"];
    //_block = [SKSpriteNode spriteNodeWithColor:COLOR_FOR_BLOCK size:CGSizeMake(SIZE_OF_BLOCK, SIZE_OF_BLOCK)];
    _block.position = CGPointMake(position.x, POSITION_OF_BLOCK_AND_TARGET_Y);
    _block.zPosition = 20;
    _block.name = @"block";
    
    //Setting physicsBody stats
    //Initial physicsBody
    _block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_block.size];
    
    //Setting bitMask
    _block.physicsBody.categoryBitMask = blockCategory;
    _block.physicsBody.collisionBitMask = playerCategory;
    _block.physicsBody.contactTestBitMask = playerCategory;
    
    //Set gravity stats
    _block.physicsBody.affectedByGravity = NO;
    _block.physicsBody.mass = 10;
    
    //Add node to scene
    [self addChild:_block];
    
    //Actions to drop blocks
    //Create position to move
    CGPoint positionToMove = CGPointMake(_block.position.x, -40);
    //Create action moved to position
    SKAction *actionMove = [SKAction moveTo:positionToMove duration:objectSpeed];
    //Create action removing after cancel action move
    SKAction *actionMoveDone = [SKAction removeFromParent];
    //Add and run action for _leftBlock object
    [_block runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}

- (void)setTargetToPosition:(CGPoint)position {
    //If your need change color to image
    _target = [SKSpriteNode spriteNodeWithImageNamed:@"cute.png"];
    //_target = [SKSpriteNode spriteNodeWithColor:COLOR_FOR_TARGET size:CGSizeMake(SIZE_OF_TARGET, SIZE_OF_TARGET)];
    _target.position = CGPointMake(position.x, POSITION_OF_BLOCK_AND_TARGET_Y);
    _target.zPosition = 20;
    _target.name = @"target";
    
    //Setting physicsBody stats
    //Initial physicsBody
    _target.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_target.size];
    
    //Setting bitMask
    _target.physicsBody.categoryBitMask = targetCategory;
    _target.physicsBody.collisionBitMask = checkerCategory | playerCategory;
    _target.physicsBody.contactTestBitMask = checkerCategory | playerCategory;
    
    //Set gravity stats
    _target.physicsBody.affectedByGravity = NO;
    _target.physicsBody.mass = 10;
    
    //Add node to scene
    [self addChild:_target];
    
    //Actions to drop blocks
    //Create position to move
    CGPoint positionToMove = CGPointMake(_target.position.x, -40);
    //Create action moved to position
    SKAction *actionMove = [SKAction moveTo:positionToMove duration:objectSpeed];
    //Create action removing after cancel action move
    SKAction *actionMoveDone = [SKAction removeFromParent];
    //Add and run action for _leftBlock object
    [_target runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
}

- (void)setChecker {
    //Add checker to scene
    _checker = [SKSpriteNode spriteNodeWithColor:COLOR_FOR_BACKGROUND size:CGSizeMake(self.frame.size.width, self.frame.size.height / 100 * 5)];
    _checker.position = CGPointMake(self.frame.size.width / 2, _player.position.y - _player.size.height);
    _checker.zPosition = 25;
    _checker.alpha = 0;
    
    //Setting physicsBody stats
    //Initial physicsBody
    _checker.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_checker.size];
    
    //Setting bitMask
    _checker.physicsBody.categoryBitMask = checkerCategory;
    _checker.physicsBody.collisionBitMask = targetCategory;
    _checker.physicsBody.contactTestBitMask = targetCategory;
    
    //Set gravity stats
    _checker.physicsBody.affectedByGravity = NO;
    _checker.physicsBody.mass = 100000;
    
    //Add node to scene
    [self addChild:_checker];
}

- (void)setLabelScore {
    //Set label font and other
    _labelScore = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    _labelScore.fontColor = FONT_COLOR_DARK;
    //Set diffirent font size if app run on iPad or iPhone
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        _labelScore.fontSize = FONT_SIZE_3 * 2;
    }
    else {
        _labelScore.fontSize = FONT_SIZE_3;
    }
    _labelScore.position = CGPointMake(self.frame.size.width / 2, POSITION_OF_LABEL_Y);
    _labelScore.zPosition = 30;
    _labelScore.text = @"0";
    //Add node to scene
    [self addChild:_labelScore];
}

- (void)setLabelGameOver {
    //Set label font and other
    _labelGameOver = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    _labelGameOver.fontColor = FONT_COLOR_WHITE;
    //Set diffirent font size if app run on iPad or iPhone
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        _labelGameOver.fontSize = FONT_SIZE_4 * 2;
    }
    else {
        _labelGameOver.fontSize = FONT_SIZE_4;
    }
    _labelGameOver.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    _labelGameOver.zPosition = 300;
    _labelGameOver.text = @"Game Over";
    //Add node to scene
    [self addChild:_labelGameOver];
    
    //Actions to view label
    //Create action moved to position
    SKAction *fadeIn = [SKAction fadeInWithDuration:TIME_TO_REMOVE_BLOCK / 100 * 140];
    //Add and run action for _leftBlock object
    [_labelGameOver runAction:[SKAction sequence:@[fadeIn]]];
}

#pragma mark Programm

- (void)startGame {
    //Set start game settings
    score = 0;
    spawnSpeed = SPAWN_SPEED;
    objectSpeed = SPEED_OF_OBJECT;
    nowPlay = YES;
    
    //Set game objects
    [self setPlayer];
    [self setChecker];
}

- (void)endGame {
    //Save results and change view
    nowPlay = NO;
    [self setLabelGameOver];
    
    //Save result
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"score"];
    
    changeSceneTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_TO_REMOVE_BLOCK * 2 target:self selector:@selector(changeSceneToEnd) userInfo:nil repeats:NO];
    
    [_player removeFromParent];
    
    _player= nil;
}

- (void)changeScore {
    _labelScore.text = [NSString stringWithFormat:@"%d", score];
}

- (void)changeSpeedToUpdate {
    //Change speed on speed change value
    objectSpeed -= SPEED_OF_OBJECT_CHANGE;
    //If objectSpeed had the limit, set limir value to objectSpeedLimit
    if (objectSpeed <= SPEED_OF_OBJECT_LIMIT) { objectSpeed = SPEED_OF_OBJECT_LIMIT;}
    
    //Change spawn speed on speed change value
    spawnSpeed -= SPAWN_SPEED_CHANGE;
    //If spawnSpeed had the limit, set limir value to spawnSpeedLimit
    if (spawnSpeed <= SPAWN_SPEED_LIMIT) { spawnSpeed = SPAWN_SPEED_LIMIT;}
}

- (void)removeFromParentTarget:(SKSpriteNode *)sprite {
    //Remove all actions from target
    [sprite removeAllActions];
    //Actions to change size and remove node
    //Create action resize
    SKAction *actionScale = [SKAction scaleXBy:0 y:0 duration:TIME_TO_REMOVE_TARGET];
    //Create move action
    SKAction *moveToTop = [SKAction moveTo:CGPointMake(sprite.position.x, self.frame.size.height * 2) duration:TIME_TO_REMOVE_TARGET];
    //Create action removing after cancel action
    SKAction *actionMoveDone = [SKAction removeFromParent];
    //Add and run action for _leftBlock object
    [sprite runAction:[SKAction sequence:@[actionScale, actionMoveDone]]];
    [sprite runAction:[SKAction sequence:@[moveToTop]]];
    
}

- (void)removeFromParentBlock:(SKSpriteNode *)sprite {
    //Remove all actions from target
    [sprite removeAllActions];
    //Actions to change size and remove node
    //Create action resize
    SKAction *actionScale = [SKAction scaleXBy:self.frame.size.width y:self.frame.size.height duration:TIME_TO_REMOVE_BLOCK];
    //Create move action
    SKAction *moveToCenter = [SKAction moveTo:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) duration:TIME_TO_REMOVE_BLOCK];
    //Add and run action for _leftBlock object
    [sprite runAction:[SKAction sequence:@[actionScale]]];
    [sprite runAction:[SKAction sequence:@[moveToCenter]]];
    sprite.zPosition = 200;
}

- (void)rotarePlayer {
    //Create action rotate
    SKAction *actionRotate = [SKAction rotateByAngle:360 duration:TIME_TO_ROTATE];
    //Add action to node
    [_player runAction:[SKAction sequence:@[actionRotate]]];
}

#pragma mark Update

- (void)update:(CFTimeInterval)currentTime {
    if (nowPlay) {
        //Update time interval for spawn
        CFTimeInterval timeSinceLast = currentTime - _lastSpawnTimeInterval;
        _lastUpdateTimeInterval = currentTime;
        if (timeSinceLast > 1) {
            timeSinceLast = 1.0 / spawnSpeed;
            _lastUpdateTimeInterval = currentTime;
        }
        [self updateWithTimeSinceLastUpdate:timeSinceLast];
    }
}

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval) timeSinceLast{
    if (nowPlay) {
        //Spawn blocks
        _lastSpawnTimeInterval += timeSinceLast;
        if (_lastSpawnTimeInterval > 1) {
            _lastSpawnTimeInterval = 0;
            
            //Spawn blocks or target
            if ((arc4random() % 2) == 1) {
                [self setTargetToPosition:CGPointMake(arc4random() % (int)self.frame.size.width, 0)];
            }
            else {
                [self setBlockToPosition:CGPointMake(arc4random() % (int)self.frame.size.width, 0)];
            }
            
            //Set zRotation if nodes accidentally rotate
            _player.zRotation = 0;
        }
    }
}

#pragma mark Contact

//If node contact
- (void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else{
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    //If checker contact to objects
    if ((firstBody.categoryBitMask & checkerCategory) != 0){
        [self checkerContact:(SKSpriteNode *)firstBody.node didCollideWithTarget:(SKSpriteNode *)secondBody.node];
    }
    //If player
    if ((firstBody.categoryBitMask & playerCategory) != 0){
        [self playerContact:(SKSpriteNode *)firstBody.node didCollideWithTarget:(SKSpriteNode *)secondBody.node];
    }
}

//If player contact to target
- (void)checkerContact:(SKSpriteNode *)checker didCollideWithTarget:(SKSpriteNode *)target {
    if (nowPlay) {
        if ([target.name isEqual:@"target"]) {
            [self endGame];
            [self removeFromParentBlock:target];
        }
    }
}

//If player contact to target
- (void)playerContact:(SKSpriteNode *)checker didCollideWithTarget:(SKSpriteNode *)target {
    if (nowPlay) {
        if ([target.name isEqual:@"target"]) {
            score++;
            [self changeScore];
            [self changeSpeedToUpdate];
            [self removeFromParentTarget:target];
            [self rotarePlayer];
            //play sound
            [sound playGetOnePoint];
        }
        if ([target.name isEqualToString:@"block"]) {
            [self endGame];
            [self removeFromParentBlock:target];
        }
    }
}

#pragma mark Action touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        _player.position = CGPointMake(location.x, _player.position.y);
        
        //play sound
        [sound playSoundButtonClick];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if(nowPlay){
            _player.position = CGPointMake(location.x, _player.position.y);
        }
    }
}

#pragma mark Change scene

- (void)changeSceneToEnd {
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    SKTransition *reveal = [SKTransition fadeWithColor:COLOR_FOR_BACKGROUND duration:1];
    SKScene *level = [[CREndGameScene alloc] initWithSize:skView.bounds.size];
    
    [self.view presentScene:level transition:reveal];
}

@end
