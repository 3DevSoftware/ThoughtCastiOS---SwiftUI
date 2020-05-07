//
//  GlobalSlateManager.cpp
//  ThoughtCast
//
//  Created by David Kachlon on 12/6/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//


#include "GlobalSlateManager.h"
#include "ThoughtCast-Swift.h"

iSketchnoteController * isknController;

extern "C"
{

    

    
    void launchiSketchnoteController(SelectSlateTableViewController *viewController)
    {
        try
        {
        
            if (viewController == nil) {
                //NSString * p = [MySlateManager sharedManager].peripheral;
                isknController = new
                iSketchnoteController([MyManager sharedManager].deviceName);
                NSLog(@"Reconnecting to a name");
                
            } else {
                isknController = new iSketchnoteController(viewController);
            }
            

 
            
        
            
      
        } catch (Error &err)
        {
            NSLog(@"Error");
        }
    }
    
    BOOL isDeviceConnected() {
        return isknController->slateManager->isConnected();
    }
    
    void connectToSlate(int slateID) {
        
        CBPeripheral* peripheral= isknController->slateManager->getDeviceByID(slateID);
        isknController->slateManager->connect(peripheral);
    }
    
    void connectToFirstAvailableDevice() {
        isknController->slateManager->connect();
    }
    
    void connectToPeripheralByName(NSString* name) {
        //isknController->slateManager->connect(name);
        
        
        NSMutableArray* devices = isknController->slateManager->getDevicesList();
        for  (CBPeripheral* p  in devices) {
            
            if (p.name == name) {
                NSLog(@"found periferal %@", p.name);
                if(isknController->slateManager->connect(p.name))
                
                {
                    return;
                }
            }
        }
        
        // isknController->slateManager->connect(name);
    }
    void connectToPeripheral(CBPeripheral* peripheral) {
        
        NSLog(@"connectToPeripheral %@", peripheral.name);
        isknController->slateManager->connect(peripheral);
        
    }
    
    void refresh()
    {
        Device &test = isknController->slateManager->getDevice();
        test.refresh();
        
   
        
    }
    void disconnect() {
        NSLog(@"Slate disconnected");
        [MyManager sharedManager].isConnected = false;
        //[MySlateManager sharedManager].watchdisc;
        
        if([MyManager sharedManager].CurrentPage == FRONT_PAGE)
        {
            NSLog(@"atttempte");
            [[MyManager sharedManager] drawFrontPage];
        }
        isknController->slateManager->disconnect();
    
    
    }
    
    
    void doRename(NSString *name)
    {
       
        isknController->renameSlate(name);
        
   
    
        
    }
    
   
}



iSketchnoteController::iSketchnoteController(SelectSlateTableViewController *viewController) {
    
    NSLog(@"init");
  
    
    
    //Create the slate manager
    slateManager = new SlateManager();
    
    //Register the iSketchnoteController as a Listener
    slateManager->registerListener(this);
    
    //Connect to the first available device
    //slateManager->connect();
    
    //OR Scan all Ble devices
    slateManager->startScan(this);
    
    [MyManager sharedManager].currentTableView = viewController;
    
    //Get access to the ViewController.it will be used
    this->viewController=viewController;
    

    
  
}




iSketchnoteController::iSketchnoteController(NSString * name) {
    NSLog(@"init");
    
  
    
    //Create the slate manager
    slateManager=new SlateManager();
    
    //Register the iSketchnoteController as a Listener
    slateManager->registerListener(this);
    
    //conenct by name
    slateManager->connect(name);
    
    //connect by name
    
    //OR Scan all Ble devices
    slateManager->startScan(this);
    
    //Get access to the ViewController.it will be used
    //this->viewController=viewController;
    
}

void iSketchnoteController::renameSlate(NSString *name)
{
    
    Device *device;
    
    device = &isknController->slateManager->getDevice();
    BOOL nameChanged = device->setDeviceName((char*)[name UTF8String]);
    
    
    if ([MyManager sharedManager].isConnected) {
        
        [MyManager sharedManager].deviceName = name;
        [[MyManager sharedManager] drawFrontPage];
        
        
    }
    
    isknController->slateManager->request(REQ_DESCRIPTION);
    
    [[MyManager sharedManager].strSlatesList removeAllObjects];
    
 
    
    NSLog(@"Disconnected.");
    
//        isknController->slateManager->request(REQ_DESCRIPTION);
//        isknController->slateManager->request(REQ_DESCRIPTION);
//        isknController->slateManager->request(REQ_DESCRIPTION);
//        isknController->slateManager->request(REQ_DESCRIPTION);
    NSLog(@"Trying: %@", name);
    
    
    
}


void iSketchnoteController::connectionStatusChanged(bool connected){
    if (connected) {
        [MyManager sharedManager].isConnected = true;
        slateManager->request(REQ_DESCRIPTION);
        [MyManager sharedManager].discClicked = false;
        [MyManager sharedManager].alreadyConnected = true;


        
        
        slateManager->request(REQ_STATUS);

       
        if([MyManager sharedManager].CurrentPage == DRAWING_MODE)
        {
            [[MyManager sharedManager] update_Draw_Dot];
            
            
        }
         Device &test = isknController->slateManager->getDevice();
        
    //    [MyManager sharedManager].deviceName = [NSString stringWithUTF8String:test.getDeviceName()];
        
        [MyManager sharedManager].isLooking = false;
        
        if([MyManager sharedManager].renamingSlate)
        {
            [MyManager sharedManager].renamingSlate = false;
            [[MyManager sharedManager] drawFrontPage];
        }
        if(![MyManager sharedManager].discClicked)
        {
            [[MyManager sharedManager] startCheckingPeripheralConnection:YES];
        }
        //Subscribe to the events
        slateManager->subscribe(AUTO_STATUS|AUTO_SOFTWARE_EVENTS|AUTO_HARDWARE_EVENTS|AUTO_PEN_2D );
        
        
        
        //   [[MySlateManager sharedManager] watchgreen];
        
        
        if (viewController != nil) {
       
            
            [viewController.navigationController popViewControllerAnimated:YES];
            
             
        }
       
        
        if ([MyManager sharedManager].state == RECONNECTING) {
            [MyManager sharedManager].state  = RECONNECTED;
            [MyManager sharedManager].isLooking = true;
            
        }
        
        NSLog(@"Slate connected test %s: \n [MyManager sharedManager].state %u", test.getDeviceName(), [MyManager sharedManager].state);

        
        if([MyManager sharedManager].CurrentPage == FRONT_PAGE)
        {
            [[MyManager sharedManager] drawFrontPage];
        }
  
        
    } else {
        
        if(![MyManager sharedManager].bluetoothAvailable)
        {
            [MyManager sharedManager].discClicked = false;
            [[MyManager sharedManager] stopCheckingPeripheralConnection];
            [MyManager sharedManager].isLooking = false;
            
            [MyManager sharedManager].alreadyConnected = false;
             [MyManager sharedManager].isConnected = false;
            NSLog(@"done through here.");
            [[MyManager sharedManager] drawFrontPage];
            
            return;
        }
                 [MyManager sharedManager].isConnected = false;
        NSLog(@"disconnected");
        if([MyManager sharedManager].discClicked)
        {
            [MyManager sharedManager].discClicked = false;
            [[MyManager sharedManager] stopCheckingPeripheralConnection];
            [MyManager sharedManager].isLooking = false;
            
            [MyManager sharedManager].alreadyConnected = false;

            NSLog(@"done through here.");
            [[MyManager sharedManager] drawFrontPage];
            return;
        }
        
        
        [[MyManager sharedManager] startCheckingPeripheralConnection:YES];

        [MyManager sharedManager].isLooking = true;
        
        
        if([MyManager sharedManager].CurrentPage == FRONT_PAGE)
        {
           [[MyManager sharedManager] drawFrontPage];
        }
        slateManager->connect();
        
        
        if([MyManager sharedManager].CurrentPage == DRAWING_MODE)
        {
            NSLog(@"here we go");
            
            [[MyManager sharedManager] playContiniousShortVibration];
            
            [[MyManager sharedManager] update_Draw_Dot];
        }
        
        
 
        
     
    
      //  viewController = nil;
        
        NSLog(@"Slate could not connect\n");
  
        
        
    }

    
}


void iSketchnoteController::processEvent(ISKN_API::Event &event,unsigned int timecode){

    

    switch (event.Type) {
            
            case EVT_STATUS:
        {
            EventStatus &ev=event.Status ;
            int bat=ev.getBattery() ;
            
            [MyManager sharedManager].isCharging = ev.isBatteryInCharge();
            
              NSLog(@"here---->%d", [MyManager sharedManager].isCharging );
            [MyManager sharedManager].batteryCharge = bat;
            
            if([MyManager sharedManager].CurrentPage == DRAWING_MODE || [MyManager sharedManager].CurrentPage == ZONE_SETUP)
            {
            [[MyManager sharedManager] update_Draw_Dot];
            }
            
            
            [[MyManager sharedManager] drawFrontPage];
           // store the battery for display
            
            // update the battery
            
            
            //((WatchScreen*)[MySlateManager sharedManager].viewWatchSheet) updateColor];
            //saves locally
            
         //   [MyManager sharedManager].batteryCharge = bat;
            

            NSLog(@"Battery %d\n",bat);
        }
            break;
            
            case EVT_HARDWARE:
        {
            EventHardware &ev=event.HardwareEvent ;
            switch (ev.getHardwareEventType())
            {
                    
                    case HE_BUTTON1_PRESSED :
                    NSLog(@"Button 1 pressed\n") ;
                    break ;
                    case HE_BUTTON2_PRESSED :
                    NSLog(@"Button 2 pressed\n");
                    break ;
                default :
                    break ;
            }
        }
            break;
            
            case EVT_DESCRIPTION:
        {
            EventDescription &ev=event.Description ;
            NSString * name = [NSString stringWithUTF8String:ev.getDeviceName()];
            
            NSLog(@"Attempt at fix: %@ <- new name", name);
            
            
            if ([MyManager sharedManager].isConnected) {

           
                [MyManager sharedManager].deviceName = name;
                if([MyManager sharedManager].renamingSlate)
                {
                      [MyManager sharedManager].deviceName = [MyManager sharedManager].renameTo;
                    if([MyManager sharedManager].renameTo == name)
                    {
                        [MyManager sharedManager].renamingSlate = false;
                        [[MyManager sharedManager] drawFrontPage];
                    }
                }
            }
            
            NSMutableArray* devices = slateManager->getDevicesList();
            for  (CBPeripheral* p  in devices) {
                if (p.name == name) {
                    [MyManager sharedManager].peripheral = p;
                    NSLog(@"setup periferal %@", p.name);
                }
            }
            
            
            NSLog(@"Slate name: %@", name);
            ISKN_API::Rect rect = ev.getActiveZone();
                    Device &test = isknController->slateManager->getDevice();
            
            [MyManager sharedManager].activeZone = CGRectMake(rect.Left, rect.Top, rect.Width, rect.Height);
            
            [[MyManager sharedManager] drawFrontPage];
        }
            break;
            
            case EVT_SOFTWARE :
        {
            EventSoftware &ev=event.SoftwareEvent ;
            
            int p=ev.getObjectID() ;
            switch (ev.getSoftwareEventType())
            {
                    case SE_OBJECT_IN :
                {
                    //NSLog(@"in : %d ",p);
                }
                    break ;
                    case SE_OBJECT_OUT :
                {
                    //NSLog(@"out : %d ",p);
                }
                    break;
                    case SE_HANDSHAKE:
                    
                    break;
            }
        }
            break ;
            case EVT_PEN_2D:
        {
            EventPen2D &ev=event.Pen2D;
            Vector2D pos=ev.getPosition();
            CGPoint point = CGPointMake(pos.X, pos.Y);
          
            static bool bkContact=false;
            // Detect touch
            /*
             
             */
            
         
            if([MyManager sharedManager].CurrentPage == ZONE_GO)
            {{
               
                
             
                 if(!bkContact && ev.Touch())
                 {
                     
                     
                    
                     
                     
                     
                     
                     [[MyManager sharedManager] start_Touch_Go:point];
                     
                 } else if (bkContact && ev.Touch()) {
                     
                     
                     [[MyManager sharedManager]move_Touch_Go:point];
                     
                     
                
                     //Touch moved
                     //       NSValue *objectT = [NSValue valueWithCGPoint:point];
                     
                     
                     //   [[MySlateManager sharedManager]  performSelectorInBackground:@selector(touchMoved:) withObject: objectT];
                     
                     
              
                 } else if (bkContact && !ev.Touch()) {
                     
                     [[MyManager sharedManager]stop_Touch];
                     
                     
                
                     
                     //NSLog(@"Touch ended");
                 }
                 
                 bkContact=ev.Touch();
                 break;
                 }
                 
                 return;
                 }
            
       




            
            if([MyManager sharedManager].CurrentPage == DRAWING_MODE)
            {{
                
                
                
                if(!bkContact && ev.Touch())
                {
                    
                    
                    
                    
                    
                    
                    
                    [[MyManager sharedManager] front_draw_Start:point];
                    
                    
                } else if (bkContact && ev.Touch()) {
                    
                    
                    [[MyManager sharedManager] front_draw_Move:point];
                    
                    
                    
                    
                    //Touch moved
                    //       NSValue *objectT = [NSValue valueWithCGPoint:point];
                    
                    
                    //   [[MySlateManager sharedManager]  performSelectorInBackground:@selector(touchMoved:) withObject: objectT];
                    
                    
                    
                } else if (bkContact && !ev.Touch()) {
                    
                    [[MyManager sharedManager]stop_Touch];
                    
             
                    
                    //NSLog(@"Touch ended");
                }
                
                bkContact=ev.Touch();
                break;
            }
                
                return;
            }
            
            

            if(!([MyManager sharedManager].CurrentPage == ZONE_SETUP )) return;
          
            if(!bkContact && ev.Touch())
            {
     
                
                
                [[MyManager sharedManager]start_Touch:point];
                
                
                
                
                
            } else if (bkContact && ev.Touch()) {
                
                
                [[MyManager sharedManager]move_Touch:point];
                
                //Touch moved
                //       NSValue *objectT = [NSValue valueWithCGPoint:point];
                
                
                //   [[MySlateManager sharedManager]  performSelectorInBackground:@selector(touchMoved:) withObject: objectT];
                
              
            } else if (bkContact && !ev.Touch()) {
           
                [[MyManager sharedManager]stop_Touch];
                
               
                
                //NSLog(@"Touch ended");
            }
            
            bkContact=ev.Touch();
            break;
        }
        default:
            break;
    }
}



void iSketchnoteController::newDeviceFound(CBPeripheral * _Nullable p_device){
    
    NSLog(@"Device found %@",p_device.name);
    [MyManager sharedManager].peripheral = p_device;
    if (viewController != nil) {
        if([[MyManager sharedManager].strSlatesList  containsObject:p_device.name])
        {
            [[MyManager sharedManager].strSlatesList  removeObject:p_device.name];
       
          
                [[MyManager sharedManager] reloadData];
       
            
            NSLog(@"found duplicate");
            
            
        }
        [[MyManager sharedManager].strSlatesList addObject:p_device.name];

        NSLog(@"ok:%d ", [MyManager sharedManager].strSlatesList.count);
      
            [[MyManager sharedManager] reloadData];
            
        NSLog(@".mm ok:%d ", [MyManager sharedManager].strSlatesList.count);
        
        
        return;
     //   [viewController.AvailableSlates reloadData];
    }
    else  {
       disconnect();
       connectToPeripheral(p_device);
    }
}

void iSketchnoteController::scanFinished()
{
    NSLog(@"Scan finished");
}

void iSketchnoteController::notify(ScannerEvent evt){
    
    switch(evt){
            case BLESCANNER_EVENT_ACTIVATION_REQUIRED:
            NSLog(@"Notification received");
            break;
            case BLESCANNER_EVENT_BLE_NOT_SUPPORTED:
            NSLog(@"BLE not supported");
            break;
            case BLESCANNER_EVENT_BLE_SCAN_STARTED:
            NSLog(@"Scan started");
            break;
            case BLESCANNER_EVENT_NONE:
            break;
    }
}
