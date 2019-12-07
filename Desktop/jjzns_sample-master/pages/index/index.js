//index.js
import regeneratorRuntime from "../../utils/runtime.js"

//获取应用实例
const app = getApp()
const {
  handleOpenLock,
  handleDeleteLock,
  handleSearchLock,
  handleBindLock,
  handleInformLock,
  handleSyncLockTime,
  handleSyncLockData,
  handleReadCard,
  handleAddLockCardPassword,
  handleEditLockCardPassword,
  handleDeleteLockCardPassword
} = require("../../utils/jjzns.js");
var lock = require("../../datas/lock.js")
var card = require("../../datas/card.js")

Page({
  data: {
    curId: undefined,
    curMac: undefined,
    appid: '123456',
    appSecret: '1234567890123456',
  },

  onLoad: function() {
    this.dealToken()
  },

  async dealToken() {
    try {
      const kToken = await this.getToken();
      console.log('获取token', kToken)

      this.setData({
        token: kToken
      })
    } catch (e) {
      console.log(e)
    }
  },

  /* 获取token */
  getToken() {
    console.log('获取token')
    return new Promise((resolve, reject) => {
      wx.request({
        url: 'http://hotel.ke-er.com/api/netroom/auth.jsp?action=authorize',
        data: {
          appId: this.data.appid,
          appSecret: this.data.appSecret,
        },
        success: res => {
          console.log(res);
          if (res.data.code == 0) {
            console.log('获取token成功', res)
            resolve(res.data.data.token);
          } else {
            reject(new Error(res.data.data.msg));
          }
        },
        fail: err => {
          console.error('获取token失败', err)
          reject(err)
        }
      })
    })
  },

  getLockInfo: function() {
    return new Promise((resolve, reject) => {
      wx.request({
        url: 'http://hotel.ke-er.com/api/netroom/jjcontroller.jsp?action=getDoorLockInformation',
        header: {
          token: this.data.token,
        },
        data: {
          lockMac: this.data.curMac,
          lockId: this.data.curId,
        },
        success: res => {
          console.log(res)
          if (res.data.code == 0) {
            console.log('获取门锁信息成功')
            resolve(res.data.data)
          } else {
            wx.showToast({
              title: res.data.msg,
            })
            reject(new Error(res.data.msg));
          }
        },
        fail: function(res) {
          console.log(res)
          wx.showToast({
            title: '请求失败, 请检查网络设置',
          })
          reject(err)
        }
      })
    })
  },

  async openLock() {
    try {
      // 先从服务器获取锁对象
      var lock = await this.getLockInfo()
      console.log('lockInfo = ')
      console.log(lock)
      // var sendInfo = {
      //   'lockName': lock.lockName,
      //   'lockAlias': lock.lockName,
      //   'lockMac': lock.lockMac,
      //   'anyCode': lock.anyCode,
      //   'randomString': lock.randomString,
      //   'initialTimeString': lock.initialTimeString,
      //   'timezoneRawOffset': lock.timezoneRawOffset,
      //   'advertiseData': lock.advertiseData,
      // }
      handleOpenLock(lock, (response) => {
        console.log(response);
      })
    } catch (err) {
      console.log(err)
    }
  },

  deleteLock: function(e) {
    wx.showModal({
      title: "解绑",
      content: "解绑前请先拍亮锁面板！确认解绑吗？",
      showCancel: true,
      success: (res) => {
        if (res.confirm) {
          handleDeleteLock(lock, (response) => {
            console.log(response);
          });
        }
      }
    })

  },
  scanLocks: function() {
    var that = this
    wx.showModal({
      title: "搜索锁",
      content: "搜索前请先拍亮未绑定的锁面板！",
      showCancel: false,
      success: (res) => {
        if (res.confirm) {
          handleSearchLock((item) => {
            console.log(item);
            wx.showModal({
              title: "找到锁" + item.name,
              content: "确认绑定吗？",
              showCancel: true,
              success: (res) => {
                if (res.confirm) {
                  handleBindLock(item, () => {
                    console.log('绑定锁返回')
                    console.log(item);
                    var infoData = {
                      'lockName': item.lockName,
                      'lockAlias': item.lockName,
                      'lockMac': item.lockMac,
                      'anyCode': item.anyCode,//Math.ceil(Math.random() * 1000 + 1000),
                      'randomString': item.randomString,
                      'initialTimeString': item.initialTimeString,
                      'timezoneRawOffset': 28800, // 锁上的时间减去UTC时间的差值,以秒为单位
                      'advertiseData': item.advertiseData,
                    }
                    console.log(infoData)
                    wx.request({
                      url: 'http://hotel.ke-er.com/api/netroom/jjcontroller.jsp?action=boundDoorLock',
                      header: {
                        token: that.data.token,
                      },
                      data: {
                        'lockName': item.lockName,
                        'lockAlias': item.lockName,
                        'lockMac': item.lockMac,
                        'anyCode': item.anyCode,//Math.ceil(Math.random() * 1000 + 1000),
                        'randomString': item.randomString,
                        'initialTimeString': item.initialTimeString,
                        'timezoneRawOffset': 28800, // 锁上的时间减去UTC时间的差值,以秒为单位
                        'advertiseData': item.advertiseData,
                      },
                      success: function(res) {
                        console.log('上传信息返回')
                        console.log(res)
                        that.setData({
                          curId: res.data.data.lockId,
                          curMac: item.lockMac,
                        })
                      },
                      fail: err => {

                      }
                    })
                    handleInformLock(item, (response) => {
                      console.log('inform返回')
                      console.log(response);

                    });
                    item.binded = true;
                    lock = item;
                  });
                }
              }
            })

          }, false);
        }
      }
    })
  },
  syncTime: function() {
    handleSyncLockTime(lock, (response) => {
      console.log(response);
    })
  },
  syncData: function() {
    handleSyncLockData(lock, (response) => {
      console.log(response);
    })
  },
  addCard: function() {
    handleReadCard(lock, (response) => {
      console.log(response);
      var password = "1836748";
      handleAddLockCardPassword(lock, response.identifier, password, (addResponse) => {
        console.log(addResponse);

      });
    })
  },
  editCard: function() {
    var password = card.password;
    handleEditLockCardPassword(lock, card.identifier, password, (response) => {
      console.log(response);

    });
  },
  deleteCard: function() {
    handleDeleteLockCardPassword(lock, card.identifier, (response) => {
      console.log(response);

    });
  },

})