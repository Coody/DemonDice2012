//
//  MainMenuLayer.m
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//

/* 3/7做到選單可以儲存兩個檔案。 */
#import "MainMenuLayer.h"

@interface MainMenuLayer()
-(void)displayMainMenu;
-(void)pressStoryButton;
-(void)pressQuickGameButton;

-(void)deletePlayerData;

-(void)startSingleGame;
-(void)startLevelGame;
-(void)startStoryGame;

@end

@implementation MainMenuLayer

#pragma mark -
#pragma mark StartGameMode

-(void)singleGameMode{
    [[GameManager sharedGameManager] runSceneWithID:enumSingleScene];
}

-(void)firstPlayGame{
	[[GameManager sharedGameManager]runSceneWithID:enumFirstPlayScene];
}

-(void)startStoryGame{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
	[[GameManager sharedGameManager] runSceneWithID:enumSingleScene];
}

-(void)startLevelGame{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
    [[GameManager sharedGameManager] runSceneWithID:enumLVScene];
}

/* 快玩遊戲開始 */
-(void)quickGame{
	[[GameManager sharedGameManager] runSceneWithID:enumSingleScene];
}

#pragma mark -
#pragma mark Methods

-(id)init{
	self = [super init];
	if (self != nil ) {
		self.isTouchEnabled = YES;
		[[GameManager sharedGameManager] stopSoundEffect:(ALuint)@"LOGO"];
		CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCMenuItemImage *optionMenuItem;
        optionMenuItem = [CCMenuItemImage itemFromNormalImage:@"optionMenuButton.png"
                                                selectedImage:@"optionMenuButtonSelected.png"
                                                disabledImage:nil
                                                       target:self
                                                     selector:@selector(pushAlbumScene)];
        
        CCSprite *startBackground;
        
		if ( screenSize.height > 480 ) {
            startBackground = [CCSprite spriteWithFile:@"startBackgroundIPhone5.png"];
			
            //upperStartBackground = [CCSprite spriteWithFile:@""];
		}
		else{
            startBackground = [CCSprite spriteWithFile:@"startBackground.png"];
//			startBackground = [CCMenuItemImage itemFromNormalImage:@"startBackground.png"
//                                                     selectedImage:nil
//                                                     disabledImage:nil
//                                                            target:self
//                                                          selector:@selector(pushAlbumScene)];
            //upperStartBackground = [CCSprite spriteWithFile:@""];
		}
        [self addChild:startBackground];
        [startBackground setPosition:ccp(screenSize.width*0.5f, screenSize.height*0.5f)];
        
        albumnButton = [CCMenuEx menuWithItems:optionMenuItem, nil];
		demonDiceLogo = [CCSprite spriteWithFile:@"DemonDiceLogo-568h.png"];
        //[startBackground setPosition:ccp(screenSize.width * 0.5 , screenSize.height * 0.5)];
        [albumnButton setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
		[self addChild:albumnButton];
		[self displayMainMenu];
		/* should add start animation here */
        
        //[self loadAudio];
        
//        /* 這裡是專題展用來清除資料的地方！！！！ */
//        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *checkPath = [path stringByAppendingPathComponent:@"playerData"];
//        
//        if([[NSFileManager defaultManager] fileExistsAtPath:checkPath]){
//            [[GamePlayer sharedGamePlayer] deleteData];
//        }
        /* 到此 */
        
        [[GameManager sharedGameManager] playBackgroundTrack:START_MAIN_MENU];
	}
	return self;
}

-(void)pushAlbumScene{
    [[GameManager sharedGameManager] pushSceneWithID:enumAlbumScene];
}

/* 最開始的選擇畫面(Logo動作 ＋ 故事模式 & 快玩模式) */
-(void)displayMainMenu{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
    
	CCMenuItemImage *storyButtonImage = [CCMenuItemImage itemFromNormalImage:@"storyModeButton.png"
														  selectedImage:@"storyModeButtonSelected.png"
														  disabledImage:nil
																 target:self
															   selector:@selector(pressStoryButton)];
	
	CCMenuItemImage *quickPlayButtonImage = [CCMenuItemImage itemFromNormalImage:@"quickPlayModeButton.png"
                                                              selectedImage:@"quickPlayModeButtonSelected.png"
                                                              disabledImage:nil
                                                                     target:self
                                                                   selector:@selector(pressQuickGameButton)];
	
	mainMenu = [CCMenu menuWithItems:storyButtonImage , quickPlayButtonImage , nil];
	[mainMenu alignItemsHorizontallyWithPadding:screenSize.width*0.05f];
	[mainMenu setPosition:ccp(screenSize.width*0.5 , screenSize.height*startGameMenuScreenPositionOriginal)];
	[mainMenu setOpacity:0];
	
	id delayShowLogo = [CCDelayTime actionWithDuration:0.3f];
	
    id delayTouchScreen = [CCDelayTime actionWithDuration:1.5f];
    id setTouchStart = [CCCallFunc actionWithTarget:self selector:@selector(setTouchScreen)];
    id allSetTouchScreen = [CCSequence actions:setTouchStart,delayTouchScreen,setTouchStart, nil];
    [self runAction:allSetTouchScreen];
    
	/* 處理 Demon Dice Logo 出現 */
	//[demonDiceLogo setOpacity:0];
	[demonDiceLogo setPosition:ccp(screenSize.width * 0.51, screenSize.height*startGameMenuScreenPositionOriginal)];
	id moveDemonDiceLogo = [CCScaleTo actionWithDuration:0 scale:0];
	[demonDiceLogo runAction:moveDemonDiceLogo];
	id demonLogoFadeInAction = [CCFadeIn actionWithDuration:0.1];
	id moveDemonDiceLogoLarge = [CCScaleTo actionWithDuration:0.5 scale:1.12];
	id becomeBigEaseIn = [CCEaseIn actionWithAction:moveDemonDiceLogoLarge rate:3];
	id moveDemonDiceLogoSmall = [CCScaleTo actionWithDuration:0.15 scale:1];
	id becomeSmallEaseIn = [CCEaseIn actionWithAction:moveDemonDiceLogoSmall rate:1];
	id allActionLogo = [CCSequence actions:delayShowLogo,demonLogoFadeInAction,becomeBigEaseIn,becomeSmallEaseIn, nil];
	[demonDiceLogo runAction:allActionLogo];
	
	/* Main Menu 出現 */
	[self addChild:mainMenu z:0];
	id fadeInMainMenuAction = [CCFadeIn actionWithDuration:0.1];
	id moveAction = [CCMoveTo actionWithDuration:0.4f position:ccp(screenSize.width*0.5,screenSize.height*startGameMenuScreenPositionMoveUp)];
	id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.8f];
	id moveActionUp = [CCMoveTo actionWithDuration:0.1f position:ccp(screenSize.width*0.5,screenSize.height*startGameMenuScreenPositionMoveDown)];
	id moveEffectUp = [CCEaseIn actionWithAction:moveActionUp rate:2.3f];
	id delay = [CCDelayTime actionWithDuration:1.0f];
	id allAction = [CCSequence actions:delay,fadeInMainMenuAction,moveEffect,moveEffectUp, nil];
	[mainMenu runAction:allAction];
	[self addChild:demonDiceLogo z:1];
}

/*　移除所有logo及 Main Menu 按鈕，呼叫下個選單： 　*/
-(void)pressStoryButton{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
	mainMenu.isTouchEnabled = NO;
	CCLOG(@"Continue game scene");
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	id moveoutButtonDown = [CCMoveTo actionWithDuration:0.06f position:ccp(screenSize.width*0.5, screenSize.height*startGameMenuScreenPositionMoveUp)];
	id moveoutButtonUp = [CCMoveTo actionWithDuration:0.3f position:ccp(screenSize.width*0.5, screenSize.height*startGameMenuScreenPositionOriginal)];
	id mainMenuFadeOut = [CCFadeOut actionWithDuration:0.1];
	id allAction = [CCSequence actions:moveoutButtonDown,moveoutButtonUp,mainMenuFadeOut, nil];
	[mainMenu runAction:allAction];
	
	id demonDiceLogoScaleLarge = [CCScaleTo actionWithDuration:0.15 scale:1.12];
	id becomeLargeEaseIn = [CCEaseIn actionWithAction:demonDiceLogoScaleLarge rate:3];
	id demonDiceLogoScaleSmall = [CCScaleTo actionWithDuration:0.3 scale:0];
	id becomeSmallEaseIn = [CCEaseIn actionWithAction:demonDiceLogoScaleSmall rate:3];
	id delayTime = [CCDelayTime actionWithDuration:0.4];
    /* 呼叫新 Story Menu */
	id startGameButtonSelected = [CCCallFunc actionWithTarget:self selector: @selector(startStoryGameMenu)];
	id allActionWithDemonLogo = [CCSequence actions:delayTime,becomeLargeEaseIn,becomeSmallEaseIn,startGameButtonSelected, nil];
	[demonDiceLogo runAction:allActionWithDemonLogo];
	
	/* mainMenu pop up animation , and call @selector(startGame) */
}

/* 進入下個選單畫面：開始故事遊戲、開始關卡遊戲（刪除選單） */
-(void)startStoryGameMenu{
    
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	/* 尋找是否有玩家存檔 */
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *checkPath = [path stringByAppendingPathComponent:@"playerData"];
	
	CCMenuItemImage *singelGameButton = [CCMenuItemImage itemFromNormalImage:@"singleGameButton.png"
															  selectedImage:@"singleGameButtonSelected.png"
																	 target:self
																   selector:@selector(startStoryGame)];
	
	CCMenuItemImage *levelGameButton = [CCMenuItemImage itemFromNormalImage:@"levelGameButton.png"
														   selectedImage:@"levelGameButtonSelected.png"
																  target:self
																selector:@selector(startLevelGame)];
	startGameButton = [CCMenu menuWithItems: singelGameButton, levelGameButton, nil];
	[startGameButton alignItemsHorizontallyWithPadding:screenSize.height*0.05f];
	[startGameButton setPosition:ccp(screenSize.width*0.5f, screenSize.height * 1.5f)];
	id moveInAction = [CCMoveTo actionWithDuration:0.3f position:ccp(screenSize.width*0.5f, screenSize.height * 0.83f)];
	id moveEaseIn = [CCEaseIn actionWithAction:moveInAction rate:0.2f];
	id delay = [CCDelayTime actionWithDuration:0.15f];
	id allAction = [CCSequence actions:delay,moveEaseIn, nil];
	[self addChild:startGameButton z:10];
	[startGameButton runAction:allAction];
	
	/*　if player's file is existed , must have delete button!(這裡是移除存檔按鈕) */
	
	CCMenuItemImage *deleteButtonItem = [CCMenuItemImage itemFromNormalImage:@"deleteButton.png"
															   selectedImage:@"deleteButtonSelected.png"
															   disabledImage:nil
																	  target:self
																	selector:@selector(deletePlayerData)];
	[deleteButtonItem setOpacity:0];
	
	deleteButton = [CCMenu menuWithItems:deleteButtonItem, nil];
	
	if ( screenSize.height <= 480 ) {
		[deleteButtonItem setScale:0.8f];
		[deleteButton setPosition:ccp(screenSize.width*0.33f, screenSize.height*0.95f)];
	}
	else{
		[deleteButton setPosition:ccp(screenSize.width*0.33f, screenSize.height*0.93f)];
	}
	[self addChild:deleteButton];
	if ( [[NSFileManager defaultManager] fileExistsAtPath:checkPath] ) {
		id delayDeleteButton = [CCDelayTime actionWithDuration:0.4f];
		id fadeInDeleteButton = [CCFadeIn actionWithDuration:0.2f];
		id allDeleteButtonAction = [CCSequence actions:delayDeleteButton,fadeInDeleteButton, nil];
		[deleteButton runAction:allDeleteButtonAction];
		if ( screenSize.height <= 480 ) {
			//[deleteButton setScale:0.8f];
			//[deleteButton setPosition:ccp(screenSize.width*0.33f, screenSize.height*0.87f)];
		}
	}
}

/* 主遊戲畫面！ */
-(void)startSingleGame{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	[deleteButton setOpacity:0];
	
	id moveUpAction = [CCMoveTo actionWithDuration:0.2 position:ccp(screenSize.width*0.5, screenSize.height*2)];
	id easeOutAction = [CCEaseOut actionWithAction:moveUpAction rate:0.3];
	id runSingleGame = [CCCallFunc actionWithTarget:self selector:@selector(startSingleGame)];
	/*
	if ([GamePlayer sharedGamePlayer].firstPlay == NO) {
		runSingleGame = [CCCallFunc actionWithTarget:self selector:@selector(storyMode)];
	}
	else{
		runSingleGame = [CCCallFunc actionWithTarget:self selector:@selector(singleGame)];
	}*/
	id allAction = [CCSequence actions:easeOutAction,runSingleGame, nil];
	[startGameButton runAction:allAction];
}

/* 遊戲開始『快玩模式』！ */
-(void)pressQuickGameButton{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
    mainMenu.isTouchEnabled = NO;
	CCLOG(@"Continue game scene");
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	id moveoutButtonDown = [CCMoveTo actionWithDuration:0.06f position:ccp(screenSize.width*0.5, screenSize.height*startGameMenuScreenPositionMoveUp)];
	id moveoutButtonUp = [CCMoveTo actionWithDuration:0.25f position:ccp(screenSize.width*0.5, screenSize.height*startGameMenuScreenPositionOriginal)];
	id mainMenuFadeOut = [CCFadeOut actionWithDuration:0.1];
	id allAction = [CCSequence actions:moveoutButtonDown,moveoutButtonUp,mainMenuFadeOut, nil];
	[mainMenu runAction:allAction];
    
	id delayTime = [CCDelayTime actionWithDuration:0.3];
    id delayTime2 = [CCDelayTime actionWithDuration:0.05];
	id demonDiceLogoScaleLarge = [CCScaleTo actionWithDuration:0.15 scale:1.12];
	id becomeLargeEaseIn = [CCEaseIn actionWithAction:demonDiceLogoScaleLarge rate:3];
	id demonDiceLogoScaleSmall = [CCScaleTo actionWithDuration:0.3 scale:0];
	id becomeSmallEaseIn = [CCEaseIn actionWithAction:demonDiceLogoScaleSmall rate:3];
    
	id startGameButtonSelected = [CCCallFunc actionWithTarget:self selector: @selector(singleGameMode)];
	id allActionWithDemonLogo = [CCSequence actions:delayTime,becomeLargeEaseIn,becomeSmallEaseIn,delayTime2,startGameButtonSelected, nil];
	[demonDiceLogo runAction:allActionWithDemonLogo];
}

-(void)setTouchScreen{
    if ( self.isTouchEnabled == NO ) {
        [self setIsTouchEnabled:YES] ;
        [mainMenu setIsTouchEnabled:YES];
        CCLOG(@"Set touch screen to YES!!!!!");
    }
    else{
        [self setIsTouchEnabled:NO];
        [mainMenu setIsTouchEnabled:NO];
        CCLOG(@"Set touch screen to NO!!!!!");
    }
}

/* 移除存檔，應該要出現警告視窗！ */
-(void)deletePlayerData{
	[[GamePlayer sharedGamePlayer] deleteData];
	[deleteButton setOpacity:0];
}



@end