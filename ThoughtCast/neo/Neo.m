//
//  Neo.m
//  ThoughtCast
//
//  Created by Rafik Boghouzian on 6/24/19.
//  Copyright © 2019 ThoughtCast. All rights reserved.
//

#import "Neo.h"
#import "MyManager.h"
#define THOUGHTCAST_OWNER_ID 28


@implementation Neo
@synthesize pencommManager = pencommManager, discoveredPeripherals, scribeRealName, didDisconnectClick, OWNER_ID;

+(instancetype _Nonnull)shared
{
    static Neo *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        NSLog(@"************************ NEO dispatched *******************");
    });
    return shared;
}

- (void) getReady
{
    [[MyManager sharedManager].strSlatesList addObject:SCRIBE_NAME];
    [[MyManager sharedManager] reloadData];
}

- (void) startNeoPen
{
    didDisconnectClick = NO;
    [MyManager sharedManager].deviceName = SCRIBE_NAME;
    pencommManager = [NJPenCommManager sharedInstance];
    [pencommManager setPenCommParserStartDelegate:self];
    [pencommManager setPenCommParserCommandHandler:self];
    [pencommManager setPenStatusDelegate:self];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(writingOnCanvasStart:) name:NJPenCommParserPageChangedNotification object:nil];
    
    [nc addObserver:self selector:@selector(btStatusChanged:) name:NJPenCommManagerPenConnectionStatusChangeNotification object:nil];
    
    [nc addObserver:self selector:@selector(penPasswordCompareSuccess:) name:NJPenCommParserPenPasswordSutupSuccess object:nil];
    [nc addObserver:self selector:@selector(penDisconnected:) name:NJBTDisconnectedNotification object:nil];

    
    if([pencommManager hasPenRegistered])
        NSLog(@"******************  Neo Pen is not connected. ********");
    else
        NSLog(@"****************** Neo Pen is not registered. ********");

    
    [pencommManager setHandleNewPeripheral:nil];
    [pencommManager btStart];
    self.btStatus = BT_CONNECTING;
    
//    [pencommManager btStart];
//    [pencommManager setHandleNewPeripheral:nil];
//
//    [pencommManager btStartForPeripheralsList];
//
//    [self startScanTimer:3.0f];
    
    
    [pencommManager setPenCommParserStrokeHandler:self];
    
    [self isLookingNow];
}

- (void)disconnectPen
{
    didDisconnectClick = YES;
    [pencommManager btStop];
    [pencommManager disConnect];
}

#pragma mark- Actions
#define ON 1
#define OFF 2

- (void)setPenSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL penSound = false;
    
    BOOL penConnected = [NJPenCommManager sharedInstance].isPenConnected;
    BOOL penRegister = [NJPenCommManager sharedInstance].hasPenRegistered;
    
    if (!penConnected || !penRegister) {
        return;
    }
    
//    if([sender isOn]){
//        penSound = YES;
//        [defaults setBool:penSound forKey:@"penSound"];
//        [defaults synchronize];
//        [_dSwitchCtl setOn:YES];
//    } else {
//        penSound = NO;
//        [defaults setBool:penSound forKey:@"penSound"];
//        [defaults synchronize];
//        [_dSwitchCtl setOn:NO];
//    }
//
    
    
    
    unsigned char pSound = [defaults boolForKey:@"penSound"]? ON : OFF ;
    unsigned char pAutoPwer;
    
    if (![NJPenCommManager sharedInstance].isPenSDK2) {
        BOOL penAutoPower = [defaults boolForKey:@"penAutoPower"];
        pAutoPwer = penAutoPower? ON : OFF ;
    } else {
        pAutoPwer = 0xFF;
        pSound = penSound;
    }
    
    [[NJPenCommManager sharedInstance] setPenStateAutoPower:pAutoPwer Sound:pSound];
    
    return;
}




bool startedAlready;

#pragma mark- strokeHandler delegate
- (void) processStroke:(NSDictionary *)stroke
{
    NSLog(@"*********** NEo OWNER_ID %d", self.OWNER_ID);
    if(self.OWNER_ID != 0 && self.OWNER_ID != THOUGHTCAST_OWNER_ID){
        return;
    }
    @try {
        NSLog(@"************ stroke %@", stroke.description);
        if([[stroke objectForKey:@"type"]  isEqual: @"stroke"]){
            NJNode *node = (NJNode *)[stroke objectForKey:@"node"];
            NSNumber *xpoint = [[NSNumber alloc] initWithFloat:node.x];
            NSNumber *ypoint = [[NSNumber alloc] initWithFloat:node.y];
            CGPoint point = CGPointMake([xpoint doubleValue], [ypoint doubleValue]);
            NSLog(@"************** NEO stroke coordinates: x-> %f  y-> %f pressure %f  timeDiff %c", point.x, point.y, node.pressure, node.timeDiff);
            if(startedAlready){
                [[MyManager sharedManager] front_draw_Move:point];
                
            }else{
                [[MyManager sharedManager] front_draw_Start:point];
                startedAlready = true;
            }
            
            /*
            if([MyManager sharedManager].CurrentPage == FRONT_PAGE)
            {
                if(startedAlready){
                    [[MyManager sharedManager] front_draw_Move:point];
                    
                }else{
                    [[MyManager sharedManager] front_draw_Start:point];
                    startedAlready = true;
                }
            }else if([MyManager sharedManager].CurrentPage == ZONE_GO){
                if(startedAlready){
                    [[MyManager sharedManager] move_Touch_Go:point];
                    
                }else{
                    [[MyManager sharedManager] start_Touch_Go:point];
                    startedAlready = true;
                }
            }
            */
            
            
        }else{
            if([[stroke objectForKey:@"status"] isEqualToString:@"up"]){
                [[MyManager sharedManager]stop_Touch];
                startedAlready = false;
            }else{
                [MyManager sharedManager].activeZone = CGRectMake(0, 0, 408, 600);
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"************ ERROR processStroke %@", exception.description);

    }
   
   
}

- (void) activeNoteId:(int)noteId pageNum:(int)pageNumber sectionId:(int)section ownderId:(int)owner
{
    NSLog(@"************ activeNoteId:(int)noteId %d pageNumber %d section %d owner %d", noteId, pageNumber, section, owner);

}
- (void) notifyPageChanging
{
    NSLog(@"**************** notifyPageChanging ********");
//    NSDictionary * userInfo = @{@"newpage": @(YES)};
//    [[NSNotificationCenter defaultCenter] postNotificationName:keyNeoNOtificationNewPage object:self userInfo:userInfo];
}
- (UInt32)setPenColor
{
    UInt32 colorRed = 0.2f;
    UInt32 colorGreen = 0.2f;
    UInt32 colorBlue = 0.2f;
    UInt32 colorAlpah = 1.0f;
    UInt32 alpah = (UInt32)(colorAlpah * 255) & 0x000000FF;
    UInt32 red = (UInt32)(colorRed * 255) & 0x000000FF;
    UInt32 green = (UInt32)(colorGreen * 255) & 0x000000FF;
    UInt32 blue = (UInt32)(colorBlue * 255) & 0x000000FF;
    UInt32 color = (alpah << 24) | (red << 16) | (green << 8) | blue;
    
    return [self convertUIColorToAlpahRGB:[UIColor whiteColor]];
    
//    if (self.penColor) {
//        color = self.penColor;
//    }
//    return color;
}

- (void)postConnectionNotification:(BOOL)connected
{
    NSDictionary * userInfo = @{@"connected": @(connected)};
    [[NSNotificationCenter defaultCenter] postNotificationName:keyNeoNOtification object:self userInfo:userInfo];
}

- (void)setBtStatus:(NSUInteger)btStatus
{
    if (btStatus == BT_DISCONNECTED) {
        
        NSLog(@"*********** neo pen is Disconnected [MyManager sharedManager].discClicked is: %@  and didDisconnectClick %@ ********", [MyManager sharedManager].discClicked ? @"YES" : @"NO", didDisconnectClick ? @"YES" : @"NO");
        [self updateBatteryNname:NO];
        [self postConnectionNotification:NO];
        if(!didDisconnectClick){
            [pencommManager setHandleNewPeripheral:nil];
            [pencommManager btStart];
//            [pencommManager setHandleNewPeripheral:nil];
//            [pencommManager btStartForPeripheralsList];
//            [self startScanTimer:3.0f];
        }else{
            [self stopScanTimer];
        }

        
    }
    else if (btStatus == BT_CONNECTING) {
        [self stopScanTimer];
        NSLog(@"*********** neo pen is Scanning [MyManager sharedManager].discClicked is: %@  and didDisconnectClick %@ ********", [MyManager sharedManager].discClicked ? @"YES" : @"NO", didDisconnectClick ? @"YES" : @"NO");
        if(!didDisconnectClick){
            [self isLookingNow];
        }else{
            [self stopScanTimer];
            [pencommManager btStop];
        }
//        [self setPenSettings];
//        [_connectButton setTitle:@"Connecting" forState:UIControlStateNormal];
//        _statusMessage.text = @"Scanning Neo Pen.";
    }
    else if (btStatus == BT_CONNECTED) {
        @try {
           
            
            [self postConnectionNotification:YES];

            [self updateBatteryNname:YES];
           
            
        } @catch (NSException *exception) {
            NSLog(@"*********** ERROR neo pen is connected %@ ********", exception.description);
        }


    } else if (btStatus == BT_UNREGISTERED) {
        NSLog(@"*********** neo pen is not registered ********");

//        [_connectButton setTitle:@"Register" forState:UIControlStateNormal];
//        _statusMessage.text = @"Neo Pen is not registered.";
        
    }
    _btStatus = btStatus;
}


- (void)isLookingNow
{
    [MyManager sharedManager].isLooking = true;
    
    
    if([MyManager sharedManager].CurrentPage == FRONT_PAGE)
    {
        [[MyManager sharedManager] drawFrontPage];
    }
    
    
    if([MyManager sharedManager].CurrentPage == DRAWING_MODE)
    {        
        [[MyManager sharedManager] playContiniousShortVibration];
        
        [[MyManager sharedManager] update_Draw_Dot];
    }
}

- (void)updateBatteryNname:(BOOL)connected
{
    @try {
        [MyManager sharedManager].isConnected = connected;
        [MyManager sharedManager].discClicked = false;
        [MyManager sharedManager].alreadyConnected = connected;
        
        if(connected){
            self.discoveredPeripherals = [pencommManager discoveredPeripherals];
            
            //getname
            CBPeripheral *ff = self.discoveredPeripherals[0];
            [MyManager sharedManager].deviceName = SCRIBE_NAME; //ff.name
            scribeRealName = ff.name;
            //get battery
            [pencommManager getPenBattLevelAndMemoryUsedSize:^(unsigned char remainedBattery, unsigned char usedMemory){
                unsigned char battery = remainedBattery;
                unsigned char  memory = 100 - usedMemory;
                [MyManager sharedManager].isCharging = battery > 100;
                
                [MyManager sharedManager].batteryCharge = battery;
                
                
                if([MyManager sharedManager].CurrentPage == DRAWING_MODE || [MyManager sharedManager].CurrentPage == ZONE_SETUP)
                {
                    [[MyManager sharedManager] update_Draw_Dot];
                }
                if([MyManager sharedManager].CurrentPage == FRONT_PAGE)
                {
                    [[MyManager sharedManager] drawFrontPage];
                }
                
                NSLog(@"Name: %@ Battery Remainder: %d, Unused Memory Space: %d",  ff.name, battery, memory);
            }];
        
        }else{
            if([MyManager sharedManager].CurrentPage == DRAWING_MODE || [MyManager sharedManager].CurrentPage == ZONE_SETUP)
            {
                [[MyManager sharedManager] update_Draw_Dot];
            }
            if([MyManager sharedManager].CurrentPage == FRONT_PAGE)
            {
                [[MyManager sharedManager] drawFrontPage];
            }
        }
        
       
    } @catch (NSException *exception) {
        NSLog(@"*********** neo updateBatteryNname ********");

    }
}

- (void)penDisconnected:(NSNotification *)notification
{
    NSLog(@"*********** neo penDisconnected ********");

}

- (void)writingOnCanvasStart:(NSNotification *)notification
{
    NSLog(@"*********** neo writingOnCanvasStart ********");

//    if (self.canvasCloseBtnPressed) {
//        self.pageCanvasController= nil;
//        self.canvasCloseBtnPressed = NO;
//    }
//
//    if (!self.pageCanvasController) {
//        self.pageCanvasController = [[NJPageCanvasController alloc] initWithNibName:nil bundle:nil];
//        self.pageCanvasController.parentController = self;
//        self.pageCanvasController.activeNotebookId = self.activeNotebookId;
//        self.pageCanvasController.activePageNumber = self.activePageNumber;
//        self.pageCanvasController.canvasPage = self.cPage;
//
//        if (_color) {
//            self.pageCanvasController.penColor = [self convertUIColorToAlpahRGB:_color];
//        }
//        [self presentViewController:self.pageCanvasController animated:YES completion:^{
//        }];
//    }
}

- (void)btStatusChanged:(NSNotification *)notification
{
    NSLog(@"********************* NEO - (void)btStatusChanged:(NSNotification *)notification: %@", notification.description);
    NSInteger penConnctionStatus = [[[notification userInfo] valueForKey:@"info"] integerValue];
    [self checkBtStatus:penConnctionStatus];
}
- (void) checkBtStatus:(NSInteger)penConnectionStatus
{
    if(penConnectionStatus == NJPenCommManPenConnectionStatusConnected){
        self.btStatus = BT_CONNECTED;
    } else if(penConnectionStatus == NJPenCommManPenConnectionStatusScanStarted){
        self.btStatus = BT_CONNECTING;
    }
    else {
        if([pencommManager hasPenRegistered])
            self.btStatus = BT_DISCONNECTED;
        else
            self.btStatus = BT_UNREGISTERED;
    }
}

- (void)menuBtnPressed:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet;
    
    if ([pencommManager hasPenRegistered]) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"Menu"
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Connect",@"Disconnect",@"Pen Unregistration",@"Setting",@"OfflineData list",@"Show OfflineData", @"Pen Firmware Update", @"Pen Status", @"Transferable Note ID",@"Change canvas Color",@"Pen Tip Color",@"BT List", @"Battery Level and Memory Space", @"BT ID", nil];
    }else{
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"Menu"
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Register",@"Disconnect",@"Pen Unregistration",@"Setting",@"OfflineData list",@"Show OfflineData", @"Pen Firmware Update", @"Pen Status", @"Transferable Note ID",@"Change canvas Color",@"Pen Tip Color",@"BT List",@"Battery Level and Memory Space", @"BT ID", nil];
    }
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
//    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        
    } else if ([choice isEqualToString:@"Connect"]||[choice isEqualToString:@"Register"]){
        [pencommManager setHandleNewPeripheral:nil];
        [pencommManager setPenPasswordDelegate:self];
        [pencommManager setPenStatusDelegate:self];
        [pencommManager btStart];
        self.btStatus = BT_CONNECTING;
    } else if ([choice isEqualToString:@"Disconnect"]){
        [pencommManager disConnect];
        [pencommManager setPenPasswordDelegate:nil];
        self.btStatus = BT_DISCONNECTED;
    } else if ([choice isEqualToString:@"Pen Unregistration"]){
        
        [pencommManager resetPenRegistration];
        self.btStatus = BT_UNREGISTERED;
    } else if ([choice isEqualToString:@"Setting"]){
        if (_btStatus == BT_CONNECTED) {
            [pencommManager setPenStatusDelegate:self];
            NSLog(@"**************** neo else if ([choice isEqualToString:Setting *********" );
//            NJPenInfoViewController *penInfoViewController = [[NJPenInfoViewController alloc] initWithNibName:nil bundle:nil];
//            [self.navigationController pushViewController:penInfoViewController animated:NO];
        }
        
    } else if ([choice isEqualToString:@"OfflineData list"]){
        if (_btStatus == BT_CONNECTED) {
            
            NSLog(@"**************** neo [choice isEqualToString:OfflineData list *********" );

//            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            NJOfflineSyncViewController *offlineSyncViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OffSyncVC"];
//            offlineSyncViewController.showOfflineFileList = YES;
//
//            [self.navigationController pushViewController:offlineSyncViewController animated:NO];
        }
        
    } else if ([choice isEqualToString:@"Show OfflineData"]){
        if (_btStatus == BT_CONNECTED) {
            NSLog(@"**************** neo [choice isEqualToString:OfflineData  *********" );

//            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            NJOfflineSyncViewController *offlineSyncViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OffSyncVC"];
//            offlineSyncViewController.showOfflineFileList = NO;
//            offlineSyncViewController.parentController = self;
//            [self.navigationController pushViewController:offlineSyncViewController animated:NO];
        }
        
    } else if ([choice isEqualToString:@"Pen Firmware Update"]){
        if (_btStatus == BT_CONNECTED) {
            NSLog(@"**************** neo [choice isEqualToString:Pen Firmware Update  *********" );

//            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            NJFWUpdateViewController *fwUpdateViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"FWUpdateVC"];
//            [self.navigationController pushViewController:fwUpdateViewController animated:NO];
        }
    } else if ([choice isEqualToString:@"Pen Status"]){
        if (_btStatus == BT_CONNECTED) {
            [pencommManager setPenStatusDelegate:self];
            [pencommManager setPenState];
        }
    } else if ([choice isEqualToString:@"Transferable Note ID"]){
        if (_btStatus == BT_CONNECTED) {
            NSUInteger notebookId = 610; NSUInteger sectionId = 3; NSUInteger ownerId = THOUGHTCAST_OWNER_ID;
            [[NPPaperManager sharedInstance] reqAddUsingNote:notebookId section:sectionId owner:ownerId];
            
            [pencommManager setNoteIdListFromPList];
        }
    } else if ([choice isEqualToString:@"Change canvas Color"]){
        if (_btStatus == BT_CONNECTED) {
            _color = [UIColor redColor];
        }
    } else if ([choice isEqualToString:@"Pen Tip Color"]){
        if (_btStatus == BT_CONNECTED) {
            UInt32 penColor = [self convertUIColorToAlpahRGB:[UIColor blueColor]];
            [pencommManager setPenStateWithRGB:penColor];
        }
    } else if ([choice isEqualToString:@"BT List"]){
        [pencommManager setHandleNewPeripheral:self];
        [pencommManager setPenPasswordDelegate:self];
        
        [pencommManager btStartForPeripheralsList];
        
        [self startScanTimer:3.0f];
        
    } else if ([choice isEqualToString:@"BT ID"]){
        NSArray *btIDList = [NSArray arrayWithObjects:@"NWP-F110", @"NWP-F120", nil];
        [pencommManager setBTIDForPenConnection:btIDList];
    }
}

- (void)startScanTimer:(CGFloat)duration
{
    if (!_timer)
    {
        _timer = [NSTimer timerWithTimeInterval:duration
                                         target:self
                                       selector:@selector(discoveredPeripheralsAndConnect)
                                       userInfo:nil
                                        repeats:NO];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)stopScanTimer
{
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
   
}

- (void)discoveredPeripheralsAndConnect
{
    [pencommManager setHandleNewPeripheral:nil];
    [pencommManager btStart];
    self.btStatus = BT_CONNECTING;
    /*
    CBPeripheral *foundPeripheral;
    NSString *penName;
    
    [self stopScanTimer];
    NSLog(@"******** discoveredPeripheralsAndConnect");
    self.discoveredPeripherals = [pencommManager discoveredPeripherals];
    self.macArray = [pencommManager macArray];
    self.serviceIdArray = [pencommManager serviceIdArray];
    if ([self.discoveredPeripherals count] > 0) {
        //example, if index 0 of discoveredPeripherals should be connected
        NSInteger index = 0;
        
        NSString *serviceUUID;
        if ([self.serviceIdArray count] > 0)
            serviceUUID = [self.serviceIdArray objectAtIndex:0];
        
        // 1.try macAddr first
        foundPeripheral = self.discoveredPeripherals[0];
        penName = foundPeripheral.name;
        if ([serviceUUID isEqualToString:@"19F0"] || [serviceUUID isEqualToString:@"19F1"]) {
            pencommManager.isPenSDK2 = YES;
            NSLog(@"Pen SDK2.0");
        } else {
            pencommManager.isPenSDK2 = NO;
            NSLog(@"Pen SDK1.0");
        }
        
        [pencommManager connectPeripheralAt:index];
    }else{
        NSLog(@"******** discoveredPeripheralsAndConnect  false-> [self.discoveredPeripherals count] > 0");

    }
    */
}

//NJPenCommManagerNewPeripheral
- (void) connectionResult:(BOOL)success
{
    [pencommManager btStop];
    if (success) {
        NSLog(@"Pen connection success");
    } else {
        NSLog(@"Pen connection failure or pen disconnection");
    }
    
}

//NJPenStatusDelegate
- (void) penStatusData:(PenStateStruct *)penStatus
{
    NSLog(@"viewController penstatus");
    NSLog(@"penStatus %d, timezoneOffset %d, timeTick %llu", penStatus->penStatus, penStatus->timezoneOffset, penStatus->timeTick);
    NSLog(@"pressureMax %d, battery %d, memory %d", penStatus->pressureMax, penStatus->battLevel, penStatus->memoryUsed);
    NSLog(@"autoPwrOffTime %d, penPressure %d", penStatus->autoPwrOffTime, penStatus->penPressure);
    
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970]*1000;
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    NSInteger millisecondsFromGMT = 1000 * [localTimeZone secondsFromGMT] + [localTimeZone daylightSavingTimeOffset]*1000;
    
    
    if (pencommManager.isPenSDK2) {
        if ((fabs(penStatus->timeTick - timeInMiliseconds) > 2000)) {
            [pencommManager setPenStateWithTimeTick];
        }
    }else{
        if ((fabs(penStatus->timeTick - timeInMiliseconds) > 2000)
            || (penStatus->timezoneOffset != millisecondsFromGMT)) {
            [pencommManager setPenStateWithTimeTick];
        }
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    BOOL penAutoPower = YES, penSound = YES;
    
    if (pencommManager.isPenSDK2) {
        if (penStatus->usePenTipOnOff == 1) {
            penAutoPower = YES;
        }else if (penStatus->usePenTipOnOff == 0) {
            penAutoPower = NO;
        }
        
        if (penStatus->beepOnOff == 1) {
            penSound = YES;
        }else if (penStatus->beepOnOff == 0) {
            penSound = NO;
        }
    } else {
        if (penStatus->usePenTipOnOff == 1) {
            penAutoPower = YES;
        }else if (penStatus->usePenTipOnOff == 2) {
            penAutoPower = NO;
        }
        
        if (penStatus->beepOnOff == 1) {
            penSound = YES;
        }else if (penStatus->beepOnOff == 2) {
            penSound = NO;
        }
    }
    
    NSLog(@"************ penautopower: %@ penSound: %@", penAutoPower ? @"YES" : @"NO", penSound ? @"YES" : @"NO");
    
    BOOL savedPenAutoPower = [defaults boolForKey:@"penAutoPower"];
    if (penAutoPower != savedPenAutoPower) {
        [defaults setBool:penAutoPower forKey:@"penAutoPower"];
        [defaults synchronize];
    }
    
    BOOL savedPenSound = [defaults boolForKey:@"penSound"];
    if (penSound != savedPenSound) {
        [defaults setBool:penSound forKey:@"penSound"];
        [defaults synchronize];
    }
    
    
    
    NSNumber *penPressure = [NSNumber numberWithInt:penStatus->penPressure];
    NSNumber *savedPenPressure = [defaults objectForKey:@"penPressure"];
    if (![savedPenPressure isEqualToNumber:penPressure]) {
        [defaults setObject:penPressure forKey:@"penPressure"];
        [defaults synchronize];
    }
    
    NSNumber *autoPwrOff = [NSNumber numberWithInt:penStatus->autoPwrOffTime];
    NSNumber *savedAutoPwrOff = [defaults objectForKey:@"autoPwrOff"];
    if (![savedAutoPwrOff isEqualToNumber:autoPwrOff]) {
        [defaults setObject:autoPwrOff forKey:@"autoPwrOff"];
        [defaults synchronize];
    }
    
    if(pencommManager.isPenSDK2){
        if((penStatus -> battLevel & 0x80) == 0x80 ){
            if ((penStatus -> battLevel & 0x7F) == 100) {
                NSLog(@"Battery is fully charged");
            }
            NSLog(@"Battery is being charged");
            return;
        }
    }
    
}



//NJPenPasswordDelegate
- (void) penPasswordRequest:(PenPasswordRequestStruct *)request
{
    NSString *password = [MyFunctions loadPasswd];
    int resetCount = (int)request->resetCount;
    int retryCount = (int)request->retryCount;
    int count = resetCount - retryCount;
    
    if(count <= 1) {
        // last attempt was failed we delete registration and disconnect pen
        [[NJPenCommManager sharedInstance] setBTComparePassword:@"0000"];
        [[NJPenCommManager sharedInstance] resetPenRegistration];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NJPenCommParserPenPasswordValidationFail object:nil userInfo:nil];
        });
        
        return;
    }
    
    if ([password isEqualToString:@""]) {
        password = @"0000";
        [MyFunctions saveIntoKeyChainWithPasswd:password];
        
        [[NJPenCommManager sharedInstance] setBTComparePassword:password];
    }else{
        if(request->retryCount == 0){
            [[NJPenCommManager sharedInstance] setBTComparePassword:password];
        }else{
            NSLog(@"*********** neo request->retryCount == 0 else ***********");
//            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            NJInputPasswordViewController *inputPasswordViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"inputPWVC"];
//            [self presentViewController:inputPasswordViewController animated:YES completion:nil];
        }
    }
    
}

- (void)penPasswordCompareSuccess:(NSNotification *)notification
{
    NSLog(@"setBTComparePassword success");
    
}



//NJPenCommParserStartDelegate
- (void) activeNoteIdForFirstStroke:(int)noteId pageNum:(int)pageNumber sectionId:(int)section ownderId:(int)owner
{
    //[[MyManager sharedManager] front_draw_Start:point];
    NSLog(@"noteID:%d, page number:%d, sectionId:%d, ownerId:%d",noteId, pageNumber, section, owner);
    self.OWNER_ID = owner;
    self.activeNotebookId = noteId;
    if(self.activePageNumber != pageNumber){
            NSDictionary * userInfo = @{@"newpage": @(YES)};
            [[NSNotificationCenter defaultCenter] postNotificationName:keyNeoNOtificationNewPage object:self userInfo:userInfo];
    }
    self.activePageNumber = pageNumber;
    
    
}

- (void) setPenCommNoteIdList
{
    NSUInteger notebookId = 625; NSUInteger sectionId = 3; NSUInteger ownerId = 28;
    [[NPPaperManager sharedInstance] reqAddUsingNote:notebookId section:sectionId owner:ownerId];
    
    //[pencommManager setNoteIdListFromPList];
    [pencommManager setAllNoteIdList];
}

//NJPenCommParserCommandHandler
- (void) findApplicableSymbols:(NSString *)param action:(NSString *)action andName:(NSString *)name
{
    //NSLog(@"param:%@, action:%@, name:%@",param, action, name);
}



- (void) penConnectedByOtherApp:(BOOL)penConnected
{
    if (penConnected) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Your pen has been connected by the one of other apps. Please disconnect it from the app and please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark- extras
- (UInt32)convertUIColorToAlpahRGB:(UIColor *)color
{
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    NSLog(@"Red: %f", components[0]);
    NSLog(@"Green: %f", components[1]);
    NSLog(@"Blue: %f", components[2]);
    NSLog(@"Alpha: %f", CGColorGetAlpha(color.CGColor));
    
    CGFloat colorRed = components[0];
    CGFloat colorGreen = components[1];
    CGFloat colorBlue = components[2];
    CGFloat colorAlpah = 1.0f;
    UInt32 alpah = (UInt32)(colorAlpah * 255) & 0x000000FF;
    UInt32 red = (UInt32)(colorRed * 255) & 0x000000FF;
    UInt32 green = (UInt32)(colorGreen * 255) & 0x000000FF;
    UInt32 blue = (UInt32)(colorBlue * 255) & 0x000000FF;
    UInt32 penColor = (alpah << 24) | (red << 16) | (green << 8) | blue;
    
    return penColor;
}

- (UIColor *)convertUIColorFromIntColor:(UInt32)intColor
{
    float colorA = (intColor>>24)/255.0f;
    float colorR = ((intColor>>16)&0x000000FF)/255.0f;
    float colorG = ((intColor>>8)&0x000000FF)/255.0f;
    float colorB = (intColor&0x000000FF)/255.0f;
    
    return [[UIColor alloc] initWithRed:colorR green:colorG blue:colorB alpha:colorA];
}






@end
