//
//  SkillLayer.m
//  DiceGame
//
//  Created by coody0829 on 13/10/11.
//
//

#import "SkillLayer.h"

@implementation SkillLayer

-(id)init{
    self = [super init];
    if (self != nil) {
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *background;
        if ( screenSize.height > 480 ) {
            background = [CCSprite spriteWithFile:@"skillBackgroundiPhone5.png"];
        }
        else{
            background = [CCSprite spriteWithFile:@"skillBackground.png"];
        }
        [self addChild:background z:0];
        [background setPosition:ccp(screenSize.width*0.5f, screenSize.height*0.5f)];
        CCMenuItemImage *firstSkill = [CCMenuItemImage itemFromNormalImage:@"secondSkill.png"
                                                             selectedImage:@"secondSkillSelected.png"
                                                             disabledImage:nil
                                                                    target:self
                                                                  selector:@selector(touchFirstSkill)];
        CCMenuItemImage *secondSkill = [CCMenuItemImage itemFromNormalImage:@"secondSkill.png"
                                                              selectedImage:@"secondSkillSelected.png"
                                                              disabledImage:nil
                                                                     target:self
                                                                   selector:@selector(touchSecondSkill)];
        CCMenuItemImage *thirdSkill = [CCMenuItemImage itemFromNormalImage:@"secondSkill.png"
                                                             selectedImage:@"secondSkillSelected.png"
                                                             disabledImage:nil
                                                                    target:self
                                                                  selector:@selector(touchThirdSkill)];
        CCMenuItemImage *fourthSkill = [CCMenuItemImage itemFromNormalImage:@"secondSkill.png"
                                                              selectedImage:@"secondSkillSelected.png"
                                                              disabledImage:nil
                                                                     target:self
                                                                   selector:@selector(touchFourthSkill)];
        CCMenuItemImage *fifthSkill = [CCMenuItemImage itemFromNormalImage:@"secondSkill.png"
                                                             selectedImage:@"secondSkillSelected.png"
                                                             disabledImage:nil
                                                                    target:self
                                                                  selector:@selector(touchFifthSkill)];
        CCMenuItemImage *sixthSkill = [CCMenuItemImage itemFromNormalImage:@"secondSkill.png"
                                                             selectedImage:@"secondSkillSelected.png"
                                                             disabledImage:nil
                                                                    target:self
                                                                  selector:@selector(touchSixthSkill)];
        upperSkillMenu = [CCMenu menuWithItems:firstSkill,secondSkill,thirdSkill, nil];
        [self addChild:upperSkillMenu];
        
        lowerSkillMenu = [CCMenu menuWithItems:fourthSkill,fifthSkill,sixthSkill, nil];
        [self addChild:lowerSkillMenu];
        
        if ( screenSize.height > 480 ) {
            [upperSkillMenu alignItemsHorizontallyWithPadding:10.0f];
            [upperSkillMenu setPosition:ccp(160 , 87.5 )];
            [lowerSkillMenu alignItemsHorizontallyWithPadding:10.0f];
            [lowerSkillMenu setPosition:ccp(160, 212.5)];
        }
        else{
            [upperSkillMenu alignItemsHorizontallyWithPadding:10.0f];
            [upperSkillMenu setPosition:ccp(160 , 67.5 )];
            [lowerSkillMenu alignItemsHorizontallyWithPadding:10.0f];
            [lowerSkillMenu setPosition:ccp(160, 172.5)];
        }
        skillNote = [CCLabelTTF labelWithString:@"目前沒有選擇任何技能！" dimensions:CGSizeMake(270,260) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:22.0f];
        switch ( [GamePlayer sharedGamePlayer].recentSkill ) {
            case enumSkillName01:
                [self touchFirstSkill];
                break;
            case enumSkillName02:
                [self touchSecondSkill];
                break;
            case enumSkillName03:
                [self touchThirdSkill];
                break;
            case enumSkillName04:
                [self touchFourthSkill];
                break;
            case enumSkillName05:
                [self touchFifthSkill];
                break;
            case enumSkillName06:
                [self touchSixthSkill];
                break;
            default:
                break;
        }
        [self addChild:skillNote z:enumOptionSceneObject];
        
        //設置文字顏色
        [skillNote setColor:ccWHITE];
        CCMenuItemImage *returnButtonImage = [CCMenuItemImage itemFromNormalImage:@"backSingleGameButton.png"
                                                                    selectedImage:@"backSingleGameButtonSelected.png"
                                                                    disabledImage:nil
                                                                           target:self
                                                                         selector:@selector(backToSingleGameScene)];
        returnButton = [CCMenu menuWithItems: returnButtonImage , nil];
        [self addChild:returnButton];
        if ( screenSize.height > 480 ) {
            [skillNote setPosition:ccp(170, 400)];
            [returnButton setPosition:ccp(284, 296)];
        }
        else{
            [skillNote setPosition:ccp(170, 320)];
            [returnButton setPosition:ccp(284, 256)];
        }
        
    }
    return self;
}

-(void)touchFirstSkill{
    [skillNote cleanup];
    [GamePlayer sharedGamePlayer].recentSkill = enumSkillName01;
    [skillNote setString:@"50% 機率：\n解鎖一個固定的骰子。\n\n\n沒有固定骰子，分數 +10 分。"];
}

-(void)touchSecondSkill{
    [skillNote cleanup];
    [GamePlayer sharedGamePlayer].recentSkill = enumSkillName02;
    [skillNote setString:@"Game over 時\n\n 1/2 的機會解開所有骰子。"];
}

-(void)touchThirdSkill{
    [skillNote cleanup];
    [GamePlayer sharedGamePlayer].recentSkill = enumSkillName03;
    int skill03MultiNumber = SKILL03_MULTI_NUMBER ;
    [skillNote setString:[NSString stringWithFormat:@"50%% 的機率：\n『增加的分數』x %d倍。\n\nPS：兩個以上的超級骰子所得分數，不計入 x %d倍 分數中！！", skill03MultiNumber,skill03MultiNumber]];
}

-(void)touchFourthSkill{
    [skillNote cleanup];
    [GamePlayer sharedGamePlayer].recentSkill = enumSkillName04;
    [skillNote setString:@"None"];
}

-(void)touchFifthSkill{
    [skillNote cleanup];
    [GamePlayer sharedGamePlayer].recentSkill = enumSkillName05;
    [skillNote setString:@"None"];
}

-(void)touchSixthSkill{
    [skillNote cleanup];
    [GamePlayer sharedGamePlayer].recentSkill = enumSkillName06;
    [skillNote setString:@"None"];
}

-(void)backToSingleGameScene{
    PLAYSOUNDEFFECT(CLICK_BUTTON);
    [[CCDirector sharedDirector] popScene];
}

#pragma mark -
#pragma mark skill methods

@end
