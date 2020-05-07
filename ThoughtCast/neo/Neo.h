//
//  Neo.h
//  ThoughtCast
//
//  Created by Rafik Boghouzian on 6/24/19.
//  Copyright © 2019 ThoughtCast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NISDK/NISDK.h>

#define SCRIBE_NAME @"Scribe"

typedef enum{
    BT_DISCONNECTED = 0,
    BT_CONNECTING,
    BT_CONNECTED,
    BT_UNREGISTERED,
}BT_STATUS;



NS_ASSUME_NONNULL_BEGIN

NSString *const keyNeoNOtification = @"NEO_NOTIFICATION";
NSString *const keyNeoNOtificationNewPage = @"NEO_NOTIFICATION_NEW_PAGE";

 
 
@interface Neo : NSObject<UIActionSheetDelegate, NJPenStatusDelegate, NJPenPasswordDelegate,NJPenCommParserStartDelegate,NJPenCommParserCommandHandler,NJPenCommManagerNewPeripheral, NJPenCommParserStrokeHandler>

@property (nonatomic, strong) NJPenCommManager *pencommManager;
@property (nonatomic) NSUInteger btStatus;
@property (nonatomic) NSInteger activeNotebookId;
@property (nonatomic) NSInteger activePageNumber;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMutableArray *discoveredPeripherals;
@property (strong, nonatomic) NSMutableArray *macArray;
@property (strong, nonatomic) NSMutableArray *serviceIdArray;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) UInt16 useHover;
@property (nonatomic) BOOL isNoteInfoInstalled;
@property (strong, nonatomic) NSString *scribeRealName;
@property (nonatomic) BOOL didDisconnectClick;
@property (nonatomic) int OWNER_ID;

+(instancetype _Nonnull)shared;
- (void) startNeoPen;
- (void)isLookingNow;
- (void)disconnectPen;
- (void) getReady;

@end

NS_ASSUME_NONNULL_END
