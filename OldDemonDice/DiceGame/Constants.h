//
//  Constants.h
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//
#define mainMenuTagValue 10
#define sceneMenuTagValue 20
#define MaxDiceNumber 20
#define MaxSuperDiceNumber 4
#define MaxCountScoreDiceNumber 4

#define ANIMATION_TALK_BUBBLE_MOVE_TIME 1
#define animationDiceBreakTime 0.6
#define animationCountScoreTime 0.58
#define remindDiceJumpTime 0.25

#define bubblePositionWidth 48
#define bubblePositionHeight 439 //439

#define talkLabelPositionWidth 82
#define talkLabelPositionHeight 417

#define superDiceGameboardWidth 82
#define superDiceGameboardHeight 417 //417

#define optionPanelPositionWidth 78
#define optionPanelPositionHeight 417

#define startGameMenuScreenPositionOriginal 0.86
#define startGameMenuScreenPositionMoveDown 0.686
#define startGameMenuScreenPositionMoveUp 0.67

#define changeScene 0.25

#define SHOW_CARD_ANIMATION 0.3

#define SKILL03_MULTI_NUMBER 2

#define ALBUM_PAGE_NUMBER 6

//Audio Items

#define AUDIO_MAX_WAITTIME 150

#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]

#define STOPSOUNDEFFECT(...) \
[[GameManager sharedGameManager] stopSoundEffect:@#__VA_ARGS__]

#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define START_MAIN_MENU @"startMainMenu.mp3"
#define SINGLE_GAME @"singleGame.mp3"
#define FIRST_PLAY @"firstPlay.mp3"

typedef enum{
	enumActionBubbleMoveTag = 10
}EnumActionTag;

typedef enum {
	NPCZOrder = 2,
    enumEnergyBar = 3,
	ZOrderGameBoard = 4,
	bubbleBackgroundZOrder = 5,
	bubbleZOrder = 15,
	talkLabelZOrder = 25,
	superDiceGameboardZOrder = 25,
	optionZOrder = 25,
	bubbleDiceZOrder = 6,
	ZOrderLeading = 1,
	ZOrderEye = 2,
	ZOrderTEST = 200
}EnumSingleGameZOrder;

typedef enum {
    /* 這些數值必須要在上面棋盤 ZOrderGameboard = 4 的上方才行 */
	enumStableZOrder = 5,
	enumAutoMovingZOrder = 25,
	enumGoldDiceZOrder = 20,
	enumMovingZOrder = 30,
    enumOptionSceneObject = 50,
    enumToppestZOrder = 1000
}EnumDiceZOrder;


/* 要增加請務必記得要增佳聲音檔案 SoundEffects.plist */
typedef enum {
	enumNoSceneUninitialized = 0,
	enumLogoScene = 1,
	enumMainMenuScene = 2,
	enumSingleScene = 3,
	enumLVScene = 4,
	enumCreditScene = 5,
	enumAnimateScene01 = 7,
	enumFirstPlayScene = 8
}EnumSceneTypes;

typedef enum{
    enumAlbumScene = 1,
    enumSkillScene = 2,
    enumFirstPlayeScene = 3,
    enumOptionScene = 4
}EnumSittingTypes;

typedef enum{
	enumScoreUpdate = 100,
	enumScoreFourDiceTheSameColorTheSameNumberEnum = 50,
	enumScoreFourDiceTheSameNumberEnum = 20,
	enumScoreFourDiceTheSameColorEnum = 20,
	enumScoreFourDiceDifColorDifNumber = 4
}EnumscoreNumberEnum;

typedef enum{
	enumDiceError = -1,
	enumDiceGold = 20,
	enumDice01Blue = 1,
	enumDice02Blue = 2,
	enumDice03Blue = 3,
	enumDice04Blue = 4,
	enumDice01Green = 5,
	enumDice02Green = 6,
	enumDice03Green = 7,
	enumDice04Green = 8,
	enumDice01Red = 9,
	enumDice02Red = 10,
	enumDice03Red = 11,
	enumDice04Red = 12,
	enumDice01Yellow = 13,
	enumDice02Yellow = 14,
	enumDice03Yellow = 15,
	enumDice04Yellow = 16
}EnumDiceNumberAndColor;

typedef enum{
	noneChapter = -1,
	firstChapter = 0,
	secondChapter = 1,
	thirdChapter = 2
}EnumstorySchedule;

typedef enum{
	enumSuperDiceArrayFill00 = 0,
	enumSuperDiceArrayPosition01 = 51,
	enumSuperDiceArrayPosition02 = 52,
	enumSuperDiceArrayPosition03 = 53,
	enumSuperDiceArrayPosition04 = 54,
	enumSuperDiceArrayError = 99
}EnumSuperDicePosition;

typedef enum{
    enumFirstPlayStart = 0,
	enumFirstPlayPressButtonCondition = 10,
    enumFirstPlayGameBoardCondition = 15,
	enumFirstPlayFourDiceCondition = 20,
    enumFirstPlayFourDiceCondition2 = 21,
    enumFirstPlayFourDiceCondition3 = 22,
    enumFirstPlayFourDiceCondition4 = 23,
	enumFirstPlayThreeDifRuleCondition = 30,
	enumFirstPlayThreeDifRuleCondition2 = 40,
    enumFirstPlayThreeDifRuleCondition3 = 45,
	enumFirstPlayFourDiceComboCondition = 50,
	enumFirstPlaySuperDiceCreateCondition = 60,
	enumFirstPlayGameBoardBuffCondition = 70,
    enumFirstPlayChangeTalkBubbleCondition = 75,
	enumFirstPlayEndCondition = 80,
    
    
    
	enumFirstPlayError = -1
}EnumEventCount;

typedef enum{
	enumTalkBubbleNPCTalk = 0,
	enumTalkBubbleSuperDice = 1,
	enumTalkBubbleOption = 2,
	enumTalkBubbleNumber = 3 /* 這是用來當除數的基底！ */
}EnumTalkBubbleTag;

typedef enum{
    enumSkillName01 = 1,
    enumSkillName02 = 2,
    enumSkillName03 = 3,
    enumSkillName04 = 4,
    enumSkillName05 = 5,
    enumSkillName06 = 6
}EnumSkillName;

typedef enum{
    enumSingleGameBackground = 0,
    enumNewYearBackground = 1,
    enumValentineDayBackground01 = 21,
    enumValentineDayBackground02 = 22,
    enumValentineDayBackground03 = 23,
    enumChineseValentineDayBackground01 = 31,
    enumChineseValentineDayBackground02 = 32,
    enumChineseValentineDayBackground03 = 33,
    enumMarryChristmasBackground01 = 41,
    enumMarryChristmasBackground02 = 42,
    enumMarryChristmasBackground03 = 43
}EnumBackgroundData;

#pragma mark Audio Items

typedef enum{
    enumAudioManagerUninitialized = 0,
    enumAudioManagerFailed = 1,
    enumAudioManagerInitializing = 2,
    enumAudioManagerInitialized = 100,
    enumAudioManagerLoading = 200 ,
    enumAudioManagerReady = 300
}EnumGameManagerSoundState;

