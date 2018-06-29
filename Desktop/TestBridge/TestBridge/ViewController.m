//
//  ViewController.m
//  TestBridge
//
//  Created by ZJ on 09/08/2017.
//  Copyright © 2017 HY. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZJUploadViewController.h"
#import "TestBridge-Swift.h"

@interface ViewController ()<CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_devices;
}

@property (nonatomic, strong) CBCentralManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

#define MatchServiceUUID @"00001523-1212-efde-1523-785feabcd123"
#define MatchCharacteristicUUID @"00001525-1212-efde-1523-785feabcd123" // 设备通知APP特性

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSettiing];
}

- (void)initSettiing {
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (void)initAry {
    _devices = @[].mutableCopy;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    [self.manager scanForPeripheralsWithServices:nil options:nil];
}

/**
 *  发现设备
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([peripheral.name isEqualToString:@"FROD-EBC813E7436C"]) {
        NSLog(@"发现设备--->%@, %@", advertisementData, peripheral.identifier.UUIDString);
        
        [_devices addObject:peripheral];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];            
        });
    }
}

/**
 *  已连接
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%s", __func__);
    [peripheral discoverServices:nil];
}

/**
 *  断开连接
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {

}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    NSLog(@"service = %@", peripheral.services);
    
    for (CBService *sev in peripheral.services) {
        if ([sev.UUID.UUIDString caseInsensitiveCompare:MatchServiceUUID] == NSOrderedSame) {
            [peripheral discoverCharacteristics:nil forService:sev];
            break;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"characteristic = %@", service.characteristics);
    
    for (CBCharacteristic *ct in service.characteristics) {
        if ([ct.UUID.UUIDString caseInsensitiveCompare:MatchCharacteristicUUID] == NSOrderedSame) {
            [peripheral setNotifyValue:YES forCharacteristic:ct];
            break;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
   
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"%s, %@", __func__, characteristic);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        TestViewController *vc = [TestViewController new];
        [vc setCentralManager:self.manager];
        [vc setTargetPeripheral:peripheral];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CBPeripheral *peripheral = _devices[indexPath.row];
    cell.textLabel.text = peripheral.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    CBPeripheral *p = _devices[indexPath.row];
    p.delegate = self;
    [self.manager connectPeripheral:p options:nil];
}


@end
