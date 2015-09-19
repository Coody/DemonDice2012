//
//  SingleGameLayer.m
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//
// all "/4" means "/ 4" because ARM can't use / director , so use * to take off /


#import "SingleGameLayer.h"
#import "GamePlayer.h"
#import "Constants.h"
#import "cocos2d.h"
#import "GameManager.h"
#import "Dice.h"
#import "LeadingActress.h"
#import "SuperDice.h"
#import "TalkLabel.h"
#import "SuperDiceGameboard.h"
#import "OptionPanel.h"
#import "DBManager.h"

static int DICE_PIC_WIDTH_helf = 25;
static int DICE_PIC_HEIGHT_helf = 25;
static int DICE_PIC_WIDTH = 50;
static int DICE_PIC_HEIGHT = 50;

@interface SingleGameLayer()< SuperDiceGameboardDelegate , OptionPanelDelegate >
{
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

-(NSString *)getDicePicture:(EnumDiceNumberAndColor)tempDiceType;
-(void)sortHashGameBoard:(int)tempI withDiceType:(int)diceType;
-(void)startCountScoreAnim;
-(void)addDiceToHashGameBoard:(Dice *)tempDice;
-(void)testHashGameTable;
-(void)removeDiceToHashGameBoard:(Dice *)tempDice;
-(void)findHashGameBoard:(int)tempI withDiceType:(int)diceType;
-(void)findDiceBehindSuperDice;
/* temp gameLogic */
-(void)setTouchScreen;
-(void)createDice;
-(void)runCountScoreAnimation;
-(void)sortHavingFourDiceHashNumberArray:(int *)tempArray;

-(BOOL)countScoreLogicWithFirst:(EnumDiceNumberAndColor)first
					 withSecond:(EnumDiceNumberAndColor)second
					  withThird:(EnumDiceNumberAndColor)third
					 withFourth:(EnumDiceNumberAndColor)fourth;
-(BOOL)checkScoreLogicWithFirst:(EnumDiceNumberAndColor)first
					 withSecond:(EnumDiceNumberAndColor)second
					  withThird:(EnumDiceNumberAndColor)third
					 withFourth:(EnumDiceNumberAndColor)fourth;
-(BOOL)handleOneSuperDiceAndDifColorDifNumWithFirst:(EnumDiceNumberAndColor)first
										 withSecond:(EnumDiceNumberAndColor)second
										  withThird:(EnumDiceNumberAndColor)third;
-(BOOL)checkDelayTimeAdd;

-(void)showScoreGameboardWithPosition:(int)showScorePosition withScore:(EnumscoreNumberEnum)showScore;

/**/
-(void)resetAllDice;

-(void)createSuperDiceLogic;
-(void)createSuperDice:(int)createSuperDiceNumber;
-(void)superDicePosition:(EnumSuperDicePosition)tempSuperDicePosition withCGPoint:(CGPoint *)tempCGPoint;

-(void)remindPlayerDiceMustMove:(Dice *)remindDice;

/**/
-(void)moveInTalkBubbleWithObject:(id)object withWidth:(int)width withHeight:(int)height;
-(void)moveOutTalkBubbleWithObject:(id)object withWidth:(int)width withHeight:(int)height;

-(void)runSkillMethod;

-(void)changeTalkContext:(NSSet *)touch;

@end

@implementation SingleGameLayer

-(void)pressedRockDiceButton{
	/* if have dice in createDiceArray's position , remind Player to move the dice out !! */
    
	if (mustMoveDiceNumber > 0) {
		/* 以下防止使用者在這期間移動骰子！！所以關閉螢幕觸碰一段時間！ */
		id stopButtonAction = [CCCallFunc actionWithTarget:self selector:@selector(setTouchScreen)];
		id stopDelayTime = [CCDelayTime actionWithDuration:(remindDiceJumpTime*3+0.13f)];
		id allStopScreenAction = [CCSequence actions:stopButtonAction,stopDelayTime,stopButtonAction, nil];
		[self runAction:allStopScreenAction];
		
		for ( Dice *tempDice in createDiceArray ) {
			if ( tempDice.position.x == 40 ) {
				[self remindPlayerDiceMustMove:tempDice];
			}
		}
		for ( Dice *tempDice in diceArray ) {
			if ( tempDice.position.x == 40 ) {
				[self remindPlayerDiceMustMove:tempDice];
			}
		}
		for ( Dice *tempDice in buffDiceArray ) {
			if ( tempDice.position.x == 40 ) {
				[self remindPlayerDiceMustMove:tempDice];
			}
		}
        PLAYSOUNDEFFECT(PRESS_RED_BUTTON_ERROR);
	}
	else{
        PLAYSOUNDEFFECT(PRESS_RED_BUTTON);
		/* 如果骰子都結束就固定骰子 and add dice to diceArray , remove dice from createDiceArray..... */
		CCArray *tempArrayWithDiceArray =[CCArray array];
		CCArray *tempArrayWithBuffDiceArray = [CCArray array];
		
        /* 這個狀況處理CreateDiceArray....將create Dice Array 搬移到 1.tempDiceArray 2.tempBuffDiceArray */
		for ( Dice *tempDice in createDiceArray ) {
			if ( tempDice.gameBoardPosition >=0 && tempDice.gameBoardPosition <= 15 ) {
				[tempArrayWithDiceArray addObject:tempDice];
			}
			else{
				[tempArrayWithBuffDiceArray addObject:tempDice];
			}
		}
		[diceArray addObjectsFromArray:tempArrayWithDiceArray];
		[buffDiceArray addObjectsFromArray:tempArrayWithBuffDiceArray];
		[tempArrayWithDiceArray removeAllObjects];
		[tempArrayWithBuffDiceArray removeAllObjects];
		
        /* 將diceArray中，移動到buff Array區域的骰子加入 */
		for( Dice *tempDice in diceArray ){
			if ( tempDice.gameBoardPosition >= 16  ) {
				[tempArrayWithBuffDiceArray addObject:tempDice];
			}
		}
        
		/* remove dices from buffDiceArray , because diceArray's dice.position is in buffDiceArray*/
		[diceArray removeObjectsInArray:tempArrayWithBuffDiceArray];
		[buffDiceArray addObjectsFromArray:tempArrayWithBuffDiceArray];
		[tempArrayWithBuffDiceArray removeAllObjects];
		
		for ( Dice *tempDice in buffDiceArray) {
			if ( tempDice.gameBoardPosition >= 0 && tempDice.gameBoardPosition <= 15) {
				[tempArrayWithDiceArray addObject:tempDice];
			}
		}
		[buffDiceArray removeObjectsInArray:tempArrayWithDiceArray];
		[diceArray addObjectsFromArray:tempArrayWithDiceArray];
		[tempArrayWithDiceArray removeAllObjects];
		
		/* clean all dice form createDiceArray , tempArrayWithDiceArray , tempArrayWithBuffDiceArray . */
		[createDiceArray removeAllObjects];
		
		/* 以下是如果確定所有骰子的位置以後，該改變logic的hashGameBoard[],以及isGameBoardHasDice[] */
		for ( Dice *tempDice in buffDiceArray ) {
			CCLOG(@"BuffDiceArray position = %d" , tempDice.gameBoardPosition);
			isGameBoardHasDice[tempDice.gameBoardPosition] = YES;
			[tempDice setCanMoveOrNot:YES];
		}
        
        /* 將gameBoard裡面的Dice全設定為不能移動 */
		for ( Dice *tempDice in diceArray ) {
			if ( [tempDice getCanMoveOrNot] == NO) {
				continue;
			}
			else{
                /* 這裡如果加了下面那句，會造成連續兩次去加入骰子！ */
				[self addDiceToHashGameBoard:tempDice];
				[tempDice setCanMoveOrNot:NO];
				CCLOG(@"tempDice set CanMoveOrNot to NO .");
			}
		}
		
		[self sortHavingFourDiceHashNumberArray:newRoundHavingFourDiceHashNumber];
		/* 處理Super Dice */
		[self findDiceBehindSuperDice];
		[self sortHavingFourDiceHashNumberArray:newRoundHavingFourDiceHashNumber];
		/* test */
		[self testHashGameTable];
		
		/* run countScore to start game. */
		[self startCountScoreAnim];
	}
}


#pragma mark -
#pragma mark Handle Game Logical

-(void)createDice{
	/* 停下分數計算動畫 */
	CCLOG(@"test bug");
	if ( [diceArray count] >= (MaxDiceNumber - 4) && [superDiceArray count] == 0 ) {
		/* [self chooseMenu]; */
		/* 這裡的resetAllDice是為了測試用！！ */
        [self resetAllDice];
        
        /* Game over , call restart menu */
	}
	else{
		if ( [diceArray count] == (MaxDiceNumber - 4) && [superDiceArray count] != 0 ) {
			NSMutableArray *tempDelayTouchArray = [[NSMutableArray alloc]init];
			[tempDelayTouchArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(setTouchScreen)]];
			[tempDelayTouchArray addObject:[CCDelayTime actionWithDuration:remindDiceJumpTime*3+0.05]];
			[tempDelayTouchArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(setTouchScreen)]];
			for ( Dice *tempSuperDice in superDiceArray ) {
				[self remindPlayerDiceMustMove:tempSuperDice];
			}
            if (talkBubbleTag != enumTalkBubbleSuperDice) {
                if ( talkBubbleTag == enumTalkBubbleNPCTalk ) {
                    [self moveOutTalkBubbleWithObject:talkLabel withWidth:talkLabelPositionWidth withHeight:talkLabelPositionHeight+ bubbleIPHONE5SuperDiceHeightIncrease ];
                    [self moveInTalkBubbleWithObject:superDiceBoard withWidth:superDiceGameboardWidth withHeight:superDiceGameboardHeight + bubbleIPHONE5SuperDiceHeightIncrease ];
                }
                /* 這裡剩下的一定是talkBubbleTag == enumTalkBubbleOption */
                else{
                    [self moveOutTalkBubbleWithObject:optionSprite withWidth:talkLabelPositionWidth withHeight:talkLabelPositionHeight + bubbleIPHONE5SuperDiceHeightIncrease];
                    [self moveInTalkBubbleWithObject:superDiceBoard withWidth:superDiceGameboardWidth withHeight:superDiceGameboardHeight + bubbleIPHONE5SuperDiceHeightIncrease];
                }
                talkBubbleTag = enumTalkBubbleSuperDice;
            }
			id remindGoldDiceAction = [CCSequence actionsWithArray:tempDelayTouchArray];
			[self runAction:remindGoldDiceAction];
			[tempDelayTouchArray release];
			tempDelayTouchArray = nil;
			return;
		}
		/* if < 16 */
		/* create dice */
		unsigned int createDiceNumber ;
		if ( [diceArray count] > 12  ) {
			createDiceNumber = 4 - ([diceArray count]%4) ;
		}
		else{
			createDiceNumber = 4;
		}
		CCLOG(@"Total dice number = %d" , createDiceNumber);
        CCLOG(@"Total Score = %d" , totalScore);
		for (int i = 0; i<createDiceNumber; i++) {
			int randomDiceNumber = ((arc4random()%16) + 1);
			//測試用！！
			
//			if ( i == 0 ) {
//				randomDiceNumber = 1;
//			}
//			else if( i == 1){
//				randomDiceNumber = 1;
//			}
//			else if( i ==2 ){
//				randomDiceNumber = 11;
//			}
//			else if( i ==3 ){
//				randomDiceNumber = 16;
//			}
//          randomDiceNumber = 9;
			
			Dice *tempCreateDice = [[Dice alloc]initWithFile:[self getDicePicture:randomDiceNumber] withDiceType:randomDiceNumber withRecentPosition:ccp( 40 , 220-(60*i))];
			[createDiceArray addObject:tempCreateDice];
			[tempCreateDice setPosition:ccp( 40 , 220-(60*i))];
			//[tempCreateDice setRecentPosition:ccp( 40 , 220-(60*i))];
			[self addChild:tempCreateDice z:enumStableZOrder];
			[tempCreateDice release];
			tempCreateDice = nil;
			mustMoveDiceNumber++;
		}
        PLAYSOUNDEFFECT(CREATE_DICE);
	}
}

-(void)startCountScoreAnim{
	[self setTouchScreen];
	[self runCountScoreAnimation];
}

-(void)runCountScoreAnimation{
	[countScoreArray removeAllObjects];
	CCLOG(@"countScoreArray = %d" , (int)[countScoreArray count]);
	
	/* 利用CCCallFunc　將（方法的）動作包裝成物件，並加入 Action Array 中。 */
	CCCallFunc *tempCallFunc ;
	CCDelayTime *tempDelayCountScoreAnim = [CCDelayTime actionWithDuration:animationCountScoreTime*1.08f];
	CCSequence *allCountAnimation ;
	[countScoreArray addObject:[CCDelayTime actionWithDuration:animationCountScoreTime*0.5]];
	for (int i = 0 ; i < 19 ; i++ ) {
		if ( newRoundHavingFourDiceHashNumber[i] != -1 ) {
			switch ( newRoundHavingFourDiceHashNumber[i] ) {
				case 0:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action00)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 1:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action01)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 2:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action02)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 3:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action03)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 4:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action04)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 5:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action05)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 6:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action06)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 7:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action07)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 8:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action08)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 9:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action09)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 10:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action10)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 11:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action11)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 12:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action12)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 13:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action13)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 14:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action14)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 15:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action15)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 16:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action16)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 17:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action17)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				case 18:
					tempCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(action18)];
					[countScoreArray addObject:tempCallFunc];
					[countScoreArray addObject:tempDelayCountScoreAnim];
					break;
				default:
					break;
			}
			/* 將run過的 fourDiceArray 歸零，避免下次算分 */
			newRoundHavingFourDiceHashNumber[i] = -1;
		}
	}
	
	/* break Dice... */
	/* add more time to delayTime, because i have to run breakDiceAnimation. */
	[countScoreArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(findBreakDice)]];
	if ( [self checkDelayTimeAdd] ) {
        [countScoreArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(playBreakDiceMp3)]];
		[countScoreArray addObject:[CCDelayTime actionWithDuration:animationDiceBreakTime*1.3f]];
	}
	
	//createDice
	[countScoreArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(removeDiceFromDiceArray)]];
    [countScoreArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(runSkillMethod)]];
	//create Dcie must separate two methods.
	[countScoreArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(createDice)]];
	[countScoreArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(createSuperDiceLogic)]];
    
    [countScoreArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(setTouchScreen)]];

	allCountAnimation = [CCSequence actionsWithArray:countScoreArray];
	[self runAction:allCountAnimation];
    tempCallFunc = nil;
	[self testHashGameTable];
}

/* 由小到大拿進來，並且計算分數！ */
-(BOOL)countScoreLogicWithFirst:(EnumDiceNumberAndColor)first
					 withSecond:(EnumDiceNumberAndColor)second
					  withThird:(EnumDiceNumberAndColor)third
					 withFourth:(EnumDiceNumberAndColor)fourth{
	CCLOG(@"first:%d , second:%d , third:%d , fourth:%d" , first , second , third , fourth);
	int tempScore = 0;
	BOOL tempCheckDiceBreakBool = NO;
	/* check does not have super dice. */
	if ( fourth != enumDiceGold) {
		/* check four dices are the same. */
		if ( first == fourth ) {
            tempScoreNumber = enumScoreFourDiceTheSameColorTheSameNumberEnum;
			tempScore = tempScore + enumScoreFourDiceTheSameColorTheSameNumberEnum;
			totalScore = tempScore + totalScore;
            skill03CkeckScore = skill03CkeckScore + tempScore;
			tempCheckDiceBreakBool = YES;
			CCLOG(@"The same Color and the same Numbers.");
			return tempCheckDiceBreakBool;
		}
		/* The same Color and sequence Numbers. */
		if( (first == 1 || first == 5 || first == 9 || first == 13 ) &&
				((fourth - first) == 3) && ((fourth - second) == 2) && ((fourth - third) == 1) ){
            tempScoreNumber = enumScoreFourDiceTheSameColorEnum;
			tempScore = tempScore + enumScoreFourDiceTheSameColorEnum;
			totalScore = tempScore + totalScore;
            skill03CkeckScore = skill03CkeckScore + tempScore;
			tempCheckDiceBreakBool = YES;
			CCLOG(@"The same Color and sequence Numbers.");
			return tempCheckDiceBreakBool;
		}
		/* The same Color and dif Number. */
		if( (first + 4) == second && (second + 4) == third && (third + 4) == fourth){
            tempScoreNumber = enumScoreFourDiceTheSameNumberEnum;
			tempScore = tempScore + enumScoreFourDiceTheSameNumberEnum;
			totalScore = tempScore + totalScore;
            skill03CkeckScore = skill03CkeckScore + tempScore;
			tempCheckDiceBreakBool = YES;
			CCLOG(@"The same Color and dif Number.");
			return tempCheckDiceBreakBool;

		}
		/* Dif color and Dif number */
		if( first + second + third + fourth == 34 ){
			if ( ( ( first <=4 && first >= 1 ) && (second >=5 && second <= 8) && ( third >= 9 && third <= 12 ) && ( fourth >= 13 && fourth <= 16 )) ) {
				/* 底下條件是說不准1,2,3,4隨意亂放變成 1,1,4,4　這樣！ */
				if ( ( second - first != 4 &&
					  third - second != 4 &&
					  third - first != 8 &&
					  fourth - third != 4 &&
					  fourth - second != 8 &&
					  fourth - first != 12 )  ) {
                    tempScoreNumber = enumScoreFourDiceDifColorDifNumber;
					tempScore = tempScore + enumScoreFourDiceDifColorDifNumber;
					totalScore = tempScore + totalScore;
                    skill03CkeckScore = skill03CkeckScore + tempScore;
					tempCheckDiceBreakBool = YES;
					CCLOG(@"Dif color and Dif number.");
					return  tempCheckDiceBreakBool;
				}
			}
		}
	}
	/* 這裡一定要從第一個骰子是不是超級骰子開始算起 */
	/* 表示有 4個 超級骰子 */
	else if( first == enumDiceGold ){
        tempScoreNumber = enumScoreFourDiceTheSameColorTheSameNumberEnum;
		tempScore = tempScore + enumScoreFourDiceTheSameColorTheSameNumberEnum;
		totalScore = tempScore + totalScore;
		tempCheckDiceBreakBool = YES;
	}
	/* 表示有 3個 超級骰子 */
	else if( second == enumDiceGold ){
        tempScoreNumber = enumScoreFourDiceTheSameColorTheSameNumberEnum;
		tempScore = tempScore + enumScoreFourDiceTheSameColorTheSameNumberEnum;
		totalScore = tempScore + totalScore;
		tempCheckDiceBreakBool = YES;
	}
	/* 表示有 2個 超級骰子 */
	else if( third == enumDiceGold ){
		/* the same Color the same Number */
		if( first == second ){
            tempScoreNumber = enumScoreFourDiceTheSameColorTheSameNumberEnum;
			tempScore = tempScore + enumScoreFourDiceTheSameColorTheSameNumberEnum;
			totalScore = tempScore + totalScore;
			tempCheckDiceBreakBool = YES;
		}
		/* the same Color Sequence Number */
		else if( (first != 4 && first != 8 && first != 12 && first != 16) &&
				(( second - first == 1 ) || ( second - first == 2 ) || ( second - first == 3 ) ) ){
			/* 這裡有錯誤要改 */
            tempScoreNumber = enumScoreFourDiceTheSameColorEnum;
			tempScore = tempScore + enumScoreFourDiceTheSameColorEnum;
			totalScore = tempScore + totalScore;
			tempCheckDiceBreakBool = YES;
		}
		/* dif Color and the same Number */
		else if( ((second - first) % 4 == 0) ){
            tempScoreNumber = enumScoreFourDiceTheSameNumberEnum;
			tempScore = tempScore + enumScoreFourDiceTheSameNumberEnum;
			totalScore = tempScore + totalScore;
			tempCheckDiceBreakBool = YES;
		}
		/* dif Color and dif Number */
		else{
            tempScoreNumber = enumScoreFourDiceDifColorDifNumber;
			tempScore = tempScore + enumScoreFourDiceDifColorDifNumber;
			totalScore = tempScore + totalScore;
			tempCheckDiceBreakBool = YES;
		}
		/* 記得超級骰跑一次就要銷掉 */
	}
	/* 表示有 1個 超級骰子 */
	else if( fourth == enumDiceGold ){
		/* the same Color the same Number */
		if (first == third) {
            tempScoreNumber = enumScoreFourDiceTheSameColorTheSameNumberEnum;
			tempScore = tempScore + enumScoreFourDiceTheSameColorTheSameNumberEnum;
			totalScore = tempScore + totalScore;
            skill03CkeckScore = skill03CkeckScore + tempScore;
			tempCheckDiceBreakBool = YES;
		}
		/* the same Color Sequence Number */
		else{
			if( ( first == 1 || first == 5 || first == 9 || first == 13 ) ||
			    (first == 2 || first == 6 || first == 10 || first == 14) ){
				if ( first == 1 || first == 5 || first == 9 || first == 13 ) {
					if ( ((third - first == 3) && (second - first == 2 || second - first == 1)) ||
						 ((third - first == 2) && (second - first == 1)) ) {
                        tempScoreNumber = enumScoreFourDiceTheSameColorEnum;
						tempScore = tempScore + enumScoreFourDiceTheSameColorEnum;
						totalScore = tempScore + totalScore;
                        skill03CkeckScore = skill03CkeckScore + tempScore;
						tempCheckDiceBreakBool = YES;
						return tempCheckDiceBreakBool;
					}
				}
				else if(first == 2 || first == 6 || first == 10 || first == 14){
					if ( (third - first ==2) && (second - first == 1) ) {
                        tempScoreNumber = enumScoreFourDiceTheSameColorEnum;
						tempScore = tempScore + enumScoreFourDiceTheSameColorEnum;
						totalScore = tempScore + totalScore;
                        skill03CkeckScore = skill03CkeckScore + tempScore;
						tempCheckDiceBreakBool = YES;
						return tempCheckDiceBreakBool;
					}
				}
			}
			if( (first < 9 && second < 13 ) && (
												(( first + 4 == second) && ( second + 4 == third) ) ||
												(( first + 8 == second) && ( second + 4 == third) ) ||
												(( first + 4 == second) && ( second + 8 == third) )) ){
                tempScoreNumber = enumScoreFourDiceTheSameNumberEnum;
				tempScore = tempScore + enumScoreFourDiceTheSameNumberEnum;
				totalScore = tempScore + totalScore;
                skill03CkeckScore = skill03CkeckScore + tempScore;
				tempCheckDiceBreakBool = YES;
				return tempCheckDiceBreakBool;
			}
			/* dif Color and the same Number */
			if( (first < 9 && second < 13 ) && (
												(( first + 4 == second) && ( second + 4 == third) ) ||
												(( first + 8 == second) && ( second + 4 == third) ) ||
												(( first + 4 == second) && ( second + 8 == third) )) ){
                tempScoreNumber = enumScoreFourDiceTheSameNumberEnum;
				tempScore = tempScore + enumScoreFourDiceTheSameNumberEnum;
				totalScore = tempScore + totalScore;
                skill03CkeckScore = skill03CkeckScore + tempScore;
				tempCheckDiceBreakBool = YES;
				return tempCheckDiceBreakBool;
			}
			/* dif Color and dif Number */
			if( [self handleOneSuperDiceAndDifColorDifNumWithFirst:first
														withSecond:second
														 withThird:third] ){
                tempScoreNumber = enumScoreFourDiceDifColorDifNumber;
				tempScore = tempScore + enumScoreFourDiceDifColorDifNumber;
				totalScore = tempScore + totalScore;
                skill03CkeckScore = skill03CkeckScore + tempScore;
				tempCheckDiceBreakBool = YES;
				return tempCheckDiceBreakBool;
			}
		}
	}
    /* 保險 */
	/* totalScore = tempScore + totalScore; */
	return tempCheckDiceBreakBool;
}

-(BOOL)checkScoreLogicWithFirst:(EnumDiceNumberAndColor)first
					 withSecond:(EnumDiceNumberAndColor)second
					  withThird:(EnumDiceNumberAndColor)third
					 withFourth:(EnumDiceNumberAndColor)fourth{
	BOOL tempCheckDiceBreakBool = NO;
	/* check does not have super dice. */
	if ( fourth != enumDiceGold) {
		/* check four dices are the same. */
		if ( first == fourth ) {
			tempCheckDiceBreakBool = YES;
			CCLOG(@"The same Color and the same Numbers.");
			return tempCheckDiceBreakBool;
		}
		/* The same Color and sequence Numbers. */
		if( (first == 1 || first == 5 || first == 9 || first == 13 ) &&
           ((fourth - first) == 3) && ((fourth - second) == 2) && ((fourth - third) == 1) ){
			tempCheckDiceBreakBool = YES;
			CCLOG(@"The same Color and sequence Numbers.");
			return tempCheckDiceBreakBool;
		}
		/* The same Color and dif Number. */
		if( (first + 4) == second && (second + 4) == third && (third + 4) == fourth){
			tempCheckDiceBreakBool = YES;
			CCLOG(@"The same Color and dif Number.");
			return tempCheckDiceBreakBool;
            
		}
		/* Dif color and Dif number */
		if( first + second + third + fourth == 34 ){
			if ( ( ( first <=4 && first >= 1 ) && (second >=5 && second <= 8) && ( third >= 9 && third <= 12 ) && ( fourth >= 13 && fourth <= 16 )) ) {
				/* 底下條件是說不准1,2,3,4隨意亂放變成 1,1,4,4　這樣！ */
				if ( ( second - first != 4 &&
					  third - second != 4 &&
					  third - first != 8 &&
					  fourth - third != 4 &&
					  fourth - second != 8 &&
					  fourth - first != 12 )  ) {
					tempCheckDiceBreakBool = YES;
                    CCLOG(@"Dif color and Dif number.");
					return  tempCheckDiceBreakBool;
				}
			}
		}
	}
	/* 這裡一定要從第一個骰子是不是超級骰子開始算起 */
	/* 表示有 4個 超級骰子 */
	else if( first == enumDiceGold ){
		tempCheckDiceBreakBool = YES;
	}
	/* 表示有 3個 超級骰子 */
	else if( second == enumDiceGold ){
		tempCheckDiceBreakBool = YES;
	}
	/* 表示有 2個 超級骰子 */
	else if( third == enumDiceGold ){
		/* the same Color the same Number */
		if( first == second ){
			tempCheckDiceBreakBool = YES;
		}
		/* the same Color Sequence Number */
		else if( (first != 4 && first != 8 && first != 12 && first != 16) &&
				(( second - first == 1 ) || ( second - first == 2 ) || ( second - first == 3 ) ) ){
			//TODO:這裡有錯誤要改
            /* 這裡有錯誤要改 */
			tempCheckDiceBreakBool = YES;
		}
		/* dif Color and the same Number */
		else if( ((second - first) % 4 == 0) ){
			tempCheckDiceBreakBool = YES;
		}
		/* dif Color and dif Number */
		else{
			tempCheckDiceBreakBool = YES;
		}
		/* 記得超級骰跑一次就要銷掉 */
	}
	/* 表示有 1個 超級骰子 */
	else if( fourth == enumDiceGold ){
		/* the same Color the same Number */
		if (first == third) {
			tempCheckDiceBreakBool = YES;
		}
		/* the same Color Sequence Number */
		else{
			if( ( first == 1 || first == 5 || first == 9 || first == 13 ) ||
               (first == 2 || first == 6 || first == 10 || first == 14) ){
				if ( first == 1 || first == 5 || first == 9 || first == 13 ) {
					if ( ((third - first == 3) && (second - first == 2 || second - first == 1)) ||
                        ((third - first == 2) && (second - first == 1)) ) {
						tempCheckDiceBreakBool = YES;
						return tempCheckDiceBreakBool;
					}
				}
				else if(first == 2 || first == 6 || first == 10 || first == 14){
					if ( (third - first ==2) && (second - first == 1) ) {
						tempCheckDiceBreakBool = YES;
						return tempCheckDiceBreakBool;
					}
				}
			}
			if( (first < 9 && second < 13 ) && (
												(( first + 4 == second) && ( second + 4 == third) ) ||
												(( first + 8 == second) && ( second + 4 == third) ) ||
												(( first + 4 == second) && ( second + 8 == third) )) ){
				tempCheckDiceBreakBool = YES;
				return tempCheckDiceBreakBool;
			}
			/* dif Color and the same Number */
			if( (first < 9 && second < 13 ) && (
												(( first + 4 == second) && ( second + 4 == third) ) ||
												(( first + 8 == second) && ( second + 4 == third) ) ||
												(( first + 4 == second) && ( second + 8 == third) )) ){
				tempCheckDiceBreakBool = YES;
				return tempCheckDiceBreakBool;
			}
			/* dif Color and dif Number */
			if( [self handleOneSuperDiceAndDifColorDifNumWithFirst:first
														withSecond:second
														 withThird:third] ){
				tempCheckDiceBreakBool = YES;
				return tempCheckDiceBreakBool;
			}
		}
	}
	return tempCheckDiceBreakBool;
}

-(BOOL)handleOneSuperDiceAndDifColorDifNumWithFirst:(EnumDiceNumberAndColor)first
										 withSecond:(EnumDiceNumberAndColor)second
										  withThird:(EnumDiceNumberAndColor)third{
	BOOL check = NO;
	switch ( first+second+third ) {
		case 18:
			if (third == 11 && ((first == 1 && second == 6 ) || ( first == 2 && second == 5 ))) {
				check = YES;
			}
			else if(third == 10 && ((first == 1 && second == 7 ) || ( first == 3 && second == 5 ))) {
				check = YES;
			}
			else if(third == 9 && ((first == 2 && second == 7 ) || ( first == 3 && second == 6 ))) {
				check = YES;
			}
			break;
		case 19:
			if (third == 12 && ((first == 1 && second == 6 ) || ( first == 2 && second == 5 ))) {
				check = YES;
			}
			else if(third == 10 && ((first == 1 && second == 8 ) || ( first == 4 && second == 5 ))) {
				check = YES;
			}
			else if(third == 9 && ((first == 2 && second == 8 ) || ( first == 4 && second == 6 ))) {
				check = YES;
			}
			break;
		case 20:
			if (third == 12 && ((first == 1 && second == 7 ) || ( first == 3 && second == 5 ))) {
				check = YES;
			}
			else if(third == 11 && ((first == 1 && second == 8 ) || ( first == 4 && second == 5 ))) {
				check = YES;
			}
			else if(third == 9 && ((first == 3 && second == 8 ) || ( first == 4 && second == 7 ))) {
				check = YES;
			}
			break;
		case 21:
			if (third == 12 && ((first == 2 && second == 7 ) || ( first == 3 && second == 6 ))) {
				check = YES;
			}
			else if(third == 11 && ((first == 2 && second == 8 ) || ( first == 4 && second == 6 ))) {
				check = YES;
			}
			else if(third == 10 && ((first == 3 && second == 8 ) || ( first == 4 && second == 7 ))) {
				check = YES;
			}
			break;
		case 22:
			if (third == 15 && ((first == 1 && second == 6 ) || ( first == 2 && second == 5 ))) {
				check = YES;
			}
			else if(third == 14 && ((first == 1 && second == 7 ) || ( first == 3 && second == 5 ))) {
				check = YES;
			}
			else if(third == 13 && ((first == 2 && second == 7 ) || ( first == 3 && second == 6 ))) {
				check = YES;
			}
			break;
		case 23:
			if (third == 16 && ((first == 1 && second == 6 ) || ( first == 2 && second == 5 ))) {
				check = YES;
			}
			else if(third == 14 && ((first == 1 && second == 8 ) || ( first == 4 && second == 5 ))) {
				check = YES;
			}
			else if(third == 13 && ((first == 2 && second == 8 ) || ( first == 4 && second == 6 ))) {
				check = YES;
			}
			break;
		case 24:
			if (third == 16 && ((first == 1 && second == 7 ) || ( first == 3 && second == 5 ))) {
				check = YES;
			}
			else if(third == 15 && ((first == 1 && second == 8 ) || ( first == 4 && second == 5 ))) {
				check = YES;
			}
			else if(third == 13 && ((first == 3 && second == 8 ) || ( first == 4 && second == 7 ))) {
				check = YES;
			}
			break;
		case 25:
			if (third == 16 && ((first == 2 && second == 7 ) || ( first == 3 && second == 6 ))) {
				check = YES;
			}
			else if(third == 15 && ((first == 2 && second == 8 ) || ( first == 4 && second == 6 ))) {
				check = YES;
			}
			else if(third == 14 && ((first == 3 && second == 8 ) || ( first == 4 && second == 7 ))) {
				check = YES;
			}
			break;
		case 26:
			if (third == 15 && ((first == 1 && second == 10 ) || ( first == 2 && second == 9 ))) {
				check = YES;
			}
			else if(third == 14 && ((first == 1 && second == 11 ) || ( first == 3 && second == 9 ))) {
				check = YES;
			}
			else if(third == 13 && ((first == 2 && second == 11 ) || ( first == 3 && second == 10 ))) {
				check = YES;
			}
			break;
		case 27:
			if (third == 16 && ((first == 1 && second == 10 ) || ( first == 2 && second == 9 ))) {
				check = YES;
			}
			else if(third == 14 && ((first == 1 && second == 12 ) || ( first == 4 && second == 9 ))) {
				check = YES;
			}
			else if(third == 13 && ((first == 2 && second == 12 ) || ( first == 4 && second == 10 ))) {
				check = YES;
			}
			break;
		case 28:
			if (third == 16 && ((first == 1 && second == 11 ) || ( first == 3 && second == 9 ))) {
				check = YES;
			}
			else if(third == 15 && ((first == 1 && second == 12 ) || ( first == 4 && second == 9 ))) {
				check = YES;
			}
			else if(third == 13 && ((first == 3 && second == 12 ) || ( first == 4 && second == 11 ))) {
				check = YES;
			}
			break;
		case 29:
			if (third == 16 && ((first == 2 && second == 11 ) || ( first == 3 && second == 10 ))) {
				check = YES;
			}
			else if(third == 15 && ((first == 2 && second == 12 ) || ( first == 4 && second == 10 ))) {
				check = YES;
			}
			else if(third == 14 && ((first == 3 && second == 12 ) || ( first == 4 && second == 11 ))) {
				check = YES;
			}
			break;
		case 30:
			if (third == 15 && ((first == 5 && second == 10 ) || ( first == 6 && second == 9 ))) {
				check = YES;
			}
			else if(third == 14 && ((first == 5 && second == 11 ) || ( first == 7 && second == 9 ))) {
				check = YES;
			}
			else if(third == 13 && ((first == 6 && second == 11 ) || ( first == 7 && second == 10 ))) {
				check = YES;
			}
			break;
		case 31:
			if (third == 16 && ((first == 5 && second == 10 ) || ( first == 6 && second == 9 ))) {
				check = YES;
			}
			else if(third == 14 && ((first == 5 && second == 12 ) || ( first == 8 && second == 9 ))) {
				check = YES;
			}
			else if(third == 13 && ((first == 6 && second == 12 ) || ( first == 8 && second == 10 ))) {
				check = YES;
			}
			break;
		case 32:
			if (third == 16 && ((first == 5 && second == 11 ) || ( first == 7 && second == 9 ))) {
				check = YES;
			}
			else if(third == 15 && ((first == 5 && second == 12 ) || ( first == 8 && second == 9 ))) {
				check = YES;
			}
			else if(third == 13 && ((first == 7 && second == 12 ) || ( first == 8 && second == 11 ))) {
				check = YES;
			}
			break;
		case 33:
			if (third == 16 && ((first == 6 && second == 11 ) || ( first == 7 && second == 10 ))) {
				check = YES;
			}
			else if(third == 15 && ((first == 6 && second == 12 ) || ( first == 8 && second == 10 ))) {
				check = YES;
			}
			else if(third == 14 && ((first == 7 && second == 12 ) || ( first == 8 && second == 11 ))) {
				check = YES;
			}
			break;
		default:
			break;
	}
	return check;
}

-(void)findBreakDice{
	for ( Dice *tempDice in diceArray ) {
		if ([tempDice getUseOrNot] == YES) {
			[tempDice breakDice];
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray) {
		if ( [tempSuperDice getRollDiceOrNot] == YES ) {
			[tempSuperDice breakDice];
		}
	}
}

/* 創立一個陣列來移除其中的骰子！ */
-(void)removeDiceFromDiceArray{
	CCArray *tempRemoveDiceArray = [CCArray array];
	for(Dice *tempDice in diceArray){
		if ([tempDice getUseOrNot]==YES) {
			CCLOG(@"移除！！！！！！！　DiceType = %d" , tempDice.diceType);
			[self removeDiceToHashGameBoard:tempDice];
			[tempRemoveDiceArray addObject:tempDice];
            /* cocos2d裡頭移除sprite的自己的方法，不使用會造成記憶體遺漏 */
			[tempDice removeFromParentAndCleanup:YES];
		}
	}
	[diceArray removeObjectsInArray:tempRemoveDiceArray];
	[tempRemoveDiceArray removeAllObjects];
	for ( SuperDice *tempSuperDice in superDiceArray) {
		if ( [tempSuperDice getRollDiceOrNot] == YES ) {
			CCLOG(@"移除！！！！！！！　SuperDice = %d" , tempSuperDice.gameBoardPosition);
			/* [self removeDiceToHashGameBoard:tempSuperDice]; */ /* 這裡會照成兩次移除，因為我將SuperDice加入diceArray了！！所以在上面那個for迴圈我就會先移除了！！這裡又移除一次就會照成hashGameBoard兩次移除！！ */
			[tempRemoveDiceArray addObject:tempSuperDice];
			[tempSuperDice removeFromParentAndCleanup:YES];
		}
	}
	[superDiceArray removeObjectsInArray:tempRemoveDiceArray];
	[tempRemoveDiceArray removeAllObjects];
}

-(void)chooseMenu{
	
}

#pragma mark -
#pragma mark init & dealloc

-(id)init{
	self = [super init];
	if (self != nil) {
		self.isTouchEnabled = YES;
        
		totalScore = [GamePlayer sharedGamePlayer].score;
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCSprite *diceGameboardBackground = [CCSprite spriteWithFile:@"testSingleGameBackgroundWithProgress.png"];
        [diceGameboardBackground setPosition:ccp(160, 172)];
		[self addChild:diceGameboardBackground z:ZOrderGameBoard];
		
		superDicePositionArray[0] = enumSuperDiceArrayPosition01;
		superDicePositionArray[1] = enumSuperDiceArrayPosition02;
		superDicePositionArray[2] = enumSuperDiceArrayPosition03;
		superDicePositionArray[3] = enumSuperDiceArrayPosition04;
		superDicePositionArray[4] = enumSuperDiceArrayError;
		
		//Set talk Bubble Action
		talkBubble = [CCSprite spriteWithFile:@"talkBubble.png"];
		[talkBubble setScale:0];
		id delayShowBubble = [CCDelayTime actionWithDuration:0.7];
		id talkBubbleBigAction = [CCScaleTo actionWithDuration:0.3 scale:1.1];
		id talkBubbleSmallAction = [CCScaleTo actionWithDuration:0.15 scale:1];
		id allTalkBubbleAction = [CCSequence actions:delayShowBubble,talkBubbleBigAction,talkBubbleSmallAction, nil];
		[self addChild:talkBubble z:bubbleZOrder];
		
		/* first */
		talkLabel = [TalkLabel spriteWithFile:@"talkLabelBackground.png"];
        [talkLabel setAnchorPoint:ccp(0 , 0)];
		[self addChild:talkLabel z:talkLabelZOrder];
		//[talkLabel setOpacity:0];
		[talkLabel setTag:enumTalkBubbleNPCTalk];
		[talkLabel showLabelAction];
		/* 延遲讓對話框出現 */
		
		/* second */
		superDiceBoard = [SuperDiceGameboard spriteWithFile:@"superDiceGameboard.png"];
		[self addChild:superDiceBoard z:superDiceGameboardZOrder];
		[superDiceBoard setTag:enumTalkBubbleSuperDice];  /* set to 1 */
		superDiceBoard.delegate = self;
		
		/* Third */
		optionSprite = [OptionPanel spriteWithFile:@"talkLabelBackground.png"];
        [optionSprite setAnchorPoint:ccp(0, 0)];
        [self addChild:optionSprite z:talkLabelZOrder];
        [optionSprite setTag:enumTalkBubbleOption];
		optionSprite.delegate = self;
		
		if (screenSize.height > 480) {
			bubbleIPHONE5HeightIncrease = 44 ; //46
			bubbleIPHONE5SuperDiceHeightIncrease = 21 ; //21
		}
		else{
			bubbleIPHONE5HeightIncrease = 0;
			bubbleIPHONE5SuperDiceHeightIncrease = 0;
		}
		[talkBubble setPosition:ccp( bubblePositionWidth , bubblePositionHeight + bubbleIPHONE5HeightIncrease )];
		[talkBubble runAction:allTalkBubbleAction];
		/* first */
		[talkLabel setPosition:ccp( talkLabelPositionWidth, talkLabelPositionHeight + bubbleIPHONE5HeightIncrease + bubbleIPHONE5SuperDiceHeightIncrease )];
        CCLOG(@"*********** talkLabel position = ccp(%.2f,%.2f)" , talkLabel.position.x,talkLabel.position.y);
		/* second */
		/* + 190 because start must hide the superDiceBoard! */
		[superDiceBoard setPosition:ccp( superDiceGameboardWidth  , superDiceGameboardHeight + bubbleIPHONE5HeightIncrease + bubbleIPHONE5SuperDiceHeightIncrease + 160 )];
        /* Third */
        [optionSprite setPosition:ccp(  optionPanelPositionWidth , optionPanelPositionHeight + bubbleIPHONE5HeightIncrease + bubbleIPHONE5SuperDiceHeightIncrease + 160 )];
		
		/* set Array */
		countScoreArray = [[NSMutableArray alloc]init];
		diceArray = [[CCArray alloc]init];
		createDiceArray = [[CCArray alloc]init];
		buffDiceArray = [[CCArray alloc]init];
		superDiceArray = [[CCArray alloc]init];
		tempMovingDice = nil;
		mustMoveDiceNumber = 0;
		CCMenuItemImage *tempButton = [CCMenuItemImage itemFromNormalImage:@"rollButton.png" selectedImage:@"rollButtonPressed.png" target:self selector:@selector(pressedRockDiceButton)];
		for (int i = 0; i < MaxDiceNumber ; i++ ) {
			isGameBoardHasDice[i] = NO;
		}
		for (int i = 0 ; i < 19 ; i++ ) {
			newRoundHavingFourDiceHashNumber[i] = -1;
			havingFourDiceHashNumber[i] = -1;
			for (int j = 0 ;  j < 6 ; j++ ) {
				if (j != 0 ) {
					hashGameBoard[i][j] = -1;
				}
				else{
					hashGameBoard[i][j] = 0;
				}
			}
		}
		/* tempScoreNumber只是為了讓算分的時候知道是哪種分數被擷取到（比方說50 point or 10 point） */
        tempScoreNumber = 0;
        
        showScoreSprite2 = [[CCSprite alloc]initWithFile:@"4point.png"];
        showScoreSprite10 = [[CCSprite alloc] initWithFile:@"20point.png"];
        showScoreSprite50 = [[CCSprite alloc] initWithFile:@"50point.png"];
        [self addChild:showScoreSprite2 z:enumToppestZOrder];
        [self addChild:showScoreSprite10 z:enumToppestZOrder];
        [self addChild:showScoreSprite50 z:enumToppestZOrder];
        [showScoreSprite2 setOpacity:0];
        [showScoreSprite10 setOpacity:0];
        [showScoreSprite50 setOpacity:0];
        
        /* 處理Energy Bar */
        energyBar = [CCProgressTimer progressWithFile:@"energyBar.png"];
        //energyBar.percentage = totalScore + 10;
        energyBar.type = kCCProgressTimerTypeHorizontalBarLR;
        [energyBar setPosition:ccp( 80 , 330 )];
        [self addChild:energyBar z:enumEnergyBar];
        
        /* update score methods. */
        [self scoreUpdateMethod];
        
		talkBubbleTag = 0;

		rollButtonMenu = [CCMenu menuWithItems:tempButton, nil];
		[rollButtonMenu setPosition:ccp(40, 280)];
		[self addChild:rollButtonMenu z:enumStableZOrder];
		[self pressedRockDiceButton];
		
		leading = [[LeadingActress alloc]init];
		[self addChild:leading z:ZOrderLeading];
		[leading setPosition:ccp(screenSize.width*0.72f, screenSize.height*0.56f)];
		id leadingMoveUp = [CCMoveTo actionWithDuration:0.5 position:ccp(screenSize.width*0.72f, screenSize.height*0.565f)];
		id leadingMoveDown = [CCMoveTo actionWithDuration:0.5 position:ccp(screenSize.width*0.72f, screenSize.height*0.558f)];
		id delayTime = [CCDelayTime actionWithDuration:2.0f];
		id allLeadingMoveAction = [CCSequence actions:leadingMoveUp,delayTime,leadingMoveDown,delayTime,delayTime,delayTime,nil];
		id repeatLeadingAction = [CCRepeatForever actionWithAction:allLeadingMoveAction];
		[leading runAction:repeatLeadingAction];
        
        /* 改變對話視窗 */
        
        [self schedule:@selector(changeTalkContext:) interval:20.0f];
        
		/* first,check data exist or not , if not , create it. if existed , load it . */
        
        
        skill03CkeckScore = 0;
        
        [[GameManager sharedGameManager] stopSoundBackground];
        [[GameManager sharedGameManager] playBackgroundTrack:SINGLE_GAME];
	}
	return self;
}

-(void)dealloc{
    [leading release];
    [showScoreSprite2 release];
    [showScoreSprite10 release];
    [showScoreSprite50 release];
    
	[countScoreArray release];
	[diceArray release];
	[createDiceArray release];
	[buffDiceArray release];
	[superDiceArray release];
	[super dealloc];
}

#pragma mark -
#pragma mark ccTouches methods

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	tempMovingDice = nil;
	UITouch *myTouch = [touches anyObject];
	CGPoint touchLocation = [myTouch locationInView:[myTouch view]];
	touchLocation = [[CCDirector sharedDirector]convertToGL:touchLocation];
	/* Handle Gold Dice First!! */
	//CCLOG(@"superDiceArray = %d" , [superDiceArray count]);
	if ( talkBubbleTag == enumTalkBubbleSuperDice && touchLocation.y > 420 && touchLocation.x > 260) {
		[self createSuperDice:1];
		CCLOG(@"作弊 ！！！！！！！！！");
		return;
	}
	if ( touchLocation.y > 320 && touchLocation.x > 160 ){
        CCLOG(@"不處理觸碰NPC動作！");
		return;
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		//[tempSuperDice setOpacity:0];
		
		CGRect superDicePosition = CGRectMake( tempSuperDice.position.x  - tempSuperDice.contentSize.width*0.5 ,
											   tempSuperDice.position.y  - tempSuperDice.contentSize.height*0.5 ,
											  tempSuperDice.contentSize.width,
											  tempSuperDice.contentSize.height);
		
		//CCLOG(@"tempSuperDice = (%4.0f,%4.0f)",tempSuperDice.position.x,tempSuperDice.position.y);
		CGPoint superDiceTouchLocation;
		superDiceTouchLocation.x = touchLocation.x - (superDiceBoard.position.x - superDiceBoard.contentSize.width*0.5);
		superDiceTouchLocation.y = touchLocation.y - (superDiceBoard.position.y - superDiceBoard.contentSize.height*0.5);
		if ( CGRectContainsPoint(superDicePosition, superDiceTouchLocation) ) {
			[superDiceBoard reorderChild:tempSuperDice z:enumMovingZOrder];
			tempMovingDice = tempSuperDice;
			[tempMovingDice selectDiceAnim];
			
			CCLOG(@"Touch Super Dice2!!!!!!");
			return;
		}
	}
	
	/* move dice from createDiceArray */
	for ( Dice *tempDice in createDiceArray  ) {
		if ([tempDice getCanMoveOrNot] == YES) {
			CGRect createDicePosition = CGRectMake(tempDice.position.x - DICE_PIC_WIDTH_helf,
												   tempDice.position.y - DICE_PIC_HEIGHT_helf,
												   DICE_PIC_WIDTH,
												   DICE_PIC_HEIGHT);
			if( CGRectContainsPoint(createDicePosition, touchLocation) ){
				//[tempDice setOpacity:240];
				[self reorderChild:tempDice z:enumMovingZOrder];
				tempMovingDice = tempDice;
				[tempMovingDice selectDiceAnim];
				return;
			}
		}
	}
	/* move dice form diceArray( in gameBoard) */
	for ( Dice *tempDice in diceArray ) {
		if ( [tempDice getCanMoveOrNot]== YES ) {
			
			CGRect dicePosition = CGRectMake(tempDice.position.x - DICE_PIC_WIDTH_helf ,
											 tempDice.position.y - DICE_PIC_HEIGHT_helf ,
											 DICE_PIC_WIDTH,
											 DICE_PIC_HEIGHT);
			if ( CGRectContainsPoint(dicePosition, touchLocation) ) {
				[self reorderChild:tempDice z:enumMovingZOrder];
				tempMovingDice = tempDice;
				[tempMovingDice selectDiceAnim];
				return;
			}
		}
	}
	/* move dice form buffDiceArray */
	for ( Dice *tempDice in buffDiceArray) {
		if ([tempDice getCanMoveOrNot] == YES) {
			CGRect dicePosition = CGRectMake(tempDice.position.x - DICE_PIC_WIDTH_helf,
											 tempDice.position.y - DICE_PIC_HEIGHT_helf,
											 DICE_PIC_WIDTH,
											 DICE_PIC_HEIGHT);
			if (CGRectContainsPoint(dicePosition, touchLocation)) {
				[self reorderChild:tempDice z:enumMovingZOrder];
				tempMovingDice = tempDice;
				[tempMovingDice selectDiceAnim];
				CCLOG(@"This is putDice!!!");
				return;
			}
		}
	}
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if (tempMovingDice == nil) {
		return;
	}
	UITouch *myTouch = [touches anyObject];
	CGPoint touchLocation = [myTouch locationInView:[myTouch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    int x = 0 , y = 0;
    x = touchLocation.x;
    y = touchLocation.y;
    
	if ( tempMovingDice.diceType != enumDiceGold ) {
        if ( touchLocation.x > 298) {
            x = 298;
        }
        else if( touchLocation.x < 20 ){
            x = 20;
        }
        if ( touchLocation.y > 298) {
            y = 298;
        }
        else if(touchLocation.y < 20){
            y = 20;
        }
        [tempMovingDice setPosition:ccp(x, y)];
	}
	else{
        if ( touchLocation.x > 298) {
            x = 298;
        }
        else if( touchLocation.x < 20 ){
            x = 20;
        }
        if ( touchLocation.y > 548) {
            y = 548;
        }
        else if(touchLocation.y < 20){
            y = 20;
        }
        [tempMovingDice setPosition:ccp((x - (superDiceBoard.position.x - superDiceBoard.contentSize.width*0.5)), (y - (superDiceBoard.position.y - superDiceBoard.contentSize.height*0.5)))];
	}
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	CCLOG(@"Must Move Dice number = %d",mustMoveDiceNumber);
	UITouch *myTouch = [touches anyObject];
	CGPoint touchLocation = [myTouch locationInView:[myTouch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	[tempMovingDice unselectDiceAnim];
	
	/* 這裡用來處理更動對話框、以及更換對話等動作 */
    int tempYouchLocationY ;
    if ( [CCDirector sharedDirector].winSize.height > 480) {
        tempYouchLocationY = 520;
    }
    else{
        tempYouchLocationY = 420;
    }
	if ( tempMovingDice == NULL && touchLocation.y > 320 && touchLocation.x > 150 && touchLocation.y <= tempYouchLocationY && touchLocation.x <= 260){
		talkBubbleTag = talkBubbleTag + 1;
        PLAYSOUNDEFFECT(CLICK_BUTTON);
		if (talkBubbleTag >= enumTalkBubbleNumber) {
			talkBubbleTag = talkBubbleTag % enumTalkBubbleNumber;
		}
		switch ( talkBubbleTag ) {
				/* 將 option 視窗移開、將npc Talk移動回來 */
			case enumTalkBubbleNPCTalk:
			{
				[self moveInTalkBubbleWithObject:talkLabel withWidth:talkLabelPositionWidth withHeight:talkLabelPositionHeight+ bubbleIPHONE5SuperDiceHeightIncrease ];
				/* 在Move Out這裡會處理額外的動作，如果以Super Dice gameboard來說！將本身不在Super Dice gameboard 的 Super Dice移動回原來的地方 */
				[self moveOutTalkBubbleWithObject:optionSprite withWidth:optionPanelPositionWidth withHeight:optionPanelPositionHeight + bubbleIPHONE5SuperDiceHeightIncrease ];
			}
				break;
                /* 將 npc Talk 視窗移開、將 super dice Gameboard 移動回來 */
			case enumTalkBubbleSuperDice:
			{
				[self moveInTalkBubbleWithObject:superDiceBoard withWidth:superDiceGameboardWidth withHeight:superDiceGameboardHeight + bubbleIPHONE5SuperDiceHeightIncrease ];
				[self moveOutTalkBubbleWithObject:talkLabel withWidth:talkLabelPositionWidth withHeight:talkLabelPositionHeight+ bubbleIPHONE5SuperDiceHeightIncrease ];
			}
				break;
                /* 將 super Dice Gameboard 視窗移開、將 option 移動回來 */
			case enumTalkBubbleOption:
			{
                [self moveInTalkBubbleWithObject:optionSprite withWidth:optionPanelPositionWidth withHeight:optionPanelPositionHeight + bubbleIPHONE5SuperDiceHeightIncrease];
                [self moveOutTalkBubbleWithObject:superDiceBoard withWidth:superDiceGameboardWidth withHeight:superDiceGameboardHeight + bubbleIPHONE5SuperDiceHeightIncrease];
			}
				break;
			default:
				break;
		}
		return;
	}
    else if( tempMovingDice == NULL && touchLocation.y > 320 && touchLocation.x < 150 && talkBubbleTag == enumTalkBubbleNPCTalk ){
        [talkLabel setContext];
        CCLOG(@"更換對話！！！！");
        return;
    }
	
    /* 處理黃金骰子 */
	if ( tempMovingDice.diceType == enumDiceGold ) {
		CCLOG(@"********  This is GoldDice!!!!  ********");
		// Here is to check finger's position is in GameBoard and without buff position
		CGPoint superDiceTouchLocation;
		superDiceTouchLocation.x = touchLocation.x - (superDiceBoard.position.x - superDiceBoard.contentSize.width*0.5);
		superDiceTouchLocation.y = touchLocation.y - (superDiceBoard.position.y - superDiceBoard.contentSize.height*0.5);
		for ( SuperDice *checkSuperDice in superDiceArray ) {
			if ( tempMovingDice.zOrder == checkSuperDice.zOrder) {
				/* This is Super dice self */
				continue;
			}
			else{
				/* Player can't exchange Super dice because it is the same. */
				CGRect stableSuperDicePosition = CGRectMake(checkSuperDice.position.x - DICE_PIC_WIDTH_helf - 5,
															checkSuperDice.position.y - DICE_PIC_HEIGHT_helf - 5,
															DICE_PIC_WIDTH + 10 , DICE_PIC_HEIGHT + 10 );
				if (CGRectContainsPoint(stableSuperDicePosition, tempMovingDice.position)) {
					[tempMovingDice moveDiceWithPosition:tempMovingDice.recentPosition withGameBoardPosition:tempMovingDice.gameBoardPosition];
					[superDiceBoard reorderChild:tempMovingDice z:enumGoldDiceZOrder];
					return;
				}
			}
		}
		/* 處理超級骰子，擺到一般棋盤上！ */
		for (int i = 0 ; i < MaxDiceNumber - 4 ; i++ ) {
			CGRect tempGameBoardPosition = CGRectMake(  70 + 60 * (i%4) - (superDiceBoard.position.x - superDiceBoard.contentSize.width*0.5),
													  10 + 60 * (i/4) - (superDiceBoard.position.y - superDiceBoard.contentSize.height*0.5) ,
													  tempMovingDice.contentSize.width +10 ,
													  tempMovingDice.contentSize.height +10 );
			if (CGRectContainsPoint(tempGameBoardPosition, superDiceTouchLocation)) {
				if ( tempMovingDice.gameBoardPosition >= 51) {
					superDicePositionArray[(tempMovingDice.gameBoardPosition - 51)] = tempMovingDice.gameBoardPosition;
				}
				[tempMovingDice moveDiceWithPosition:ccp(100 + 60 *(i%4) - (superDiceBoard.position.x - superDiceBoard.contentSize.width*0.5),40 + 60 *(i/4) - (superDiceBoard.position.y - superDiceBoard.contentSize.height*0.5) )
							   withGameBoardPosition:i];
				[superDiceBoard reorderChild:tempMovingDice z:enumGoldDiceZOrder];
				
				tempMovingDice = nil;
				return;
			}
		}
		/* 處理超級骰子，擺到超級骰子棋盤上！ */
		for ( int i = 0 ; i < MaxSuperDiceNumber ; i++ ) {
			//TODO:這裡位置要在詳細的確認一下！！
			CGRect tempSuperDiceArraysPosition = CGRectMake( 5 + 50*(i%2), 5 + /*bubbleIPHONE5SuperDiceHeightIncrease +*/ 50*(i/2) , tempMovingDice.contentSize.width +10 , tempMovingDice.contentSize.height +10);
			if ( superDicePositionArray[i] != enumSuperDiceArrayFill00 ) {
				if ( CGRectContainsPoint(tempSuperDiceArraysPosition, superDiceTouchLocation)) {
					superDicePositionArray[i] = enumSuperDiceArrayFill00;
					if (  tempMovingDice.gameBoardPosition >= 51) {
						superDicePositionArray[tempMovingDice.gameBoardPosition - 51 ] = tempMovingDice.gameBoardPosition;
					}
					[tempMovingDice moveDiceWithPosition:ccp( 32 + 60*(i%2), 31 + /*bubbleIPHONE5SuperDiceHeightIncrease +*/ 60*(i/2)) withGameBoardPosition:enumSuperDiceArrayPosition01+i];
					[superDiceBoard reorderChild:tempMovingDice z:enumGoldDiceZOrder];
					tempMovingDice = nil;
					return;
				}
			}
		}
		/* 移回原位 */
		[tempMovingDice moveDiceWithPosition:tempMovingDice.recentPosition withGameBoardPosition:tempMovingDice.gameBoardPosition];
		[superDiceBoard reorderChild:tempMovingDice z:enumGoldDiceZOrder];
		return;
	}
	if (tempMovingDice == nil) {
		return;
	}
    [tempMovingDice unselectDiceAnim];
    
    /* 如果移動到的地方是 createDice 的 Array  */
	/* change createDiceArray and buffDiceArray to tempMovingDice. */
	for (Dice *tempDice in createDiceArray) {
		CGRect leavePosition = CGRectMake(tempDice.position.x - DICE_PIC_WIDTH_helf,
										  tempDice.position.y - DICE_PIC_HEIGHT_helf,
										  DICE_PIC_WIDTH,
										  DICE_PIC_HEIGHT);
		if( tempDice.zOrder == tempMovingDice.zOrder ){
			continue;
			/* if dice is self and do not change anything. */
		}
		if (CGRectContainsPoint(leavePosition, touchLocation)) {
			CGPoint tempSaveReplacePosition = tempDice.recentPosition;
			int tempGameBoardPosition = tempDice.gameBoardPosition;
			[self reorderChild:tempDice z:enumAutoMovingZOrder];
			[tempDice moveDiceWithPosition:tempMovingDice.recentPosition
					 withGameBoardPosition:tempMovingDice.gameBoardPosition];
			[tempMovingDice moveDiceWithPosition:tempSaveReplacePosition
						   withGameBoardPosition:tempGameBoardPosition];
			[self reorderChild:tempDice z:enumStableZOrder];
			[self reorderChild:tempMovingDice z:enumStableZOrder];
			CCLOG(@"Change two CREATE dice position... tempDice = %d , tempMovingDice = %d" , tempDice.gameBoardPosition , tempMovingDice.gameBoardPosition );
			tempMovingDice = nil;
			return;
		}
	}
    
    /* 如果移動到 buffDiceArray 時 */
	for ( Dice *tempDice in buffDiceArray ) {
		CGRect leavePosition = CGRectMake(tempDice.position.x - DICE_PIC_WIDTH_helf,
										  tempDice.position.y - DICE_PIC_HEIGHT_helf,
										  DICE_PIC_WIDTH,
										  DICE_PIC_HEIGHT);
		if( tempDice.zOrder == tempMovingDice.zOrder ){
			continue;
			/* if dice is self and do not change anything. */
		}
		if ( CGRectContainsPoint(leavePosition, touchLocation) ) {
			CGPoint tempSaveReplacePosition = tempDice.recentPosition;
			int tempGameBoardPosition = tempDice.gameBoardPosition;
			[self reorderChild:tempDice z:enumAutoMovingZOrder];
			
			[tempDice moveDiceWithPosition:tempMovingDice.recentPosition
					 withGameBoardPosition:tempMovingDice.gameBoardPosition];
			[tempMovingDice moveDiceWithPosition:tempSaveReplacePosition
						   withGameBoardPosition:tempGameBoardPosition];
			[self reorderChild:tempDice z:enumStableZOrder];
			[self reorderChild:tempMovingDice z:enumStableZOrder];
			CCLOG(@"Change two CREATE dice position... tempDice = %d , tempMovingDice = %d" , tempDice.gameBoardPosition , tempMovingDice.gameBoardPosition );
			tempMovingDice = nil;
			return;
		}
	}
	CCLOG(@"createDiceArray = %d , diceArray = %d" , [createDiceArray count],[diceArray count]);
	
	/* tempMovingDice move to gameBoard position. */
	for (int i = 0 ; i < MaxDiceNumber ; i++) {
		CGRect gameBoardPosition = CGRectMake( 70 + 60 * (i%4) ,
											  10 + 60 * (i/4),
											  tempMovingDice.contentSize.width +10 ,
											  tempMovingDice.contentSize.height +10 );
        /* 這裡會先判斷是否是兩骰子交換 */
        /* 這裡先確認移動到的地方是否有骰子 */
		if ( isGameBoardHasDice[i] == YES ) {
			/* tempMovingDice exchange diceArray dice */
			for ( Dice *tempDice in diceArray ) {
				if ( tempDice.zOrder == tempMovingDice.zOrder ) {
					continue;
					/*it's your self */
				}
				CGRect gameBoardDicePosition = CGRectMake(tempDice.position.x - DICE_PIC_WIDTH_helf,
														  tempDice.position.y - DICE_PIC_HEIGHT_helf,
														  DICE_PIC_WIDTH , DICE_PIC_HEIGHT);
				
				if ( CGRectContainsPoint(gameBoardDicePosition, touchLocation) ) {
					if ( [tempDice getCanMoveOrNot] == YES ) {
						CGPoint tempSaveDice = tempDice.recentPosition;
						int tempGameBoardPosition = tempDice.gameBoardPosition ;
						[self reorderChild:tempDice z:enumAutoMovingZOrder];
						
						[tempDice moveDiceWithPosition:tempMovingDice.recentPosition
								 withGameBoardPosition:tempMovingDice.gameBoardPosition];
						[tempMovingDice moveDiceWithPosition:tempSaveDice
									   withGameBoardPosition:tempGameBoardPosition];
						[self reorderChild:tempDice z:enumStableZOrder];
						[self reorderChild:tempMovingDice z:enumStableZOrder];
						CCLOG(@"Change two dice , one is diceArray's Dice , another is createDiceArrey's Dice.");
					}
				}
				else{
				}
			}
			/* move buffDiceArray dice */
			for (Dice *tempDice in buffDiceArray ) {
				if ( tempDice.zOrder == tempMovingDice.zOrder ) {
					continue;
					/* it's your self */
				}
				CGRect gameBoardDicePosition = CGRectMake(tempDice.position.x - DICE_PIC_WIDTH_helf,
														  tempDice.position.y - DICE_PIC_HEIGHT_helf,
														  DICE_PIC_WIDTH , DICE_PIC_HEIGHT);
				
				if ( CGRectContainsPoint(gameBoardDicePosition, touchLocation) ) {
					if ( [tempDice getCanMoveOrNot] == YES ) {
						CGPoint tempSaveDice = tempDice.recentPosition;
						int tempGameBoardPosition = tempDice.gameBoardPosition ;
						[self reorderChild:tempDice z:enumAutoMovingZOrder];
						
						[tempDice runAction:[CCMoveTo actionWithDuration:0.2 position:tempMovingDice.recentPosition]];
						[tempDice setRecentPosition:tempMovingDice.recentPosition];
						tempDice.gameBoardPosition = tempMovingDice.gameBoardPosition;
						
						[tempMovingDice runAction:[CCMoveTo actionWithDuration:0.2 position:tempSaveDice]];
						[tempMovingDice setRecentPosition:tempSaveDice];
						tempMovingDice.gameBoardPosition = tempGameBoardPosition;
						[self reorderChild:tempDice z:enumStableZOrder];
						[self reorderChild:tempMovingDice z:enumStableZOrder];
						CCLOG(@"Change two dice , one is diceArray's Dice , another is createDiceArrey's Dice.");
					}
				}
				else{
				}
			}
		}
        
        //TODO:這裡要在詳細的確認一下！！
        /*  */
		/* tempMovingDice move to gameBoard(gameBoard does not have dice). */
		else{
			if( CGRectContainsPoint( gameBoardPosition , touchLocation ) ){
				CCLOG(@"There shouldn't have any Dice !!");
				if ( tempMovingDice.recentPosition.x == 40 ) {
					mustMoveDiceNumber = mustMoveDiceNumber - 1;
					CCLOG(@"muse Moving Dice - 1 !!!");
				}
                [tempMovingDice runAction:[CCMoveTo actionWithDuration:0.2 position:ccp(100 + 60 * (i%4) , 40 + 60 * (i /4))]];
				[tempMovingDice setRecentPosition:ccp(100 + 60 * (i%4), 40 + 60 * (i /4))];
				isGameBoardHasDice[tempMovingDice.gameBoardPosition] = NO;
				[tempMovingDice setGameBoardPosition:i];
                
				isGameBoardHasDice[i] = YES;
				[self reorderChild:tempMovingDice z:enumStableZOrder];
				CCLOG(@"dice array = %d , dice position = %d" , [diceArray count] , tempMovingDice.gameBoardPosition);
				tempMovingDice = nil;
				return;
			}
		}
	}
	[tempMovingDice runAction:[CCMoveTo actionWithDuration:0.2 position:tempMovingDice.recentPosition]];
	[self reorderChild:tempMovingDice z:enumStableZOrder];
	tempMovingDice = nil;
}

# pragma mark -

-(NSString *)getDicePicture:(EnumDiceNumberAndColor)tempDiceType{
	switch (tempDiceType) {
		case enumDiceGold:
			return @"diceGold-568h.png";
			break;
		case enumDice01Blue:
			return @"blueDiceOne.png";
			break;
		case enumDice01Green:
			return @"greenDiceOne.png";
			break;
		case enumDice01Red:
			return @"redDiceOne.png";
			break;
		case enumDice01Yellow:
			return @"yellowDiceOne.png";
			break;
		case enumDice02Blue:
			return @"blueDiceTwo.png";
			break;
		case enumDice02Green:
			return @"greenDiceTwo.png";
			break;
		case enumDice02Red:
			return @"redDiceTwo.png";
			break;
		case enumDice02Yellow:
			return @"yellowDiceTwo.png";
			break;
		case enumDice03Blue:
			return @"blueDiceThree.png";
			break;
		case enumDice03Green:
			return @"greenDiceThree.png";
			break;
		case enumDice03Red:
			return @"redDiceThree.png";
			break;
		case enumDice03Yellow:
			return @"yellowDiceThree.png";
			break;
		case enumDice04Blue:
			return @"blueDiceFour.png";
			break;
		case enumDice04Green:
			return @"greenDiceFour.png";
			break;
		case enumDice04Red:
			return @"redDiceFour.png";
			break;
		case enumDice04Yellow:
			return @"yellowDiceFour.png";
			break;
		case enumDiceError:
			return @"testDiceLocked-568h.png";
			CCLOG(@"Error Dice Image!!!!!!!!");
			break;
		default:
			return @"testDice-568h.png";
			break;
	}
}

/* 以下Function用來做將骰子加入Hash Table以便能確認骰子是否有達到四顆要計算分數。 */
/* sortHashGameBoard:(int)position withDiceType:(int)type 這個Function是用來將骰子資訊加入Hash Table的功能 */
-(void)addDiceToHashGameBoard:(Dice *)tempDice{
	int x = tempDice.gameBoardPosition /4;
	int y = tempDice.gameBoardPosition % 4;
	int varticalArray;
	int horizontalArray;
	int matrixArray;
	varticalArray = y  ;
 	[self sortHashGameBoard:varticalArray withDiceType:tempDice.diceType];
	horizontalArray = 4 + x ;
	[self sortHashGameBoard:horizontalArray withDiceType:tempDice.diceType];
	switch (tempDice.gameBoardPosition) {
		case 0:
			[self sortHashGameBoard:8 withDiceType:tempDice.diceType];
			break;
		case 1:
		case 2:
			[self sortHashGameBoard:(8+y) withDiceType:tempDice.diceType];
			[self sortHashGameBoard:(7+y) withDiceType:tempDice.diceType];
			break;
		case 3:
			[self sortHashGameBoard:10 withDiceType:tempDice.diceType];
			break;
		case 4:
		case 8:
			[self sortHashGameBoard:(8+3*x) withDiceType:tempDice.diceType];
			[self sortHashGameBoard:(8+3*(x-1)) withDiceType:tempDice.diceType];
			break;
		case 5:
		case 6:
		case 9:
		case 10:
			matrixArray = (8+3*x+y);
			[self sortHashGameBoard:matrixArray withDiceType:tempDice.diceType];
			[self sortHashGameBoard:(matrixArray-1) withDiceType:tempDice.diceType];
			[self sortHashGameBoard:(matrixArray-3) withDiceType:tempDice.diceType];
			[self sortHashGameBoard:(matrixArray-4) withDiceType:tempDice.diceType];
			break;
		case 7:
		case 11:
			matrixArray = (7+3*x+y);
			[self sortHashGameBoard:matrixArray withDiceType:tempDice.diceType];
			[self sortHashGameBoard:(matrixArray-3) withDiceType:tempDice.diceType];
			break;
		case 13:
		case 14:
			[self sortHashGameBoard:14+y withDiceType:tempDice.diceType];
			[self sortHashGameBoard:13+y withDiceType:tempDice.diceType];
			break;
		case 12:
			[self sortHashGameBoard:14 withDiceType:tempDice.diceType];
			break;
		case 15:
			[self sortHashGameBoard:16 withDiceType:tempDice.diceType];
			break;
		default:
			break;
	}
	if ( x == y ) {
		[self sortHashGameBoard:18 withDiceType:tempDice.diceType];
	}
	else if ( (x+y) == 3 ) {
		[self sortHashGameBoard:17 withDiceType:tempDice.diceType];
	}
	isGameBoardHasDice[tempDice.gameBoardPosition] = YES;
}

-(void)sortHashGameBoard:(int)tempI withDiceType:(int)diceType{
	/**/
	hashGameBoard[tempI][0]++;
	/* 處理 havingFourDiceHashNumber[] and newRoundHavingFourDiceHashNumber[] */
	if ( hashGameBoard[tempI][0] == 4 ) {
		for (int i = 0 ;  i < 19 ; i++ ) {
			if (havingFourDiceHashNumber[i] == -1 ) {
				havingFourDiceHashNumber[i] = tempI;
				break;
			}
		}
		for (int i = 0 ;  i < 19 ; i++ ) {
			if (newRoundHavingFourDiceHashNumber[i] == -1 ) {
				newRoundHavingFourDiceHashNumber[i] = tempI;
				break;
			}
		}
	}
	else if( hashGameBoard[tempI][0] > 4 ){
		CCLOG(@"ERROR!!!!! sortHashGameBoard: broken!!!!");
	}
	
	/* 這裡只是把骰子排序好（由小到大）*/
	int tempDiceType;
	for (int j = 1 ; j < 5 ; j++ ) {
		if ( hashGameBoard[tempI][j] == -1 ) {
			hashGameBoard[tempI][j] = diceType;
			return;
		}else{
			if( hashGameBoard[tempI][j] < diceType ){
				tempDiceType = hashGameBoard[tempI][j];
				hashGameBoard[tempI][j] = diceType;
				diceType = tempDiceType;
			}
		}
	}
}

-(void)chooseBreakDiceArray{
	for( Dice *tempDiceBreakAnim in diceArray ){
		if ( [tempDiceBreakAnim getUseOrNot] == YES ) {
			[tempDiceBreakAnim breakDice];
		}
	}
	for( SuperDice *tempSuperDice in superDiceArray ) {
		if ( [tempSuperDice getRollDiceOrNot] == YES ) {
			[tempSuperDice breakDice];
		}
	}
}

-(void)sortHavingFourDiceHashNumberArray:(int *)tempArray{
	int tempNumber;
	for (int i = 18 ; i > 1 ; i-- ) {
		if (tempArray[i] == -1) {
			continue;
		}
		for (int j = 0 ; j < i; j++ ) {
			if ( tempArray[j] > tempArray[j+1]) {
				tempNumber = tempArray[j];
				tempArray[j] = tempArray[j+1];
				tempArray[j+1] = tempNumber;
			}
		}
		
	}
}

# pragma mark -
# pragma mark TEST Methods

-(void)remindPlayerDiceMustMove:(Dice *)remindDice{
    id delayRemindTime ;
    if ( [remindDice isKindOfClass:[SuperDice class]]  && talkBubbleTag != enumTalkBubbleSuperDice ) {
        delayRemindTime = [CCDelayTime actionWithDuration:0.7f];
    }
    else{
        delayRemindTime = [CCDelayTime actionWithDuration:0];
    }
	id jumpAction = [CCJumpTo actionWithDuration:remindDiceJumpTime position:ccp(remindDice.position.x, remindDice.position.y) height:16 jumps:1];
	id jumpAction2 = [CCJumpTo actionWithDuration:remindDiceJumpTime position:remindDice.position height:14 jumps:1];
	id jumpAction3 = [CCJumpTo actionWithDuration:remindDiceJumpTime position:remindDice.position height:8 jumps:1];
	id allAction = [CCSequence actions:delayRemindTime,jumpAction,jumpAction2,jumpAction3, nil];
	[remindDice runAction:allAction];
}

-(void)createSuperDiceLogic{
	int createSuperDiceNumber = 0;
	if ( totalScore / enumScoreUpdate  >= 1 ) {
		/* -100後重新計算分數 */
		createSuperDiceNumber = totalScore / enumScoreUpdate;
		totalScore = totalScore % enumScoreUpdate;
	}
	/*　判斷super dice array裡面有沒有已經存在的super，如果沒有，那麼就確認有沒有超過4顆，有就只能補足四顆，沒有就維持原狀　*/
	if ( superDiceArray != nil ) {
		if ( [superDiceArray count] + createSuperDiceNumber > 4 ) {
			createSuperDiceNumber = 4 - [superDiceArray count];
		}
	}
	/* 確認createSuperDiceNumber不會超過四科 */
	else{
		if ( createSuperDiceNumber > 4 ) {
			createSuperDiceNumber = 4;
		}
		else if(createSuperDiceNumber <0){
			createSuperDiceNumber = 0;
		}
	}
	
	if (createSuperDiceNumber != 0) {
		[self createSuperDice:createSuperDiceNumber];
	}
	else{
		/* 確認如果超級骰滿了，但是分數卻有到達產生超級骰子的分數，那麼就特別做處理 */
	}
	/*
	 superDice = [CCSprite spriteWithFile:@"diceGold-568h.png"];
	 
	 for (int i = 0 ; i < createSuperDiceNumber ; i++) {
	 CCSprite *tempDice = [[CCSprite alloc] initWithFile:@"diceGold.png"];
	 [talkBubble addChild:tempDice z:bubbleDiceZOrder];
	 [tempDice setPosition:ccp( 130 + (i/2) * 55, 80 + (i%2) * 55)];
	 }
	 */
}

-(void)createSuperDice:(int)createSuperDiceNumber{
	if ([superDiceArray count] + createSuperDiceNumber > 4) {
		return;
	}
    if (talkBubbleTag != enumTalkBubbleSuperDice) {
        if ( talkBubbleTag == enumTalkBubbleNPCTalk ) {
            [self moveOutTalkBubbleWithObject:talkLabel withWidth:talkLabelPositionWidth withHeight:talkLabelPositionHeight + bubbleIPHONE5SuperDiceHeightIncrease];
            [self moveInTalkBubbleWithObject:superDiceBoard withWidth:superDiceGameboardWidth withHeight:superDiceGameboardHeight + bubbleIPHONE5SuperDiceHeightIncrease];
        }
        else{
            [self moveOutTalkBubbleWithObject:optionSprite withWidth:talkLabelPositionWidth withHeight:talkLabelPositionHeight + bubbleIPHONE5SuperDiceHeightIncrease];
            [self moveInTalkBubbleWithObject:superDiceBoard withWidth:superDiceGameboardWidth withHeight:superDiceGameboardHeight + bubbleIPHONE5SuperDiceHeightIncrease];
        }
        talkBubbleTag = enumTalkBubbleSuperDice;
    }
	/* superDicePositionArray　是用來保存超級骰子目前已經被佔用的位置 */
	int runPosition = 0;
	if (superDiceArray.count != 0) {
		/* 此為跑陣列裡面沒用過空格的暫存i值 */
		for ( SuperDice *tempCheckDice in superDiceArray ) {
			/* 從裡面取得骰子的位置，將checkPositionArray陣列的位置設定為已經填滿 */
			superDicePositionArray[ (tempCheckDice.gameBoardPosition - 51) ] = enumSuperDiceArrayFill00;
		}
	}
	for (int i = 0 ; i < createSuperDiceNumber ; i++ ) {
		SuperDice *tempSuperDice = [[SuperDice alloc]initWithFile:[self getDicePicture:enumDiceGold] withDiceType:enumDiceGold withRecentPosition:ccp(0, 0)];
		/* 讓runPosition的職能確保是在沒有站到位置的空間 */
		while (superDicePositionArray[runPosition] == enumSuperDiceArrayFill00) {
			runPosition++;
		}
		tempSuperDice.gameBoardPosition = superDicePositionArray[runPosition];
		/* 將新增的骰子加入checkPositionArray之中，並且count + 1 */
		superDicePositionArray[runPosition] = enumSuperDiceArrayFill00;
		runPosition++;
		
		[superDiceBoard addChild:tempSuperDice z:enumGoldDiceZOrder];
		[superDiceArray addObject:tempSuperDice];
		//[tempSuperDice runAction:[CCFadeOut actionWithDuration:0]];
		CCLOG(@"tempSuperDice.gameBoardPosition = %d" , tempSuperDice.gameBoardPosition);
		CGPoint temp ;
		[self superDicePosition:tempSuperDice.gameBoardPosition withCGPoint:(&temp)];
		CCLOG(@"temp.x = %f , temp.y = %f" , temp.x , temp.y);
		[tempSuperDice setPosition:temp];
		tempSuperDice.recentPosition = CGPointMake(temp.x, temp.y);
		[tempSuperDice release];
		tempSuperDice = nil;
	}
}

-(void)superDicePosition:(EnumSuperDicePosition)tempSuperDicePosition withCGPoint:(CGPoint *)tempCGPoint{
	switch (tempSuperDicePosition) {
		case enumSuperDiceArrayPosition01:
			tempCGPoint->x = 32;
			tempCGPoint->y = 31;
			break;
		case enumSuperDiceArrayPosition02:
			tempCGPoint->x = 92;
			tempCGPoint->y = 31;
			break;
		case enumSuperDiceArrayPosition03:
			tempCGPoint->x = 32;
			tempCGPoint->y = 91;
			break;
		case enumSuperDiceArrayPosition04:
			tempCGPoint->x = 92;
			tempCGPoint->y = 91;
			break;
		default:
			break;
	}
}

-(void)setTouchScreen{
	if ( self.isTouchEnabled == NO ) {
		[self setIsTouchEnabled:YES] ;
		[rollButtonMenu setIsTouchEnabled:YES];
        [optionSprite setTouchScreen:YES];
		CCLOG(@"Set touch screen to YES!!!!!");
	}
	else{
		[self setIsTouchEnabled:NO];
		[rollButtonMenu setIsTouchEnabled:NO];
        [optionSprite setTouchScreen:NO];
		CCLOG(@"Set touch screen to NO!!!!!");
	}
}

-(void)removeDiceToHashGameBoard:(Dice *)tempDice{
	int x = tempDice.gameBoardPosition /4;
	int y = tempDice.gameBoardPosition % 4;
	int varticalArray;
	int horizontalArray;
	int matrixArray;
	varticalArray = y  ;
 	[self findHashGameBoard:varticalArray withDiceType:tempDice.diceType];
	horizontalArray = 4 + x ;
	[self findHashGameBoard:horizontalArray withDiceType:tempDice.diceType];
	switch (tempDice.gameBoardPosition) {
		case 0:
			[self findHashGameBoard:8 withDiceType:tempDice.diceType];
			break;
		case 1:
		case 2:
			[self findHashGameBoard:(8+y) withDiceType:tempDice.diceType];
			[self findHashGameBoard:(7+y) withDiceType:tempDice.diceType];
			break;
		case 3:
			[self findHashGameBoard:10 withDiceType:tempDice.diceType];
			break;
		case 4:
		case 8:
			[self findHashGameBoard:(8+3*x) withDiceType:tempDice.diceType];
			[self findHashGameBoard:(8+3*(x-1)) withDiceType:tempDice.diceType];
			break;
		case 5:
		case 6:
		case 9:
		case 10:
			matrixArray = (8+3*x+y);
			[self findHashGameBoard:matrixArray withDiceType:tempDice.diceType];
			[self findHashGameBoard:(matrixArray-1) withDiceType:tempDice.diceType];
			[self findHashGameBoard:(matrixArray-3) withDiceType:tempDice.diceType];
			[self findHashGameBoard:(matrixArray-4) withDiceType:tempDice.diceType];
			break;
		case 7:
		case 11:
			matrixArray = (7+3*x+y);
			[self findHashGameBoard:matrixArray withDiceType:tempDice.diceType];
			[self findHashGameBoard:(matrixArray-3) withDiceType:tempDice.diceType];
			break;
		case 13:
		case 14:
			[self findHashGameBoard:14+y withDiceType:tempDice.diceType];
			[self findHashGameBoard:13+y withDiceType:tempDice.diceType];
			break;
		case 12:
			[self findHashGameBoard:14 withDiceType:tempDice.diceType];
			break;
		case 15:
			[self findHashGameBoard:16 withDiceType:tempDice.diceType];
			break;
		default:
			break;
	}
	if ( x == y ) {
		[self findHashGameBoard:18 withDiceType:tempDice.diceType];
	}
	else if ( (x+y) == 3 ) {
		[self findHashGameBoard:17 withDiceType:tempDice.diceType];
	}
	isGameBoardHasDice[tempDice.gameBoardPosition] = NO;
}

-(void)findHashGameBoard:(int)tempI withDiceType:(int)diceType{
	// 將目前存在havingFourDiceHashGameboard 裡面存的「已經有四個骰子的Hash index」刪除！
	if ( hashGameBoard[tempI][0] == 4 ) {
		for (int i = 0 ; i < 19 ; i++ ) {
			if ( havingFourDiceHashNumber[i] == tempI ) {
				havingFourDiceHashNumber[i] = -1;
				break;
			}
		}
		for (int i = 0 ;  i < 19 ; i++ ) {
			if (newRoundHavingFourDiceHashNumber[i] == tempI) {
				newRoundHavingFourDiceHashNumber[i] = -1;
				break;
			}
		}
	}
	else if( hashGameBoard[tempI][0] > 4){
		CCLOG(@"ERROR in findGashGameBoard: methods!!!!!!!!\n");
	}
	
	for (int j = MaxCountScoreDiceNumber ; j > 0 ; j--) {
		if (hashGameBoard[tempI][j] == diceType) {
			hashGameBoard[tempI][j] = -1;
			break;
		}
	}
	
	for (int j = 1 ; j < MaxCountScoreDiceNumber ; j++) {
		if (hashGameBoard[tempI][j] < hashGameBoard[tempI][j+1]) {
			int tempNumber = hashGameBoard[tempI][j];
			hashGameBoard[tempI][j] = hashGameBoard[tempI][j+1];
			hashGameBoard[tempI][j+1] = tempNumber;
		}
	}
	hashGameBoard[tempI][0]--;
}

/* 找到再super dice array背後的骰子，並且移除 */
-(void)findDiceBehindSuperDice{
	CCArray *removeDiceArray = [CCArray array];
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition >= 0 && tempSuperDice.gameBoardPosition <=15) {
			for ( Dice *tempDice in diceArray ) {
				if (tempSuperDice.gameBoardPosition == tempDice.gameBoardPosition) {
					[removeDiceArray addObject:tempDice];
					[self removeDiceToHashGameBoard:tempDice];
					[tempDice removeFromParentAndCleanup:YES];
				}
			}
			[diceArray addObject:tempSuperDice];
			[self addDiceToHashGameBoard:tempSuperDice];
			[tempSuperDice setRollDiceOrNot:YES];
		}
	}
	[diceArray removeObjectsInArray:removeDiceArray];
}

-(BOOL)checkDelayTimeAdd{
	for (int i = 0 ;  i < 19 ; i++) {
		if (hashGameBoard[i][4] == -1) {
			continue;
		}
        /* 確認如果骰子是四個（上面的if），且有符合銷掉邏輯的時候，就要跑骰子消失的動畫（預留時間給他跑） */
		if ( [self checkScoreLogicWithFirst:hashGameBoard[i][4]
								 withSecond:hashGameBoard[i][3]
								  withThird:hashGameBoard[i][2]
								 withFourth:hashGameBoard[i][1]] ) {
			return YES;
		}
	}
    /* 確認超級骰子在棋盤上，所以就要跑消失的動畫（預留時間給他跑） */
	for ( SuperDice *checkSuperDice in superDiceArray ) {
		if ( checkSuperDice.gameBoardPosition < 50 ) {
			return YES;
		}
	}
	return NO;
}

-(void)scoreUpdateMethod{
    if ( totalScore >= enumScoreUpdate) {
        int tempNumber = totalScore;
        tempNumber = tempNumber % enumScoreUpdate;
        energyBar.percentage = tempNumber ;
    }
    else{
        energyBar.percentage = totalScore;
    }
    [[GamePlayer sharedGamePlayer] setScore:totalScore];
}

-(BOOL)useSkillOrNotWithProbability:(int)probability{
    int number = arc4random()%probability;
    CCLOG(@"number = %d" , number);
    if ( number == 0) {
        return YES;
    }
    else{
        return NO;
    }
}

-(void)runSkillMethod{
    switch ( [GamePlayer sharedGamePlayer].recentSkill ) {
        case enumSkillName01:
            CCLOG(@"In Skill01");
            if ( [self useSkillOrNotWithProbability:2] ) {
                if ( [diceArray count] > 0 ) {
                    Dice *tempSkillDice = [diceArray objectAtIndex:(arc4random()%[diceArray count])];
                    [tempSkillDice setCanMoveOrNot:YES];
                    //[tempMovingDice setRecentPosition:ccp(100 + 60 * (i%4), 40 + 60 * (i /4))];
                    
                    [self removeDiceToHashGameBoard:tempSkillDice];
                    isGameBoardHasDice[tempSkillDice.gameBoardPosition] = YES;
                }
            }
            if ( [diceArray count] == 0 ) {
                totalScore = totalScore + 10;
                [self scoreUpdateMethod];
                [self showScoreGameboardWithPosition:12 withScore:enumScoreFourDiceTheSameColorEnum];
            }
            break;
        case enumSkillName02:
            if ( [diceArray count] == 16 && [superDiceArray count]==0 ) {
                if ( [self useSkillOrNotWithProbability:2] ) {
                    [self resetAllDice];
                }
            }
            break;
            
        case enumSkillName03:
            CCLOG(@" totalScore = %d" , totalScore);
            if ( [self useSkillOrNotWithProbability:2] ) {
                if ( skill03CkeckScore > 0 ) {
                    skill03CkeckScore = (int)(skill03CkeckScore * SKILL03_MULTI_NUMBER /2);
                    CCLOG(@"這次增加了 %d 分！！！！！" , skill03CkeckScore );
                    totalScore = totalScore + skill03CkeckScore;
                    [[GamePlayer sharedGamePlayer] setScore:totalScore];
                    [self scoreUpdateMethod];
                }
            }
            break;
        case enumSkillName04:
            break;
        case enumSkillName05:
            break;
        case enumSkillName06:
            break;
        default:
            break;
    }
    skill03CkeckScore = 0;
}

-(void)changeTalkContext:(NSSet *)touch{
    for ( SuperDice *tempSuperDice in superDiceArray ) {
        if ( tempSuperDice.position.y <= -40) {
            return;
        }
    }
    if ( tempMovingDice == nil && talkBubbleTag != enumTalkBubbleNPCTalk ) {
        if ( talkBubbleTag == enumTalkBubbleOption) {
            [self moveOutTalkBubbleWithObject:optionSprite withWidth:talkLabelPositionWidth withHeight:talkLabelPositionHeight + bubbleIPHONE5SuperDiceHeightIncrease];
            [self moveInTalkBubbleWithObject:talkLabel withWidth:talkLabelPositionWidth withHeight:talkLabelPositionHeight + bubbleIPHONE5SuperDiceHeightIncrease];
            talkBubbleTag = enumTalkBubbleNPCTalk;
        }
        else{
            [self moveOutTalkBubbleWithObject:superDiceBoard withWidth:talkLabelPositionWidth withHeight:talkLabelPositionHeight + bubbleIPHONE5SuperDiceHeightIncrease];
            [self moveInTalkBubbleWithObject:talkLabel withWidth:talkLabelPositionWidth withHeight:talkLabelPositionHeight + bubbleIPHONE5SuperDiceHeightIncrease];
            talkBubbleTag = enumTalkBubbleNPCTalk;
        }
    }
    [talkLabel setContext];
}

-(void)playBreakDiceMp3{
    PLAYSOUNDEFFECT(BREAK_DICE);
}

#pragma mark -
#pragma mark TalkBubbleMethods
#pragma mark Delegate

-(void)showWarningDelegate{
    [self setTouchScreen];
    yesNoBackground = [CCSprite spriteWithFile:@"yesNoBackground.png"];
    CCMenuItemImage *yesButton = [CCMenuItemImage itemFromNormalImage:@"yesButton.png"
                                                        selectedImage:@"yesButtonSelected.png"
                                                        disabledImage:nil
                                                               target:self
                                                             selector:@selector(confirmToStartFirstPlayScene)];
    CCMenuItemImage *noButton = [CCMenuItemImage itemFromNormalImage:@"noButton.png"
                                                       selectedImage:@"noButtonSelected.png"
                                                       disabledImage:nil
                                                              target:self
                                                            selector:@selector(backToGame)];
    [noButton setScale:2.0f];
    yesNoMenu = [CCMenu menuWithItems:yesButton,noButton, nil];
    [yesNoMenu alignItemsHorizontallyWithPadding:100.0f];
    [yesNoMenu setPosition:ccp(150, 90)];
    [yesNoBackground addChild:yesNoMenu];
    [self addChild:yesNoBackground z:1000];
    [yesNoBackground setPosition:ccp(160, 240)];
}

-(void)confirmToStartFirstPlayScene{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
    [[GameManager sharedGameManager] runSceneWithID:enumFirstPlayScene];
}

-(void)backToGame{
    [yesNoMenu removeFromParentAndCleanup:YES];
    [yesNoBackground removeFromParentAndCleanup:YES];
    [self setTouchScreen];
}

-(void)showGameboardDelegate{
	[superDiceBoard setVisible:YES];
	if ( talkBubbleTag != enumTalkBubbleSuperDice ) {
		id otherFadeOut = [CCFadeOut actionWithDuration:0.01f];
		id otherFadeIn = [CCFadeIn actionWithDuration:0.01f];
		id otherDelayTime = [CCDelayTime actionWithDuration:animationCountScoreTime*2];
		id otherAllAction = [CCSequence actions:otherFadeOut,otherDelayTime,otherFadeIn, nil];
		if ( talkBubbleTag == enumTalkBubbleNPCTalk ) {
			[talkBubble runAction:otherAllAction];
		}
		else{
			
		}
	}
	id fadeInAction = [CCFadeIn actionWithDuration:animationDiceBreakTime];
	id fadeOutAction = [CCFadeOut actionWithDuration:animationCountScoreTime];
	id allAction = [CCSequence actions:fadeInAction,fadeOutAction, nil];
	[superDiceBoard runAction:allAction];
}

-(void)showScoreGameboardWithPosition:(int)showScorePosition withScore:(EnumscoreNumberEnum)showScore{
    CCSprite **tempScoreSprite = NULL ;
    switch (showScore) {
        case enumScoreFourDiceDifColorDifNumber:
            tempScoreSprite = &showScoreSprite2;
            break;
        case enumScoreFourDiceTheSameColorEnum:
            tempScoreSprite = &showScoreSprite10;
            break;
        case enumScoreFourDiceTheSameColorTheSameNumberEnum:
            tempScoreSprite = &showScoreSprite50;
            break;
        default:
            CCLOG(@"Program shouldn't come here!!!");
            break;
    }
    switch (showScorePosition) {
        case 0:
            [*tempScoreSprite setPosition:ccp( 100 , 130)];
            CCLOG(@"position = ccp(100,130)");
            break;
        case 1:
            [*tempScoreSprite setPosition:ccp( 160 , 130)];
            break;
        case 2:
            [*tempScoreSprite setPosition:ccp( 220 , 130)];
            break;
        case 3:
            [*tempScoreSprite setPosition:ccp( 280 , 130)];
            break;
        case 4:
            [*tempScoreSprite setPosition:ccp( 190 , 40)];
            break;
        case 5:
            [*tempScoreSprite setPosition:ccp( 190 , 100)];
            break;
        case 6:
            [*tempScoreSprite setPosition:ccp( 190 , 160)];
            break;
        case 7:
            [*tempScoreSprite setPosition:ccp( 190 , 220)];
            break;
        case 8:
            [*tempScoreSprite setPosition:ccp( 130 , 70)];
            break;
        case 9:
            [*tempScoreSprite setPosition:ccp( 190 , 70)];
            break;
        case 10:
            [*tempScoreSprite setPosition:ccp( 250 , 70)];
            break;
        case 11:
            [*tempScoreSprite setPosition:ccp( 130 , 130)];
            break;
        case 12:
        case 17:
        case 18:
            [*tempScoreSprite setPosition:ccp( 190 , 130)];
            break;
        case 13:
            [*tempScoreSprite setPosition:ccp( 250 , 130)];
            break;
        case 14:
            [*tempScoreSprite setPosition:ccp( 130 , 190)];
            break;
        case 15:
            [*tempScoreSprite setPosition:ccp( 190 , 190)];
            break;
        case 16:
            [*tempScoreSprite setPosition:ccp( 250 , 190)];
            break;
        default:
            [*tempScoreSprite setPosition:ccp(30, 30)];
            CCLOG(@"Program shouldn't come here!!!");
            break;
    }
    
    [*tempScoreSprite setScale:0];
    CCFadeIn *showScoreFadeIn = [CCFadeIn actionWithDuration:animationDiceBreakTime*0.4f];
    CCDelayTime *showScoreDelayTime = [CCDelayTime actionWithDuration:0.45f];
    CCFadeOut *showScoreFadeOut = [CCFadeOut actionWithDuration:animationCountScoreTime*0.1f];
    CCSequence *showScoreAction = [CCSequence actions:showScoreFadeIn,showScoreDelayTime,showScoreFadeOut, nil];
    [*tempScoreSprite runAction:showScoreAction];
    
    id bigAction = [CCScaleTo actionWithDuration:animationDiceBreakTime*0.3 scale:1.2];
	id easeBigAction = [CCEaseIn actionWithAction:bigAction rate:3];
	id smallAction = [CCScaleTo actionWithDuration:animationDiceBreakTime*0.1 scale:1];
	id easeSmallAction = [CCEaseIn actionWithAction:smallAction rate:3];
	id tintAction = [CCTintTo actionWithDuration:animationDiceBreakTime*0.35 red:255 green:255 blue:255];
	id tintAction2 = [CCTintTo actionWithDuration:animationDiceBreakTime*0.65 red:170 green:170 blue:170];
	id allTintAction = [CCSequence actionOne:tintAction two:tintAction2];
	[*tempScoreSprite runAction:allTintAction];
	id allAction = [CCSequence actions:easeBigAction,easeSmallAction, nil];
	[*tempScoreSprite runAction:allAction];
    [self scoreUpdateMethod];
}

-(void)moveInTalkBubbleWithObject:(id)object withWidth:(int)width withHeight:(int)height{
	[object setPosition:ccp( width , height  + bubbleIPHONE5HeightIncrease  +200 )];
	id moveInAction = [CCMoveTo actionWithDuration:ANIMATION_TALK_BUBBLE_MOVE_TIME*0.4f position:ccp( width , height + bubbleIPHONE5HeightIncrease  )];
	id moveInFadeIn = [CCFadeIn actionWithDuration:ANIMATION_TALK_BUBBLE_MOVE_TIME*0.3f];
	[object runAction:moveInAction];
	[object runAction:moveInFadeIn];
}

-(void)moveOutTalkBubbleWithObject:(id)object withWidth:(int)width withHeight:(int)height{
	id moveOutAction = [CCMoveTo actionWithDuration:ANIMATION_TALK_BUBBLE_MOVE_TIME*0.4f position:ccp( width - 300 , height + bubbleIPHONE5HeightIncrease )];
	id moveOutFadeOut = [CCFadeOut actionWithDuration:ANIMATION_TALK_BUBBLE_MOVE_TIME*0.3f];
	[object runAction:moveOutAction];
	[object runAction:moveOutFadeOut];
	if ( [object isKindOfClass:[superDiceBoard class]] ) {
		int countI = 0;
		for ( SuperDice *moveSuperDice in superDiceArray ) {
			if (moveSuperDice.gameBoardPosition < 51) {
				for ( countI = 0 ; countI < 4; countI++) {
					if ( superDicePositionArray[countI] != enumSuperDiceArrayFill00 ) {
						break;
					}
				}
				superDicePositionArray[countI] = enumSuperDiceArrayFill00;
				countI = countI + 51 ;
				CGPoint tempPoint;
				[self superDicePosition:countI withCGPoint:&tempPoint];
				[moveSuperDice moveDiceWithPosition:tempPoint withGameBoardPosition:countI];
			}
		}
	}
}


# pragma mark -
# pragma mark Special Skill

-(void)resetAllDice{
	for (int i = 0 ; i < 19 ; i++) {
		hashGameBoard[i][0] = 0;
		hashGameBoard[i][1] = -1;
		hashGameBoard[i][2] = -1;
		hashGameBoard[i][3] = -1;
		hashGameBoard[i][4] = -1;
		hashGameBoard[i][5] = -1;
	}
	for (int i = 0 ; i < 19; i++) {
		havingFourDiceHashNumber[i] = -1;
		newRoundHavingFourDiceHashNumber[i] = -1;
	}
	for ( Dice *tempResetDice in diceArray ) {
		[tempResetDice setCanMoveOrNot:YES];
		[tempMovingDice setColor:ccc3(255, 255, 255)];
	}
}

# pragma mark -
# pragma mark 測試用

-(void)testHashGameTable{
	for (int i = 0 ; i < 19 ; i++ ) {
		for (int j = 0 ;  j < 6 ; j++ ) {
			if (j == 0 ) {
                printf("%2d " , hashGameBoard[i][j] );
				printf(" |%2d|" , i);
			}
            else{
                switch ( hashGameBoard[i][j] ) {
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                        printf("藍%d " , hashGameBoard[i][j]);
                        break;
                    case 5:
                    case 6:
                    case 7:
                    case 8:
                        printf("綠%d " , (hashGameBoard[i][j]-1)%4+1);
                        break;
                    case 9:
                    case 10:
                    case 11:
                    case 12:
                        printf("紅%d " , (hashGameBoard[i][j]-1)%4+1);
                        break;
                    case 13:
                    case 14:
                    case 15:
                    case 16:
                        printf("黃%d" , (hashGameBoard[i][j]-1)%4+1);
                        break;
                    default:
                        printf("--");
                        break;
                }
                if (j == 5) {
                    hashGameBoard[i][j] = -1;
                    printf("\n");
                }
            }
	 	}
	}
	for ( int j = 0 ; j < [diceArray count] ; j++ ) {
		Dice *tempDice = [diceArray objectAtIndex:j];
		CCLOG(@"index: %d , dicePosition: %d" , j , tempDice.gameBoardPosition );
	}
	for (int i = MaxDiceNumber - 1 ; i >= 0 ; i-- ) {
		printf("%d" , isGameBoardHasDice[4-i] );
		if ( i%4 == 0) {
			printf("\n");
		}
		else{
			printf(",");
		}
	}
	for (int i = 0 ; i < 18 ; i++ ) {
		CCLOG(@"havingFourDiceHashNumber = %d" , havingFourDiceHashNumber[i] );
	}
	CCLOG(@"diceArray = %d , createDiceArray = %d" , [diceArray count],[createDiceArray count]);
	CCLOG(@"buffDiceArray = %d" , [buffDiceArray count]);
	CCLOG(@"diceArray = %d" , [diceArray count]);
}


#pragma mark -
#pragma mark ActionAnimations

-(void)action00{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 0 ||
			tempDice.gameBoardPosition == 4 ||
			tempDice.gameBoardPosition == 8 ||
			tempDice.gameBoardPosition == 12) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[0][4]
									withSecond:hashGameBoard[0][3]
									 withThird:hashGameBoard[0][2]
									withFourth:hashGameBoard[0][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:0 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                //PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 0 ||
			tempSuperDice.gameBoardPosition == 4 ||
			tempSuperDice.gameBoardPosition == 8 ||
			tempSuperDice.gameBoardPosition == 12) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action01{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 1 ||
			tempDice.gameBoardPosition == 5 ||
			tempDice.gameBoardPosition == 9 ||
			tempDice.gameBoardPosition == 13) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[1][4]
									withSecond:hashGameBoard[1][3]
									 withThird:hashGameBoard[1][2]
									withFourth:hashGameBoard[1][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:1 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                //PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 1 ||
			tempSuperDice.gameBoardPosition == 5 ||
			tempSuperDice.gameBoardPosition == 9 ||
			tempSuperDice.gameBoardPosition == 13) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action02{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 2 ||
			tempDice.gameBoardPosition == 6 ||
			tempDice.gameBoardPosition == 10 ||
			tempDice.gameBoardPosition == 14) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if (
				[self countScoreLogicWithFirst:hashGameBoard[2][4]
									withSecond:hashGameBoard[2][3]
									 withThird:hashGameBoard[2][2]
									withFourth:hashGameBoard[2][1]]) {
					[tempDiceArray[0] setUseOrNot:YES];
					[tempDiceArray[1] setUseOrNot:YES];
					[tempDiceArray[2] setUseOrNot:YES];
					[tempDiceArray[3] setUseOrNot:YES];
                    [self showScoreGameboardWithPosition:2 withScore:tempScoreNumber];
                    PLAYSOUNDEFFECT(COUNT_SCORE_YES);
            }
            else{
                PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                //PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 2 ||
			tempSuperDice.gameBoardPosition == 6 ||
			tempSuperDice.gameBoardPosition == 10 ||
			tempSuperDice.gameBoardPosition == 14) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action03{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 3 ||
			tempDice.gameBoardPosition == 7 ||
			tempDice.gameBoardPosition == 11 ||
			tempDice.gameBoardPosition == 15) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[3][4]
									withSecond:hashGameBoard[3][3]
									 withThird:hashGameBoard[3][2]
									withFourth:hashGameBoard[3][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:3 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                //PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 3 ||
			tempSuperDice.gameBoardPosition == 7 ||
			tempSuperDice.gameBoardPosition == 11 ||
			tempSuperDice.gameBoardPosition == 15) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action04{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 0 ||
			tempDice.gameBoardPosition == 1 ||
			tempDice.gameBoardPosition == 2 ||
			tempDice.gameBoardPosition == 3) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[4][4]
									withSecond:hashGameBoard[4][3]
									 withThird:hashGameBoard[4][2]
									withFourth:hashGameBoard[4][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:4 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                //PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 0 ||
			tempSuperDice.gameBoardPosition == 1 ||
			tempSuperDice.gameBoardPosition == 2 ||
			tempSuperDice.gameBoardPosition == 3) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action05{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 4 ||
			tempDice.gameBoardPosition == 5 ||
			tempDice.gameBoardPosition == 6 ||
			tempDice.gameBoardPosition == 7) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[5][4]
									withSecond:hashGameBoard[5][3]
									 withThird:hashGameBoard[5][2]
									withFourth:hashGameBoard[5][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:5 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                //PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 4 ||
			tempSuperDice.gameBoardPosition == 5 ||
			tempSuperDice.gameBoardPosition == 6 ||
			tempSuperDice.gameBoardPosition == 7) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action06{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 8 ||
			tempDice.gameBoardPosition == 9 ||
			tempDice.gameBoardPosition == 10 ||
			tempDice.gameBoardPosition == 11) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[6][4]
									withSecond:hashGameBoard[6][3]
									 withThird:hashGameBoard[6][2]
									withFourth:hashGameBoard[6][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:6 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                //PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 8 ||
			tempSuperDice.gameBoardPosition == 9 ||
			tempSuperDice.gameBoardPosition == 10 ||
			tempSuperDice.gameBoardPosition == 11) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action07{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 12 ||
			tempDice.gameBoardPosition == 13 ||
			tempDice.gameBoardPosition == 14 ||
			tempDice.gameBoardPosition == 15) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[7][4]
									withSecond:hashGameBoard[7][3]
									 withThird:hashGameBoard[7][2]
									withFourth:hashGameBoard[7][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:7 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                //PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 12 ||
			tempSuperDice.gameBoardPosition == 13 ||
			tempSuperDice.gameBoardPosition == 14 ||
			tempSuperDice.gameBoardPosition == 15) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action08{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 0 ||
			tempDice.gameBoardPosition == 1 ||
			tempDice.gameBoardPosition == 4 ||
			tempDice.gameBoardPosition == 5) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if (
				[self countScoreLogicWithFirst:hashGameBoard[8][4]
									withSecond:hashGameBoard[8][3]
									 withThird:hashGameBoard[8][2]
									withFourth:hashGameBoard[8][1]]) {
					[tempDiceArray[0] setUseOrNot:YES];
					[tempDiceArray[1] setUseOrNot:YES];
					[tempDiceArray[2] setUseOrNot:YES];
					[tempDiceArray[3] setUseOrNot:YES];
                    [self showScoreGameboardWithPosition:8 withScore:tempScoreNumber];
                    PLAYSOUNDEFFECT(COUNT_SCORE_YES);
            }
            else{
                PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                //PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 0 ||
			tempSuperDice.gameBoardPosition == 1 ||
			tempSuperDice.gameBoardPosition == 4 ||
			tempSuperDice.gameBoardPosition == 5) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action09{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 1 ||
			tempDice.gameBoardPosition == 2 ||
			tempDice.gameBoardPosition == 5 ||
			tempDice.gameBoardPosition == 6) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[9][4]
									withSecond:hashGameBoard[9][3]
									 withThird:hashGameBoard[9][2]
									withFourth:hashGameBoard[9][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:9 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                //PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 1 ||
			tempSuperDice.gameBoardPosition == 2 ||
			tempSuperDice.gameBoardPosition == 5 ||
			tempSuperDice.gameBoardPosition == 6) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action10{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 2 ||
			tempDice.gameBoardPosition == 3 ||
			tempDice.gameBoardPosition == 6 ||
			tempDice.gameBoardPosition == 7) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[10][4]
									withSecond:hashGameBoard[10][3]
									 withThird:hashGameBoard[10][2]
									withFourth:hashGameBoard[10][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:10 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                //PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 2 ||
			tempSuperDice.gameBoardPosition == 3 ||
			tempSuperDice.gameBoardPosition == 6 ||
			tempSuperDice.gameBoardPosition == 7) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action11{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 4 ||
			tempDice.gameBoardPosition == 5 ||
			tempDice.gameBoardPosition == 8 ||
			tempDice.gameBoardPosition == 9) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[11][4]
									withSecond:hashGameBoard[11][3]
									 withThird:hashGameBoard[11][2]
									withFourth:hashGameBoard[11][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:11 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                //PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 4 ||
			tempSuperDice.gameBoardPosition == 5 ||
			tempSuperDice.gameBoardPosition == 8 ||
			tempSuperDice.gameBoardPosition == 9) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action12{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 5 ||
			tempDice.gameBoardPosition == 6 ||
			tempDice.gameBoardPosition == 9 ||
			tempDice.gameBoardPosition == 10) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[12][4]
									withSecond:hashGameBoard[12][3]
									 withThird:hashGameBoard[12][2]
									withFourth:hashGameBoard[12][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:12 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                //PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 5 ||
			tempSuperDice.gameBoardPosition == 6 ||
			tempSuperDice.gameBoardPosition == 9 ||
			tempSuperDice.gameBoardPosition == 10) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action13{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 6 ||
			tempDice.gameBoardPosition == 7 ||
			tempDice.gameBoardPosition == 10 ||
			tempDice.gameBoardPosition == 11) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[13][4]
									withSecond:hashGameBoard[13][3]
									 withThird:hashGameBoard[13][2]
									withFourth:hashGameBoard[13][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:13 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                //PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 6 ||
			tempSuperDice.gameBoardPosition == 7 ||
			tempSuperDice.gameBoardPosition == 10 ||
			tempSuperDice.gameBoardPosition == 11) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action14{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 8 ||
			tempDice.gameBoardPosition == 9 ||
			tempDice.gameBoardPosition == 12 ||
			tempDice.gameBoardPosition == 13) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[14][4]
									withSecond:hashGameBoard[14][3]
									 withThird:hashGameBoard[14][2]
									withFourth:hashGameBoard[14][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:14 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                //PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 8 ||
			tempSuperDice.gameBoardPosition == 9 ||
			tempSuperDice.gameBoardPosition == 12 ||
			tempSuperDice.gameBoardPosition == 13) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action15{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 9 ||
			tempDice.gameBoardPosition == 10 ||
			tempDice.gameBoardPosition == 13 ||
			tempDice.gameBoardPosition == 14) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[15][4]
									withSecond:hashGameBoard[15][3]
									 withThird:hashGameBoard[15][2]
									withFourth:hashGameBoard[15][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:15 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                //PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 9 ||
			tempSuperDice.gameBoardPosition == 10 ||
			tempSuperDice.gameBoardPosition == 13 ||
			tempSuperDice.gameBoardPosition == 14) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action16{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 10 ||
			tempDice.gameBoardPosition == 11 ||
			tempDice.gameBoardPosition == 14 ||
			tempDice.gameBoardPosition == 15) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[16][4]
									withSecond:hashGameBoard[16][3]
									 withThird:hashGameBoard[16][2]
									withFourth:hashGameBoard[16][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:16 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                //PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 10 ||
			tempSuperDice.gameBoardPosition == 11 ||
			tempSuperDice.gameBoardPosition == 14 ||
			tempSuperDice.gameBoardPosition == 15) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action17{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 3 ||
			tempDice.gameBoardPosition == 6 ||
			tempDice.gameBoardPosition == 9 ||
			tempDice.gameBoardPosition == 12) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[17][4]
									withSecond:hashGameBoard[17][3]
									 withThird:hashGameBoard[17][2]
									withFourth:hashGameBoard[17][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:17 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                //PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 3 ||
			tempSuperDice.gameBoardPosition == 6 ||
			tempSuperDice.gameBoardPosition == 9 ||
			tempSuperDice.gameBoardPosition == 12) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

-(void)action18{
	int countStop = 0;
	Dice *tempDiceArray[4];
	for ( Dice *tempDice in diceArray) {
		if (tempDice.gameBoardPosition == 0 ||
			tempDice.gameBoardPosition == 5 ||
			tempDice.gameBoardPosition == 10 ||
			tempDice.gameBoardPosition == 15) {
			[tempDice becomeBigAndSmall];
			tempDiceArray[countStop] = tempDice;
			countStop++;
		}
		if (countStop == 4) {
			if ([self countScoreLogicWithFirst:hashGameBoard[18][4]
									withSecond:hashGameBoard[18][3]
									 withThird:hashGameBoard[18][2]
									withFourth:hashGameBoard[18][1]]) {
				[tempDiceArray[0] setUseOrNot:YES];
				[tempDiceArray[1] setUseOrNot:YES];
				[tempDiceArray[2] setUseOrNot:YES];
				[tempDiceArray[3] setUseOrNot:YES];
                [self showScoreGameboardWithPosition:18 withScore:tempScoreNumber];
                PLAYSOUNDEFFECT(COUNT_SCORE_YES);
			}
            else{
                PLAYSOUNDEFFECT(COUNT_SCORE_FIRST);
                //PLAYSOUNDEFFECT(COUNT_SCORE);
            }
			break;
		}
	}
	for ( SuperDice *tempSuperDice in superDiceArray ) {
		if (tempSuperDice.gameBoardPosition == 0 ||
			tempSuperDice.gameBoardPosition == 5 ||
			tempSuperDice.gameBoardPosition == 10 ||
			tempSuperDice.gameBoardPosition == 15) {
			[tempSuperDice becomeBigAndSmall];
		}
	}
}

@end
