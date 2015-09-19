//
//  CCMenuEx.m
//  DiceGame
//
//  Created by coody0829 on 2013/11/13.
//
//

#import "CCMenuEx.h"

@implementation CCMenuEx

-(CCMenuItem *)itemForTouch:(UITouch *)touch{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
    CCMenuItem* item = nil;
    CCMenuItem* hitItem = nil;
    CCARRAY_FOREACH(children_, item){
        if ( [item visible] && [item isEnabled] ) {
            if (CGRectContainsPoint([item rect], touchLocation)) {
                if (hitItem) {
                    if ([hitItem zOrder] < item.zOrder) {
                        hitItem = item;
                    }
                } else {
                    hitItem = item;
                }
            }
        }
    }
    return hitItem;
}

@end
