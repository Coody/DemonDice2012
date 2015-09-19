//
//  SuperDiceGameboard.h
//  DiceGame
//
//  Created by Coody0829 on 13/5/21.
//
//

#import "CCSprite.h"
#import "SuperDiceGameboardDelegate.h"

@interface SuperDiceGameboard : CCSprite{
	id <SuperDiceGameboardDelegate> delegate;
}

@property (nonatomic, retain) id <SuperDiceGameboardDelegate> delegate;

#pragma mark -
#pragma mark Delegate

-(void)moveGameboard;
-(void)showGameboard;

@end
