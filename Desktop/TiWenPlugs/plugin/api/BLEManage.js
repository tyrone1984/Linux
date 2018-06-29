const tool = require('tool.js')

const ServicesCharacteristic = "0000FFE7"
const ReadCharacteristic = "0000FEC9"
const WriteCharacteristic = "0000FEC7"
const UpdateCharacteristic = "0000FEC8"

var WriteDataType = -1

module.exports = class {
  constructor() {
    this.openAdapter = false
  }

  initBLESetting() {
    this.openBLEAdapter()
    this.listenAdapterStateChange()
  }

  openBLEAdapter() {
    var that = this
    wx.openBluetoothAdapter({
      success: function (res) {
        that.openAdapter = true
        that.beganSearch()
      },
      fail: function (res) {
        tool.showMention('请打开手机蓝牙', true)
      }
    })
  }

  // 开始搜索蓝牙设备
  beganSearch() {
    wx.startBluetoothDevicesDiscovery({
      success: function (res) {
        console.log("开始搜索成功: ")
        console.log(res)
      }
    })
  }

  // 监听蓝牙状态
  listenAdapterStateChange() {
    var that = this
    wx.onBluetoothAdapterStateChange(function (res) {
      console.log(res)

      if (res.available == false) {
        that.openAdapter = false
        tool.showMention('蓝牙不可用,请检查蓝牙是否打开', true)
      } else {
        if (that.openAdapter != true) {
          that.openBLEAdapter()
        }
      }
    })
  }

  // 获取搜索设备
  searchDevice(searchCallBack, prefix) {
    var that = this   // 注意this的层级关系
    wx.getBluetoothDevices({
      success: function (res) {
        let devices = res.devices
        var mDevices = []
        if (!prefix) prefix = ""

        for (let i = 0; i < devices.length; i++) {
          var device = devices[i]
          if (device.name.indexOf(prefix) > -1) {
            mDevices.push(device)
            console.log(device)
          }
        }
        console.log('搜索设备回调')
        searchCallBack(mDevices)
      },
      fail: function (res) {
        console.log('未搜索到设备')
        console.log(res)
        searchCallBack([])
      }
    })
  }

  // 搜索指定设备
  searchMatchDevice(searchCallBack, searchDeviceMac) {
    var that = this
    console.log('搜索设备的Mac地址 = ' + searchDeviceMac)

    wx.getBluetoothDevices({
      success: function (res) {
        let devices = res.devices

        for (let i = 0; i < devices.length; i++) {
          let device = devices[i]
          let mac = device.localName.split('-')[1]
          console.log(device)
          console.log(mac)
          if (mac == searchDeviceMac) {
            that.matchMac = mac
            that.settingDevice(device)
            searchCallBack(true)
            return;
          }
        }
        searchCallBack(false)
      },
      fail: function (res) {
        console.log('搜索失败')
        console.log(res)
        searchCallBack(false)
      }
    })
  }

  settingDevice(device) {
    var that = this
    that.device = device
    that.deviceID = device.deviceId
    that.deviceName = device.name
  }

  // 连接设备
  connectDevice(connCallBack, device) {
    var that = this
    if (device) {
      console.log(device)
      that.settingDevice(device)
    }

    wx.createBLEConnection({
      deviceId: that.deviceID,
      success: function (res) {
        that.connCallBack = connCallBack
        console.log('连接成功')
        console.log(res)
        that.findServices()
      },
      fail: function (res) {
        console.log('连接失败')
        console.log(res)
        connCallBack(false)
      }
    })
  }

  // 监听蓝牙连接状态
  listenConnectState(connectStateCallBack) {
    var that = this
    wx.onBLEConnectionStateChange(function (res) {
      console.log("onBLEConnectionStateChange")
      console.log(res)

      if (connectStateCallBack) {
        console.log("返回连接状态")
        connectStateCallBack(res.connected)
      }
    })
  }

  cancelBLEConnect(cancelConnectCallBack) {
    var that = this
    wx.closeBLEConnection({
      deviceId: that.deviceID,
      success: function (res) {
        console.log('取消连接成功')
        console.log(res)
        if (cancelConnectCallBack) {
          cancelConnectCallBack(true)
        }
      },
      fail: function (res) {
        console.log('取消连接失败')
        console.log(res)
        if (cancelConnectCallBack) {
          cancelConnectCallBack(true)
        }
      }
    })
  }

  //查找服务
  findServices() {
    var that = this
    wx.getBLEDeviceServices({
      deviceId: that.deviceID,
      success: function (res) {
        console.log('搜索服务成功')
        console.log(res);
        let services = res.services
        if (services instanceof Array) {
          for (var i = 0; i < services.length; i++) {
            console.log("uuid-", services[i].uuid);
            if (services[i].uuid.indexOf(ServicesCharacteristic) > -1) {
              that.matchService = services[i]
              that.findCharacteristics()
              break
            }
          }
        } else {
          that.matchService = res.services[0]
        }
      },
      fail: function (res) {
        console.log("搜索服务失败")
        console.log(res)
      },
    })
  }

  /*
    查找特征
  */
  findCharacteristics() {
    var that = this
    wx.getBLEDeviceCharacteristics({
      deviceId: that.deviceID,
      serviceId: that.matchService.uuid,
      success: function (res) {
        console.log("查找特征成功")
        console.log(res)
        if (res.characteristics instanceof Array) {
          that.characteristics = res.characteristics
          that.dealCharacteristics()
        }
      },
      fail: function (res) {
        console.log("查找特征失败")
        console.log(res)
      },
    })
  }

  dealCharacteristics() {
    var that = this
    let cts = that.characteristics;
    for (let i = 0; i < cts.length; i++) {
      let ct = cts[i]
      if (ct.uuid.indexOf(UpdateCharacteristic) > -1) {
        that.openNotify(ct)
        that.listenNotifyValueChange()
      } else if (ct.uuid.indexOf(WriteCharacteristic) > -1) {
        that.WriteCharacteristicID = ct.uuid
      } else if (ct.uuid.indexOf(ReadCharacteristic) > -1) {
        that.ReadCharacteristicID = ct.uuid
      }
    }
  }

  /*
    打开订阅
  */
  openNotify(ct) {
    var that = this
    wx.notifyBLECharacteristicValueChange({
      deviceId: that.deviceID,
      serviceId: that.matchService.uuid,
      characteristicId: ct.uuid,
      state: true,
      success: function (res) {
        console.log("notify打开成功")
        console.log(res)
      },
      fail: function (res) {
        console.log("notify打开失败");
        console.log(res)
      },
    })
  }

  /*
   处理notify数据
  */
  listenNotifyValueChange() {
    var that = this
    wx.onBLECharacteristicValueChange(function (res) {

    })
  }
}

