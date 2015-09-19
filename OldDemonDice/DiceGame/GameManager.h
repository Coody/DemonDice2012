//
//  GameManager.h
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface GameManager : NSObject {
    BOOL isMusicOn;
	BOOL isSoundEffectsOn;
	BOOL hasPlayerDied;
	EnumSceneTypes currentScene;
    
    EnumBackgroundData today;
    
    /* Add for Audio */
    BOOL hasAudioBeenInitialized;
    EnumGameManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    NSMutableDictionary *listOfSoundEffectFiles;
    NSMutableDictionary *soundEffectsState;
}

@property(readwrite) BOOL isMusicOn;
@property(readwrite) BOOL isSoundEffectsOn;
@property(readwrite) BOOL hasPlayerDied;
@property(readwrite) EnumBackgroundData today;

@property(readwrite) EnumGameManagerSoundState managerSoundState;
@property(nonatomic , retain) NSMutableDictionary *listOfSoundEffectFiles;
@property(nonatomic , retain) NSMutableDictionary *soundEffectsState;

+(GameManager *)sharedGameManager;
-(void)runSceneWithID:(EnumSceneTypes)sceneID;
-(void)pushSceneWithID:(EnumSittingTypes)sittingSceneID;

/* 處理聲音部分 */
-(void)setupAudioEngine;
-(ALuint)playSoundEffect:(NSString *)soundEffectKey;
-(void)stopSoundEffect:(ALuint)soundEffectID;
-(void)stopSoundBackground;
-(void)playBackgroundTrack:(NSString *)trackFileName;

/* 預先讀出DB的資料，讓每個更換畫面都會用到此DB */

-(NSString *)getDBPath;

@end
