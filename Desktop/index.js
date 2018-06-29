//index.js
//获取应用实例
var scaningDevice = false;
var app = getApp()
Page({
  data: {
    userInfo: {},
    images: {
      headBgImg: '../resourse/pic/bg_1080x373.png',
      mainImg: '../resourse/pic/pic_mensuo_999x855.jpg',
      boyImg: '../resourse/pic/pic_tishikatongren_114x226.png'
    },
    isReservation: 1,
  },
  onLoad: function () {
    console.log('onLoad')
    var that = this
    //调用应用实例的方法获取全局数据
    app.getUserInfo(function (userInfo) {
      //更新数据
      that.setData({
        userInfo: userInfo
      })
    })

  },
  bookDoor: function () {
    var that = this
    that.setData({ isReservation: 2 });
  },
  scanDoor: function () {
    var that = this;
    wx.scanCode({
      onlyFromCamera: true,
      success: (res) => {
        console.log(res.result)
        var doorindex = res.result.indexOf("door=");
        if (doorindex > -1) {
          var doorcode = res.result.substring(doorindex + 5, res.result.length);
          console.log(doorcode);
          that.setData({
            Mac: doorcode
          })
          // wx.showLoading({
          //   title:"正在开门",
          //   mask:true
          // })
          wx.closeBluetoothAdapter({})
          wx.openBluetoothAdapter({
            success: function (res) {
              wx.startBluetoothDevicesDiscovery({
                success: function (res) {
                  console.log("开始搜索附近蓝牙设备");
                  // wx.showLoading({
                  //   title: "开始搜索附近蓝牙设备",
                  //   mask: true
                  // })
                  scaningDevice = true;
                }
              })
              wx.onBluetoothDeviceFound(function (res) {
                // wx.getBluetoothDevices({
                //   success: function (res) {
                //     console.log('发现新蓝牙设备')
                console.log(JSON.stringify(res))
                let devices = res
                var foundeddevice = false;
                if (devices.devices != undefined) {
                  //todo ios此处获取advertisData有问题
                  console.log("devices数组" + devices.devices.length);
                  for (let i = 0; i < devices.devices.length; i++) {
                    console.log('advertisData:' + uint8Array2Str(devices.devices[i].advertisData))
                    // const base64 = wx.arrayBufferToBase64(devices.devices[i].advertisData)
                    // console.log('找到'+base64);
                    // console.log('找到' + base64 + '--' + that.data.Mac)
                    if (devices.devices[i].name.toLowerCase().indexOf('e22e54ea80d7'.toLowerCase()) > -1) {
                      // wx.showLoading({
                      //   title: "找到匹配设备",
                      //   mask: true
                      // })
                      console.log('找到匹配设备')
                      that.setData({
                        deviceId: devices.devices[i].deviceId
                      })
                      scaningDevice = false;
                      foundeddevice = true;
                      break;
                    }
                  }
                }
                else {
                  console.log("devices对象");
                  console.log('找到' + uint8Array2Str(devices.advertisData) + '--' + that.data.Mac)
                  if (uint8Array2Str(devices.advertisData).toLowerCase().indexOf(that.data.Mac.toLowerCase()) > -1) {
                    // wx.showLoading({
                    //   title: "找到匹配设备",
                    //   mask: true
                    // })
                    console.log('找到匹配设备')
                    that.setData({
                      deviceId: devices.deviceId
                    })
                    scaningDevice = false;
                    foundeddevice = true;
                  }
                }
                if (foundeddevice) {
                  wx.stopBluetoothDevicesDiscovery(function () {

                  })
                  wx.createBLEConnection({
                    deviceId: that.data.deviceId,
                    success: function (resConn) {
                      // wx.showLoading({
                      //   title: "连接设备成功",
                      //   mask: true
                      // })
                      console.log("连接设备成功")
                      wx.getBLEDeviceServices({
                        deviceId: that.data.deviceId,
                        complete: function (resService) {
                          console.log(JSON.stringify(resService));
                          for (let j = 0; j < resService.services.length; j++) {
                            console.log('找到服务' + resService.services[j].uuid)
                            if (resService.services[j].uuid.toLowerCase().indexOf("ffe7") > -1) {
                              that.setData({
                                serviceId: resService.services[j].uuid
                              })
                              wx.getBLEDeviceCharacteristics({
                                deviceId: that.data.deviceId,
                                serviceId: that.data.serviceId,
                                success: function (res) {
                                  for (let k = 0; k < res.characteristics.length; k++) {
                                    console.log('找到特性' + res.characteristics[k].uuid)
                                    if (res.characteristics[k].uuid.toLowerCase().indexOf("fec8") > -1) {
                                      // that.setData({
                                      //   characteristicId: res.characteristics[i].uuid
                                      // })
                                      wx.notifyBLECharacteristicValueChanged({
                                        state: true,
                                        deviceId: that.data.deviceId,
                                        serviceId: that.data.serviceId,
                                        characteristicId: that.data.characteristicId,
                                        complete: function (res) {
                                          console.log('notifyBLECharacteristicValueChanged success', res.errMsg, that.data.characteristicId)

                                        }
                                      })
                                    }
                                    else if (res.characteristics[k].uuid.toLowerCase().indexOf("fec7") > -1) {
                                      that.setData({
                                        writeCharacteristicId: res.characteristics[k].uuid
                                      })
                                    }
                                  }
                                  // wx.showLoading({
                                  //   title: "开门ing",
                                  //   mask: true
                                  // })
                                  let arr = str2Bytes("aa0f01E2246B328BCB3132323033343138364255");
                                  let buffer = new ArrayBuffer(arr.length)
                                  let dataView = new DataView(buffer)
                                  for (let i = 0; i < arr.length; i++) {
                                    dataView.setUint8(i, arr[i])
                                  }
                                  wx.writeBLECharacteristicValue({
                                    deviceId: that.data.deviceId,
                                    serviceId: that.data.serviceId,
                                    characteristicId: that.data.writeCharacteristicId,
                                    value: buffer,
                                    success: function (res) {
                                      wx.showToast({title:"开门成功"});
                                      wx.hideLoading();
                                      console.log('writeBLECharacteristicValue success', res.errMsg)
                                    }
                                  })

                                }
                              })
                            }
                          }
                        }
                      })
                    },
                    fail: function (res) {
                      wx.hideLoading();
                      console.log("连接设备失败")
                    }
                  })
                }
                //   }
                // })
              })
            },
            fail: function (res) {
              console.log(res)
              that.setData({
                errmsg: "请检查手机蓝牙是否打开"
              })
            }
          })


        }
        else {
          // wx.showToast({
          //   title: '请扫描门锁二维码',
          //   duration: 2000
          // })
          that.setData({ isReservation: 0});
        }
        // wx.createBLEConnection({
        //   deviceId: e.currentTarget.id,
        //   //deviceId: "98:D3:32:30:B0:4E",
        //   success: function (res) {
        //     console.log("连接设备成功")
        //     console.log(res)
        //     that.setData({
        //       connected: true,
        //       connectedDeviceId: e.currentTarget.id
        //     })
        //   },
        //   fail: function (res) {
        //     console.log("连接设备失败")
        //     console.log(res)
        //     that.setData({
        //       connected: false
        //     })
        //   }
        // })
        // wx.onBLECharacteristicValueChange(function (res) {
        //   console.log('characteristic value comed:', JSON.stringify(res))
        //   let buffer = res.value
        //   console.log("接收字节:" + uint8Array2Str(buffer))

        // })
        // wx.stopBluetoothDevicesDiscovery(function () {

        // })
      }
    })
  }
})
function str2Bytes(str) {
  var pos = 0;
  var len = str.length;
  if (len % 2 != 0) {
    return null;
  }
  len /= 2;
  var hexA = new Array();
  for (var i = 0; i < len; i++) {
    var s = str.substr(pos, 2);
    var v = parseInt(s, 16);
    hexA.push(v);
    pos += 2;
  }
  return hexA;
}

//字节数组转十六进制字符串
function uint8Array2Str(buffer) {
  var str = "";
  let dataView = new DataView(buffer)
  for (let i = 0; i < dataView.byteLength; i++) {
    var tmp = dataView.getUint8(i).toString(16)
    if (tmp.length == 1) {
      tmp = "0" + tmp
    }
    str += tmp
  }
  return str;
}

function formatTime(date) {
  var year = date.getFullYear()
  var month = date.getMonth() + 1
  var day = date.getDate()

  var hour = date.getHours()
  var minute = date.getMinutes()
  var second = date.getSeconds()


  return [year, month, day].map(formatNumber).join('/') + ' ' + [hour, minute, second].map(formatNumber).join(':')
}

function formatNumber(n) {
  n = n.toString()
  return n[1] ? n : '0' + n
}