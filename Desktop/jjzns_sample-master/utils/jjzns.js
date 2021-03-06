'use strict';
var _extends = Object.assign || function(a) {
    for (var c, b = 1; b < arguments.length; b++)
      for (var d in c = arguments[b], c) Object.prototype.hasOwnProperty.call(c, d) && (a[d] = c[d]);
    return a
  },
  app = getApp();
var _Mathceil = Math.ceil;
Object.defineProperty(exports, '__esModule', {
  value: !0
});
app.globalData === void 0 && (app.globalData = {});
var isAndroid, data = {},
  globalData = app.globalData,
  AVAILABLE_DEVICE_NAME = 'Yun',
  BLUETOOTH_READ_SERVICE_ID = 'FF91',
  BLUETOOTH_WRITE_SERVICE_ID = 'FF92',
  BLUETOOTH_NOTIFY_SERVICE_ID = 'FF93',
  FRESH_CARD_TIME = 10,
  cardTimer, CONNECT_OUT_TIME = 30,
  getCurrentTime = function() {
    return parseInt(new Date().getTime() / 1e3)
  },
  timeToDate = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : !0,
      c = new Date(a),
      d = c.getFullYear(),
      e = c.getMonth() + 1,
      f = c.getDate(),
      g = c.getHours(),
      h = c.getMinutes(),
      j = c.getSeconds(),
      k = [d, e, f].map(formatNumber).join('-');
    return b ? k + ' ' + [g, h, j].map(formatNumber).join(':') : k
  },
  formatNumber = function(a) {
    return a = a.toString(), a[1] ? a : '0' + a
  },
  getDateTime = function() {
    var a = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : void 0,
      b = void 0;
    a ? b = new Date(a) : (b = new Date, a = b.getTime());
    var c = b.getFullYear(),
      d = b.getMonth() + 1,
      e = b.getDate(),
      f = b.getHours(),
      g = b.getMinutes(),
      h = b.getSeconds();
    return d = 10 > d ? '0' + d : d, e = 10 > e ? '0' + e : e, f = 10 > f ? '0' + f : f, g = 10 > g ? '0' + g : g, h = 10 > h ? '0' + h : h, {
      year: c,
      month: d,
      day: e,
      hour: f,
      minute: g,
      second: h,
      time: a
    }
  },
  getNextDay = function(a, b) {
    if (b++, 30 < b) a *= 1, -1 !== [1, 3, 5, 7, 8, 10, 12].indexOf(a) && (a++, b = 1);
    else if (28 < b && 2 == a) {
      var c = 0 == year % 400 && 0 != year % 100 || 0 == year % 400;
      c && (a++, b = 1)
    }
    return a = 10 > a ? '0' + 1 * a : a, b = 10 > b ? '0' + 1 * b : b, {
      nextMonth: a,
      nextDay: b
    }
  },
  timer, timeCountdown = function(a, b) {
    a--, 0 <= a ? (b(a), timer = setTimeout(function() {
      timeCountdown(a, b)
    }, 1e3)) : stopTimeCountdown()
  },
  stopTimeCountdown = function() {
    timer && clearTimeout(timer)
  },
  dateSeparatedDay = function(a, b) {
    return a = Date.parse(new Date(a)), b = Date.parse(new Date(b)), Math.abs(parseInt((a - b) / 1e3 / 3600 / 24))
  },
  outTime, settingOutTime = function(a, b) {
    outTime = setTimeout(function() {
      b(), clearOutTime()
    }, 1e3 * a)
  },
  clearOutTime = function() {
    outTime && clearTimeout(outTime)
  },
  message = function(a, b) {
    var c = 2 < arguments.length && arguments[2] !== void 0 && arguments[2],
      d = 3 < arguments.length && arguments[3] !== void 0 ? arguments[3] : '\u63D0\u793A';
    wx.showModal({
      title: d,
      content: a,
      showCancel: c,
      success: function success(e) {
        e.confirm && b && b()
      }
    })
  },
  info = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : 'success';
    wx.showToast({
      title: a,
      icon: b,
      success: function success() {
        var c = setTimeout(function() {
          wx.hideToast(), clearTimeout(c)
        }, 1e3)
      },
      mask: !0
    })
  },
  loading = function() {
    var a = 0 < arguments.length && arguments[0] !== void 0 ? arguments[0] : !0,
      b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : '\u6570\u636E\u52A0\u8F7D\u4E2D...',
      c = 2 < arguments.length && arguments[2] !== void 0 ? arguments[2] : !0;
    a ? wx.showLoading({
      title: b,
      mask: c
    }) : wx.hideLoading()
  },
  minLoginError = '\u5C0F\u7A0B\u5E8F\u767B\u5F55\u5931\u8D25\u8BF7\u91CD\u65B0\u6253\u5F00\u5FAE\u4FE1', // 小程序登录失败请重新打开微信
  input = '\u8BF7\u8F93\u5165',
  inputAccount = input + '\u8D26\u6237',
  inputPassword = input + '\u5BC6\u7801',
  inputOldPassword = input + '\u65E7\u5BC6\u7801',
  inputNewPassword = input + '\u65B0\u5BC6\u7801',
  newPasswordError = '\u4E24\u6B21\u8F93\u5165\u7684\u65B0\u5BC6\u7801\u4E0D\u4E00\u76F4\uFF0C\u8BF7\u91CD\u65B0\u8F93\u5165',
  inputRandomNumber = input + '\u968F\u673A\u6570',
  inputRandomNumberError = input + '4\u4F4D\u968F\u673A\u6570',
  inputLockAsName = input + '\u9501\u522B\u79F0',
  inputCardAsName = input + '\u5361\u522B\u79F0',
  inputMobile = input + '\u624B\u673A\u53F7\u7801',
  codeNotFound = '\u624B\u673A\u9A8C\u8BC1\u7801\u4E0D\u80FD\u4E3A\u7A7A',
  timeError = '\u5F00\u59CB\u65F6\u95F4\u5FC5\u987B\u5C0F\u4E8E\u7ED3\u675F\u65F6\u95F4',
  synchronizeDataString = '\u662F\u5426\u786E\u5B9A\u540C\u6B65\u6570\u636E?',
  synchronizeTimeString = '\u662F\u5426\u786E\u5B9A\u540C\u6B65\u65F6\u95F4?',
  notFoundLock = '\u6CA1\u6709\u627E\u5230\u9501',
  inputName = input + '\u540D\u79F0',
  inputAcceptAccount = input + '\u63A5\u6536\u8005\u7528\u6237\u540D',
  logoutLockString = '\u662F\u5426\u786E\u5B9A\u6CE8\u9500\u5F53\u524D\u8BBE\u5907?',
  authorizePhone = '\u8BF7\u6388\u6743\u624B\u673A\u53F7\u7801\u4FE1\u606F',
  systemError = '\u51FA\u9519\u4E86\uFF0C\u8BF7\u7A0D\u540E\u91CD\u8BD5!',
  androidPositionError = '\u9700\u8981\u6388\u6743\u5730\u5740\u624D\u80FD\u4F7F\u7528\u84DD\u7259',
  currentDeviceBind = '\u5F53\u524D\u8BBE\u5907\u5DF2\u7ECF\u88AB\u7ED1\u5B9A\u8FC7\u4E86\uFF0C\u8BF7\u91CD\u65B0\u9009\u62E9',
  connectionBluetoothIng = '\u84DD\u7259\u8FDE\u63A5\u4E2D...',
  connectionIng = '\u84DD\u7259\u672A\u8FDE\u63A5\u6210\u529F\uFF0C\u8BF7\u7A0D\u540E\u91CD\u8BD5...',
  lockBindIng = '\u6B63\u5728\u7ED1\u5B9A\u9501...',
  connectionBluetoothSuccess = '\u84DD\u7259\u8FDE\u63A5\u6210\u529F!',
  bindLockSuccess = '\u7ED1\u5B9A\u9501\u6210\u529F!',
  unLockSuccess = '\u89E3\u7ED1\u9501\u6210\u529F!',
  unLockFail = '\u89E3\u7ED1\u5931\u8D25!',
  notConnectionLock = '\u8BF7\u6253\u5F00\u84DD\u7259\u8BBE\u5907\u8FDE\u63A5\u9501!',
  lockStandbyStatus = '\u8BF7\u786E\u4FDD\u95E8\u9501\u9762\u677F\u4EAE\u7740!',
  unLockIng = '\u6CE8\u9500\u4E2D...',
  getElectricityIng = '\u83B7\u53D6\u7535\u91CF\u4E2D...',
  openLockIng = '\u5F00\u9501\u4E2D...',
  lockAddIng = '\u6DFB\u52A0\u4E2D...',
  openLockSuccess = '\u5F00\u9501\u6210\u529F...',
  logSynchronizeSuccess = '\u8BB0\u5F55\u540C\u6B65\u6210\u529F...',
  logSynchronizeFail = '\u8BB0\u5F55\u540C\u6B65\u5931\u8D25...',
  logSynchronizeIng = '\u8BB0\u5F55\u540C\u6B65\u4E2D...',
  timeSynchronizeSuccess = '\u65F6\u95F4\u540C\u6B65\u6210\u529F...',
  timeSynchronizeIng = '\u65F6\u95F4\u540C\u6B65\u4E2D...',
  addCardIng = '\u65B0\u589E\u5361\u7247\u4E2D,\u8BF7\u7A0D\u540E...',
  addCardSuccess = '\u65B0\u589E\u5361\u7247\u6210\u529F...',
  addCardFail = '\u65B0\u589E\u5361\u7247\u5931\u8D25...',
  editCardIng = '\u4FEE\u6539\u5361\u7247\u4E2D,\u8BF7\u7A0D\u540E...',
  editCardSuccess = '\u4FEE\u6539\u5361\u7247\u6210\u529F...',
  editCardFail = '\u4FEE\u6539\u5361\u7247\u5931\u8D25',
  deleteCardIng = '\u5220\u9664\u5361\u7247\u4E2D,\u8BF7\u7A0D\u540E...',
  deleteCardSuccess = '\u5220\u9664\u5361\u7247\u6210\u529F...',
  deleteCardFail = '\u5220\u9664\u5361\u7247\u5931\u8D25...',
  cardNumber = '\u5361\u7247\u6570\u91CF\u5DF2\u7ECF\u8FBE\u5230\u4E0A\u9650\u4E86',
  cardExist = '\u5361\u7247\u5DF2\u7ECF\u88AB\u6DFB\u52A0\u8FC7\u4E86',
  noFoundCard = '\u6CA1\u6709\u627E\u5230\u5361\u7247\u4FE1\u606F\uFF01',
  connectTimeOut = '\u84DD\u7259\u8FDE\u63A5\u8D85\u65F6',
  addCardSettingFail = '\u6DFB\u52A0\u5361\u914D\u7F6E\u5931\u8D25',
  openLockError = '\u5F00\u9501\u592A\u9891\u7E41\u4E86\uFF0C\u8BF7\u7A0D\u540E\u91CD\u8BD5!',
  opFrequencyError = '\u64CD\u4F5C\u592A\u9891\u7E41\u4E86\uFF0C\u8BF7\u7A0D\u540E\u91CD\u8BD5!',
  openLockTimeOut = '\u5F00\u9501\u5931\u8D25\uFF0C\u8BF7\u68C0\u67E5\u9501\u662F\u5426\u5728\u8EAB\u8FB9\uFF01',
  opLockTimeOut = '\u64CD\u4F5C\u5931\u8D25\uFF0C\u8BF7\u68C0\u67E5\u9501\u662F\u5426\u5728\u8EAB\u8FB9\uFF01',
  lockDeleteTips = '\u5220\u9664\u524D\u8BF7\u62CD\u4EAE\u95E8\u9501\u9762\u677F\uFF0C\u786E\u5B9A\u5220\u9664?',
  lockMoveTips = '\u786E\u5B9A\u8F6C\u79FB\u5F53\u524D\u9501?',
  keyAliasNull = '\u94A5\u5319\u522B\u79F0\u4E0D\u80FD\u4E3A\u7A7A\uFF01',
  keyAccountNull = '\u94A5\u5319\u53D1\u9001\u8D26\u6237\u4E0D\u80FD\u4E3A\u7A7A\uFF01',
  keySendSuccess = '\u94A5\u5319\u53D1\u9001\u6210\u529F',
  keyModifySuccess = '\u94A5\u5319\u4FEE\u6539\u6210\u529F',
  errorInfo = {
    10000: '\u672A\u5F00\u542F\u84DD\u7259\u8BBE\u5907', // 未开启蓝牙设备
    10001: '\u8BF7\u6253\u5F00\u84DD\u7259\u8BBE\u5907,\u8FDB\u884C\u9002\u914D', // // 请打开蓝牙设备,进行适配
    10002: '\u6CA1\u6709\u627E\u5230\u6307\u5B9A\u8BBE\u5907,Android\u8BF7\u5F00\u542F\u5B9A\u4F4D\u670D\u52A1', // 没有找到指定设备,Android请开启定位服务
    10003: '\u8FDE\u63A5\u5931\u8D25', // 连接失败
    10004: '\u6CA1\u6709\u627E\u5230\u6307\u5B9A\u670D\u52A1', // 没有找到指定服务
    10005: '\u6CA1\u6709\u627E\u5230\u6307\u5B9A\u7279\u5F81\u503C', // 没有找到指定特征值
    10006: '\u5F53\u524D\u8FDE\u63A5\u5DF2\u65AD\u5F00', // 当前连接已断开
    10007: '\u5F53\u524D\u7279\u5F81\u503C\u4E0D\u652F\u6301\u6B64\u64CD\u4F5C', // 当前特征值不支持此操作
    10008: '\u5176\u4F59\u6240\u6709\u7CFB\u7EDF\u4E0A\u62A5\u7684\u5F02\u5E38', // 其余所有系统上报的异常
    10009: 'Android \u7CFB\u7EDF\u7279\u6709\uFF0C\u7CFB\u7EDF\u7248\u672C\u4F4E\u4E8E 4.3 \u4E0D\u652F\u6301 BLE', // Android 系统特有，系统版本低于 4.3 不支持 BLE
    40001: '\u6682\u65F6\u65E0\u6CD5\u8FDE\u63A5\u6B64\u8BBE\u5907', // 暂时无法连接此设备
    40002: '\u8BBE\u5907\u5DF2\u7ECF\u88AB\u4ED6\u4EBA\u4F7F\u7528', // 设备已经被他人使用
    40003: '\u5F00\u9501\u5931\u8D25', // 开锁失败
    40004: '\u83B7\u53D6\u7535\u91CF\u5931\u8D25', // 获取电量失败
    40005: '\u5173\u9501\u5931\u8D25', // 关锁失败
    40006: '\u6570\u636E\u5F02\u5E38', // 数据异常
    40007: '\u8BBE\u5907\u5F02\u5E38\uFF0C\u8BF7\u7A0D\u540E\u91CD\u8BD5!' // 设备异常，请稍后重试!
  },
  getErrorInfo = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0,
      c = {};
    c.succeed = !1; // c.succeed = false;
    var d = errorInfo[a]; // 未知错误
    handleRestartError(), d || (d = '\u672A\u77E5\u9519\u8BEF'), c.reason = d, b && b(c)  // 
  },
  getDateLong = function(a, b) {
    var c = a + ' ' + b + ':00.0';
    return c = c.substring(0, 18), c = c.replace(/-/g, '/'), new Date(c).getTime()
  },
  ab2hex = function(a) {
    var b = Array.prototype.map.call(new Uint8Array(a), function(c) {
      return ('00' + c.toString(16)).slice(-2)
    });
    return b.join('')
  },
  decimalToBinary = function(a, b) {
    var c = new ArrayBuffer(b);
    if (0 < a.length) {
      var d = new DataView(c);
      a.map(function(e, f) {
        d.setInt8(f, a[f])
      })
    }
    return c
  },
  hexToDecimal = function(a) {
    var b = [];
    if (a && 0 < a.length)
      for (var c = a.length, d = 0; d < c; d++)
        if (1 == d % 2) {
          var e = a.substr(d - 1, 2);
          b.push(parseInt(e, 16))
        }
    return b
  },
  blueToothWriteValue = function(a) {
    var b = hexToDecimal(a);
    return decimalToBinary(b, _Mathceil(a.length / 2))
  },
  decimalToHex = function(a) {
    return parseInt(a, 16)
  },
  bccVerification = function(a) {
    for (var g, b = _Mathceil(a.length / 2), c = [], f = 0; f < b; f++) g = a.substr(2 * f, 2), c.push('0x' + g);
    var d = 0;
    c.map(function(f) {
      return d ^= f
    });
    var e = d.toString(16);
    return 1 == e.length && (e = '0' + e), e
  },
  userInputNumber = function(a) {
    var b = [];
    return a = parseInt(a).toString(16), 1 == a.length && b.push(0), 2 == a.length && b.push(0), 3 == a.length && b.push(0), b.push(a), b.join('')
  },
  initLockAction = function(a) {
    var b = [userInputNumber(a)],
      c = hexDate(),
      d = c.year,
      e = c.month,
      f = c.day,
      g = c.hour,
      h = c.minute,
      j = c.second,
      k = [];
    k.push(d), k.push(e), k.push(f), k.push(g), k.push(h), k.push(j);
    var l = k.join('');
    b.push(l);
    var m = b.join('');
    return b.push(bccVerification(m)), b.push('44'), {
      action: '41' + b.join(''),
      initialTimeString: l
    }
  },
  synchronizeTimeAction = function() {
    var a = [],
      b = hexDate(),
      c = b.year,
      d = b.month,
      e = b.day,
      f = b.hour,
      g = b.minute,
      h = b.second,
      j = b.time;
    a.push(c), a.push(d), a.push(e), a.push(f), a.push(g), a.push(h);
    var k = a.join('');
    return a.push(bccVerification(k)), a.push('44'), {
      action: '4a' + a.join(''),
      time: j
    }
  },
  randomPasswrodAction = function() {
    return '420144'
  },
  randomPasswrodSuccessAction = function() {
    return '431a44'
  },
  randomPasswrodFailAction = function() {
    return '431b44'
  },
  getBlueToothMacAction = function() {
    return '440244'
  },
  logSuccessAction = function() {
    return '4e0144'
  },
  hexDate = function() {
    var a = getDateTime(),
      b = a.year,
      c = a.month,
      d = a.day,
      e = a.hour,
      f = a.minute,
      g = a.second,
      h = a.time;
    return b = userInputNumber(b), c = parseInt(c).toString(16), 2 > c.length && (c = '0' + c), d = parseInt(d).toString(16), 2 > d.length && (d = '0' + d), e = parseInt(e).toString(16), 2 > e.length && (e = '0' + e), f = parseInt(f).toString(16), 2 > f.length && (f = '0' + f), g = parseInt(g).toString(16), 2 > g.length && (g = '0' + g), {
      year: b,
      month: c,
      day: d,
      hour: e,
      minute: f,
      second: g,
      time: h
    }
  },
  handleOpenLockAction = function(a, b) {
    var c = [userInputNumber(a), b.replace(/:/g, '')],
      d = hexDate(),
      e = d.year,
      f = d.month,
      g = d.day,
      h = d.hour,
      j = d.minute,
      k = d.second;
    c.push(e), c.push(f), c.push(g), c.push(h), c.push(j), c.push(k);
    var l = c.join('');
    return c.push(bccVerification(l)), c.push('44'), '46' + c.join('')
  },
  handleUnLockAction = function(a, b) {
    var c = [userInputNumber(a), b],
      d = c.join('');
    return c.push(bccVerification(d)), c.push('44'), '47' + c.join('')
  },
  handleRandomNumber = function() {
    return Math.floor(9e3 * Math.random()) + 1e3
  },
  getBlueToothElectricityAction = function() {
    return '480144'
  },
  openLockLogLengthAction = function() {
    return '4c0144'
  },
  logAction = function() {
    return '4d0144'
  },
  addCardApplyAction = function() {
    return '5101010144'
  },
  addCardSettingAction = function() {
    return '5001010144'
  },
  confirmAddCardAction = function(a, b) {
    b = parseInt(b).toString(16);
    for (var c = b.length, f = c; 8 > f; f++) b = '0' + b;
    var d = a + b,
      e = bccVerification(d);
    return '5105' + d + e + '44'
  },
  editCardAction = function(a, b) {
    b = parseInt(b).toString(16);
    for (var c = b.length, f = c; 8 > f; f++) b = '0' + b;
    var d = a + b,
      e = bccVerification(d);
    return '510a' + d + e + '44'
  },
  deleteCardAction = function(a) {
    var b = bccVerification(a);
    return '5107' + a + b + '44'
  },
  handleOpenLock = exports.handleOpenLock = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0,
      c = 2 < arguments.length && arguments[2] !== void 0 ? arguments[2] : void 0;
    a && a.lockMac && (data = a, confirmIsAndroid(), handleBluetoothOp(openLockIng, function(d) {
      return handleOpenConnection(d, b)
    }, b))
  },
  handleDeleteLock = exports.handleDeleteLock = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0,
      c = 2 < arguments.length && arguments[2] !== void 0 ? arguments[2] : void 0;
    a && a.lockMac && (data = a, confirmIsAndroid(), handleBluetoothOp(unLockIng, function(d) {
      return handleDeleteLockConnection(d, b)
    }, b))
  },
  handleSyncLockTime = exports.handleSyncLockTime = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0;
    a && a.lockMac && (data = a, confirmIsAndroid(), handleBluetoothOp(timeSynchronizeIng, function(c) {
      return handleSynchronizeTimeConnection(c, b)
    }, b))
  },
  handleSyncLockData = exports.handleSyncLockData = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0;
    a && a.lockMac && (data = a, confirmIsAndroid(), handleBluetoothOp(logSynchronizeIng, function(c) {
      return handleSynchronizeDataConnection(c, b)
    }, b))
  },
  handleReadCard = exports.handleReadCard = function(a, b) {
    if (a && a.lockMac) {
      data = a, confirmIsAndroid();
      handleBluetoothOp(void 0, function(d) {
        return handleReadCardConnection(d, b)
      }, b)
    }
  },
  handleReadCardConnection = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0;
    handleConnectionCurrentBluetooth(a, function(c) {
      var d = {},
        e = c.substr(0, 4);
      if ('5103' == e) {
        var f = c.substr(4, 10);
        d.succeed = !0, d.identifier = f, clearTimeout(globalData.currentTimer), b && b(d)
      } else if ('5102' == e) d.succeed = !1, d.reason = cardNumber, handleRestartError(), b && b(d), cardTimer && clearInterval(cardTimer), clearTimeout(globalData.currentTimer), handleCloseBLEConnection(a);
      else if ('5104' == e) d.succeed = !1, d.reason = cardExist, cardTimer && clearInterval(cardTimer), handleRestartError(), b && b(d), clearTimeout(globalData.currentTimer), handleCloseBLEConnection(a);
      else if ('5002' == e) {
        var f = c.substr(4, 2);
        '01' == f ? handleWriteAction(addCardApplyAction(), function() {
          return handleFreshCardTime(a)
        }) : (d.succeed = !1, d.reason = cardExist, handleRestartError(), b && b(d), cardTimer && clearInterval(cardTimer), clearTimeout(globalData.currentTimer), handleCloseBLEConnection(a))
      } else if ('5106' == e) {
        var f = c.substr(4, 4).toUpperCase();
        '4F4B' == f ? d.succeed = !0 : (d.succeed = !1, handleRestartError()), b && b(d), cardTimer && clearInterval(cardTimer), clearTimeout(globalData.currentTimer), handleCloseBLEConnection(a)
      }
    }, function() {
      handleWriteAction(addCardSettingAction())
    })
  },
  handleAddLockCardPassword = exports.handleAddLockCardPassword = function(a, b, c) {
    3 < arguments.length && arguments[3] !== void 0 ? arguments[3] : void 0;
    a && a.lockMac && (data = a, handleWriteAction(confirmAddCardAction(b, c)))
  },
  handleEditLockCardPassword = exports.handleEditLockCardPassword = function(a, b, c) {
    var d = 3 < arguments.length && arguments[3] !== void 0 ? arguments[3] : void 0;
    a && a.lockMac && (data = a, handleBluetoothOp(void 0, function(e) {
      return handleEditLockCardPasswordConnection(e, b, c, d)
    }, d))
  },
  handleDeleteLockCardPassword = exports.handleDeleteLockCardPassword = function(a, b) {
    var c = 2 < arguments.length && arguments[2] !== void 0 ? arguments[2] : void 0;
    a && a.lockMac && (data = a, handleBluetoothOp(void 0, function(d) {
      return handleDeleteLockCardPasswordConnection(d, b, c)
    }, c))
  },
  handleDeleteLockCardPasswordConnection = function(a, b) {
    var c = 2 < arguments.length && arguments[2] !== void 0 ? arguments[2] : void 0,
      d = {};
    handleConnectionCurrentBluetooth(a, function(e) {
      var f = e.substr(0, 4);
      if ('5108' == f) d.succeed = !1, d.reason = noFoundCard;
      else {
        var g = e.substr(4, 4).toUpperCase();
        '4F4B' == g ? d.succeed = !0 : (d.succeed = !1, d.reason = deleteCardFail)
      }
      handleRestartError(), c && c(d), clearTimeout(globalData.currentTimer), handleCloseBLEConnection(a)
    }, function() {
      return handleWriteAction(deleteCardAction(b))
    }, function() {
      handleCloseBLEConnection(a)
    })
  },
  handleEditLockCardPasswordConnection = function(a, b, c) {
    var d = 3 < arguments.length && arguments[3] !== void 0 ? arguments[3] : void 0;
    handleConnectionCurrentBluetooth(a, function(e) {
        var f = {},
          g = e.substr(0, 4);
        if ('5108' == g) f.succeed = !1, f.reason = noFoundCard;
        else {
          var h = e.substr(4, 4).toUpperCase();
          '4F4B' == h ? f.succeed = !0 : (f.succeed = !1, f.reason = editCardFail)
        }
        d && d(f), clearTimeout(globalData.currentTimer), handleCloseBLEConnection(a)
      }, function() {
        return handleWriteAction(editCardAction(b, c))
      }),
      function() {
        handleCloseBLEConnection(a)
      }
  },
  handleAddLockCardPasswordConnection = function(a, b, c) {
    var d = 3 < arguments.length && arguments[3] !== void 0 ? arguments[3] : void 0;
    handleConnectionCurrentBluetooth(a, function(e) {
      var f = {},
        g = e.substr(0, 4);
      if ('5103' == g) {
        var h = e.substr(4, 10);
        f.identifier = h, d && d(f), clearOutTime(), clearTimeout(globalData.currentTimer)
      } else if ('5102' == g) cardTimer && clearInterval(cardTimer), handleCloseBLEConnection(a);
      else if ('5104' == g) cardTimer && clearInterval(cardTimer), handleCloseBLEConnection(a);
      else if ('5002' == g) {
        cardTimer && clearInterval(cardTimer);
        var h = e.substr(4, 2);
        '01' == h ? handleWriteAction(addCardApplyAction(), function() {
          return handleFreshCardTime(a)
        }) : handleCloseBLEConnection(a)
      } else if ('5106' == g) {
        cardTimer && clearInterval(cardTimer);
        var h = e.substr(4, 4).toUpperCase();
        handleCloseBLEConnection(a), f.succeed = !('4F4B' != h), d && d(f), clearTimeout(globalData.currentTimer)
      }
    }, function() {
      handleWriteAction(confirmAddCardAction(b, c))
    })
  },
  handleFreshCardTime = function(a) {
    var b = FRESH_CARD_TIME;
    cardTimer = setInterval(function() {
      b--, 0 > b ? (wx.hideToast(), handleCloseBLEConnection(a), cardTimer && clearInterval(cardTimer)) : wx.showToast({
        icon: 'loading',
        title: '\u8BF7\u5728' + b + '\u79D2\u5185\u5728\u9501\u4E0A\u5237\u5361',
        mask: !0
      })
    }, 1e3)
  },
  handleSynchronizeDataConnection = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0,
      c = {},
      d = openLockLogLengthAction(),
      e = 0,
      g = '',
      h = data,
      j = h.lockId,
      k = h.advertiseData,
      l = 9;
    (!k || 18 > k.length) && (l = 4), handleConnectionCurrentBluetooth(a, function(m) {
      if ('4C' == m.substr(0, 2).toUpperCase() && '44' == m.substr(6, 2).toUpperCase()) {
        var q = hexToDecimal(m.substr(2, 4));
        0 == e && q.map(function(r) {
          e += parseInt(r)
        }), 0 < e ? handleWriteAction(logAction()) : (clearTimeout(globalData.currentTimer), info(logSynchronizeSuccess), c.succeed = !0, c.log = '', c.logLength = 0, b && b(c), handleCloseBLEConnection(a))
      } else if ('4F' == m.substr(0, 2).toUpperCase()) handleCloseBLEConnection(a), clearTimeout(globalData.currentTimer);
      else if (g += m, g.length >= 2 * l * e) {
        4 == l ? handleWriteAction(logSuccessAction()) : handleCloseBLEConnection(a);
        for (var o = '', p = 0; p < e; p++) 0 < p && (o += ','), o += g.substr(2 * (p * l), 2 * l);
        c.succeed = !0, c.log = o, c.logLength = e, loading(!1), clearTimeout(globalData.currentTimer), b && b(c)
      }
    }, function() {
      handleWriteAction(d)
    })
  },
  handleSynchronizeTimeConnection = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0,
      c = data,
      d = c.lockMac,
      e = synchronizeTimeAction(),
      f = e.action,
      g = e.time,
      h = {};
    handleConnectionCurrentBluetooth(a, function(j) {
      '4B' == j.substr(0, 2).toUpperCase() && (clearTimeout(globalData.currentTimer), info(timeSynchronizeSuccess), h.succeed = !0, b && b(h), handleCloseBLEConnection(a))
    }, function() {
      return handleWriteAction(f)
    })
  },
  handleDeleteLockConnection = function(a, b) {
    var c = data,
      d = c.lockMac,
      e = c.anyCode,
      f = c.initialTimeString,
      g = c.lockName,
      h = handleUnLockAction(e, f);
    handleConnectionCurrentBluetooth(a, function(j) {
      var k = {};
      if (h == j) {
        var l = data,
          m = l.lockId,
          o = l.deviceId;
        clearTimeout(globalData.currentTimer), info(unLockSuccess), k.succeed = !0, handleCloseBLEConnection(o), wx.removeStorageSync(d + '-deviceId')
      } else clearTimeout(globalData.currentTimer), k.succeed = !1, k.reason = unLockFail, info(unLockFail), handleCloseBLEConnection(a);
      b && b(k)
    }, function() {
      handleWriteAction(h)
    })
  },
  handleSearchBluetooth = function() {
    var a = 0 < arguments.length && arguments[0] !== void 0 ? arguments[0] : void 0,
      b = !1,
      d = data.advertiseData && 18 < data.advertiseData.length;
    handleSearchLock(function(e) {
      b || (b = !0, data.deviceId = e.deviceId, a && a(e.deviceId))
    }, void 0, data.lockName, d)
  },
  handleBluetoothOp = function(a, b) {
    var c = 2 < arguments.length && arguments[2] !== void 0 ? arguments[2] : void 0;
    confirmOpenBluetoothAdapter(function() {
      var d = globalData[data.lockName + '-endOpenLockTime'];
      if (d && 6 > getCurrentTime() - d) {
        var e = {};
        return e.succeed = !1, e.reason = opFrequencyError, void(c && c(e))
      }
      var f = data,
        g = f.lockMac,
        h = data.deviceId;
      if (a && loading(!0, a), !h) {
        var j = wx.getStorageSync(g + '-deviceId');
        j && (h = j)
      }
      if (!h && !0 === isAndroid) {
        var k = g.toUpperCase(),
          l = k.split(':');
        h = '';
        for (var m = 5; - 1 < m; m--) h += l[m], 0 < m && (h += ':')
      }
      if (h) {
        confirmOpenBluetoothAdapter(b(h));
        var o = setTimeout(function() {
          loading(!1), handleCloseBLEConnection(h);
          var p = {};
          p.succeed = !1, p.reason = opLockTimeOut, handleRestartError(), c && c(p), wx.removeStorageSync(data.lockMac + '-deviceId')
        }, 1e3 * CONNECT_OUT_TIME);
        globalData.currentTimer = o
      } else {
        handleSearchBluetooth(function(p) {
          return b(p)
        });
        var o = setTimeout(function() {
          loading(!1), handeStopBluetoothDevices(), handleCloseBLEConnection(h);
          var p = {};
          p.succeed = !1, p.reason = opLockTimeOut, handleRestartError(), c && c(p)
        }, 1e3 * CONNECT_OUT_TIME);
        globalData.currentTimer = o
      }
    })
  },
  handleOpenConnection = function(a, b) {
    var c = data,
      d = c.anyCode,
      e = c.lockMac,
      f = c.openIng,
      g = c.electricity,
      h = {};
    if (d && e && !f) {
      data.openIng = !0;
      var j = handleOpenLockAction(d, e);
      handleConnectionCurrentBluetooth(a, function(k) {
        var l = data,
          m = l.openLockAction,
          o = l.deviceId;
        if (m && m.toUpperCase() == k.toUpperCase()) {
          clearTimeout(globalData.currentTimer), h.succeed = !0, h.electricity = data.electricity[0], info(openLockSuccess), wx.setStorageSync(data.lockMac + '-deviceId', o);
          var p = getCurrentTime();
          data.openIng = !1, globalData[data.lockName + '-endOpenLockTime'] = p, handleCloseBLEConnection(o), h.succeed && b && b(h)
        }
        if ('49' === k.substr(0, 2)) {
          var p = hexToDecimal(k.substr(2, 2));
          data.electricity = p, handleWriteAction(m)
        }
      }, function() {
        if (data.openLockAction = j, data.deviceId = a, g) handleWriteAction(j);
        else {
          var k = getBlueToothElectricityAction();
          handleWriteAction(k)
        }
      })
    }
  },
  confirmIsAndroid = function() {
    isAndroid == void 0 && (wx.getSystemInfo({
      success: function success(a) {
        isAndroid = -1 < a.platform.indexOf('android')
      }
    }), confirmIsAndroid())
  },
  currentConnectionBluetooth, errorHandle, errorNumber = {
    actionMaxNumber: {},
    maxNumber: 2
  },
  handleEventRestart = function(a, b, c) {
    var d = 3 < arguments.length && arguments[3] !== void 0 ? arguments[3] : void 0,
      e = errorNumber.maxNumber,
      f = errorNumber.actionMaxNumber;
    if (f[a]) {
      var g = f[a] || 1;
      g > e ? (b.errCode && getErrorInfo(b.errCode, c), errorHandle && (errorHandle(d), clearTimeout(globalData.currentTimer), errorHandle = void 0), loading(!1)) : (g++, errorNumber.actionMaxNumber[a] = g, c())
    }
  },
  handleRestartError = function() {
    errorNumber.actionMaxNumber = {}
  },
  handleBlueToothAdapter = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : !0;
    wx.openBluetoothAdapter({
      success: function success(c) {
        'openBluetoothAdapter:ok' === c.errMsg ? a() : !0 === b && (c.errCode = 10001, handleEventRestart('adapter', c, function() {
          return handleBlueToothAdapter(a)
        }))
      },
      fail: function fail(c) {
        !0 === b && (c.errCode = 10001, handleEventRestart('adapter', c, function() {
          return handleBlueToothAdapter(a)
        }))
      }
    })
  },
  confirmOpenBluetoothAdapter = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : !0;
    wx.getBluetoothAdapterState({
      success: function success(c) {
        !0 === c.available ? a && a() : handleBlueToothAdapter(function() {
          return confirmOpenBluetoothAdapter(a)
        }, b)
      },
      fail: function fail(c) {
        1e4 === c.errCode ? handleBlueToothAdapter(function() {
          return confirmOpenBluetoothAdapter(a)
        }, b) : b && handleEventRestart('confirmBluetooth', c, function() {
          return confirmOpenBluetoothAdapter(a)
        })
      }
    })
  },
  handleBluetoothAdapterState = function(a) {
    wx.getBluetoothAdapterState({
      success: function success(b) {
        'getBluetoothAdapterState:ok' === b.errMsg ? a() : handleEventRestart('adapterState', b, function() {
          return handleBluetoothAdapterState(a)
        })
      },
      fail: function fail(b) {
        handleEventRestart('adapterState', b, function() {
          return handleBluetoothAdapterState(a)
        })
      }
    })
  },
  handleSearchBluetoothDevice = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : !0;
    !1 === b ? wx.startBluetoothDevicesDiscovery({
      success: function success(c) {
        'startBluetoothDevicesDiscovery:ok' === c.errMsg ? a() : handleEventRestart('searchBluetooth', c, function() {
          return handleSearchBluetoothDevice(a)
        })
      },
      fail: function fail(c) {
        handeStopBluetoothDevices(), handleEventRestart('searchBluetooth', c, function() {
          return handleSearchBluetoothDevice(a)
        })
      }
    }) : wx.startBluetoothDevicesDiscovery({
      services: [BLUETOOTH_READ_SERVICE_ID],
      success: function success(c) {
        'startBluetoothDevicesDiscovery:ok' === c.errMsg ? a() : handleEventRestart('searchBluetooth', c, function() {
          return handleSearchBluetoothDevice(a, b)
        })
      },
      fail: function fail(c) {
        handeStopBluetoothDevices(), handleEventRestart('searchBluetooth', c, function() {
          return handleSearchBluetoothDevice(a, b)
        })
      }
    })
  },
  handleDeviceMacAddress = function(a) {
    var b;
    if (a.advertisData) {
      var c = a.advertisData.slice(2, 8);
      b = Array.prototype.map.call(new Uint8Array(c), function(d) {
        return ('00' + d.toString(16)).slice(-2)
      }).join(':')
    }
    return b
  },
  handleGetBluetoothDevices = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0,
      c = 2 < arguments.length && arguments[2] !== void 0 ? arguments[2] : void 0,
      d = 3 < arguments.length && arguments[3] !== void 0 ? arguments[3] : AVAILABLE_DEVICE_NAME;
    wx.getBluetoothDevices({
      success: function success(e) {
        var f = e.devices,
          g = !1;
        f && f.map(function(h) {
          JSON.stringify(h);
          if (h && h.name && -1 < h.name.indexOf(d)) {
            var k = handleDeviceMacAddress(h);
            k && (handleAdvertise(h, b, k, a), g = !0)
          }
        }), wx.onBluetoothDeviceFound(function(h) {
          var j = h.devices[0],
            k = JSON.stringify(j);
          if (j && j.name && -1 < j.name.indexOf(d)) {
            var l = handleDeviceMacAddress(j);
            l && handleAdvertise(j, b, l, a)
          }
        })
      },
      fail: function fail() {
        getErrorInfo(40001, a)
      }
    })
  },
  handleAdvertise = function(a, b, c, d) {
    a.lockMac = c, a.lockName = a.localName;
    var e = Array.prototype.map.call(new Uint8Array(a.advertisData), function(f) {
      return ('00' + f.toString(16)).slice(-2)
    });
    9 === e.length ? a.byteCount = 1500 : 9 < e.length && '01' == e.slice(9, 10) && (a.byteCount = 100), a.advertiseData = e.join(''), a.binded = '00' != e.slice(8, 9), d && (b === void 0 ? d(a) : b === a.binded && d(a))
  },
  handleConnectionBluetooth = function(a, b) {
    handeStopBluetoothDevices(), wx.createBLEConnection({
      deviceId: a,
      success: function success(c) {
        'createBLEConnection:ok' === c.errMsg && (wx.onBLEConnectionStateChange(function(d) {
          !1 === d.connected && currentConnectionBluetooth && d.deviceId === a && handleEventRestart('connectionBluetooth', d, function() {
            return handleConnectionBluetooth(a, b)
          })
        }), b())
      },
      fail: function fail(c) {
        10003 === c.errCode && 'createBLEConnection:fail:connection fail status:133' === c.errMsg ? setTimeout(function() {
          handleEventRestart('connectionBluetooth', c, function() {
            return handleConnectionBluetooth(a, b)
          })
        }, 1e3) : handleEventRestart('connectionBluetooth', c, function() {
          return handleConnectionBluetooth(a, b)
        })
      }
    })
  },
  handleGetDeviceServices = function(a, b) {
    wx.getBLEDeviceServices({
      deviceId: a.deviceId,
      success: function success(c) {
        if ('getBLEDeviceServices:ok' === c.errMsg) {
          var d = c.services,
            e = !1;
          d && d.map(function(f) {
            f.isPrimary && -1 !== f.uuid.indexOf(BLUETOOTH_READ_SERVICE_ID) && (a.serviceId = f.uuid, b(a), e = !0)
          }), !1 == e && handleEventRestart('deviceServices', c, function() {
            return handleGetDeviceServices(a, b)
          })
        } else handleEventRestart('deviceServices', c, function() {
          return handleGetDeviceServices(a, b)
        })
      },
      fail: function fail(c) {
        handleEventRestart('deviceServices', c, function() {
          return handleGetDeviceServices(a, b)
        })
      }
    })
  },
  handleGetDeviceCharacteristics = function(a, b) {
    wx.getBLEDeviceCharacteristics({
      deviceId: a.deviceId,
      serviceId: a.serviceId,
      success: function success(c) {
        if ('getBLEDeviceCharacteristics:ok' === c.errMsg) {
          var d = c.characteristics;
          d && d.map(function(e) {
            e.properties && (-1 === e.uuid.indexOf(BLUETOOTH_NOTIFY_SERVICE_ID) ? -1 !== e.uuid.indexOf(BLUETOOTH_WRITE_SERVICE_ID) && (a.writeCharacteristicId = e.uuid) : a.notifyCharacteristicId = e.uuid)
          }), a.notifyCharacteristicId && a.writeCharacteristicId && b(a)
        } else handleEventRestart('deviceCharacteristics', c, function() {
          return handleGetDeviceCharacteristics(a, b)
        })
      },
      fail: function fail(c) {
        handleEventRestart('deviceCharacteristics', c, function() {
          return handleGetDeviceCharacteristics(a, b)
        })
      }
    })
  },
  handleListenDevice = function(a, b) {
    var c = a.deviceId,
      d = a.serviceId,
      e = a.notifyCharacteristicId;
    wx.notifyBLECharacteristicValueChange({
      deviceId: c,
      serviceId: d,
      characteristicId: e,
      state: !0,
      success: function success(f) {
        'notifyBLECharacteristicValueChange:ok' === f.errMsg ? b() : handleEventRestart('listenDevice', f, function() {
          return handleListenDevice(a, b)
        })
      },
      fail: function fail(f) {
        10008 === f.errCode ? settingOutTime(1, function() {
          b()
        }) : handleEventRestart('listenDevice', f, function() {
          return handleListenDevice(a, b)
        })
      }
    })
  },
  handleInitBluetooth = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0,
      c = 2 < arguments.length && arguments[2] !== void 0 ? arguments[2] : void 0,
      d = 3 < arguments.length && arguments[3] !== void 0 ? arguments[3] : AVAILABLE_DEVICE_NAME,
      e = 4 < arguments.length && arguments[4] !== void 0 ? arguments[4] : !0;
    confirmOpenBluetoothAdapter(function() {
      return handleSearchBluetoothDevice(function() {
        handleGetBluetoothDevices(function(f) {
          a(f)
        }, b, c, d)
      }, e)
    })
  },
  handleSearchLock = exports.handleSearchLock = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0,
      c = 2 < arguments.length && arguments[2] !== void 0 ? arguments[2] : AVAILABLE_DEVICE_NAME,
      d = 3 < arguments.length && arguments[3] !== void 0 ? arguments[3] : void 0,
      e = 4 < arguments.length && arguments[4] !== void 0 ? arguments[4] : !0;
    errorHandle = d, !1 === isAndroid ? handleInitBluetooth(a, b, d, c, e) : wx.getLocation({
      success: function success() {
        handleInitBluetooth(a, b, d, c, e)
      },
      fail: function fail() {
        var f = {};
        f.succeed = !1, f.reason = androidPositionError, handleRestartError(), clearTimeout(globalData.currentTimer)
      }
    })
  },
  handleBindLock = exports.handleBindLock = function(a, b) {
    var c = a.name,
      d = a.deviceId,
      e = a.byteCount;
    if (!0 === a.binded) {
      var f = {};
      return f.succeed = !1, f.reason = currentDeviceBind, void(b && b(f))
    }
    loading(!0, lockAddIng);
    var g = handleRandomNumber(),
      h = initLockAction(g),
      j = h.action,
      k = h.initialTimeString,
      l = '',
      m = !1;
    handleConnectionCurrentBluetooth(d, function(o) {
      if (j == o) handleWriteAction(randomPasswrodAction());
      else if (l.length < 2 * e && (l += o), l.length >= 2 * e && !m) {
        m = !0;
        for (var r, p = [], q = 0; q < e; q++) r = l.substr(2 * q, 2), p.push('0x' + r);
        a.randomString = p.join(','), a.anyCode = g, a.initialTimeString = k, b && b(a)
      }
    }, function() {
      handleWriteAction(j), settingOutTime(CONNECT_OUT_TIME, function() {
        var o = {};
        o.succeed = !1, o.reason = '绑定超时,请稍后重试', handleRestartError(), b && b(o), handleCloseBLEConnection(d)
      })
    }, function() {})
  },
  handleInformLock = exports.handleInformLock = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0;
    loading(!1);
    var c = {};
    handleWriteAction(randomPasswrodSuccessAction(), function() {
      handleCloseBLEConnection(a.deviceId), info(bindLockSuccess), c.succeed = !0, b && b(c), clearOutTime(), wx.setStorageSync(a.lockMac + '-deviceId', a.deviceId)
    })
  },
  handeStopBluetoothDevices = function() {
    wx.getBluetoothAdapterState({
      success: function success(a) {
        a.discovering && wx.stopBluetoothDevicesDiscovery()
      }
    })
  },
  handeClearBluetoothDevices = function() {
    wx.getBluetoothAdapterState({
      success: function success(a) {
        a.discovering && wx.stopBluetoothDevicesDiscovery({
          success: function success() {}
        }), a.available && wx.closeBluetoothAdapter()
      }
    })
  },
  handleConnectionCurrentBluetooth = function(a, b) {
    var c = 2 < arguments.length && arguments[2] !== void 0 ? arguments[2] : void 0,
      d = 3 < arguments.length && arguments[3] !== void 0 ? arguments[3] : void 0;
    errorHandle = d, handleConnectionBluetooth(a, function() {
      return handleGetDeviceServices({
        deviceId: a
      }, function(e) {
        e = _extends({}, e), handleGetDeviceCharacteristics(e, function(f) {
          f = _extends({}, f), currentConnectionBluetooth = JSON.stringify(f), handleListenDevice(f, function() {
            if (wx.onBLECharacteristicValueChange(function(g) {
                var h = ab2hex(g.value);
                b(h)
              }), c)
              if (!0 === isAndroid) var g = setTimeout(function() {
                c(f), clearTimeout(g)
              }, 500);
              else c(f)
          })
        })
      })
    })
  },
  handleWriteAction = function(a) {
    var b = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : void 0,
      c = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : void 0;
    if (errorHandle = c, !currentConnectionBluetooth) {
      var d = {};
      return d.succeed = !1, d.reason = '连接已断开，请稍后重试！', handleRestartError(), void(b && b(d))
    }
    var e = JSON.parse(currentConnectionBluetooth);
    if (e) {
      var f = blueToothWriteValue(a),
        g = e.deviceId,
        h = e.serviceId,
        j = e.writeCharacteristicId;
      wx.writeBLECharacteristicValue({
        deviceId: g,
        serviceId: h,
        characteristicId: j,
        value: f,
        success: function success(k) {
          'writeBLECharacteristicValue:ok' === k.errMsg ? b && b() : handleEventRestart('writeAction', k, function() {
            return handleWriteAction(a, b)
          })
        },
        fail: function fail(k) {
          10006 !== k.errCode && handleEventRestart('writeAction', k, function() {
            return handleWriteAction(a, b)
          })
        }
      })
    }
  },
  handleCloseBLEConnection = function(a) {
    var b = 1 < arguments.length && arguments[1] !== void 0 ? arguments[1] : void 0;
    currentConnectionBluetooth = void 0, a && wx.closeBLEConnection({
      deviceId: a
    }), b && b()
  };