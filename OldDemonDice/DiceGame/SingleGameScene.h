//
//  SingleGameScene.h
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SingleGameLayer.h"
#import "SingleGameBackgroundLayer.h"

@interface SingleGameScene : CCScene {
    SingleGameLayer *singleGameLayer;
    SingleGameBackgroundLayer *singleGameBackgroundLayer;
}

@end
