//
//  GlobalSlateManager.hpp
//  ThoughtCast
//
//  Created by David Kachlon on 12/6/18.
//  Copyright © 2018 ThoughtCast. All rights reserved.
//

#ifndef GlobalSlateManager_hpp
#define GlobalSlateManager_hpp

#include <stdio.h>
#include "MyManager.h"
#include "ISKN_API.h"


using namespace ISKN_API;
//View


class iSketchnoteController :public Listener,BleScanListener
{
public:
    //ISKN API attributes
    SlateManager *slateManager;
    
    
    //Contructor
    iSketchnoteController(SelectSlateTableViewController *viewController);
    iSketchnoteController(NSString * name);

    //iSketchnoteController(CBPeripheral * p);
    //Listener methods
    void connectionStatusChanged(bool connected);
    void renameSlate(NSString *name);
    NSString *renamingTo;
    
    void processEvent(ISKN_API::Event &event,unsigned int timecode);
    
    //BleScanListener methods
    CBPeripheral * getCurrentPeripheralByName(NSString* name);
    void newDeviceFound(CBPeripheral * p_device);
    void notify(ScannerEvent evt);
    void scanFinished();
    void dimiss();
    void setNewPeripheralBy(NSString* deviceName);
  
    //Drawing lib
    
    SelectSlateTableViewController * viewController;
    
};
#endif /* GlobalSlateManager_hpp */


