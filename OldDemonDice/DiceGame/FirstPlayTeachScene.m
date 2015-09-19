//
//  FirstPlayTeachScene.m
//  DiceGame
//
//  Created by Coody0829 on 13/5/9.
//
//

#import "FirstPlayTeachScene.h"

@implementation FirstPlayTeachScene

-(id)init{
	self = [super init];
	if (self != nil) {
		firstPlayTeachLayer = [FirstPlayTeachLayer node];
		[self addChild:firstPlayTeachLayer z:5];
        
        singleGameBackgroundLayer = [[[SingleGameBackgroundLayer alloc] initWithDate:[GameManager sharedGameManager].today] autorelease];
        [self addChild:singleGameBackgroundLayer z:0];
	}
	return self;
}

@end
