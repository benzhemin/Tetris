//
//  GameControl.h
//  Tetris
//
//  Created by benzhemin on 11-9-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TetrisScene.h"
#import "BlockType.h"

@interface GameControl : NSObject {
	TetrisScene *ttscene;
	BOOL isGameOver;
	
	BOOL isDropping;
	int currentX;
	int currentY;
	int tryX;
	int tryY;
	
	//current tetris type
    int tetristype;
	
	//current tetris direction
	direction tetrisdirect;
	
	//the current tetris position x
	int tetrisX[BLOCKPIECES];
	//the current tetris position y
	int tetrisY[BLOCKPIECES];
	
	//now we have two achievement
	//生存时间最长
	int aliveTimeAchievement;
	//消除行数最多
	int removeLineAchievement;
}

@property(nonatomic, retain) TetrisScene *ttscene;
@property(nonatomic, assign) BOOL isGameOver;

-(void)startGame;

-(void)gameLife;

-(double)sleepTime;

-(BOOL)checkPlace;

-(BOOL)intersectPeviousPart:(int)placeX withPlaceY:(int)placeY;

-(int)generateNewBlock;

-(void)removeLines;

-(void)rotateTetris;
-(BOOL)canRotate:(direction)direct;

-(void)moveTetrisLeft;
-(void)moveTetrisRight;
-(void)moveTetrisDown;

-(void)eraseCurrentTetris;
-(void)drawCurrentTetris;

@end
