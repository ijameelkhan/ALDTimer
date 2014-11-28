//
//  ALDTimer.m
//  ALDTimer
//
//  Created by Jameel Khan on 23/11/2014.
//  Copyright (c) 2014 Jameel. All rights reserved.
//

#import "ALDTimer.h"

typedef struct{
    double x;
    double y;
    double z;
} ALDVector3D;


@interface ALDTimer ()

@property (nonatomic, assign) CGFloat totalRotation;
@property (nonatomic, assign) CGFloat radius;

- (void)moveHandFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
- (void)updateDisplayAndListeners;

/*this limits angle and interval in interval limits set by user*/
- (void)updateIntervalInBoundsWithAngleDelta:(float)angleDelta;


/*returns the inclosing rect for clock*/
- (CGRect)clockRect;

/*draws the dots in circles*/
- (void)drawCirclesWithNumber:(int)cirlce context:(CGContextRef)context;

@end


@implementation ALDTimer

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib{
    [self commonInit];
}

- (void)commonInit {
    [super setBackgroundColor:[UIColor clearColor]];

    //zero interval
    _totalRotation = 0;
    
    // How wide should the clock be?
    [self updateRadius];
}

- (void)updateRadius {
    
    _radius = MIN(CGRectGetWidth(self.frame)/2.0f, CGRectGetHeight(self.frame)/2.0f) - 20;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    [self updateRadius];
}

#pragma mark - Tracking Methods

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [super beginTrackingWithTouch:touch withEvent:event];
    [self sendActionsForControlEvents:UIControlEventTouchDragEnter];
    
    //We need to track continuously
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    //Get touch location
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    
    //Use the location to design the Handle
    [self moveHandFromPoint:previousPoint toPoint:currentPoint];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [self sendActionsForControlEvents:UIControlEventTouchDragExit];
}

#pragma mark -
#pragma mark - Handle Tracking

-(void)moveHandFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    
    ALDVector3D u1 = [self vectorFromPoint:center toPoint:fromPoint];
    ALDVector3D u2 = [self vectorFromPoint:center toPoint:toPoint];
    
    // We find the smallest angle between these two vectors
    double deltaAngle = [self angleBetweenVector:u1 andVector:u2];
    
    // Calculate if we are moving clockwise or anti-clockwise
    double directedDeltaAngle = ([self isMovingCounterClockwise:u1 vector:u2]) ? deltaAngle : -1 * deltaAngle;
    
    //here we do calculation for angle and interval 
    [self updateIntervalInBoundsWithAngleDelta:directedDeltaAngle];
}

/*this limits angle and interval in interval limits set by user*/
- (void)updateIntervalInBoundsWithAngleDelta:(float)angleDelta{
    
    //flip the angle , because we increase timer based on right rotation
    angleDelta= -1*angleDelta;
    
    
    // Update the total rotation
    self.totalRotation = fmod(self.totalRotation + angleDelta, 24 * 360);
    
    //maximum allowed rotation
    float maxRotation = _maximumInterval/10;
    if(self.totalRotation>maxRotation)
        self.totalRotation= maxRotation;

    
    //min allow rotation
    float minRotation = _minimumInterval/10;
    if(self.totalRotation<minRotation)
        self.totalRotation= minRotation;
    
    
    // Update the hour and minute properties
    _interval= self.totalRotation*10;
    
    
    NSLog(@"Time Interval: %f angle: %f", _interval,self.totalRotation);
    
    //Redraw
    [self updateDisplayAndListeners];
}

- (void)updateDisplayAndListeners {
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

#pragma mark -


#pragma mark - Vector Math

- (ALDVector3D)vectorFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    
    ALDVector3D v = {toPoint.x - fromPoint.x, toPoint.y - fromPoint.y, 0};
    return v;
}

- (CGFloat)dotProductOfVector:(ALDVector3D)v1 andVector:(ALDVector3D)v2 {
    
    CGFloat value = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
    return value;
}

- (CGFloat)angleBetweenVector:(ALDVector3D)v1 andVector:(ALDVector3D)v2 {
    
    CGFloat normOfv1 = sqrt([self dotProductOfVector:v1 andVector:v1]);
    CGFloat normOfv2 = sqrt([self dotProductOfVector:v2 andVector:v2]);
    
    CGFloat angle = (180/M_PI) * acos( fmin([self dotProductOfVector:v1 andVector:v2] / (normOfv1 * normOfv2), 1) );
    return angle;
}

- (ALDVector3D)crossProductOfVector:(ALDVector3D)v1 andVector:(ALDVector3D)v2 {
    
    ALDVector3D v;
    v.x = v1.y*v2.z - v1.z*v2.y;
    v.y = -1 * (v1.x*v2.z - v1.z*v2.x);
    v.z = v1.x*v2.y - v1.y*v2.x;
    
    return v;
}

- (BOOL)isMovingCounterClockwise:(ALDVector3D)v1 vector:(ALDVector3D)v2 {
    
    ALDVector3D normal = {0,0,1};
    ALDVector3D crossProduct = [self crossProductOfVector:v1 andVector:v2];
    BOOL isCounterClockwise = ([self dotProductOfVector:crossProduct andVector:normal] < 0)? YES : NO;
    return isCounterClockwise;
}

#pragma mark -

/*returns the inclosing rect for clock*/
- (CGRect)clockRect{
    
    // We find a max width to ensure that the clock is always
    // bounded by a square box
    
    CGFloat maxWidth = MIN(self.frame.size.width, self.frame.size.height);
    
    // Create a rect that maximises the area of the clock in the
    // square box
    
    CGRect rectForClockFace = CGRectInset(CGRectMake((self.frame.size.width - maxWidth)/2.0f,
                                                     (self.frame.size.height - maxWidth)/2.0f,
                                                     maxWidth,
                                                     maxWidth), 2, 2);
    
    return rectForClockFace;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw the clock background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillEllipseInRect(context, [self clockRect]);
    
    //draw the cicles depends on how much cirlces we need
    int numberOfCircles = 0;
    
    double tempInterval = _interval;
    
    while (tempInterval >= 0) {
        numberOfCircles = numberOfCircles + 1;
        tempInterval = tempInterval - 3600;
    }
    
    if (_interval == self.maximumInterval) {
        numberOfCircles = numberOfCircles - 1;
    }
    
    for(int circle = 1 ; circle<=numberOfCircles; circle++){
        [self drawCirclesWithNumber:circle context:context];
    }
}

/*draws the dots in circles*/
- (void)drawCirclesWithNumber:(int)cirlce context:(CGContextRef)context{
    
    CGPoint center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
    float dotradius = self.dotRadius - (self.dotRadius*self.decreaseSizeBy/100)*cirlce;
    float offset = self.circleDistance*cirlce;

    for(NSInteger i = 0; i < 60; i ++) {
        
        //if we dont do it , it starts at x= 0 ;
        NSInteger angleOffset = 15;
        
        // Get the location of the end of the hand
        CGFloat markingDistanceFromCenter = [self clockRect].size.width/2.0f -  offset;
        
        CGFloat markingX1 = center.x + markingDistanceFromCenter * cos((M_PI/180)* (i+ angleOffset) * 6 + M_PI);
        CGFloat markingY1 = center.y + - 1 * markingDistanceFromCenter * sin((M_PI/180)* (i+ angleOffset) * 6);
        
        if(self.interval>(i*60+ ((cirlce-1) * 3600)))
            CGContextSetFillColorWithColor(context, self.selectedDotColor.CGColor);
        else
            CGContextSetFillColorWithColor(context, self.unSelectedDotColor.CGColor);
        
        CGContextFillEllipseInRect(context, CGRectMake(markingX1-3,
                                                       markingY1-3,dotradius*2,dotradius*2));
    }
    
    // Draw minor markings.
    CGContextDrawPath(context, kCGPathStroke);
}


@end
