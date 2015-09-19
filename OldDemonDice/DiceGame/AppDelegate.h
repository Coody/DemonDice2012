//
//  AppDelegate.h
//  DiceGame
//
//  Created by Coody0829 on 12/12/16.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    bool  m_bRetinaMode;
}

@property (nonatomic, retain) UIWindow *window;

-(bool)isRetinaMode;

@end
