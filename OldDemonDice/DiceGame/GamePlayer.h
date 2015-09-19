//
//  GamePlayer.h
//  DiceGame
//
//  Created by Coody0829 on 13/3/6.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface GamePlayer : NSObject{
	NSString *name;
	int firstPlay;
	int storySchedule;
    int albumIntArray[11];
    
    EnumDiceNumberAndColor saveDiceArray[25];
	
	int score;
	
	NSString *playerBehavior;
    EnumSkillName recentSkill;
}

@property (assign) NSString *name;
@property (readwrite) int firstPlay;
@property (readwrite) int storySchedule;

@property (readwrite) int score;

@property (assign) NSString *playerBehavior;

@property (readwrite) EnumSkillName recentSkill;

+(GamePlayer *)sharedGamePlayer;
-(void)saveGame;
-(void)loadData;
-(void)deleteData;
-(int)getAlbumArray:(int)page;
-(void)setAlbumArray:(int)page withNumber:(int)tempNumber;

@end
