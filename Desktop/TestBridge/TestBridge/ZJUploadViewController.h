//
//  ZJUploadViewController.h
//  TestBridge
//
//  Created by ZJ on 06/09/2017.
//  Copyright © 2017 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ZJUploadViewController : UIViewController

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;

@end
