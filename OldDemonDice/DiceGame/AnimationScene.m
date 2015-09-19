//
//  AnimationScene.m
//  DiceGame
//
//  Created by Coody0829 on 13/2/22.
//
//

#import "AnimationScene.h"

@implementation AnimationScene

-(id)init{
	self = [super init];
	if (self != nil) {
		animationLayer = [AnimationLayer node];
		[self addChild:animationLayer];
	}
	return self;
}

@end
