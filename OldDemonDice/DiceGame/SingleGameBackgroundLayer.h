//
//  SingleGameBackgroundLayer.h
//  DiceGame
//
//  Created by coody0829 on 13/9/6.
//
//

#import "cocos2d.h"
#import "Constants.h"

@interface SingleGameBackgroundLayer : CCLayer{
    CCSprite *singleGameBackground;
}

-(id)initWithDate:(EnumBackgroundData)date;

@end
