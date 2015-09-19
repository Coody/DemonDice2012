//
//  GamePlayer.m
//  DiceGame
//
//  Created by Coody0829 on 13/3/6.
//
//

#import "GamePlayer.h"

@interface GamePlayer()

-(void)createPlayerData;

@end

@implementation GamePlayer

@synthesize name;
@synthesize firstPlay;
@synthesize storySchedule;

@synthesize score;

@synthesize playerBehavior;
@synthesize recentSkill;

static GamePlayer *sharedInstance = nil;

+(GamePlayer *)sharedGamePlayer{
	@synchronized([GamePlayer class]){
		if (!sharedInstance) {
			[[self alloc] init];
		}
		return sharedInstance;
	}
	return nil;
}

+(id)alloc{
	@synchronized([GamePlayer class]){
		NSAssert(sharedInstance == nil , @"Attempted to allocate a second instance of the Game Manager singleton");
		sharedInstance = [super alloc];
		return sharedInstance;
	}
	return nil;
}

-(id)init{
	self = [super init];
	if (self != nil) {
		name = @"noName";
		firstPlay = 1;
		storySchedule = 0;
		
		score = 0;
        
        for (int i = 0 ; i < 11; i++) {
            albumIntArray[i] = 0;
        }
        
        for (int i = 0 ; i < 25; i++) {
            saveDiceArray[i] = enumDiceError;
        }
        
        self.recentSkill = 0;
        
        [self loadData];
	}
	return self;
}

-(void)dealloc{
	[name release];
	[super dealloc];
}

/* name , (int)firstPlay , (int)storySchedule , albumIntArray[11] , int score , NSString playerBehavior*/

-(void)saveGame{
    
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *saveDataName = [path stringByAppendingPathComponent:@"playerData"];
    
    CCLOG(@"%@" , saveDataName);
    /* Save Data */
    //CCLOG(@"first play = %d" , firstPlay);
    NSNumber *firstPlayNumber = [NSNumber numberWithInt:firstPlay];
    NSNumber *storyScheduleNumber = [NSNumber numberWithInt:0];
    NSNumber *albumPage01 = [NSNumber numberWithInt:albumIntArray[0]];
    NSNumber *albumPage02 = [NSNumber numberWithInt:albumIntArray[1]];
    NSNumber *albumPage03 = [NSNumber numberWithInt:albumIntArray[2]];
    NSNumber *albumPage04 = [NSNumber numberWithInt:albumIntArray[3]];
    NSNumber *albumPage05 = [NSNumber numberWithInt:albumIntArray[4]];
    NSNumber *albumPage06 = [NSNumber numberWithInt:albumIntArray[5]];
    /* can update another day */
    
    NSNumber *scoreNumber = [NSNumber numberWithInt:score];
    NSString *playerBehaviorString = [NSString stringWithFormat:@"TimidAndShy"];
    
	NSArray *playerDatas = [NSArray arrayWithObjects:[NSString stringWithFormat:@"userName"],firstPlayNumber,storyScheduleNumber,albumPage01,albumPage02,albumPage03,albumPage04,albumPage05,albumPage06,scoreNumber,playerBehaviorString,nil];
	[NSKeyedArchiver archiveRootObject:playerDatas toFile:saveDataName];
	
}

-(void)loadData{
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES)objectAtIndex:0];
	NSString *loadDataName = [path stringByAppendingPathComponent:@"playerData"];
    CCLOG(@"%@" , loadDataName);
	if ( ![[NSFileManager defaultManager] fileExistsAtPath:loadDataName] ) {
		CCLOG(@"There is no Player One !! Create it!!!!!!!!");
		[self createPlayerData];
	}
	//TODO:這裡要去實作Load data
	/*這裡要去實作Load data*/
    
	NSArray *playerDatas = [NSKeyedUnarchiver unarchiveObjectWithFile:loadDataName];
	name = [[playerDatas objectAtIndex:0] copy];
    firstPlay = (int)[[playerDatas objectAtIndex:1] integerValue];
    storySchedule = (int)[[playerDatas objectAtIndex:2] integerValue];
    albumIntArray[0] = (int)[[playerDatas objectAtIndex:3] integerValue];
    albumIntArray[1] = (int)[[playerDatas objectAtIndex:4] integerValue];
    albumIntArray[2] = (int)[[playerDatas objectAtIndex:5] integerValue];
    albumIntArray[3] = (int
                        )[[playerDatas objectAtIndex:6] integerValue];
    albumIntArray[4] = [[playerDatas objectAtIndex:7] integerValue];
    albumIntArray[5] = [[playerDatas objectAtIndex:6] integerValue];
//    [self setAlbumArray:0 withNumber:(int)[[playerDatas objectAtIndex:3] integerValue]];
//    [self setAlbumArray:1 withNumber:(int)[[playerDatas objectAtIndex:4] integerValue]];
//    [self setAlbumArray:2 withNumber:(int)[[playerDatas objectAtIndex:5] integerValue]];
//    [self setAlbumArray:3 withNumber:(int)[[playerDatas objectAtIndex:6] integerValue]];
//    [self setAlbumArray:4 withNumber:(int)[[playerDatas objectAtIndex:7] integerValue]];
    score = (int)[[playerDatas objectAtIndex:9] integerValue];
    CCLOG(@"  player Datas = %@" , playerDatas);
   
}

-(void)createPlayerData{
	/* should add methods let player add name */
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *createName = [path stringByAppendingPathComponent:@"playerData"];
    for (int i = 1 ; i <= 5; i++) {
        [self setAlbumArray:i withNumber:15];
    }
    [self setAlbumArray:0 withNumber:15];
    [self setAlbumArray:1 withNumber:5];
    [self setAlbumArray:2 withNumber:15];
    [self setAlbumArray:3 withNumber:0];
    [self setAlbumArray:4 withNumber:2];
    NSArray *playerDatas = [NSArray arrayWithObjects:[NSString stringWithFormat:@"user name"],
                            [NSNumber numberWithBool:firstPlay],
                            [NSNumber numberWithInt:storySchedule],
                            [NSNumber numberWithInt:albumIntArray[0]],
                            [NSNumber numberWithInt:albumIntArray[1]],
                            [NSNumber numberWithInt:albumIntArray[2]],
                            [NSNumber numberWithInt:albumIntArray[3]],
                            [NSNumber numberWithInt:albumIntArray[4]],
                            [NSNumber numberWithInt:albumIntArray[5]],
                            [NSNumber numberWithInt:score],
                            playerBehavior,
                            nil];
	[NSKeyedArchiver archiveRootObject:playerDatas toFile:createName];
	if ( [[NSFileManager defaultManager] fileExistsAtPath:createName] ) {
		CCLOG(@"Program can't create Player's Data Array.");
	}
}

-(void)deleteData{
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *deleteDataName = [path stringByAppendingPathComponent:@"playerData"];
    NSArray *playerDatas = [NSKeyedUnarchiver unarchiveObjectWithFile:deleteDataName];
    CCLOG(@"  player Datas = %@" , playerDatas);
	if ( [[NSFileManager defaultManager] fileExistsAtPath:deleteDataName] ) {
		BOOL test = [[NSFileManager defaultManager] removeItemAtPath:deleteDataName error:nil];
		CCLOG(@"Delete = %d" , test);
	}
	
}

-(int)getAlbumArray:(int)page{
    if (page > ALBUM_PAGE_NUMBER || page < 0) {
        CCLOG(@"Error Page!!!!");
        return -1;
    }
    else{
        return albumIntArray[page];
    }
}

-(void)setAlbumArray:(int)page withNumber:(int)tempNumber{
    if ( (page > ALBUM_PAGE_NUMBER || page < 0) || (tempNumber > 15 || tempNumber < 0)) {
        CCLOG(@"Error Page!!!!");
    }
    else{
        albumIntArray[page] = tempNumber;
    }
}

@end
