//
//  TalkLabel.m
//  DiceGame
//
//  Created by Coody0829 on 13/5/19.
//
//

#import "TalkLabel.h"
#import "DBManager.h"

@implementation TalkLabel

-(id)init{
	self = [super init];
	if (self != nil) {
		/* It just can put 15 Chinese Words. */
        //[self CopyDatabaseIfNeeded];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
//
//        }
        
		talkText = [CCLabelTTF labelWithString:@"測試看看！測試看看！測試看看！" dimensions:CGSizeMake(155,90) alignment:UITextAlignmentCenter fontName:@"Helvetica-Bold" fontSize:22];
		[talkText setOpacity:0];
		[self addChild:talkText];
		[talkText setPosition:ccp( 0 , 0 )];
		[talkText setColor:ccBLACK];
		id delayShowLabel = [CCDelayTime actionWithDuration:1.2f];
		id fadeInAction = [CCFadeIn actionWithDuration:0.3f];
		id allLabelAction = [CCSequence actions:delayShowLabel,fadeInAction, nil];
		[talkText runAction:allLabelAction];
        [talkText setString:@"嘿嘿～～遊戲開始了喔！！"];
	}
	return self;
}

-(void)dealloc{
    [eventStringArray release];
    [super dealloc];
}

-(void)setStoryText{
	[[DBManager sharedGamePlayDB] queryContext];
}

-(void)setEventTextWithSequence:(int)sequenceNumber{
    if ( [eventStringArray count] == 0) {
        CCLOG(@"enentStringArray is nil !!!!!");
    }
    else{
        [talkText setString:[eventStringArray objectAtIndex:sequenceNumber]];
        CCLOG(@" 對話%2d: %@" , sequenceNumber , [eventStringArray objectAtIndex:sequenceNumber]);
    }
}

-(void)setContext{
    [talkText cleanup];
    [talkText setOpacity:0];
    id fadeInAction = [CCFadeIn actionWithDuration:0.5f];
    [talkText runAction:fadeInAction];
    [talkText setString:[[DBManager sharedGamePlayDB] queryContext]];
}

-(void)setChapter:(EnumEventCount)tempChapter{
    [eventStringArray removeAllObjects];
	switch ( tempChapter ) {
        case enumFirstPlayStart:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayStart] retain];
//            for ( NSString *tempString in eventStringArray) {
//                NSLog(@"tempString = %@", tempString);
//            }
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
            break;
        case enumFirstPlayPressButtonCondition:
            //[eventStringArray release];
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayPressButtonCondition] retain];
            //            for ( NSString *tempString in eventStringArray) {
            //                NSLog(@"tempString = %@", tempString);
            //            }
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
            break;
        case enumFirstPlayGameBoardCondition:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayGameBoardCondition] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
            break;
		case enumFirstPlayFourDiceCondition:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayFourDiceCondition] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
			break;
        case enumFirstPlayFourDiceCondition2:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayFourDiceCondition2] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
			break;
        case enumFirstPlayFourDiceCondition3:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayFourDiceCondition3] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
			break;
        case enumFirstPlayFourDiceCondition4:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayFourDiceCondition4] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
			break;
        case enumFirstPlayThreeDifRuleCondition:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayThreeDifRuleCondition] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
            break;
        case enumFirstPlayThreeDifRuleCondition2:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayThreeDifRuleCondition2] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
            break;
        case enumFirstPlayThreeDifRuleCondition3:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayThreeDifRuleCondition3] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
            break;
		case enumFirstPlayFourDiceComboCondition:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayFourDiceComboCondition] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
			break;
        case enumFirstPlaySuperDiceCreateCondition:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlaySuperDiceCreateCondition] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
            break;
        case enumFirstPlayGameBoardBuffCondition:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayGameBoardBuffCondition] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
            break;
        case enumFirstPlayChangeTalkBubbleCondition:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayChangeTalkBubbleCondition] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
            break;
        case enumFirstPlayEndCondition:
            eventStringArray = [[[DBManager sharedGamePlayDB] queryEventContextWithNumber:enumFirstPlayEndCondition] retain];
            [talkText setString:[eventStringArray objectAtIndex:0]];
            CCLOG(@" 對話 0: %@" , [eventStringArray objectAtIndex:0]);
            break;
		case enumFirstPlayError:
            CCLOG(@"輸入的 Enum First Play 列舉型態錯誤！！");
			break;
        /* add more event here!! */
		default:
            CCLOG(@"Event Error!!!!!");
			break;
	}
}

-(void)showLabelAction{
	[self setOpacity:0];
	id delayShowLabel = [CCDelayTime actionWithDuration:1.0f];
	id fadeInAction = [CCFadeIn actionWithDuration:0.3f];
	id allLabelAction = [CCSequence actions:delayShowLabel,fadeInAction, nil];
	[self runAction:allLabelAction];
}

@end
