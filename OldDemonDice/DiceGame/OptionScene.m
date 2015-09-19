//
//  OptionScene.m
//  DiceGame
//
//  Created by coody0829 on 13/10/11.
//
//

#import "OptionScene.h"

@implementation OptionScene

-(id)init{
    self = [super init];
    if (self != nil) {
        optionLayer = [OptionLayer node];
        [self addChild:optionLayer];
    }
    return self;
}

@end
