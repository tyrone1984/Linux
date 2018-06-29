/*
  字符串转数组
*/
function string2Buffer(str) {
  let arr = str2Bytes(str)
  return array2Buffer(arr)
}

/*
  字符串转整形数组
*/
function str2Bytes(str) {
  var len = str.length;
  if (len % 2 != 0) {
    return null;
  }
  var hexA = new Array();
  for (var i = 0; i < len; i += 2) {
    var s = str.substr(i, 2)
    var v = parseInt(s, 16)
    hexA.push(v);
  }

  return hexA;
}

/*
  数组转buffer
*/
function array2Buffer(arr) {
  let buffer = new ArrayBuffer(arr.length)
  let dataView = new DataView(buffer)
  for (let i = 0; i < arr.length; i++) {
    dataView.setUint8(i, arr[i])
  }

  return buffer
}

/*
  字节数组转十六进制字符串
*/
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

/*
  delay: 秒为单位,默认1.5s
*/
function showMention(msg, hidden, delay) {
  wx.showLoading({
    title: msg,
  })

  if (hidden == true) {
    if (delay == undefined) {
      delay = 1.5
    }
    setTimeout(function () {
      wx.hideLoading()
    }, delay * 1000)
  }
}

/*
  时间对象
*/
function nextDay() {
  var date = this.daySpanSinceDate(1, new Date())
  console.log('第二天时间 = ' + date.toLocaleString())
}

function previousDay() {
  var date = this.daySpanSinceDate(-1, new Date())
  console.log('前一天时间 = ' + date.toLocaleString())
}

function daySpanSinceDate(span, date) {
  var curDate = date
  var timeStamp = curDate.getTime() + 3600 * 24 * 1000 * span  // 第二天同一时间
  curDate.setTime(timeStamp)
  return curDate
}

module.exports = {
  showMention: showMention,
  nextDay: nextDay,
  previousDay: previousDay,
  daySpanSinceDate: daySpanSinceDate,
}

/*
console.log('当前时间_toLocaleString = ' + curDate.toLocaleString())
console.log('当前时间_toString = ' + curDate.toString())
console.log('当前时间_toTimeString = ' + curDate.toTimeString())
console.log('当前时间_toDateString = ' + curDate.toDateString())
console.log('当前时间_toUTCString = ' + curDate.toUTCString())
console.log('当前时间_toLocaleTimeString = ' + curDate.toLocaleTimeString())
console.log('当前时间_toLocaleDateString = ' + curDate.toLocaleDateString())

index.js? [sm]:41 当前时间_toLocaleString = 11/16/2017, 9:32:23 AM
index.js? [sm]:41 当前时间_toString = Thu Nov 16 2017 09:32:23 GMT+0800 (CST)
index.js? [sm]:42 当前时间_toTimeString = 09:32:23 GMT+0800 (CST)
index.js? [sm]:43 当前时间_toDateString = Thu Nov 16 2017
index.js? [sm]:44 当前时间_toUTCString = Thu, 16 Nov 2017 01:32:23 GMT
index.js? [sm]:45 当前时间_toLocaleTimeString = 9:32:23 AM
index.js? [sm]:46 当前时间_toLocaleDateString = 11/16/2017
*/



/* 快捷键

格式调整
　　Ctrl+S：保存文件

　　Ctrl+[， Ctrl+]：代码行缩进

　　Ctrl+Shift+[， Ctrl+Shift+]：折叠打开代码块

　　Ctrl+C Ctrl+V：复制粘贴，如果没有选中任何文字则复制粘贴一行

　　Shift+Alt+F：代码格式化

　　Alt+Up，Alt+Down：上下移动一行

　　Shift+Alt+Up，Shift+Alt+Down：向上向下复制一行

　　Ctrl+Shift+Enter：在当前行上方插入一行

光标相关

　　Ctrl+End：移动到文件结尾

　　Ctrl+Home：移动到文件开头

　　Ctrl+i：选中当前行

　　Shift+End：选择从光标到行尾

　　Shift+Home：选择从行首到光标处

　　Ctrl+Shift+L：选中所有匹配

　　Ctrl+D：选中匹配

　　Ctrl+U：光标回退
*/