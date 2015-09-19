//
//  AlbumPage.m
//  DiceGame
//
//  Created by coody0829 on 13/10/5.
//
//

#import "AlbumPage.h"
#import "GamePlayer.h"
#import "GameManager.h"

@implementation AlbumPage
@synthesize delegate;
@synthesize imageSelectedOrNot;
@synthesize recentPageNumber;

-(id)initWithPageNumber:(int)pageNumber{
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        if ( screenSize.height > 480 ) {
            iPhone5 = YES;
        }
        else{
            iPhone5 = NO;
        }
        
        recentPageNumber = pageNumber;
        delegate = nil;
        imageSelectedOrNot = NO;
        selectImageNumber = 0;
        
        getPicNumber = [[GamePlayer sharedGamePlayer] getAlbumArray:pageNumber];
        
        /* 此為測試資料！！ */
        //getPicNumber = 15;
        
        CCSprite *albumnBackground = [CCSprite spriteWithFile:[NSString stringWithFormat:@"albumnBackground%d.png",pageNumber]];
        [self addChild:albumnBackground];
        [albumnBackground setPosition:ccp(screenSize.width*0.5f, screenSize.height*0.5f)];
        
        int tempNubmer ;
        
        /* 2進位法來計算相本有哪些相片可以開啟，最高為15， */
        getPicString = [NSString stringWithFormat:@"pic%d-",pageNumber];
        int picNumber1 = getPicNumber % 2;
        tempNubmer = getPicNumber / 2;
        int picNumber2 = tempNubmer % 2 ;
        tempNubmer = tempNubmer / 2;
        int picNumber3 = tempNubmer % 2 ;
        tempNubmer = tempNubmer / 2;
        int picNumber4 = tempNubmer % 2;
        
        /* 圖案名稱定為：pic1-1 (相本第一頁、第一張（最多四張）左下1,右下2,左上3,右上4) */
        /* 選擇圖案名稱定為：Pic1-1Selected */
        if ( picNumber1 == 1) {
            firstImage = [CCMenuItemImage itemFromNormalImage:[getPicString stringByAppendingFormat:@"%d.png" , 1]
                                                selectedImage:[getPicString stringByAppendingFormat:@"%dSelected.png",1]
                                                disabledImage:nil
                                                       target:self
                                                     selector:@selector(selectFirstImage)];
            CCLOG(@"getPicNumber = %@" , [getPicString stringByAppendingFormat:@"%d.png",1]);
        }
        else{
            firstImage = [CCMenuItemImage itemFromNormalImage:@"lockPic.png" selectedImage:nil];
            //firstPic = [[PhotoSprite alloc] initWithPicNumber:1 withFileName:@"lockPic.png"];
        }
        if ( picNumber2 == 1) {
            secondImage = [CCMenuItemImage itemFromNormalImage:[getPicString stringByAppendingFormat:@"%d.png",2]
                                                selectedImage:[getPicString stringByAppendingFormat:@"%dSelected.png",2]
                                                disabledImage:nil
                                                       target:self
                                                     selector:@selector(selectSecondImage)];
            CCLOG(@"getPicNumber = %@" , [getPicString stringByAppendingFormat:@"%d.png",2]);
        }
        else{
            secondImage = [CCMenuItemImage itemFromNormalImage:@"lockPic.png" selectedImage:nil];
            //secondPic = [[PhotoSprite alloc] initWithPicNumber:3 withFileName:@"lockPic.png"];
        }
        if ( picNumber3 == 1) {
            thirdImage = [CCMenuItemImage itemFromNormalImage:[getPicString stringByAppendingFormat:@"%d.png",3]
                                                 selectedImage:[getPicString stringByAppendingFormat:@"%dSelected.png",3]
                                                 disabledImage:nil
                                                        target:self
                                                      selector:@selector(selectThirdImage)];
            CCLOG(@"getPicNumber = %@" , [getPicString stringByAppendingFormat:@"%d.png",3]);
        }
        else{
            thirdImage = [CCMenuItemImage itemFromNormalImage:@"lockPic.png" selectedImage:nil];
        }
        if ( picNumber4 == 1) {
            fourthImage = [CCMenuItemImage itemFromNormalImage:[getPicString stringByAppendingFormat:@"%d.png",4]
                                                selectedImage:[getPicString stringByAppendingFormat:@"%dSelected.png",4]
                                                disabledImage:nil
                                                       target:self
                                                     selector:@selector(selectFourthImage)];
            CCLOG(@"getPicNumber = %@" , [getPicString stringByAppendingFormat:@"%d.png",4]);
        }
        else{
            fourthImage = [CCMenuItemImage itemFromNormalImage:@"lockPic.png" selectedImage:nil];
        }
        
        [firstImage setPosition:ccp(screenSize.width*0.44f, screenSize.height*0.3f)]; /* 140,145 */
        [secondImage setPosition:ccp(screenSize.width*0.82f, screenSize.height*0.3f)];
        [thirdImage setPosition:ccp(screenSize.width*0.44f, screenSize.height*0.8f)];
        [fourthImage setPosition:ccp(screenSize.width*0.82f, screenSize.height*0.8f)]; /* 260,385 */
        //[firstImage setScale:0.25f];
        //[secondImage setScale:0.25f];
        //[thirdImage setScale:0.25f];
        //[fourthImage setScale:0.25f];
        
        imageMenu = [CCMenu menuWithItems:firstImage,secondImage,thirdImage,fourthImage, nil];
        [self addChild:imageMenu z:0];
        [imageMenu setPosition:ccp(0, 0)];
        originalImage = nil;
        PLAYSOUNDEFFECT(CLICK_BUTTON);
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
}

-(void)selectFirstImage{
    CCLOG(@"first image");
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    if ( imageSelectedOrNot == NO ) {
        selectImageNumber = 1;
        imageSelectedOrNot = YES;
        /* 將image的Layer zOrder增加，移到螢幕前面 */
        [self selectImage];
        
        id scaleImage = [CCScaleTo actionWithDuration:0.3f scale:4.0f];
        [firstImage runAction:scaleImage];
        id moveImage = [CCMoveTo actionWithDuration:0.3f position:ccp(screenSize.width*0.5f,screenSize.height*0.5f)];
        [firstImage runAction:moveImage];
        [self reorderChild:firstImage z:100];
        
        /* 這裡是實作將原始畫面載入 */
        //[getPicString stringByAppendingFormat:@"%dOriginal" , 1];
        //CCLOG(@"getPicString page1,pic1-1 = %@" , [getPicString stringByAppendingFormat:@"%dOriginal.png" , 1]);
        if ( iPhone5 ) {
            originalImage = [CCSprite spriteWithFile:@"startBackgroundIPhone5.png"];
        }
        else{
            originalImage = [CCSprite spriteWithFile:@"startBackground.png"];
        }
        
        [originalImage setOpacity:0];
        
        [self addChild:originalImage z:110];
        [originalImage setPosition:ccp(screenSize.width*0.5f,screenSize.height*0.5f)];
        id delayShowImage = [CCDelayTime actionWithDuration:0.3f];
        id showImage = [CCFadeIn actionWithDuration:0.1f];
        id allAction = [CCSequence actionOne:delayShowImage two:showImage];
        [originalImage runAction:allAction];
    }
    else if( selectImageNumber == 1 && imageSelectedOrNot == YES ){
        imageSelectedOrNot = NO;
        /* 將image的Layer zOrder增加，移到螢幕前面 */
        [self selectImage];
        id scaleImage = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
        [firstImage runAction:scaleImage];
        id moveImage = [CCMoveTo actionWithDuration:0.1f position:ccp(screenSize.width*0.44f, screenSize.height*0.3f)];
        [firstImage runAction:moveImage];
        [self reorderChild:firstImage z:0];
        [self removeChild:originalImage cleanup:YES];
    }
}

-(void)selectSecondImage{
    CCLOG(@"second image");
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    if (imageSelectedOrNot == NO) {
        selectImageNumber = 2;
        imageSelectedOrNot = YES;
        /* 將image的Layer zOrder增加，移到螢幕前面 */
        [self selectImage];
        
        id scaleImage = [CCScaleTo actionWithDuration:0.3f scale:4.0f];
        [secondImage runAction:scaleImage];
        id moveImage = [CCMoveTo actionWithDuration:0.3f position:ccp(screenSize.width*0.5f,screenSize.height*0.5f)];
        [secondImage runAction:moveImage];
        [self reorderChild:secondImage z:100];

        /* 載入遊戲原尺寸圖片 */
        //originalImage = [CCSprite spriteWithFile:[getPicString stringByAppendingFormat:@"%dOriginal.png",2]];
        if ( iPhone5 ) {
            originalImage = [CCSprite spriteWithFile:@"startBackgroundIPhone5.png"];
        }
        else{
            originalImage = [CCSprite spriteWithFile:@"startBackground.png"];
        }
        [originalImage setOpacity:0];
        
        [self addChild:originalImage z:110];
        [originalImage setPosition:ccp(screenSize.width*0.5f,screenSize.height*0.5f)];
        id delayShowImage = [CCDelayTime actionWithDuration:0.3f];
        id showImage = [CCFadeIn actionWithDuration:0.1f];
        id allAction = [CCSequence actionOne:delayShowImage two:showImage];
        [originalImage runAction:allAction];
    }
    else if( selectImageNumber == 2 && imageSelectedOrNot == YES ){
        imageSelectedOrNot = NO;
        /* 將image的Layer zOrder增加，移到螢幕前面 */
        [self selectImage];
        id scaleImage = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
        [secondImage runAction:scaleImage];
        id moveImage = [CCMoveTo actionWithDuration:0.1f position:ccp(screenSize.width*0.82f, screenSize.height*0.3f)];
        [secondImage runAction:moveImage];
        [self reorderChild:secondImage z:0];
        [self removeChild:originalImage cleanup:YES];
    }
}

-(void)selectThirdImage{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    /* 將image的Layer zOrder增加，移到螢幕前面 */
    if (imageSelectedOrNot == NO) {
        selectImageNumber = 3;
        imageSelectedOrNot = YES;
        /* 將image的Layer zOrder增加，移到螢幕前面 */
        [self selectImage];
        
        id scaleImage = [CCScaleTo actionWithDuration:0.3f scale:4.0f];
        [thirdImage runAction:scaleImage];
        id moveImage = [CCMoveTo actionWithDuration:0.3f position:ccp(screenSize.width*0.5f,screenSize.height*0.5f)];
        [thirdImage runAction:moveImage];
        [self reorderChild:thirdImage z:100];

        /* 載入遊戲原尺寸圖片 */
        //originalImage = [CCSprite spriteWithFile:[getPicString stringByAppendingFormat:@"%dOriginal.png",3]];
        if ( iPhone5 ) {
            originalImage = [CCSprite spriteWithFile:@"startBackgroundIPhone5.png"];
        }
        else{
            originalImage = [CCSprite spriteWithFile:@"startBackground.png"];
        }
        [originalImage setOpacity:0];
        
        [self addChild:originalImage z:110];
        [originalImage setPosition:ccp(screenSize.width*0.5f,screenSize.height*0.5f)];
        id delayShowImage = [CCDelayTime actionWithDuration:0.3f];
        id showImage = [CCFadeIn actionWithDuration:0.1f];
        id allAction = [CCSequence actionOne:delayShowImage two:showImage];
        [originalImage runAction:allAction];
    }
    else if( selectImageNumber == 3 && imageSelectedOrNot == YES ){
        imageSelectedOrNot = NO;
        /* 將image的Layer zOrder增加，移到螢幕前面 */
        [self selectImage];
        id scaleImage = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
        [thirdImage runAction:scaleImage];
        id moveImage = [CCMoveTo actionWithDuration:0.1f position:ccp(screenSize.width*0.44f, screenSize.height*0.8f)];
        [thirdImage runAction:moveImage];
        [self reorderChild:thirdImage z:0];
        [self removeChild:originalImage cleanup:YES];
    }
}

-(void)selectFourthImage{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    if (imageSelectedOrNot == NO) {
        selectImageNumber = 4;
        imageSelectedOrNot = YES;
        /* 將image的Layer zOrder增加，移到螢幕前面 */
        [self selectImage];
        
        id scaleImage = [CCScaleTo actionWithDuration:0.3f scale:4.0f];
        [fourthImage runAction:scaleImage];
        id moveImage = [CCMoveTo actionWithDuration:0.3f position:ccp(screenSize.width*0.5f,screenSize.height*0.5f)];
        [fourthImage runAction:moveImage];
        [self reorderChild:fourthImage z:100];

        /* 載入遊戲原尺寸圖片 */
        //originalImage = [CCSprite spriteWithFile:[getPicString stringByAppendingFormat:@"%dOriginal.png",4]];
        if ( iPhone5 ) {
            originalImage = [CCSprite spriteWithFile:@"startBackgroundIPhone5.png"];
        }
        else{
            originalImage = [CCSprite spriteWithFile:@"startBackground.png"];
        }
        [originalImage setOpacity:0];
        
        [self addChild:originalImage z:110];
        [originalImage setPosition:ccp(screenSize.width*0.5f,screenSize.height*0.5f)];
        id delayShowImage = [CCDelayTime actionWithDuration:0.3f];
        id showImage = [CCFadeIn actionWithDuration:0.1f];
        id allAction = [CCSequence actionOne:delayShowImage two:showImage];
        [originalImage runAction:allAction];
    }
    else if( selectImageNumber == 4 && imageSelectedOrNot == YES ){
        imageSelectedOrNot = NO;
        /* 將image的Layer zOrder增加，移到螢幕前面 */
        [self selectImage];
        id scaleImage = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
        [fourthImage runAction:scaleImage];
        id moveImage = [CCMoveTo actionWithDuration:0.1f position:ccp(screenSize.width*0.82f, screenSize.height*0.8f)];
        [fourthImage runAction:moveImage];
        [self reorderChild:fourthImage z:0];
        [self removeChild:originalImage cleanup:YES];
    }
}

-(void)selectImage{
    [delegate selectImageDelegate];
}

@end
