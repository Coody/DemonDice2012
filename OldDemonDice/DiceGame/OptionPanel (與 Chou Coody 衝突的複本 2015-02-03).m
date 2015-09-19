//
//  OptionPanel.m
//  DiceGame
//
//  Created by Coody0829 on 13/5/30.
//
//

#import "OptionPanel.h"
#import "GameManager.h"

#define OPTION_MENU_PADDING 6.0f

@interface OptionPanel()
{
    CCMenu *upperOptionMenu;
    CCMenu *lowerOptionMenu;
    BOOL touchPanelOrNot;
    
    CCMenu *askMenu;
}

@end

@implementation OptionPanel

@synthesize delegate;

-(id)init{
	self = [super init];
	if (self != nil) {
        touchPanelOrNot = NO;
        CCMenuItemImage *albumButton = [CCMenuItemImage itemFromNormalImage:@"albumButton.png"
                                                               selectedImage:@"albumButtonSelected.png"
                                                               disabledImage:nil
                                                                      target:self
                                                                    selector:@selector(startAlbumScene)];
		CCMenuItemImage *skillButton = [CCMenuItemImage itemFromNormalImage:@"skillButton.png"
															selectedImage:@"skillButtonSelected.png"
															disabledImage:nil
																   target:self
																 selector:@selector(startSkillScene)];
        CCMenuItemImage *firstPlayButton = [CCMenuItemImage itemFromNormalImage:@"firstPlayButton.png"
                                                                  selectedImage:@"firstPlayButtonSelected.png"
                                                                  disabledImage:nil
                                                                         target:self
                                                                       selector:@selector(startFirstPlayScene)];
		CCMenuItemImage *optionButton = [CCMenuItemImage itemFromNormalImage:@"optionButton.png"
															 selectedImage:@"optionButtonSelected.png"
															 disabledImage:nil
																	target:self
																  selector:@selector(startOptionScene)];
		
        
        upperOptionMenu = [CCMenu menuWithItems:albumButton,skillButton, nil];
        [self addChild:upperOptionMenu z:optionZOrder];
        [upperOptionMenu alignItemsHorizontallyWithPadding:OPTION_MENU_PADDING];
        [upperOptionMenu setPosition:ccp(0,30)];
        lowerOptionMenu = [CCMenu menuWithItems:firstPlayButton,optionButton, nil];;
        [self addChild:lowerOptionMenu z:optionZOrder];
        [lowerOptionMenu alignItemsHorizontallyWithPadding:OPTION_MENU_PADDING];
        [lowerOptionMenu setPosition:ccp(0,-30)];
        delegate = nil;
	}
	return self;
}

-(void)startAlbumScene{
    CCLOG(@"按下 Album 按鈕！！！！");
    [[GameManager sharedGameManager] pushSceneWithID:enumAlbumScene];
}

-(void)startSkillScene{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
    CCLOG(@"按下 Skill 按鈕！！！！");
    [[GameManager sharedGameManager] pushSceneWithID:enumSkillScene];
}

-(void)askFirstPlayScene{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCSprite *background = [CCSprite spriteWithFile:@"askBackground.png"];
    [background setPosition:ccp(screenSize.width*0.5, -100)];
    CCMenuItemImage *yesButton = [CCMenuItemImage itemFromNormalImage:@"yesButton.png"
                                                        selectedImage:@"yesButtonSelected.png"
                                                        disabledImage:nil
                                                               target:self
                                                             selector:@selector(startFirstPlayScene)];
    CCMenuItemImage *noButton = [CCMenuItemImage itemFromNormalImage:@"noButton.png"
                                                       selectedImage:@"noButtonSelected.png"
                                                       disabledImage:nil
                                                              target:self
                                                            selector:@selector(backToGame)];
    askMenu = [CCMenu menuWithItems:noButton,yesButton, nil];
    [yesButton setPosition:ccp(100, 10)];
    [noButton setPosition:ccp(30, 10)];
    [self addChild:background];
    [background addChild:askMenu];
    [askMenu setPosition:ccp(105,50)];
    id moveInAction = [CCMoveTo actionWithDuration:0.5f position:ccp(screenSize.width*0.5, screenSize.height*0.5)];
    [askMenu runAction:moveInAction];
}

-(void)backToGame{
    [askMenu removeFromParentAndCleanup:YES];
}

-(void)startFirstPlayScene{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
    [delegate showWarningDelegate];
}

-(void)confirmToStartFirstPlayScene{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
    [[GameManager sharedGameManager] runSceneWithID:enumFirstPlayScene];
}

-(void)startOptionScene{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
    [[GameManager sharedGameManager] pushSceneWithID:enumOptionScene];
}

-(void)setTouchScreen:(BOOL)tempBool{
    if (tempBool == YES) {
        [upperOptionMenu setIsTouchEnabled:YES];
        [lowerOptionMenu setIsTouchEnabled:YES];
    }
    else{
        [upperOptionMenu setIsTouchEnabled:NO];
        [lowerOptionMenu setIsTouchEnabled:NO];
    }
}

#pragma mark -
#pragma mark testMethods

-(void)testSelector{
    
}

@end
