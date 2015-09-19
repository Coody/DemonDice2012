//
//  LeadingActress.m
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//

#import "LeadingActress.h"
#import "cocos2d.h"

@implementation LeadingActress

-(id)init{
	self = [super init];
	if (self != nil ) {
		CCSprite *leadingActressImage = [CCSprite spriteWithFile:@"demonSmilePic-568h.png"];
		[self addChild:leadingActressImage z:ZOrderLeading];
		
		[leadingActressImage setPosition:ccp(self.contentSize.width*0.5, self.contentSize.height*0.54)];
	
		CCSprite *eyeAnim = [CCSprite spriteWithFile:@"smileEye1-568h.png"];
		[leadingActressImage addChild:eyeAnim z:ZOrderEye];
		[eyeAnim setPosition:ccp(leadingActressImage.contentSize.width*0.544,leadingActressImage.contentSize.height*0.756)];
		CCAnimation *leadingActressAnim = [CCAnimation animation];
		[leadingActressAnim addFrameWithFilename:@"smileEye2-568h.png"];
		[leadingActressAnim addFrameWithFilename:@"smileEye3-568h.png"];
		[leadingActressAnim addFrameWithFilename:@"smileEye4-568h.png"];
		[leadingActressAnim addFrameWithFilename:@"smileEye4-568h.png"];
		[leadingActressAnim addFrameWithFilename:@"smileEye4-568h.png"];
		[leadingActressAnim addFrameWithFilename:@"smileEye4-568h.png"];
		[leadingActressAnim addFrameWithFilename:@"smileEye4-568h.png"];
		[leadingActressAnim addFrameWithFilename:@"smileEye3-568h.png"];
		[leadingActressAnim addFrameWithFilename:@"smileEye2-568h.png"];
		[leadingActressAnim addFrameWithFilename:@"smileEye1-568h.png"];
		id animationAction = [CCAnimate actionWithDuration:0.27f
		animation:leadingActressAnim
		restoreOriginalFrame:NO];
		id delayTime = [CCDelayTime actionWithDuration:2.3f];
		
		id allAction = [CCSequence actions:animationAction,delayTime, nil];
		id repeatAction = [CCRepeatForever actionWithAction:allAction];
		[eyeAnim runAction:repeatAction];
	}
	return self;
}

@end