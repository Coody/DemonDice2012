//
//  SkillScene.m
//  DiceGame
//
//  Created by coody0829 on 13/10/11.
//
//

#import "SkillScene.h"

@implementation SkillScene

-(id)init{
    self = [super init];
    if (self != nil) {
        skillLayer = [SkillLayer node];
        [self addChild:skillLayer];
    }
    return self;
}

@end
