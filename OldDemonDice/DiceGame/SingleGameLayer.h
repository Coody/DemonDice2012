//
//  SingleGameLayer.h
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "GameManager.h"
#import "Dice.h"
#import "LeadingActress.h"
#import "SuperDice.h"
#import "TalkLabel.h"
#import "SuperDiceGameboard.h"
#import "OptionPanel.h"
#import "DBManager.h"

@interface SingleGameLayer : CCLayer <SuperDiceGameboardDelegate,OptionPanelDelegate>{
	int totalScore;	//總分數
	int mustMoveDiceNumber;	//當前必須移動的骰子數量
	NSMutableArray *countScoreArray;	//計算分數的時候，這些陣列會顯示計算分數的動畫！(暫時)
    CCArray *diceArray;	//目前在遊戲版上所有的骰子！（目前最多16顆）
	CCArray *createDiceArray;	//目前創造的骰子(目前最多四顆)
	CCArray *buffDiceArray;	//這是buff中，可移動的骰子！
	CCArray *superDiceArray;	//存放超級骰子的Array！
	Dice *tempMovingDice;	//目前移動中的骰子！(暫時)
	float delayCreateDiceTime;	
	int havingFourDiceHashNumber[19];
	int newRoundHavingFourDiceHashNumber[19];
	int hashGameBoard[19][6];
	BOOL isGameBoardHasDice[20];
	
	int superDicePositionArray[5];
	
    /*這裡是處理算分效果的區域*/
    
    EnumscoreNumberEnum tempScoreNumber;
    CCSprite *showScoreSprite2;
    CCSprite *showScoreSprite10;
    CCSprite *showScoreSprite50;
    CCTexture2D *changeImageSprite;
    CCProgressTimer *energyBar;
    
    /**/
    
	CCMenu *rollButtonMenu;
	CCSprite *talkBubble;
	
	/* first */
	TalkLabel *talkLabel;
	
	/* second */
	SuperDiceGameboard *superDiceBoard;
	
	/* Third */
	OptionPanel *optionSprite;
    CCMenu *yesNoMenu;
    CCSprite *yesNoBackground;
	
	/* 底下scoreLabel測試用 */
	CCLabelTTF *scoreLabel;
	
	LeadingActress *leading;
	
	EnumTalkBubbleTag talkBubbleTag;
	
	/* 處理iPhone大小 */
	int bubbleIPHONE5SuperDiceHeightIncrease ;
	int bubbleIPHONE5HeightIncrease ;
    
    /* 處理skill03的增加分數 */
    int skill03CkeckScore;
}

-(void)pressedRockDiceButton;
-(void)scoreUpdateMethod;

@end