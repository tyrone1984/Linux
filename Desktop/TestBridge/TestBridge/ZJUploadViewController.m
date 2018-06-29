//
//  ZJUploadViewController.m
//  TestBridge
//
//  Created by ZJ on 06/09/2017.
//  Copyright © 2017 HY. All rights reserved.
//

#import "ZJUploadViewController.h"
//#import <iOSDFULibrary/iOSDFULibrary-Swift.h>

@interface ZJUploadViewController ()<LoggerDelegate, DFUServiceDelegate, DFUProgressDelegate>

@property (nonatomic, strong) DFUServiceController *dfuServiceController;

@end

@implementation ZJUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self firmwareUpgrade];
}

- (void)firmwareUpgrade {
        NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"jiezhi_03" ofType:@"zip"];
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//    NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
    
    NSURL *url = [NSURL fileURLWithPath:zipPath];
    
    //create a DFUFirmware object using a NSURL to a Distribution Packer(ZIP)
    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:url];// or
    //Use the DFUServiceInitializer to initialize the DFU process.
    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithCentralManager:self.centralManager target:self.peripheral];
    [initiator withFirmwareFile:selectedFirmware];
    // Optional:
    // initiator.forceDfu = YES/NO; // default NO
    // initiator.packetReceiptNotificationParameter = N; // default is 12
    initiator.logger = self; // - to get log info
    initiator.delegate = self; // - to be informed about current state and errors
    initiator.progressDelegate = self; // - to show progress bar
    // initiator.peripheralSelector = ... // the default selector is used
    
    self.dfuServiceController = [initiator start];
}


#pragma mark - LoggerDelegate

- (void)logWith:(enum LogLevel)level message:(NSString * _Nonnull)message {
    NSLog(@"%@", message);
}

#pragma mark - DFUServiceDelegate

- (void)didStateChangedTo:(enum DFUState)state {
    NSLog(@"state = %zd", state);
}

- (void)didErrorOccur:(enum DFUError)error withMessage:(NSString * _Nonnull)message {
    NSLog(@"error = %zd", error);
    NSLog(@"message = %zd", message);
    //    UIAlertView *alert = [];
}

#pragma mark - DFUProgressDelegate

- (void)onUploadProgress:(NSInteger)part totalParts:(NSInteger)totalParts progress:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond {
    NSLog(@"part = %zd, totalParts = %zd, progress = %zd", part, totalParts, progress);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
