//
//  GameManager.m
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//
//


#import "GameManager.h"
#import "MainMenuScene.h"
#import "LogoScene.h"
#import "FirstPlayTeachScene.h"
#import "SingleGameScene.h"
#import "AnimationScene.h"
#import "AlbumScene.h"
#import "SkillScene.h"
#import "OptionScene.h"
#import "LevelGameScene.h"

@implementation GameManager
static GameManager *_sharedGameManager = nil;
static NSString *kDateTimeFormat = @"yyyy-MM-dd HH:mm:ss";

@synthesize isMusicOn;
@synthesize isSoundEffectsOn;
@synthesize hasPlayerDied;
@synthesize today;

@synthesize managerSoundState;
@synthesize listOfSoundEffectFiles;
@synthesize soundEffectsState;

+(GameManager *)sharedGameManager{
	@synchronized([GameManager class]){
		if( !_sharedGameManager ){
			[[self alloc]init];
		}
		return _sharedGameManager;
	}
	return nil;
}

+(id)alloc{
	@synchronized([GameManager class]){
		NSAssert(_sharedGameManager == nil , @"Attempted to allocate a second instance of the Game Manager singleton");
		_sharedGameManager = [super alloc];
		return _sharedGameManager;
	}
	return nil;
}

-(id)init{
	self = [super init];
	if (self != nil) {
		CCLOG(@"Game Manager Singleton, init");
		isMusicOn = YES;
		isSoundEffectsOn = YES;
		hasPlayerDied = NO;
		currentScene = enumNoSceneUninitialized;
        
        hasAudioBeenInitialized = NO;
        soundEngine = nil;
        managerSoundState = enumAudioManagerUninitialized;
        
        /*這裡寫進讀入日期（利用switch case）並且判斷要用哪個背景 */
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:kDateTimeFormat];
        NSString *strToday = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter release];
        NSRange wantRange;
        wantRange.length = 2;
        wantRange.location = 5;
        NSString *mouth = [strToday substringWithRange:wantRange];
        wantRange.location = 8;
        NSString *day = [strToday substringWithRange:wantRange];
        NSString *recentDay = [mouth stringByAppendingString:day];
        int dateNumber = [recentDay intValue];
        CCLOG(@"Today's string = %@" , recentDay);
        CCLOG(@"Today's int format = %d" , dateNumber);
        /* Special Date = 101 , 214 , 314 , 707 , 1225 */
        
        switch ( dateNumber ) {
            case 101:
                CCLOG(@"今天是新年！！");
                today = enumNewYearBackground;
                //singleGameBackgroundLayer = [[[SingleGameBackgroundLayer alloc]initWithDate:EnumNewYearBackground] autorelease];
                break;
            case 214:
                CCLOG(@"今天是情人節！！");
                today = enumValentineDayBackground01;
                //singleGameBackgroundLayer = [[[SingleGameBackgroundLayer alloc]initWithDate:EnumValentineDayBackground01] autorelease];
                break;
            case 314:
                CCLOG(@"今天是白色情人節！！");
                today = enumValentineDayBackground02;
                //singleGameBackgroundLayer = [[[SingleGameBackgroundLayer alloc]initWithDate:EnumValentineDayBackground02] autorelease];
                break;
            case 707:
                today = enumChineseValentineDayBackground01;
                //singleGameBackgroundLayer = [[[SingleGameBackgroundLayer alloc]initWithDate:EnumChineseValentineDayBackground01] autorelease];
                CCLOG(@"今天是七夕！！");
                break;
            case 1225:
                CCLOG(@"今天是聖誕節！！");
                today = enumMarryChristmasBackground01;
                //singleGameBackgroundLayer = [[[SingleGameBackgroundLayer alloc]initWithDate:EnumMarryChristmasBackground01] autorelease];
                break;
            default:
                CCLOG(@"今天是一般日子。");
                today = enumSingleGameBackground;
                //singleGameBackgroundLayer = [[[SingleGameBackgroundLayer alloc]initWithDate:EnumSingleGameBackground] autorelease];
                break;
        }
        [self CopyDatabaseIfNeeded];
        
        /* 處理音效 */
        
	}
	return self;
}

-(void)runSceneWithID:(EnumSceneTypes)sceneID{
	EnumSceneTypes oldScene = currentScene;
	currentScene = sceneID;
	id sceneToRun = nil;
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *checkPath = [path stringByAppendingPathComponent:@"playerData"];
	switch (sceneID) {
		case enumLogoScene:
			//sceneToRun = [CCTransitionFade transitionWithDuration:changeScene scene:[SingleGameScene node]];
			sceneToRun = [CCTransitionFade transitionWithDuration:changeScene*0.5f scene:[LogoScene node]];
			break;
		case enumMainMenuScene:
			sceneToRun = [CCTransitionFade transitionWithDuration:changeScene*2 scene:[MainMenuScene node]];
			break;
		case enumSingleScene:
			if ( [[NSFileManager defaultManager] fileExistsAtPath:checkPath] ) {
				sceneToRun = [CCTransitionFade transitionWithDuration:changeScene scene:[SingleGameScene node]];
			}
			else{
				sceneToRun = [CCTransitionFade transitionWithDuration:changeScene scene:[FirstPlayTeachScene node]];
			}
			break;
		case enumFirstPlayScene:
			sceneToRun = [CCTransitionFade transitionWithDuration:changeScene scene:[FirstPlayTeachScene node]];
			break;
		case enumAnimateScene01:
			sceneToRun = [CCTransitionFade transitionWithDuration:changeScene scene:[AnimationScene node]];
			break;
			/*case diceGameQuickPlayScene:
			 sceneToRun = [QuickPlayScene node];
			 break;
			 case diceGameDiaryScene:
			 sceneToRun = [DiaryScene node];
			 break;
			 case diceGameContinueScene:
			 sceneToRun = [ContinueScene node];
			 break;*/
        case enumNoSceneUninitialized:
            sceneToRun = [CCTransitionCrossFade transitionWithDuration:changeScene scene:[FirstPlayTeachScene node]];
            break;
        case enumLVScene:
            sceneToRun = [CCTransitionCrossFade transitionWithDuration:changeScene scene:[LevelGameScene node]];
            break;
		default:
			CCLOG(@"Unknown ID, cannot switch scenes");
			return;
			break;
	}
	if( sceneToRun == nil ){
		currentScene = oldScene;
		return;
	}
    
    /* Audio */
    // load audio for new scene based on SceneID
    [self performSelectorInBackground:@selector(loadAudioForSceneWithID:) withObject:[NSNumber numberWithInt:currentScene]];
    
	if( [[CCDirector sharedDirector]runningScene] == nil ){
		[[CCDirector sharedDirector]runWithScene:sceneToRun];
	}
	else{
		[[CCDirector sharedDirector]replaceScene:sceneToRun];
	}
    
    /* Audio */
    [self performSelectorInBackground:@selector(unloadAudioForSceneWithID:) withObject:[NSNumber numberWithInt:oldScene]];
    currentScene = sceneID;
}

-(void)pushSceneWithID:(EnumSittingTypes)sittingSceneID{
    switch (sittingSceneID) {
        case enumAlbumScene:
            [[CCDirector sharedDirector] pushScene:[CCTransitionMoveInB transitionWithDuration:changeScene scene:[AlbumScene node]]];
            break;
        case enumFirstPlayeScene:
            /* 這裡要注意，如果是要新手教學請警告玩家會停止目前遊戲（避免記憶體消耗太多！（這裡可以測試看看））
             如果只有簡圖就不用離開目前遊戲（要記得幫他存檔） */
            [[CCDirector sharedDirector] pushScene:[FirstPlayTeachScene node]];
            break;
        case enumSkillScene:
            [[CCDirector sharedDirector] pushScene:[CCTransitionMoveInB transitionWithDuration:changeScene scene:[SkillScene node]]];
            break;
        case enumOptionScene:
            [[CCDirector sharedDirector] pushScene:[OptionScene node]];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark DB

-(NSString *)getDBPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);       //Documents
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"NpcEmotion.sqlite"];
}

-(void)CopyDatabaseIfNeeded{
    CCLOG(@"將 .sqlite 複製到專案上面！");
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	if(!success) {
        
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NpcEmotion.sqlite"];
        CCLOG(@"複製路徑：\n%@",defaultDBPath);
        //NSLog(@"defaultDBPath: %@", defaultDBPath);
        //NSLog(@"dbDocumentsPath: %@", dbPath);
        
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
		if (!success){
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}
	}
}

#pragma mark -
#pragma mark Audio

-(void)setupAudioEngine{
    if ( hasAudioBeenInitialized == YES ) {
        return;
    }
    else{
        hasAudioBeenInitialized = YES;
        NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
        NSInvocationOperation *asyncSetupOperation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                          selector:@selector(initAudioAsync)
                                                                                            object:nil];
        [queue addOperation:asyncSetupOperation];
        [asyncSetupOperation autorelease];
    }
}

-(void)initAudioAsync{
    managerSoundState = enumAudioManagerInitializing;
    
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    
    while ( [CDAudioManager sharedManagerState] != kAMStateInitialised ) {
        [NSThread sleepForTimeInterval:0.01f];
    }
    
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil || audioManager.soundEngine.functioning == NO) {
        CCLOG(@"CocosDenshion failed to initm no audio will play.");
        managerSoundState = enumAudioManagerFailed ;
    }
    else{
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        soundEngine = [SimpleAudioEngine sharedEngine];
        managerSoundState = enumAudioManagerReady;
        CCLOG(@"CocosDenshion is Ready.");
    }
}

-(NSString *)formatSceneTypeToString:(EnumSceneTypes)sceneID{
    NSString *result = nil;
    switch (sceneID) {
        case enumNoSceneUninitialized:
            result = @"enumNoSceneUninitialized";
            break;
        case enumMainMenuScene:
            result = @"enumMainMenuScene";
            break;
        case enumLogoScene:
            result = @"enumLogoScene";
            break;
        case enumCreditScene:
            result = @"enumCreditScene";
            break;
        case enumSingleScene:
            result = @"enumSingleScene";
            break;
        case enumFirstPlayScene:
            result = @"enumFirstPlayScene";
            break;
        case enumLVScene:
            result = @"enumLVScene";
            break;
        case enumAnimateScene01:
            result = @"enumAnimateScene01";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected SceneType!!!!"];
            break;
    }
    return result;
}

-(NSDictionary *)getSoundEffectsListForSceneWithID:(EnumSceneTypes)sceneID{
    NSString *fullFileName = @"SoundEffects.plist";
    NSString *plistPath;
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:plistPath] ) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"SoundEffects" ofType:@"plist"];
        CCLOG(@"******** plistPath = %@ **********" , plistPath);
    }
    
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    if ( plistDictionary == nil ) {
        CCLOG(@"Error reading SoundEffects.plist !!!!!");
        return nil;
    }
    
    if ( (listOfSoundEffectFiles == nil) || ([listOfSoundEffectFiles count] < 1) ) {
        NSLog(@"Before");
        [self setListOfSoundEffectFiles:[[NSMutableDictionary alloc]init]];
        NSLog(@"after");
        for ( NSString *sceneSoundDictionary in plistDictionary ) {
            [listOfSoundEffectFiles addEntriesFromDictionary:[plistDictionary objectForKey:sceneSoundDictionary]];
            CCLOG(@"YYYYYYYYYYYYYYYY");
        }
        CCLOG(@"Number of SFX filenames:%d" , [listOfSoundEffectFiles count]);
    }
    
    if ((soundEffectsState == nil ) || ([soundEffectsState count] < 1) ) {
        [self setSoundEffectsState:[[NSMutableDictionary alloc] init]];
        for ( NSString *soundEffectKey in listOfSoundEffectFiles ) {
            [soundEffectsState setObject:[NSNumber numberWithBool:SFX_NOTLOADED] forKey:soundEffectKey];
        }
    }
    NSString *sceneIDName = [self formatSceneTypeToString:sceneID];
    CCLOG(@"!!!!!!!!!!!!!!!! = %@" , sceneIDName);
    NSDictionary *soundEffectsList = [plistDictionary objectForKey:sceneIDName];
    CCLOG(@"Plist Dictionary = %@" , plistDictionary);
    if ( soundEffectsList == nil) {
        CCLOG(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
    else{
        CCLOG(@" soundEffectsList = %@" , soundEffectsList);
    }
    
    return soundEffectsList;
}

-(void)loadAudioForSceneWithID:(NSNumber *)sceneIDNumber{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    EnumSceneTypes sceneID = (EnumSceneTypes)[sceneIDNumber intValue];
    if (managerSoundState == enumAudioManagerInitializing) {
        int waitCycles = 0;
        while ( waitCycles < AUDIO_MAX_WAITTIME) {
            [NSThread sleepForTimeInterval:0.01f];
            if ((managerSoundState == enumAudioManagerReady) || (managerSoundState == enumAudioManagerFailed)) {
                break;
            }
            waitCycles = waitCycles + 1;
        }
    }
    if ( managerSoundState == enumAudioManagerFailed) {
        CCLOG(@"NOT READY~!!!");
        return;
    }
    
    NSDictionary *soundEffectsToLoad = [self getSoundEffectsListForSceneWithID:sceneID];
    if ( soundEffectsToLoad == nil ) {
        CCLOG(@"Error reading SoundEffects.plist 2");
        return;
    }
    
    for ( NSString *keyString in soundEffectsToLoad ) {
        CCLOG(@"\nLoading Audio Key:%@ File:%@" , keyString , [soundEffectsToLoad objectForKey:keyString]);
        [soundEngine preloadEffect:[soundEffectsToLoad objectForKey:keyString]];
        [soundEffectsState setObject:[NSNumber numberWithBool:SFX_LOADED] forKey:keyString];
//        CCLOG(@"有載入音樂！！！！");
//        CCLOG(@"soundEffectsState = %@" , soundEffectsState);
    }
    [pool release];
}

-(void)unloadAudioForSceneWithID:(NSNumber *)sceneIDNumber{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    EnumSceneTypes sceneID = (EnumSceneTypes)[sceneIDNumber intValue];
    if (sceneID == enumNoSceneUninitialized ) {
        return;
    }
    
    NSDictionary *soundEffectsToUnload = [self getSoundEffectsListForSceneWithID:sceneID];
    if ( soundEffectsToUnload == nil ) {
        CCLOG(@"Error reading SoundEffects.plist");
        return;
    }
    if ( managerSoundState == enumAudioManagerReady ) {
        for ( NSString *keyString in soundEffectsToUnload ) {
            [soundEffectsState setObject:[NSNumber numberWithBool:SFX_NOTLOADED] forKey:keyString];
            [soundEngine unloadEffect:keyString];
            CCLOG(@"\nUnloading Audio Key:%@ File:%@" , keyString , [soundEffectsToUnload objectForKey:keyString]);
        }
    }
    [pool release];
}

-(void)playBackgroundTrack:(NSString *)trackFileName{
    if ((managerSoundState != enumAudioManagerReady) && (managerSoundState != enumAudioManagerFailed)) {
        int waitCycles = 0;
        while ( waitCycles < AUDIO_MAX_WAITTIME ) {
            [NSThread sleepForTimeInterval:0.01f];
            if ((managerSoundState == enumAudioManagerReady) || (managerSoundState == enumAudioManagerFailed)) {
                break;
            }
            waitCycles = waitCycles + 1;
        }
    }
    
    if (managerSoundState == enumAudioManagerReady) {
        if ([soundEngine isBackgroundMusicPlaying]) {
            [soundEngine stopBackgroundMusic];
        }
        [soundEngine preloadBackgroundMusic:trackFileName];
        [soundEngine playBackgroundMusic:trackFileName loop:YES];
    }
}

-(void)stopSoundEffect:(ALuint)soundEffectID{
    if ( managerSoundState == enumAudioManagerReady) {
        [soundEngine stopEffect:soundEffectID];
    }
}

-(void)stopSoundBackground{
    if ( managerSoundState == enumAudioManagerReady) {
        [soundEngine stopBackgroundMusic];
    }
}

-(ALuint)playSoundEffect:(NSString *)soundEffectKey{
    ALuint soundID = 0;
    soundID = [soundEngine playEffect:[listOfSoundEffectFiles objectForKey:soundEffectKey]];
//    if ( managerSoundState == enumAudioManagerReady ) {
//        NSNumber *isSFXLoaded = [soundEffectsState objectForKey:soundEffectKey];
//        if ( [isSFXLoaded boolValue] == SFX_LOADED ) {
//            CCLOG(@"這裡應該要播放聲音！！！！");
//            soundID = [soundEngine playEffect:[listOfSoundEffectFiles objectForKey:soundEffectKey]];
//        }
//        else{
//            CCLOG(@"這裡因為還沒載入所以無法播放音樂！！！！");
//            CCLOG(@"GameManager : SoundEffect %@ is not loaded." , soundEffectKey);
//            CCLOG(@"SoundEffectKey = %@" , soundEffectKey);
//        }
//    }
//    else{
//        CCLOG(@"GameManager : Sound Manager is not ready , cannot play %@" , soundEffectKey);
//    }
    return soundID;
}





@end