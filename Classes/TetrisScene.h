//
//  TetrisScene.h
//  Tetris
//
//  Created by benzhemin on 11-9-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define ROWS 18
#define COLS 11
#define SIZE 20

typedef enum _ColorType {
	EmptyColor = 0,
	LightGrayColor,
	DaryGrayColor,
	PurpleColor,
	WhiteColor
} ColorType;

@interface TetrisScene : UIView {
	ColorType colorarea[ROWS][COLS];
}

-(void)clearAllTetris;

-(ColorType)colorAtRow:(int)row andCol:(int)col;
-(void)setColorRow:(int)row withCol:(int)col withColor:(ColorType) color;

-(ColorType (*)[COLS]) colorArea;

-(CGColorRef) colorWithType:(ColorType) colortype;

@end
