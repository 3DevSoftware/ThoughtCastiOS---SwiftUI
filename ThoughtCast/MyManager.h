//
//  MyManager.h
//  ThoughtCast
//
//  Created by David Kachlon on 12/5/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//



#import <FLAnimatedImage/FLAnimatedImage.h>

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <DKPhotoGallery/DKPhotoGallery-Swift.h>

#import "WatchConnectivity/WatchConnectivity.h"

typedef enum  {
    SELECT_SLATE,
    FRONT_PAGE,
    DRAWING_MODE,
    ZONE_SETUP,
    ZONE_GO,
    WALKTHROUGH
} pages;


typedef enum SlateState {
    CONNECTED_FROM_LIST,
    CONNECTED,
    RECONNECTED,
    DISCONNECTED_INITIALLY,
    DISCONNECTED,
    RECONNECTING,
    LOOKING
    
} SlateState;


@class ViewController;
@class DrawingModeViewController;
@class SelectSlateTableViewController;
@class ZoneModeViewController;
@class ZoneGoViewController;




@interface MyManager : NSObject
+ (instancetype)sharedManager;

-(void) updateConnection ;

- (void) initx;

@property (nonatomic, assign) BOOL isReconnected;
- (void) reloadData;
- (void) drawFrontPage;

- (void)playContiniousShortVibration;

@property (strong, nonatomic) NSTimer * timer;





-(NSString*) getString;

-(void) start_Touch: (CGPoint) point;
-(void) move_Touch: (CGPoint) point;
-(void) stop_Touch;
-(void) refresh;


-(void) disc;


-(void) doWatchSave;
-(void) doWatchReset;
-(void) doWatchClear;
-(void) rdrawWatch;


-(void) front_draw_Start: (CGPoint) point;

-(void) front_draw_Move: (CGPoint) point;

-(void) start_Touch_Go: (CGPoint) point;
-(void) move_Touch_Go : (CGPoint) point;


@property (nonatomic, assign) ViewController* mainPage;
@property (nonatomic, assign) ZoneGoViewController* zoneGo;

@property pages CurrentPage;
@property (nonatomic, assign) ZoneModeViewController* zoneDrawView;
@property SlateState state;
@property Boolean renamingSlate;
@property NSString* renameTo;

@property Boolean alreadyConnected;
@property Boolean  discClicked;
@property int  batteryCharge;

@property (nonatomic, assign) DrawingModeViewController* drawView;


- (CGPoint)convertPoint:(CGPoint)point ;

@property (strong, nonatomic) NSTimer * disconnectingTimer;
-(void) update_Draw_Dot;

@property NSMutableArray * strSlatesList;
@property (nonatomic, assign) bool watchChanged;

@property (nonatomic, assign) SelectSlateTableViewController* currentTableView;

- (void)startCheckingPeripheralConnection:(BOOL)board;
- (void)stopCheckingPeripheralConnection;
- (void) renameSlate: (NSString*) name;
-(void) saveAndClear;
-(void) clear;
-(void) setNoBluetooth:(BOOL)yes;
-(bool) bluetoothAvailable;
@property (nonatomic, assign) CBCentralManager *cbCentralManager;

@property (nonatomic, assign) NSString *deviceName;
@property (nonatomic, assign) bool isConnected;
@property (nonatomic, assign) bool isLooking;
@property (nonatomic, assign) bool isBLEon;
@property (nonatomic, assign) bool isCharging;
@property (nonatomic, strong)  CBPeripheral *peripheral;
@property (nonatomic, assign) CGRect activeZone;

@end

