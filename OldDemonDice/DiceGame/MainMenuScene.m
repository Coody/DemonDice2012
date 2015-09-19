//
//  MainMenuScene.m
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//

#import "MainMenuScene.h"


@implementation MainMenuScene

-(id)init{
	self = [super init];
	if (self != nil ) {
		mainMenuLayer = [MainMenuLayer node];
		[self addChild:mainMenuLayer];
	}
	return self;
}
@end
