//
//  JKViewController.m
//  ALDTimer
//
//  Created by Jameel on 11/23/2014.
//  Copyright (c) 2014 Jameel. All rights reserved.
//

#import "JKViewController.h"
#import "ALDTimer.h"

@interface JKViewController ()


- (NSString *)hourAndMinutesStringFromInterval:(NSTimeInterval )interval;
@end

@implementation JKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)timerValueChanged:(id)sender {
    
    double interval = [(ALDTimer *)sender interval];
    self.timeLbl.text= [self hourAndMinutesStringFromInterval:interval];
    
    
}


- (NSString *)hourAndMinutesStringFromInterval:(NSTimeInterval )interval{
    
    int days = interval / (60 * 60 * 24);
    interval -= days * (60 * 60 * 24);
    int hours = interval / (60 * 60);
    interval -= hours * (60 * 60);
    int minutes = interval / 60;
    interval-=minutes*60;
    
    if(days>0)
        return [NSString stringWithFormat:@"%.2d:%.2d:%.2d",days,hours,minutes];
    if(hours>0)
        return [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hours,minutes,(int)interval];
    if(interval<0)
        return [NSString stringWithFormat:@"%.2d:%.2d",0,0];
    
    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hours,minutes,(int)interval];
    
    
}


@end
