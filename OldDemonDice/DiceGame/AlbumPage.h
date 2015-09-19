//
//  AlbumPage.h
//  DiceGame
//
//  Created by coody0829 on 13/10/5.
//
//

#import "cocos2d.h"
#import "AlbumPageDelegate.h"

@interface AlbumPage : CCLayer {
    int getPicNumber;
    int recentPageNumber;
    
    int selectImageNumber ;
    CCMenuItem *firstImage;
    CCMenuItem *secondImage;
    CCMenuItem *thirdImage;
    CCMenuItem *fourthImage;
    CCMenu *imageMenu;
    
    id <AlbumPageDelegate> delegate;
    
    BOOL imageSelectedOrNot;
    CCSprite *originalImage;
    
    NSString *getPicString;
    
    BOOL iPhone5 ;
}

@property (nonatomic, retain) id <AlbumPageDelegate> delegate;
@property (readonly) BOOL imageSelectedOrNot;
@property (readonly) int recentPageNumber;

-(id)initWithPageNumber:(int)pageNumber;

@end
