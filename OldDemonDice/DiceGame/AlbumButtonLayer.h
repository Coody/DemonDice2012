//
//  AlbumLayer.h
//  DiceGame
//
//  Created by coody0829 on 13/10/4.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AlbumButtonLayerDelegate.h"

@interface AlbumButtonLayer : CCLayer{
    CCMenu *selectAlbumMenu;
    //CCMenu *returnButton;
    
    CCSprite *pageTopImage;
    
    id <AlbumButtonLayerDelegate> delegate;
}

@property (nonatomic,retain) id <AlbumButtonLayerDelegate> delegate;

-(void)setAlbumMenuTouch:(BOOL)tempBool;

@end
