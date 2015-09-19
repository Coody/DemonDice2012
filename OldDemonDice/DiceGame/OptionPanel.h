//
//  OptionPanel.h
//  DiceGame
//
//  Created by Coody0829 on 13/5/30.
//
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "OptionPanelDelegate.h"

@interface OptionPanel : CCSprite{
	CCMenu *upperOptionMenu;
    CCMenu *lowerOptionMenu;
    BOOL touchPanelOrNot;
    
    CCMenu *askMenu;
    
    id <OptionPanelDelegate> delegate;
}

@property (nonatomic, retain) id <OptionPanelDelegate> delegate;

-(void)testSelector;
-(void)setTouchScreen:(BOOL)tempBool;

@end
