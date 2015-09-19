//
//  MainMenuLayer.h
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "GameManager.h"
#import "GamePlayer.h"
#import "CCMenuEx.h"
#import "SimpleAudioEngine.h"

@interface MainMenuLayer : CCLayer {
    CCMenu *mainMenu; /* 顯示一開始遊戲選單：Start,Quick Play */
	CCMenu *startGameButton;
	CCMenu *deleteButton;
    
    CCMenu *albumnButton;
    CCMenu *creditButton;
	CCSprite *demonDiceLogo;
}

@end
