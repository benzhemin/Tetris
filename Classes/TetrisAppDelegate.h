//
//  TetrisAppDelegate.h
//  Tetris
//
//  Created by benzhemin on 11-8-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TetrisViewController;

@interface TetrisAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TetrisViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TetrisViewController *viewController;

@end

