//
//  SuperDiceGameboard.m
//  DiceGame
//
//  Created by Coody0829 on 13/5/21.
//
//

#import "SuperDiceGameboard.h"
#import "cocos2d.h"
#import "Constants.h"

@implementation SuperDiceGameboard
@synthesize delegate;

-(id)init{
	self = [super init];
	if ( self != nil) {
		delegate = nil;
	}
	return self;
}

-(void)dealloc
{
    delegate = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Delegate

-(void)moveGameboard{
	[delegate moveGameboardDelegate];
}

-(void)showGameboard{
	[delegate showGameboardDelegate];
}

@end
