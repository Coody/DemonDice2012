//
//  LogoScene.m
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//

#import "LogoScene.h"


@implementation LogoScene

-(id)init{
	self = [super init];
	if ( self != nil) {
		logoLayer = [LogoLayer node];
		[self addChild:logoLayer];
	}
	return self;
}

@end
