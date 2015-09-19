//
//  LevelGameLayer.m
//  DiceGame
//
//  Created by coody0829 on 2013/12/3.
//
//

#import "LevelGameLayer.h"
#import "GameManager.h"

@implementation LevelGameLayer

-(id)init{
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *background = [CCSprite spriteWithFile:@"sorry.png"];
        [background setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        [self addChild:background];
        CCMenuItemImage *returnButtonImage = [CCMenuItemImage itemFromNormalImage:@"backSingleGameButton.png"
                                                                    selectedImage:@"backSingleGameButtonSelected.png"
                                                                    disabledImage:nil
                                                                           target:self
                                                                         selector:@selector(backToMainMenuScene)];
        returnButton = [CCMenu menuWithItems: returnButtonImage , nil];
        [self addChild:returnButton];
        [returnButton setPosition:ccp(284, 30)];
    }
    return self;
}


-(void)backToMainMenuScene{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
    [[GameManager sharedGameManager] runSceneWithID:enumMainMenuScene];
}

@end
