var plugin = requirePlugin("myPlugin")

Page({
  onLoad: function () {
    plugin.initBLESetting()
  },

    // 搜索设备
  searchDevice: function () {
    console.log('search--')
    var that = this
    plugin.searchDevice(function (res) {
      console.log(res)
      if (res.length) {
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
    plugin.connectDevice(function (res) {

    }, device)
  },
})