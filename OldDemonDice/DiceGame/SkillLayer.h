//
//  SkillLayer.h
//  DiceGame
//
//  Created by coody0829 on 13/10/11.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "GamePlayer.h"
#import "GameManager.h"

@interface SkillLayer : CCLayer{
    CCMenu *upperSkillMenu;
    CCMenu *lowerSkillMenu;
    CCMenu *returnButton;
    CCLabelTTF *skillNote;
}

@end
