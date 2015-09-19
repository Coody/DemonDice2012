//
//  SuperDiceGameboard.h
//  DiceGame
//
//  Created by Coody0829 on 13/5/21.
//
//

#import "CCSprite.h"

#pragma mark - 超級骰子的 Delegate
@protocol SuperDiceGameboardDelegate <NSObject>

/** 要如何顯示超級骰子棋盤 */
-(void)showGameboardDelegate;

@optional
/** 要如何移動超級骰子棋盤（可以不實作） */
-(void)moveGameboardDelegate;

@end


#pragma mark - 超級骰子的棋盤
@interface SuperDiceGameboard : CCSprite
//{
//	id <SuperDiceGameboardDelegate> delegate;
//}

@property (nonatomic, retain) id <SuperDiceGameboardDelegate> delegate;

/** 移動棋盤 */
-(void)moveGameboard;
/** 顯示棋盤 */
-(void)showGameboard;

@end
