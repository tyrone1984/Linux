//index.js
//获取应用实例
const app = getApp()
const tool = require('../../Lib/tool.js')

Page({
  data: {
    devices: []
  },
  
  onLoad: function () {
    this.bleManage = app.globalData.bleManage
    
    setTimeout(function() {
      wx.onBluetoothDeviceFound(function (res) {
        let devices = res.devices;
        for(var i = 0; i < devices.length; i++) {
          
        }
      })
    }, 2000)
  },

  // 搜索设备
  searchDevice: function() {
    var that = this
    that.bleManage.searchDevice(function (res) {
      console.log(res)
      if(res.length) {
        that.setData({
          devices: res
        })
      }
    }, null) // "BeneCheck"
  },

  // 连接设备
  connectDevice: function (e) {
    console.log(e)
    var that = this
    let index = e.currentTarget.dataset.index
    let device = that.data.devices[index]
    that.bleManage.connectDevice(function (res) {

    }, device)
  },
})
