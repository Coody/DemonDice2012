//
//  TalkLabel.h
//  DiceGame
//
//  Created by Coody0829 on 13/5/19.
//
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "Constants.h"

@interface TalkLabel : CCSprite{
	CCLabelTTF *talkText;
	int storySchedule;
    NSMutableArray *eventStringArray;
}

-(void)setEventTextWithSequence:(int)sequenceNumber;
-(void)setChapter:(EnumEventCount)tempChapter;

-(void)showLabelAction;

-(void)setContext;

@end
