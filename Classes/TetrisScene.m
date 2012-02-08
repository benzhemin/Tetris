//
//  TetrisScene.m
//  Tetris
//
//  Created by benzhemin on 11-9-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TetrisScene.h"

@implementation TetrisScene

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		
		for (int i=0; i<ROWS; i++) {
			for (int j=0; j<COLS; j++) {
				colorarea[i][j] = EmptyColor;
			}
		}
		
	}
	return self;
}

-(void)drawInContext:(CGContextRef)context{
	CGContextSaveGState(context);
	
	//set stroke color
	CGContextSetStrokeColorWithColor(context, [self colorWithType:DaryGrayColor]);
	
	//set stroke width
	CGContextSetLineWidth(context, 2.0);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	
	
	CGFloat drawAtX = 10.0f;
	CGFloat drawAtY = 10.0f;
	
	
	for (int i=0; i<COLS; i++) {
		for (int j=0; j<ROWS; j++) {
			//set fill color
			CGContextSetFillColorWithColor(context, [self colorWithType:colorarea[j][i]]);
			
			CGContextAddRect(context, CGRectMake(drawAtX+i*SIZE, drawAtY+j*SIZE, SIZE, SIZE));
			CGContextStrokePath(context);
			CGContextFillRect(context, CGRectMake(drawAtX+i*SIZE, drawAtY+j*SIZE, SIZE, SIZE));
			
		}
	}
	
	//draw outside frame
	CGContextRestoreGState(context);
	CGContextSetStrokeColorWithColor(context, [self colorWithType:WhiteColor]);
	CGContextSetLineWidth(context, 3.0);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextAddRect(context, CGRectMake(drawAtX-2, drawAtY-2, SIZE*COLS+4, SIZE*ROWS+4));
	CGContextStrokePath(context);
}

-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

-(ColorType)colorAtRow:(int)row andCol:(int)col{
	if (row<0 || row>=ROWS) {
		return EmptyColor;
	}
	if (col<0 || col>=COLS) {
		return EmptyColor;
	}
	return colorarea[row][col];
}

//to invoke this method, make sure row between 0~ROWS col between 0~COLS
-(void)setColorRow:(int)row withCol:(int)col withColor:(ColorType) colortype{	
	colorarea[row][col] = colortype;
}

-(ColorType (*)[COLS]) colorArea{
	return colorarea;
}

-(void)clearAllTetris{
	for (int i=0; i<ROWS; i++) {
		for (int j=0; j<COLS; j++) {
			colorarea[i][j] = EmptyColor;
		}
	}
}

-(CGColorRef) colorWithType:(ColorType) colortype{
	CGColorRef color;
	switch (colortype) {
		case LightGrayColor:
			color =  [UIColor lightGrayColor].CGColor;
			break;
		case DaryGrayColor:
			color = [UIColor darkGrayColor].CGColor;
			break;
		case PurpleColor:
			color = [UIColor purpleColor].CGColor;
			break;
		case EmptyColor:
			//color = [UIColor lightGrayColor].CGColor;
			color = [UIColor groupTableViewBackgroundColor].CGColor;
			break;
		case WhiteColor:
			color = [UIColor whiteColor].CGColor;
			break;
	}
	
	return color;
}

@end
