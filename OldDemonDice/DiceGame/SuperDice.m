//
//  SuperDice.m
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//

#import "SuperDice.h"

@implementation SuperDice

-(id)initWithFile:(NSString *)filename withDiceType:(EnumDiceNumberAndColor)diceNumberAndColor withRecentPosition:(CGPoint)tempCGPoint{
	self = [super initWithFile:filename withDiceType:diceNumberAndColor withRecentPosition:tempCGPoint];
	if (self != nil ) {
		rollDiceOrNot = NO;
	}
	return self;
}

-(BOOL)getRollDiceOrNot{
	return rollDiceOrNot;
}

-(void)setRollDiceOrNot:(BOOL)_rollDiceOrNot{
	[super setUseOrNot:_rollDiceOrNot];
	rollDiceOrNot = _rollDiceOrNot;
}

-(void)breakDice{
	/* super dice must break with different way */
	[super breakDice];
}

@end
