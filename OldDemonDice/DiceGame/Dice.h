//
//  Dice.h
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface Dice : CCSprite {
	BOOL canMoveOrNot;
	BOOL useOrNot;
	int gameBoardPosition;
	CGPoint recentPosition ;
	EnumDiceNumberAndColor diceType;
	
//	CCLabelTTF *debugLabel;
}

@property (readwrite) CGPoint recentPosition;
@property (readwrite) EnumDiceNumberAndColor diceType;
@property (readwrite) int gameBoardPosition;

//@property (nonatomic , assign) CCLabelTTF *debugLabel;

-(id)initWithFile:(NSString *)filename withDiceType:(EnumDiceNumberAndColor)diceNumberAndColor withRecentPosition:(CGPoint)tempCGPoint;

-(void)setUseOrNot:(BOOL)tempUseOrNot;
-(BOOL)getUseOrNot;
-(void)setCanMoveOrNot:(BOOL)tempBool;
-(BOOL)getCanMoveOrNot;
-(void)moveDiceWithPosition:(CGPoint)movePosition withGameBoardPosition:(int)moveGameBoardPosition;
-(void)becomeBigAndSmall;
-(void)breakDice;

-(void)selectDiceAnim;
-(void)unselectDiceAnim;

@end


