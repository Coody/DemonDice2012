//
//  LevelScene.m
//  DiceGame
//
//  Created by coody0829 on 2013/12/3.
//
//

#import "LevelGameScene.h"

@implementation LevelGameScene

-(id)init{
    self = [super init];
    if ( self != nil) {
        levelGameLayer = [LevelGameLayer node];
        [self addChild:levelGameLayer];
    }
    return  self;
}

@end
