var data = require('./api/data.js')

module.exports = {
  initBLESetting: data.initBLESetting,
  searchDevice: data.searchDevice,
  connectDevice: data.connectDevice,
  listenConnectState: data.listenConnectState,
  cancelBLEConnect: data.cancelBLEConnect,
}