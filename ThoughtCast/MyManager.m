//
//  MyManager.m
//  ThoughtCast
//
//  Created by David Kachlon on 12/5/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//
#import "MyManager.h"
#import "ThoughtCast-Swift.h"
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Neo.h"

extern void launchiSketchnoteController(SelectSlateTableViewController *viewController);
extern void connectToPeripheralByName(NSString* name);
extern void refresh();
extern void doRename();
extern void disconnect();

@implementation MyManager


@synthesize strSlatesList;


+ (instancetype)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    

    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    _discClicked = false;
    
    return self;
}



- (CGPoint)convertPoint:(CGPoint)point {
    
    switch (_CurrentPage)
    {
    
       
        case ZONE_SETUP:
            //NSLog(@"point: %f - %f", point.x, point.y);
            
           return CGPointMake((point.x - _activeZone.origin.x) / _activeZone.size.width * _zoneDrawView.drawViewZoneSetup.frame.size.width, (point.y - _activeZone.origin.y) / _activeZone.size.height * _zoneDrawView.drawViewZoneSetup.frame.size.height);
            break;
 
        default:
            break;
    }
    
    return CGPointMake(0.0, 0.0);
    
    
   
}


-(void) front_draw_Start: (CGPoint) point
{
    NSLog(@"*************** front_draw_Start: (CGPoint) point x-> %f   y-> %f ***********", point.x, point.y);

    [_drawView move_beganWithPoint:point];
    [_drawView move_began_backWithPoint:point];
    
    
}

-(void) front_draw_Move: (CGPoint) point
{
    NSLog(@"front_draw_Move ");
    
 
    [_drawView move_movedWithPoint:point];
    [_drawView move_moved_backWithPoint:point];
    
}

-(void) saveAndClear
{
    if(_CurrentPage == DRAWING_MODE)
    {
        [_drawView doSaveAndClear];
        
        
        
    }
    else if(_CurrentPage == ZONE_GO)
    {
        [_zoneGo doSaveAndClear];
        
    }
}

-(void) clear
{
    if(_CurrentPage == DRAWING_MODE)
    {
        [_drawView clear];
        
    }
    else if(_CurrentPage == ZONE_GO)
    {
        [_zoneGo clear];
        
    }
}

-(void) start_Touch_Go: (CGPoint) point
{
    NSLog(@"*************** start_Touch_Go: (CGPoint) point ***********");

    CGPoint first, second;
    if(!(point.x > 0 && point.y > 0)) return;
    

    [_zoneGo move_beganWithPoint:point];
    [_zoneGo move_began_backWithPoint:point];
    //Another where it should add Neo

    
}
-(void) move_Touch_Go : (CGPoint) point;
{
    NSLog(@"*************** move_Touch_Go: (CGPoint) point ***********");

    CGPoint first, second;
    if(!(point.x > 0 && point.y > 0)) return;
    

    [_zoneGo move_movedWithPoint:point];
    [_zoneGo move_moved_backWithPoint:point];
}


-(void) initx
{
    NSLog(@"*************** initx ***********");
    strSlatesList = [[NSMutableArray alloc] init];
}

-(void) drawFrontPage
{
    
    if(_CurrentPage == FRONT_PAGE)
    {

        [_mainPage drawPage];
    }

}


-(void) reconnect {
    
    launchiSketchnoteController(nil);
  
}

-(void) refresh
{
    refresh();
}


-(void)stopCheckingPeripheralConnection {
    [_disconnectingTimer invalidate];
    
}


- (void)startCheckingPeripheralConnection:(BOOL)board {
    if (_disconnectingTimer) {
        [_disconnectingTimer invalidate];
        _disconnectingTimer = nil;
    }
    NSLog(@"startCheckingPeripheralConnection *********************");
    _disconnectingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateConnection) userInfo:nil repeats:YES];

}

- (void) renameSlate: (char *) name
{
    doRename(name);
    
}


-(void) disc
{
    disconnect();
}




-(void) doWatchSave
{
    if(_CurrentPage == ZONE_GO)
    {
        [_zoneGo doSaveAndClear];
    }
    else
    {
        [_drawView doSaveAndClear];
    }
}


-(void) doWatchReset
{
    if(_CurrentPage == ZONE_GO)
    {
        [_zoneGo doReset];
    }
    else
    {
        [_drawView doReset];
    }
}



-(void) doWatchClear
{
    if(_CurrentPage == ZONE_GO)
    {
        [_zoneGo doClear];
    }
    else
    {
        [_drawView doClear];
    }
}


-(void) setNoBluetooth:(BOOL)yes //if([(AppDelegate *)[[UIApplication sharedApplication] delegate] returnBluetooth] == false)
{
    NSLog(@"********************** setNoBluetooth 1 %@", yes ? @"YES" : @"NO");
    if(yes){
        self.isBLEon = true;
        [self update_Draw_Dot];
        if(_CurrentPage == FRONT_PAGE)
        {
            [[self mainPage] drawPage];
        }
    }else{
        NSLog(@"********************** setNoBluetooth ");
        self.state = DISCONNECTED;
        self.isBLEon = false;
        self.isConnected = false;
        [self update_Draw_Dot];
        if(_CurrentPage == FRONT_PAGE)
        {
            [[self mainPage] drawPage];
        }
    }
    
}

-(bool) bluetoothAvailable
{
    return ([(AppDelegate *)[[UIApplication sharedApplication] delegate] returnBluetooth]);
}

-(void) updateConnection {
    
    NSLog(@"updateConnection Here? self.peripheral.state: %ld", (long)self.peripheral.state);
    

    if([(AppDelegate *)[[UIApplication sharedApplication] delegate] returnBluetooth] == false)
    {
        
        NSLog(@"ok returnBluetooth false");
     
        [self setNoBluetooth:NO];
        return;
        
    }else{
        NSLog(@"ok returnBluetooth true");

        self.isBLEon = true;
    }
    

    if (self.peripheral.state == CBPeripheralStateConnected) {
        self.state = CONNECTED;
        NSLog(@"LOG:  CBPeripheralStateConnected");
        self.isLooking = false;
        [self update_Draw_Dot];
                 [[MyManager sharedManager] stopCheckingPeripheralConnection];
        
        return;
    }
    self.state = LOOKING;
    
    self.isLooking = true;
    
    
  
    if (self.isConnected == true && self.state != RECONNECTED) {
        self.isConnected = false;
        self.isLooking = true;
        self.state = LOOKING;
        [self update_Draw_Dot];
        
        if(_CurrentPage == FRONT_PAGE)
            
        {
        [[self mainPage] drawPage];
        }
        [self playContiniousShortVibration];
    }
    if (!self.isReconnected) {
        self.state = RECONNECTING;
        self.isLooking = true;
        if(_CurrentPage == FRONT_PAGE)
        {
            [[self mainPage] drawPage];
        }
        
        [self reconnect];
        [self update_Draw_Dot];
        
        self.isReconnected = YES;
    } else {
        self.state = CONNECTED;
        self.isLooking = true;
        [self update_Draw_Dot];
        
        NSLog(@"ok this part::::");
        [[self mainPage] drawPage];
        
        connectToPeripheralByName(self.deviceName);
    }
    // }
    
    
   
}



-(NSString*) getString
{
    switch (_CurrentPage)
    {
        case SELECT_SLATE:
            return (@"Select Slate");
            break;
        case FRONT_PAGE:
            return (@"Front page");
            break;
        case DRAWING_MODE:
            return (@"Drawing mode");
            break;
        case ZONE_SETUP:
            return (@"Zone setup");
            
            break;
        case ZONE_GO:
            return (@"Zone go");
            break;
        default:
            return(@"something else");
            break;
    }

}

-(void) update_Draw_Dot
{
    if(_CurrentPage == DRAWING_MODE)
    {
        [_drawView updateWatch];
        
    [_drawView setDot];
    }
    else if (_CurrentPage == ZONE_GO)
    {
        [_zoneGo redrawWatch];
        [_zoneGo setDot];
    }
    else if (_CurrentPage == ZONE_SETUP)
        
    {
        [_zoneDrawView setDot];
        
    }
}


-(void) start_Touch: (CGPoint) point
{
    
    NSLog(@"start touch %@", [self getString]);
    
    if(!(point.x > 0 && point.y > 0)) return;
    
    
    switch (_CurrentPage)
    {
    case ZONE_SETUP:
         [_zoneDrawView move_beganWithPoint:point];
        break;

    default:
        break;
    }
        
 
  
    
}


-(void) start_Touch:(CGPoint)point pointTwo: (CGPoint) pointtwo
{
    NSLog(@"*************** start_Touch:(CGPoint)point pointTwo: (CGPoint) pointtwo ***********");

    if(!(point.x > 0 && point.y > 0)) return;
    [_zoneGo move_beganWithPoint:point];
    [_zoneGo move_began_backWithPoint:pointtwo];
    
    
}


-(void) move_Touch: (CGPoint) point
{
    NSLog(@"*************** move_Touch: (CGPoint) point ***********");

    if(!(point.x > 0 && point.y > 0)) return;
    
    
    switch (_CurrentPage)
    {
    case DRAWING_MODE:
            [_drawView move_movedWithPoint:point];
        break;
    case ZONE_SETUP:
            NSLog(@"should be working");
            
            [_zoneDrawView move_movedWithPoint:point];
        break;


    default:
        break;
    }
    

    
}

/*

 
 */

-(void) move_Touch:(CGPoint)point pointTwo: (CGPoint) pointtwo
{
    NSLog(@"*************** move_Touch:(CGPoint)point pointTwo: (CGPoint) pointtwo ***********");

    if(!(point.x > 0 && point.y > 0)) return;
    
    
    [_zoneGo move_movedWithPoint:point];
    [_zoneGo move_moved_backWithPoint:pointtwo];
    
    
}

-(void)rdrawWatch
{
    if(_CurrentPage == ZONE_GO)
    {
    [_zoneGo redrawWatch];
    }
    else if (_CurrentPage == DRAWING_MODE){
        [_drawView updateWatch];
    }
    }

-(void)testxx
{
    if(_CurrentPage == DRAWING_MODE)
    {
       [_drawView sAC];
    }
    
}

-(void) stop_Touch
{
   
    NSLog(@"************************* stop_touch *************");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
 //   if ([UserDefaults standard].integer()) {
    
    if([defaults boolForKey:@"AutoSave"])
    {
        double timerDelay = (double)[defaults integerForKey:@"autoSaveTimer"];
    
        
        self.timer.invalidate;
    
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timerDelay target:self selector:@selector(testxx) userInfo:nil repeats:NO];
   // }
    }
}

- (void)playContiniousShortVibration {
    if (![MyManager sharedManager].isLooking) {
        return;
    }
    
    if ( _CurrentPage == DRAWING_MODE || _CurrentPage == ZONE_GO) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        
        //  [self watchVibrate];
        [self delayCallback:^{
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
            
            //  [self watchVibrate];
            [self playContiniousShortVibration];
        } forTotalSeconds:0.1];
    }
    else{return;}
}

- (void) delayCallback: (void(^)(void))callback forTotalSeconds: (double)delayInSeconds{
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(callback){
            callback();
        }
    });
}

-(void) reloadData
{

    NSLog(@"Relaoding data");
    
    NSLog(@"testing count: %d", strSlatesList.count);
   
    [_currentTableView doReload];
    

     NSLog(@"Reloaded data");
    //[_viewControllerMain.currentTableView reloadData];
    
}

@end
