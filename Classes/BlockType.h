//
//  BlockType.h
//  Tetris
//
//  Created by zhe zhang on 11-9-3.
//  Copyright 2011 Ideal Information Industry. All rights reserved.
//

#import <Foundation/Foundation.h>

// one dimension reflects type，two dimension reflects coordinate
// there are 7 block types.
// note:every tetris block consists of 4 blocks.
// every tetris have 4 directions.
#define BLOCKTYPE 7
#define BLOCKPIECES 4
#define BLOCKDIRECTIONS 4

extern int blockPosX[BLOCKTYPE][BLOCKDIRECTIONS][BLOCKPIECES];

extern int blockPosY[BLOCKTYPE][BLOCKDIRECTIONS][BLOCKPIECES];

typedef enum _direction{
	updirect = 0, 
	leftdirect,  
	downdirect,
	rightdirect,
	
	//as mark
	enddirect
	
} direction;

extern int currentDirection;

