//
//  ThoughtCast-Bridging-Header.h
//  ThoughtCast
//
//  Created by David Kachlon on 12/6/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//


#import "WatchConnectivity/WatchConnectivity.h"
#import <MessageUI/MessageUI.h>

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MyManager.h"
//#import <WatchKit/WatchKit.h>
#import "Neo.h"



extern void connectToPeripheralByName(NSString* name);
extern void connectToPeripheral(CBPeripheral* peripheral);

extern void disconnect();



extern void launchiSketchnoteController(SelectSlateTableViewController *viewController);
extern void isConnected();

