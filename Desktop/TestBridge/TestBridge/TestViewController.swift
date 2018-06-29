//
//  TestViewController.swift
//  TestBridge
//
//  Created by ZJ on 09/08/2017.
//  Copyright © 2017 HY. All rights reserved.
//

import UIKit
import CoreBluetooth

class TestViewController: UIViewController, DFUServiceDelegate, DFUProgressDelegate, LoggerDelegate {
    /**
     Callback called in the `State.Uploading` state. Gives detailed information about the progress
     and speed of transmission. This method is always called at least two times (for 0% and 100%)
     if upload has started and did not fail.
     
     This method is called in the main thread and is safe to update any UI.
     
     - parameter part: number of part that is currently being transmitted. Parts start from 1
     and may have value either 1 or 2. Part 2 is used only when there were Soft Device and/or
     Bootloader AND an Application in the Distribution Packet and the DFU target does not
     support sending all files in a single connection. First the SD and/or BL will be sent, then
     the service will disconnect, reconnect again to the (new) bootloader and send the Application.
     - parameter totalParts: total number of parts that are to be send (this is always equal to 1 or 2).
     - parameter progress: the current progress of uploading the current part in percentage (values 0-100).
     Each value will be called at most once - in case of a large file a value e.g. 3% will be called only once,
     despite that it will take more than one packet to reach 4%. In case of a small firmware file
     some values may be ommited. For example, if firmware file would be only 20 bytes you would get
     a callback 0% (called always) and then 100% when done.
     - parameter currentSpeedBytesPerSecond: the current speed in bytes per second
     - parameter avgSpeedBytesPerSecond: the average speed in bytes per second
     */

    fileprivate var selectedFirmware : DFUFirmware?
    fileprivate var selectedFileURL  : URL?
    fileprivate var dfuPeripheral    : CBPeripheral?
    fileprivate var centralManager   : CBCentralManager?
    fileprivate var dfuController    : DFUServiceController?

    override func viewDidLoad() {
        super.viewDidLoad()
//        let aa = SwiftTest()
//        aa.test()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectedFileURL  = getBundledFirmwareURLHelper()

        selectedFirmware = DFUFirmware(urlToZipFile: selectedFileURL!)
        startDFUProcess()
    }
    
    func getBundledFirmwareURLHelper() -> URL? {
        return Bundle.main.url(forResource: "jiezhi_03", withExtension: "zip")!
    }
    
    func setCentralManager(_ centralManager: CBCentralManager) {
        self.centralManager = centralManager
    }
    
    func setTargetPeripheral(_ targetPeripheral: CBPeripheral) {
        self.dfuPeripheral = targetPeripheral
    }
    
    func startDFUProcess() {
        guard dfuPeripheral != nil else {
            print("No DFU peripheral was set")
            return
        }
        
        let dfuInitiator = DFUServiceInitiator(centralManager: centralManager!, target: dfuPeripheral!)
        dfuInitiator.delegate = self
        dfuInitiator.progressDelegate = self
        dfuInitiator.logger = self
        
        // This enables the experimental Buttonless DFU feature from SDK 12.
        // Please, read the field documentation before use.
        dfuInitiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = true
        dfuController = dfuInitiator.with(firmware: selectedFirmware!).start()
    }
    
    //MARK: - DFUServiceDelegate
    
    func dfuStateDidChange(to state: DFUState) {
        print("Changed state to: \(state.description())")
    }
    
    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {

        print("Error \(error.rawValue): \(message)")
        
        // Forget the controller when DFU finished with an error
        dfuController = nil
    }
    
    //MARK: - DFUProgressDelegate
    func onUploadProgress(_ part: Int, totalParts: Int, progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        
    }
    
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
    }
    
    //MARK: - LoggerDelegate
    
    func logWith(_ level: LogLevel, message: String) {
        print("\(level.name()): \(message)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
