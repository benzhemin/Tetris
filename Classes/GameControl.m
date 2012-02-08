//
//  GameControl.m
//  Tetris
//
//  Created by benzhemin on 11-9-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameControl.h"

static double delay= 400;

@implementation GameControl

@synthesize isGameOver;

-(void)dealloc{
	[ttscene release];
	[super dealloc];
}

-(id)init{
	self = [super init];
	if (self) {
		isGameOver = NO;
		isDropping = NO;
		
		currentX = COLS/2;
		currentY = -1;
		tryX = 0;
		tryY = 0;
		
		tetristype = 0;
		tetrisdirect = updirect;
	}
	return self;
}

@synthesize ttscene;

-(void)startGame{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	while (YES) {
		if (![self isGameOver]) {
			[NSThread sleepForTimeInterval:[self sleepTime]];
			[self gameLife];
		}else {
			NSLog(@"Game Over!");
			
			[NSThread sleepForTimeInterval:2];
			isGameOver = NO;
			[ttscene clearAllTetris];
			
			break;
		}
	}
	
	[pool release];
}

//start to dreams lost， dreams found
-(void)gameLife{

	if (isDropping) {
		
		//check if the current place can contain the block.
		tryX = currentX;
		tryY = currentY;
		
		//default
		tryY++;
		if ([self checkPlace]) {
			
			[self eraseCurrentTetris];
			currentY++;
			[self drawCurrentTetris];
			
		}else {
			if (currentY == 0 && [self checkPlace] == NO) {
				isGameOver = YES;
				return;
			}
			[self removeLines];
			isDropping = FALSE;
			currentY = -1;
			currentX = COLS/2;
		}
		
	}else {
		tetristype = [self generateNewBlock];
		//initialize current tetris block for later it will be used 
		//at here we cpy memory for tetris, for later we will rotate the tetris
		memcpy(tetrisX, blockPosX[tetristype][tetrisdirect], BLOCKPIECES*sizeof(int));
		memcpy(tetrisY, blockPosY[tetristype][tetrisdirect], BLOCKPIECES*sizeof(int));
		
		isDropping = YES;
	}
	
	[ttscene performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
}

-(double)sleepTime{
	return delay/1000.0;
}

-(int)generateNewBlock{
	tetrisdirect = updirect;
	currentX = COLS/2;
	return arc4random() % BLOCKTYPE;
}

//always comput tryX,tryY to evaluate wheather can place next tetris block
//as default check, we only check whether we can place downward.
-(BOOL)checkPlace{
    // check the currentX can place the block.
	BOOL canPlace = YES;
	
	int placeX;
	int placeY;
	
	//can place down ?
	{
		for (int i=0; i<BLOCKPIECES; i++) {
			placeX = tryX + *(tetrisX+i);
			placeY = tryY + *(tetrisY+i);
			
			//ignore the upper part
			if ([self intersectPeviousPart:placeX withPlaceY:placeY]) {
				continue;
			}
			
			//for the upward beyounds the whole tetris area, we ignore it.
			if (placeY < 0) {
				continue;
			}
			
			//can not be placed out of the tetris area
			if (placeX<0 || placeX>=COLS) {
				return NO;
			}
			if (placeY>=ROWS) {
				return NO;
			}
			
			if ([ttscene colorAtRow:placeY andCol:placeX]!=EmptyColor) {
				return NO;
			}
		}
	}
	return canPlace;
}

//perform at main thread
-(void)moveTetrisLeft{
	tryX--;
	if ([self checkPlace]) {
		[self eraseCurrentTetris];
		currentX--;
		[self drawCurrentTetris];
		[ttscene setNeedsDisplay];
		return ;
	}
	tryX++;
}

-(void)moveTetrisRight{
	tryX++;
	if ([self checkPlace]) {
		[self eraseCurrentTetris];
		currentX++;
		[self drawCurrentTetris];
		[ttscene setNeedsDisplay];
		return ;
	}
	tryX--;
}

-(void)moveTetrisDown{
	tryY++;
	if ([self checkPlace]) {
		[self eraseCurrentTetris];
		currentY++;
		[self drawCurrentTetris];
		[ttscene setNeedsDisplay];
		return ;
	}
	tryY--;
}

-(void)rotateTetris{
	direction trydirect = tetrisdirect;
	trydirect = (trydirect+1) % enddirect;
	
	if ([self canRotate:trydirect]) {
		[self eraseCurrentTetris];
		memcpy(tetrisX, blockPosX[tetristype][trydirect], BLOCKPIECES*sizeof(int));
		memcpy(tetrisY, blockPosY[tetristype][trydirect], BLOCKPIECES*sizeof(int));
		[self drawCurrentTetris];
		
		[ttscene setNeedsDisplay];
		tetrisdirect = trydirect;
		return ;
	}
}

-(BOOL)canRotate:(direction)direct{
	BOOL canRotate = YES;
	
	int tryttX[BLOCKPIECES];
	int tryttY[BLOCKPIECES];
	memcpy(tryttX, blockPosX[tetristype][direct], BLOCKPIECES*sizeof(int));
	memcpy(tryttY, blockPosY[tetristype][direct], BLOCKPIECES*sizeof(int));
	
	int placeX;
	int placeY;
	for (int i=0; i<BLOCKPIECES; i++) {
		placeX = currentX + *(tryttX+i);
		placeY = currentY + *(tryttY+i);
		
		//can not be placed out of the tetris area
		if (placeX<0 || placeX>=COLS || placeY >= ROWS) {
			return NO;
		}
		
		if ([self intersectPeviousPart:placeX withPlaceY:placeY]) {
			continue;
		}
		if ([ttscene colorAtRow:placeY andCol:placeX]!=EmptyColor) {
			return NO;
		}
	}
	
	return canRotate;
}

-(BOOL)intersectPeviousPart:(int)placeX withPlaceY:(int)placeY{
	for (int i=0; i<BLOCKPIECES; i++){
		int currentplaceX = currentX + *(tetrisX+i);
		int currentplaceY = currentY + *(tetrisY+i);
		if (currentplaceX == placeX && currentplaceY == placeY) {
			return YES;
		}
	}
	return NO;
}

-(void)eraseCurrentTetris{
	for (int i=0; i<BLOCKPIECES; i++) {
		if ((currentY+*(tetrisY+i))<0 || (currentY+*(tetrisY+i))>=ROWS) {
			continue;
		}
		if ((currentX+*(tetrisX+i))<0 || (currentX+*(tetrisX+i))>=COLS) {
			continue;
		}
		[ttscene setColorRow:(currentY+*(tetrisY+i)) withCol:(currentX+*(tetrisX+i)) withColor:EmptyColor];
	}
}

-(void)drawCurrentTetris{
	
	for (int i=0; i<BLOCKPIECES; i++) {
		if ((currentY+*(tetrisY+i))<0 || (currentY+*(tetrisY+i))>=ROWS) {
			continue;
		}
		if ((currentX+*(tetrisX+i))<0 || (currentX+*(tetrisX+i))>=COLS) {
			continue;
		}
		[ttscene setColorRow:(currentY+*(tetrisY+i)) withCol:(currentX+*(tetrisX+i)) withColor:PurpleColor];
	}
	
}

//after remove one line the score++;
-(void)removeLines{
	BOOL shouldremoveline = YES;
	ColorType (*tetrisArea)[COLS] = [ttscene colorArea];
	
	for (int i=ROWS-1; i>=0; i--) {
		shouldremoveline = YES;
		for (int j=0; j<COLS; j++) {
			if (*(*(tetrisArea+i)+j) == EmptyColor) {
				shouldremoveline = NO;
			}
		}
		
		if (shouldremoveline) {
			int currentrow = i;
			int aboverow = currentrow - 1;
			for (; aboverow >=0; currentrow--, aboverow--) {
				for (int j=0; j<COLS; j++) {
					*(*(tetrisArea+currentrow)+j) = *(*(tetrisArea+aboverow)+j);
				}
			}
			
			if (currentrow == 0) {
				for (int j=0; j<COLS; j++) {
					*(*(tetrisArea+currentrow)+j) = EmptyColor;
				}
			}
			
			[ttscene performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
			i++;
		}
	}
}

@end
