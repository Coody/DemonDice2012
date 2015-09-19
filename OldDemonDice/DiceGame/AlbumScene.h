//
//  AlbumScene.h
//  DiceGame
//
//  Created by coody0829 on 13/10/4.
//
//

#import "CCScene.h"
#import "AlbumButtonLayer.h"
#import "AlbumPage.h"
#import "AlbumPageDelegate.h"
#import "AlbumButtonLayerDelegate.h"

@interface AlbumScene : CCScene <AlbumPageDelegate , AlbumButtonLayerDelegate>{
    AlbumButtonLayer *albumButtonLayer;
    AlbumPage *albumPage;
}

@end
