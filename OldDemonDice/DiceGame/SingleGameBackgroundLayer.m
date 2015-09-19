//
//  SingleGameBackgroundLayer.m
//  DiceGame
//
//  Created by coody0829 on 13/9/6.
//
//

#import "SingleGameBackgroundLayer.h"

@implementation SingleGameBackgroundLayer

-(id)initWithDate:(EnumBackgroundData)date{
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        /* should finish 1/1, 2/14, 7/7 , 12/25 , birthday , Players birthday */
        switch (date) {
            case enumSingleGameBackground:
                singleGameBackground = [CCSprite spriteWithFile:@"iPhone5blank.png"];
                /* 一般單機的時候 */
                break;
            case enumNewYearBackground:
                singleGameBackground = [CCSprite spriteWithFile:@""];
                /* 新年的時候 */
                break;
            default:
                singleGameBackground = [CCSprite spriteWithFile:@"iPhone5blank.png"];
                /* 一般日子的時候 */
                CCLOG(@"Program shouldn't come here!!!!");
                break;
        }
        [singleGameBackground setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        [self addChild:singleGameBackground];
    }
    return self;
}

@end
