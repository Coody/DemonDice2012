//
//  DBManager.m
//  DiceGame
//
//  Created by Coody0829 on 13/6/28.
//
//

#import "DBManager.h"
#import "FMDatabase.h"
#import "cocos2d.h"

DBManager *sharedInstance;

@implementation DBManager

/***************** 重要必須重複複習熟習！！（三個重要methods） ********************/

- (void)loadDB{
    NSURL *appUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *dbPath = [[appUrl path] stringByAppendingPathComponent:@"NpcEmotion.sqlite"];
    gamePlayDB = [FMDatabase databaseWithPath:dbPath];
    if( ![gamePlayDB open]){
        NSLog(@"Could not open DB!!");
        return;
    }
    else{
        NSLog(@"資料庫有開成功!!");
        return;
    }
    
//    NSURL *appUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    NSString *dbPath = [[appUrl path] stringByAppendingPathComponent:@"test.sqlite"];
//    gamePlayDB = [FMDatabase databaseWithPath:dbPath];
//    
//    if (![gamePlayDB open]) {
//        NSLog(@"Could not open db");
//        return ;
//    }
//    else{
//        NSLog(@"資料庫有開成功!!");
//        return;
//    }
}

- (id)init{
    self = [super init];
    if (self != nil){
        [self loadDB];
        NSString *countContextString = @"SELECT * FROM Dialog";
        FMResultSet *numberRs = [gamePlayDB executeQuery:countContextString];
        while ( [numberRs next] ) {
            countNumber++;
        }
        CCLOG(@"資料庫對話有 %d 個資料！！！！", countNumber);
        [numberRs close];
        [gamePlayDB close];
        
        CCLOG(@"countNumber = %d" , countNumber);
    }
    return self;
}

+ (DBManager *)sharedGamePlayDB{
    if(sharedInstance == nil){
        sharedInstance = [[DBManager alloc]init];
    }
    return sharedInstance;
}

#pragma mark -

-(NSString *)findNPC{
    //NSString *npcName;
    
    return @"test find NPC!";
}

-(id)queryContext{
    NSString *tempContext;
    [self loadDB];
    
    int randomNumberID = arc4random()%countNumber+1;
    //NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    CCLOG(@"random number = %d" , randomNumberID);
    NSString *selectString = @"SELECT Context FROM Dialog WHERE DID=?";
    NSNumber *randomNumberIDString = [NSNumber numberWithInt:randomNumberID];
    CCLOG(@"string number = %@" , randomNumberIDString);
    FMResultSet *rs = [gamePlayDB executeQuery:selectString,randomNumberIDString];
    while([rs next]){
        tempContext = [rs stringForColumn:@"Context"];
        NSLog(@"context = %@" , tempContext);
    }
    [rs close];
    [gamePlayDB close];
    return tempContext;
}

-(id)queryEventContextWithNumber:(EnumEventCount)tempEnumEventCount{
    NSString *tempContext;
    [self loadDB];
    
    //int randomNumberID = arc4random()%countNumber+1;
    //NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    
    NSString *selectString = @"SELECT Context FROM Event WHERE EID=?";
    NSNumber *randomNumberIDString = [NSNumber numberWithInt:tempEnumEventCount];
    FMResultSet *rs = [gamePlayDB executeQuery:selectString,randomNumberIDString];
    while([rs next]){
        tempContext = [rs stringForColumn:@"Context"];
    }
    NSLog(@"context = %@" , tempContext);
    NSArray *tempContextArray = [tempContext componentsSeparatedByString:@"，"];
    
    [rs close];
    [gamePlayDB close];
    return tempContextArray;
}

@end