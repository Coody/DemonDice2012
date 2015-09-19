//
//  LogoLayer.m
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//


#import "LogoLayer.h"
#import "Constants.h"


@implementation LogoLayer

-(void)startGamePlay{
	[[GameManager sharedGameManager] runSceneWithID:enumMainMenuScene];
}

//-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	[self startGamePlay];
//}

-(id)init{
	self = [super init];
	if (self != nil) {self.isTouchEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCSprite *logoBackground;
		CCLOG(@"size = %f" , screenSize.height);
		if ( screenSize.height > 480) {
			logoBackground = [CCSprite spriteWithFile:@"logoBackground-568h.png"];
		}
		else{
			logoBackground = [CCSprite spriteWithFile:@"logoBackground-568h.png"];
		}
		[logoBackground setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
		CCSprite *logoSprite = [CCSprite spriteWithFile:@"logo-568h.png"];
		[logoSprite setPosition:ccp(screenSize.width*0.27f, screenSize.height*0.485f)];
		[self addChild:logoBackground];
		[self addChild:logoSprite];
		[logoSprite setOpacity:0 ];
		
		id delayAction = [CCDelayTime actionWithDuration:2];
		id addAction = [CCFadeIn actionWithDuration:0.15f];
        id callbackAction2 = [CCCallFunc actionWithTarget:self selector:@selector(loadAudio)];
		id totalAction = [CCSequence actions:delayAction,addAction,callbackAction2, nil];
		[logoSprite runAction:totalAction];
		
		id delay = [CCDelayTime actionWithDuration:5];
		id callbackAction = [CCCallFunc actionWithTarget: self selector: @selector(startGamePlay)];
		id sequence = [CCSequence actions: delay, callbackAction, nil];
		[self runAction: sequence];
	}
	return self;
}

#pragma mark -
#pragma mark Audio

-(void)loadAudio{
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_HIGH];
    [[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
    soundEngine = [SimpleAudioEngine sharedEngine];
    [soundEngine preloadEffect:@"logo.mp3"];
    [soundEngine playEffect:@"logo.mp3"];
}

@end