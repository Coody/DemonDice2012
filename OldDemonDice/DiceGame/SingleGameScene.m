//
//  SingleGameScene.m
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//


#import "SingleGameScene.h"

@implementation SingleGameScene

-(id)init{
	self = [super init];
	if (self != nil ) {
		singleGameLayer = [SingleGameLayer node];
		[self addChild:singleGameLayer z:5];
        
        singleGameBackgroundLayer = [[[SingleGameBackgroundLayer alloc]initWithDate:[GameManager sharedGameManager].today] autorelease];
        [self addChild:singleGameBackgroundLayer z:0];
	}
	return self;
}

@end