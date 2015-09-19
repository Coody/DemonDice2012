//
//  DBManager.h
//  DiceGame
//
//  Created by Coody0829 on 13/6/28.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class FMDatabase;

@interface DBManager : NSObject{
	FMDatabase *gamePlayDB;
    int countNumber;
}

+(DBManager *)sharedGamePlayDB;

-(id)queryContext;
-(id)queryEventContextWithNumber:(EnumEventCount)tempEnumEventCount;

@end
