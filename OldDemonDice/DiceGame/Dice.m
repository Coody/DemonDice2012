//
//  Dice.m
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//

#import "Dice.h"
#import "GameManager.h"

@interface Dice()
-(void)hideDice;
@end

@implementation Dice

@synthesize recentPosition;
@synthesize diceType ;
@synthesize gameBoardPosition;

//@synthesize debugLabel;

-(id)initWithFile:(NSString *)filename withDiceType:(EnumDiceNumberAndColor)diceNumberAndColor withRecentPosition:(CGPoint)tempCGPoint{
	self = [super initWithFile:filename];
	if ( self != nil ) {
		[self setCanMoveOrNot:YES];
		useOrNot = NO;
		gameBoardPosition = -1;
		recentPosition.x = tempCGPoint.x;
		recentPosition.y = tempCGPoint.y;
		diceType = diceNumberAndColor;
        /* debug */
//		debugLabel = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica-Bold" fontSize:6];
		[self setVisible:YES];
        /* 設定不同的Method每秒處理x.x次的方式 */
        /* debug */
//		[self schedule:@selector(updateThreeTimePerSecond) interval:0.3f];
//		[self addChild:debugLabel];
	}
	return self;
}

# pragma -
# pragma debug_Position

//-(void)debugLabelTextAndPosition{
//	CGPoint newPosition = [self position];
//	NSString *labelString = [NSString stringWithFormat:@"X:%.0f,Y:%.0f,Pos:%d" , newPosition.x , newPosition.y ,gameBoardPosition];
//	[debugLabel setString:labelString];
//	[debugLabel setPosition:ccp(25 , 55)];
//	[debugLabel setColor:ccBLACK];
//}
//
//-(void)updateThreeTimePerSecond{
//	[self debugLabelTextAndPosition];
//}

-(void)breakDice{
	id bigAction = [CCScaleTo actionWithDuration:animationDiceBreakTime*0.6 scale:1.2];
	id easeBigAction = [CCEaseIn actionWithAction:bigAction rate:1];
	id smallAction = [CCScaleTo actionWithDuration:animationDiceBreakTime*0.3 scale:0];
	id easeSmallAction = [CCEaseIn actionWithAction:smallAction rate:1];
	id tintAction ;
	if ( diceType <= 4 && diceType >= 1) {
		tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.6 red:110 green:110 blue:255];
	}
	else if( diceType <= 8 && diceType >= 5 ){
		tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.6 red:110 green:255 blue:110];
	}
	else if( diceType <= 12 && diceType >= 9){
		tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.6 red:255 green:110 blue:110];
	}
	else if(diceType <= 16 && diceType >= 13){
		tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.6 red:255 green:255 blue:110];
	}
	else{
		tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.6 red:255 green:255 blue:255];
	}
	id tintAction2 = [CCTintTo actionWithDuration:animationDiceBreakTime*0.3 red:70 green:70 blue:70];
	id allTintAction = [CCSequence actionOne:tintAction two:tintAction2];
	[self runAction:allTintAction];
	id allAction = [CCSequence actions:[CCDelayTime actionWithDuration:animationDiceBreakTime*0.3],easeBigAction,easeSmallAction, nil];
	[self runAction:allAction];
	//[self setVisible:NO];
	CCLOG(@"*********** can't see dice *************");
}

-(void)moveDiceWithPosition:(CGPoint)movePosition withGameBoardPosition:(int)moveGameBoardPosition{
	[self runAction:[CCMoveTo actionWithDuration:ANIMATION_TALK_BUBBLE_MOVE_TIME * 0.2 position:movePosition]];
	self.recentPosition = movePosition;
	self.gameBoardPosition = moveGameBoardPosition;
}

-(void)hideDice{
	[self setVisible:NO];
}

# pragma -
#pragma getter_&_setter

-(BOOL)getCanMoveOrNot{
	return canMoveOrNot;
}

-(void)setCanMoveOrNot:(BOOL)tempBool{
	canMoveOrNot = tempBool ;
	if (tempBool == NO) {
		[self setColor:ccc3(110, 110, 110)];
	}
	else{
		[self setColor:ccc3(255, 255, 255)];
	}
}

-(void)setUseOrNot:(BOOL)tempUseOrNot{
	useOrNot = tempUseOrNot;
}

-(BOOL)getUseOrNot{
	return useOrNot;
}

# pragma -

-(void)selectDiceAnim{
    PLAYSOUNDEFFECT(TOUCH_DICE);
	id bigAction = [CCScaleTo actionWithDuration:0.03 scale:1.35f];
	[self runAction:bigAction];
}

-(void)unselectDiceAnim{
	id smallAction = [CCScaleTo actionWithDuration:0.01 scale:1];
	[self runAction:smallAction];
}

-(void)becomeBigAndSmall{
	id bigAction = [CCScaleTo actionWithDuration:animationDiceBreakTime*0.35 scale:1.35];
	id easeBigAction = [CCEaseIn actionWithAction:bigAction rate:1];
	id smallAction = [CCScaleTo actionWithDuration:animationDiceBreakTime*0.65 scale:1];
	id easeSmallAction = [CCEaseIn actionWithAction:smallAction rate:1];
	id tintAction ;
	if ( diceType <= 4 && diceType >= 1) {
		tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.35 red:110 green:110 blue:255];
	}
	else if( diceType <= 8 && diceType >= 5 ){
		tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.35 red:110 green:255 blue:110];
	}
	else if( diceType <= 12 && diceType >= 9){
		tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.35 red:255 green:110 blue:110];
	}
	else if(diceType <= 16 && diceType >= 13){
		tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.35 red:255 green:255 blue:110];
	}
	else if(diceType == enumDiceGold){
		/* This is Gold Dice. */
		tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.35 red:255 green:255 blue:110];
	}
	else{
		tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.35 red:0 green:0 blue:0];
	}
	id tintAction2 = [CCTintTo actionWithDuration:animationDiceBreakTime*0.65 red:110 green:110 blue:110];
    id tintAction3 = [CCTintTo actionWithDuration:animationDiceBreakTime*0.65 red:255 green:255 blue:255];
	id allTintAction ;
    if ( [self getCanMoveOrNot] ) {
        allTintAction = [CCSequence actionOne:tintAction two:tintAction3];
    }
    else{
        allTintAction = [CCSequence actionOne:tintAction two:tintAction2];
    }
    [self runAction:allTintAction];
	id allAction = [CCSequence actions:easeBigAction,easeSmallAction, nil];
	[self runAction:allAction];
}

@end