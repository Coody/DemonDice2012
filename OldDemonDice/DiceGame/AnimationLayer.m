//
//  AnimationLayer.m
//  DiceGame
//
//  Created by Coody0829 on 13/2/22.
//
//

#import "AnimationLayer.h"
#import "GamePlayer.h"
#import "Constants.h"

@interface AnimationLayer ()
-(void)showStoryWithSchedule:(int)storySchedule;
@end

@implementation AnimationLayer

-(id)init{
	self = [super init];
	if (self != nil) {
		[self showStoryWithSchedule:[GamePlayer sharedGamePlayer].storySchedule];
	}
	return self;
}

-(void)showStoryWithSchedule:(int)storySchedule{
	switch (storySchedule) {
		case firstChapter:
			break;
		case secondChapter:
			break;
		default:
			break;
	}
}

@end
