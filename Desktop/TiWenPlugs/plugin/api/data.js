const BLEManage = require('BLEManage.js')
var bleManage = new BLEManage() 

function initBLESetting () {
  bleManage.initBLESetting()
}

function searchDevice(searchCallBack, prefix) {
  console.log('搜索设备')
  bleManage.searchDevice(searchCallBack, prefix)
}

function connectDevice(connCallBack, device) {
  bleManage.connectDevice(connCallBack, device)
}

function listenConnectState(connectStateCallBack) {
  bleManage.listenConnectState(connectStateCallBack)
}

function cancelBLEConnect(cancelConnectCallBack) {
  bleManage.cancelBLEConnect(cancelConnectCallBack)
}

module.exports = {
  initBLESetting: initBLESetting,
  searchDevice: searchDevice,
  connectDevice: connectDevice,
  listenConnectState: listenConnectState,
  cancelBLEConnect: cancelBLEConnect,
}