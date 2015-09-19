//
//  AlbumScene.m
//  DiceGame
//
//  Created by coody0829 on 13/10/4.
//
//

#import "AlbumScene.h"

@implementation AlbumScene

-(id)init{
    self = [super init];
    if (self != nil) {
        albumButtonLayer = [AlbumButtonLayer node];
        [self addChild:albumButtonLayer z:10];
        [albumButtonLayer setDelegate:self];
        
        albumPage = [[AlbumPage alloc] initWithPageNumber:1];
        [self addChild:albumPage z:0];
        [albumPage setDelegate:self];
    }
    return self;
}

-(void)dealloc{
    [albumPage release];
    [super dealloc];
}

-(void)selectImageDelegate{
    if (albumPage.imageSelectedOrNot == YES) {
        [self reorderChild:albumPage z:20];
        [albumButtonLayer setAlbumMenuTouch:NO];
    }
    else{
        [self reorderChild:albumPage z:0];
        [albumButtonLayer setAlbumMenuTouch:YES];
    }
    
}

-(void)addAlbumPageDelegateWithPageNumber:(int)tempPageNumber{
    if (tempPageNumber != albumPage.recentPageNumber) {
        [self removeChild:albumPage cleanup:YES];
        //[albumLayer release];
        albumPage = [[AlbumPage alloc] initWithPageNumber:tempPageNumber];
        [self addChild:albumPage z:0];
        [albumPage setDelegate:self];
    }
}

@end
