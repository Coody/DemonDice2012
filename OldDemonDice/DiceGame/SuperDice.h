//
//  SuperDice.h
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//

#import "Dice.h"

@interface SuperDice : Dice{
	BOOL rollDiceOrNot;
}

-(BOOL)getRollDiceOrNot;
-(void)setRollDiceOrNot:(BOOL)_rollDiceOrNot;

@end
