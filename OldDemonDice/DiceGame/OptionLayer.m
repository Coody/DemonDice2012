//
//  OptionLayer.m
//  DiceGame
//
//  Created by coody0829 on 13/10/11.
//
//

#import "OptionLayer.h"
#import "GameManager.h"

@implementation OptionLayer

-(id)init{
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *background = [CCSprite spriteWithFile:@"sorry.png"];
        if ( screenSize.height > 480) {
            [background setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        }
        else{
            [background setPosition:ccp(screenSize.width*0.5, 280)];
        }
        
        [self addChild:background];
        CCMenuItemImage *returnButtonImage = [CCMenuItemImage itemFromNormalImage:@"backSingleGameButton.png"
                                                                    selectedImage:@"backSingleGameButtonSelected.png"
                                                                    disabledImage:nil
                                                                           target:self
                                                                         selector:@selector(backToSingleGameScene)];
        CCMenuItemImage *returnToMainMenuImage = [CCMenuItemImage itemFromNormalImage:@"yesButton.png"
                                                                    selectedImage:@"yesButtonSelected.png"
                                                                    disabledImage:nil
                                                                           target:self
                                                                         selector:@selector(backToMainMenuScene)];
        returnButton = [CCMenu menuWithItems: returnToMainMenuImage, returnButtonImage , nil];
        [returnButton alignItemsHorizontallyWithPadding:140];
        [self addChild:returnButton];
        [returnButton setPosition:ccp(170, 40)];
    }
    return self;
}

-(void)backToMainMenuScene{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
    [[GameManager sharedGameManager] runSceneWithID:enumMainMenuScene];
}

-(void)backToSingleGameScene{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
    [[CCDirector sharedDirector] popScene];
}

@end
