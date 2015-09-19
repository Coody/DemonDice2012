//
//  AlbumLayer.m
//  DiceGame
//
//  Created by coody0829 on 13/10/4.
//
//

#import "AlbumButtonLayer.h"
#import "GameManager.h"

@interface AlbumButtonLayer()

-(void)selectPage01;
-(void)selectPage02;
-(void)selectPage03;
-(void)selectPage04;
-(void)selectPage05;
-(void)backToSingleGameScene;

-(void)test;

@end

@implementation AlbumButtonLayer
@synthesize delegate;

-(id)init{
    self = [super init];
    if (self != nil) {
        delegate = nil;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
//        CCSprite *background = [CCSprite spriteWithFile:@"albumnBackground.png"];
//        [self addChild:background];
//        [background setPosition:ccp(200, screenSize.height*0.5f)];
        CCMenuItemImage *page01 = [CCMenuItemImage itemFromNormalImage:@"albumPage01Button.png"
                                                         selectedImage:@"albumPage01Button.png"
                                                         disabledImage:nil
                                                                target:self
                                                              selector:@selector(selectPage01)];
        
        CCMenuItemImage *page02 = [CCMenuItemImage itemFromNormalImage:@"albumPage02Button.png"
                                                         selectedImage:@"albumPage02Button.png"
                                                         disabledImage:nil
                                                                target:self
                                                              selector:@selector(selectPage02)];
        
        CCMenuItemImage *page03 = [CCMenuItemImage itemFromNormalImage:@"albumPage03Button.png"
                                                         selectedImage:@"albumPage03Button.png"
                                                         disabledImage:nil
                                                                target:self
                                                              selector:@selector(selectPage03)];
        
        CCMenuItemImage *page04 = [CCMenuItemImage itemFromNormalImage:@"albumPage04Button.png"
                                                         selectedImage:@"albumPage04Button.png"
                                                         disabledImage:nil
                                                                target:self
                                                              selector:@selector(selectPage04)];
        
        CCMenuItemImage *page05 = [CCMenuItemImage itemFromNormalImage:@"albumPage05Button.png"
                                                         selectedImage:@"albumPage05Button.png"
                                                         disabledImage:nil
                                                                target:self
                                                              selector:@selector(selectPage05)];
        
        CCMenuItemImage *page06 = [CCMenuItemImage itemFromNormalImage:@"backButton.png"
                                                         selectedImage:@"backButton.png"
                                                         disabledImage:nil
                                                                target:self
                                                              selector:@selector(backToSingleGameScene)];
        selectAlbumMenu = [CCMenu menuWithItems:page01,page02,page03,page04,page05,page06, nil];
        /* 這裡最好是將其用成固定位置（因為iPhone的寬度不變，只有高度改變） */
        if ( screenSize.height > 480 ) {
            [selectAlbumMenu setPosition:ccp(43, 317)];//43
            /* 這裡是指iPhone5 的四吋螢幕大小 */
        }
        else{
            [selectAlbumMenu setPosition:ccp(43, 240)];
        }
        //[selectAlbumMenu setPosition:ccp(60, 360)];
        [selectAlbumMenu alignItemsVerticallyWithPadding:1.2f];
        [self addChild:selectAlbumMenu];
        
//        CCMenuItemImage *returnButtonImage = [CCMenuItemImage itemFromNormalImage:@"backSingleGameButton.png"
//                                                                    selectedImage:@"backSingleGameButtonSelected.png"
//                                                                    disabledImage:nil
//                                                                           target:self
//                                                                         selector:@selector(backToSingleGameScene)];
//        returnButton = [CCMenu menuWithItems: returnButtonImage , nil];
//        [self addChild:returnButton];
//        [returnButton setPosition:ccp(20, 20)];
        [self selectPage01];
        
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
}

#pragma mark -
#pragma mark selectMethods
-(void)selectPage01{
    //[pageTopImage setScale:1.0f];
    [self removeChild:pageTopImage cleanup:YES];
    
    [delegate addAlbumPageDelegateWithPageNumber:1];
    //[self setScale:1.1f];
//    pageTopImage = [CCSprite spriteWithFile:@"albumPage01Button.png"];
//    [pageTopImage setScale:1.1f];
//    [self addChild:pageTopImage];
//    if ( [CCDirector sharedDirector].winSize.height > 480 ) {
//        
//        [pageTopImage setPosition:ccp(43, 526)];
//    }
//    else{
//        
//        [pageTopImage setPosition:ccp(43, 438)];
//    }
}
-(void)selectPage02{
    //[pageTopImage setScale:1.0f];
    [self removeChild:pageTopImage cleanup:YES];
    [delegate addAlbumPageDelegateWithPageNumber:2];
    //[self setScale:1.1f];
//    pageTopImage = [CCSprite spriteWithFile:@"albumPage01Button.png"];
//    [pageTopImage setScale:1.1f];
//    [self addChild:pageTopImage];
//    if ( [CCDirector sharedDirector].winSize.height > 480 ) {
//        
//        [pageTopImage setPosition:ccp(43, 446)];
//    }
//    else{
//        [pageTopImage setPosition:ccp(43, 358)];
//    }
    
}
-(void)selectPage03{
    [self removeChild:pageTopImage cleanup:YES];
    [delegate addAlbumPageDelegateWithPageNumber:3];
}
-(void)selectPage04{
    [self removeChild:pageTopImage cleanup:YES];
    [delegate addAlbumPageDelegateWithPageNumber:4];
}
-(void)selectPage05{
    [self removeChild:pageTopImage cleanup:YES];
    [delegate addAlbumPageDelegateWithPageNumber:5];
}

-(void)backToSingleGameScene{
    [self removeChild:pageTopImage cleanup:YES];
    [[CCDirector sharedDirector] popScene];
}

-(void)setAlbumMenuTouch:(BOOL)tempBool{
    [selectAlbumMenu setIsTouchEnabled:tempBool];
}

#pragma mark -
#pragma mark testMethods

-(void)test{
    
}

@end
