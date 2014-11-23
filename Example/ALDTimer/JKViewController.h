//
//  JKViewController.h
//  ALDTimer
//
//  Created by Jameel on 11/23/2014.
//  Copyright (c) 2014 Jameel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

- (IBAction)timerValueChanged:(id)sender;

@end
