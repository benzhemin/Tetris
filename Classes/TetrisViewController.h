//
//  TetrisViewController.h
//  Tetris
//
//  Created by benzhemin on 11-8-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameControl.h"

@interface TetrisViewController : UIViewController {
	GameControl *gamecontrol;
	TetrisScene *ttscene;
	NSThread *gamethread;
	
	UIImageView *btnleft;
	UIImageView *btnright;
	UIImageView *btnrotate;
	UIImageView *btndrop;
}

-(void)startTetris;

-(UIImage *)maskImage:(UIImage *)img withColor:(UIColor *)color;

-(IBAction) clickLeft;
-(IBAction) clickRight;
-(IBAction) clickRotate;
-(IBAction) clickDrop;

@end

