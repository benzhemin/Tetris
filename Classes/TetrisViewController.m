//
//  TetrisViewController.m
//  Tetris
//
//  Created by benzhemin on 11-8-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TetrisViewController.h"
#import "TetrisScene.h"

@implementation TetrisViewController

- (void)dealloc {
	NSLog(@"TetrisViewController dealloc");
	[gamecontrol release];
	[gamethread release];
    [ttscene release];
	
	[btnleft release];
	[btnright release];
	[btnrotate release];
	[btndrop release];
	[super dealloc];
}

-(void)viewDidLoad{
	gamecontrol = [[GameControl alloc] init];
	gamethread = [[NSThread alloc] initWithTarget:gamecontrol 
										 selector:@selector(startGame)
										   object:nil];
	
	/*
	CGFloat entireWidth = [[UIScreen mainScreen] applicationFrame].size.width;
	CGFloat entireHeight = [[UIScreen mainScreen] applicationFrame].size.height;
	CGRect entireApplication = CGRectMake(0, 0, entireWidth, entireHeight);
	*/
	
	ttscene = [[TetrisScene alloc] initWithFrame:CGRectMake(0, 0, SIZE*(COLS+1), SIZE*(ROWS+1))];
	[self.view setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	[ttscene setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];

	//[ttscene setUserInteractionEnabled:NO];
	
	gamecontrol.ttscene = ttscene;
	[self.view addSubview:ttscene];
	
	
	btnleft = [[UIImageView alloc] initWithFrame:CGRectMake(18, 384, 60, 60)];
	[btnleft setUserInteractionEnabled:YES];
	[btnleft setImage:[self maskImage:[UIImage imageNamed:@"control_left_a.jpg"] withColor:[UIColor blackColor]]];	
	[self.view addSubview:btnleft];
	
	btnright = [[UIImageView alloc] initWithFrame:CGRectMake(93, 384, 60, 60)];
	[btnright setUserInteractionEnabled:YES];
	[btnright setImage:[self maskImage:[UIImage imageNamed:@"control_right_a.jpg"] withColor:[UIColor blackColor]]];
	[self.view addSubview:btnright];
	
	
	btnrotate = [[UIImageView alloc] initWithFrame:CGRectMake(168, 384, 60, 60)];
	[btnrotate setImage:[self maskImage:[UIImage imageNamed:@"control_rotate_a.jpg"] withColor:[UIColor blackColor]]];
	[btnrotate setUserInteractionEnabled:YES];
	[self.view addSubview:btnrotate];
	
	
	btndrop = [[UIImageView alloc] initWithFrame:CGRectMake(243, 384, 60, 60)];
	[btndrop setImage:[self maskImage:[UIImage imageNamed:@"control_down_a.jpg"] withColor:[UIColor blackColor]]];
	[btndrop setUserInteractionEnabled:YES];
	[self.view addSubview:btndrop];
	
	[super viewDidLoad];
}


-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	[self performSelector:@selector(startTetris) withObject:nil afterDelay:0.5];
}

-(void)startTetris{
	[gamethread start];
}

-(UIImage *)maskImage:(UIImage *)img withColor:(UIColor *)color{
	CGImageRef maskedImageRef;
	//const CGFloat *makskingColors = CGColorGetComponents(color.CGColor);
	
	CGFloat newComponents[4] = {};
	memcpy(newComponents, CGColorGetComponents(color.CGColor), sizeof(newComponents));
	
	maskedImageRef = CGImageCreateWithMaskingColors(img.CGImage, newComponents);
	UIImage * maskedImage = [UIImage imageWithCGImage:maskedImageRef];
	CGImageRelease(maskedImageRef);
	return maskedImage;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
		
	UITouch *touch = [touches anyObject];
	UIView *touchview = [touch view];
	
	if (touchview == ttscene) {
		NSLog(@"touch began ttscene");
	}else if (touchview == btnleft) {
		NSLog(@"touch left");
		
		[self clickLeft];
		
	}else if (touchview == btnright) {
		NSLog(@"touch right");
		[self clickRight];
	}else if (touchview == btnrotate){
		NSLog(@"touch rotate");
		[self clickRotate];
	}else if (touchview == btndrop) {
		NSLog(@"touch drop");
		[self clickDrop];
	}

	else {
		NSLog(@"touch default view");
	}
	
}

-(IBAction) clickLeft{
	[gamecontrol moveTetrisLeft];
}
-(IBAction) clickRight{
	[gamecontrol moveTetrisRight];
}
-(IBAction) clickRotate{
	[gamecontrol rotateTetris];
}
-(IBAction) clickDrop{
	[gamecontrol moveTetrisDown];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end
