//
//  URLConstant.h
//  QiDai
//
//  Created by 张汇丰 on 16/4/27.
//  Copyright © 2016年 张汇丰. All rights reserved.
//
//  网址大全

#ifndef URLConstant_h
#define URLConstant_h

#endif /* URLConstant_h */
//评价
#define kUrl_appstore(appid) [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appid]
//更新 --废弃
#define kUrl_updateapp(appid) [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@", appid]
//下载
#define kUrl_downloadapp(appid) [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/qi-dai/id%@?mt=8", appid]

#define HTTP_IP_PORT @"http://apqd.q7bike.com"

//#define HostAndPort @"http://qdap.q7bike.com/q7bike/mall" //--正式服  北京

//http://59.110.0.231/
//#define HostAndPort @"http://apqdtest-temp.q7bike.com/q7bike/mall" //--外网临时 c测试
//http://10.0.0.11:8085/
//#define HostAndPort @"http://10.0.0.102:8083/q7bike/mall"   // 内网 测试服务器 windows

//http://10.0.0.11:8085/
//#define HostAndPort @"http://10.0.0.11:8085/q7bike/mall"   //测试服务器 windows

//http://192.168.1.114:8083/
//#define HostAndPort @"http://192.168.1.32:8083/q7bike/mall"  //内网服务器

//http://apqdtest-temp.q7bike.com

#define HostAndPort @"http://101.201.120.189:8080/q7bike/mall"   //北京测试服务器  linux

//#define kUserId [[LoginManager instance] getUserId]


// 更新
#define QDDEBUG false  //true
// 选择服务器
#define QDChoiceSevice true//false

#define QDDEBUGGOODSDETAIL true //true//

#define NewIP @"NewIp"

#define NEWHostAndPort  [[NSUserDefaults standardUserDefaults] objectForKey:NewIP]

#define ConvertUrl(relativeUrl) [NSString stringWithFormat:@"%@%@", HostAndPort, relativeUrl]

#define kUrl_login            ConvertUrl(@"/login")           // 手机号登录
#define kUrl_sendCode         ConvertUrl(@"/sendMobileCode")  // 发送验证码
#define kUrl_addUser          ConvertUrl(@"/addUser")         // 注册新用户
#define kUrl_getUserInfo      ConvertUrl(@"/getUserInfo")     // 获取用户信息
#define kUrl_openLogin        ConvertUrl(@"/openLogin")       // 第三方平台登录
#define kUrl_resetPassword    ConvertUrl(@"/resetPassword")   // 重置密码

#define kUrl_qqGetMyInfo          ConvertUrl(@"/qqGetMyInfo")         //获得用户信息
//getUserInfo
#define kUrl_getUserInfo          ConvertUrl(@"/getUserInfo")         // 获得用户信息
#define kUrl_updUser          ConvertUrl(@"/updUser")         // 修改用户信息
#define kUrl_addFeedback      ConvertUrl(@"/addFeedback")     // 提交意见反馈
#define kUrl_getAboutUs       ConvertUrl(@"/getAboutUs")      // 获取关于我们文案
#define kUrl_updUsersPwd      ConvertUrl(@"/updUsersPwd")     // 修改登录密码
#define kUrl_forUpload              ConvertUrl(@"/forUpload")       // 上传图片
#define kUrl_checkPhoto              ConvertUrl(@"/checkPhoto")  //判断服务器是否存在图片
#define kUrl_uploadPhoto              ConvertUrl(@"/uploadAllPhoto") //运动结束上传多张图片
#define kUrl_addRidingRecord        ConvertUrl(@"/addAllRidingRecord") // 骑行数据上报
#define kUrl_loadRidingRecord       ConvertUrl(@"/queryByDate")   // 查询骑行数据
#define kUrl_forRidingRecord        ConvertUrl(@"/forUpload") //长传运动详细数据
#define kUrl_downloadDetailRecord   ConvertUrl(@"/downloadDetail")  //下载详细数据
#define kUrl_getAllRidingRecord     ConvertUrl(@"/getRidingRecord")  //获取运动总数据
#define kUrl_getRankingData     ConvertUrl(@"/getRankings")
#define kUrl_checkUpdAppVersion ConvertUrl(@"/checkUpdAppVersion") //检查app版本更新
#define kUrl_scanJoinTask ConvertUrl(@"/task/scanJoinTask") //二维码扫描

#pragma -mark- --发现 --弃用
#define kUrl_getFindData     ConvertUrl(@"/getTask")  //获取发现数据
#define kUrl_getBikeRefund    ConvertUrl(@"/getTaskDetail") //获取车的退款
#define kUrl_getJoinTask    ConvertUrl(@"/joinTask") //加入活动
#define kUrl_getMyTask    ConvertUrl(@"/getMyTask") //获取加入后的数据
#define kUrl_getPrize    ConvertUrl(@"/getPrize") //兑奖
#define kUrl_getArea    ConvertUrl(@"/getArea") //发现_选择区域

#pragma -mark -new发现 --弃用

// 筛选接口 参数是area = 城市
#define kUrl_getSearchOption     ConvertUrl(@"/getSearchOption")

// 搜索接口 参数 (String area,String lng,String lat,String itemId,String down,String up,String type)
#define kUrl_SearchItem  ConvertUrl(@"/SearchItem")

// 物品详情 参数 (String itemId,String type,String lng,String lat)
#define kUrl_getItemDetail  ConvertUrl(@"//qqGetItemDetail")

/** 获取商店 参数 (String lng,String lat,String taskDetailId)*/
#define kUrl_getShop  ConvertUrl(@"/getShop")
/** 这个接口在点击预定页面的 提交订单按钮是调用
 参数 (taskDetailId,color,shopId,userId,phone,shopCode) */
#define kUrl_orderItem  ConvertUrl(@"/orderItem")
#define kUrl_qqOrderItem  ConvertUrl(@"/qqOrderItem")
//(userId)
#define kUrl_getMyTasks  ConvertUrl(@"//qqGetMyTasks?")

//  (orderId,userId, shopCode, itemMark)
#define kUrl_joinDiscover  ConvertUrl(@"/joinDiscover")
#define kUrl_getMyTaskDetail  ConvertUrl(@"/getMyTaskDetail")  //  userTaskId

#pragma -mark --任务--
//点击任务的任务详情,参数都为uid
#define kUrl_TaskGetTaskDetail  ConvertUrl(@"/qqGetTaskDetail")
//点击任务，查看自己的排名，参数都为uid
#define kUrl_TaskGetTotalRank  ConvertUrl(@"/qqGetTotalRank")
#define kUrl_TaskGetMonthRank  ConvertUrl(@"/qqGetMonthRank")
#define kUrl_TaskGetWeekRank  ConvertUrl(@"/qqGetWeekRank")

#define kUrl_TaskGetMyTaskDetail  ConvertUrl(@"/qqGetMyTaskDetail")

#pragma -mark --存在
#define kUrl_existGetRace     ConvertUrl(@"/getRace")  //获取存在数据
#define kUrl_existCheckJoin     ConvertUrl(@"/checkJoin")  //点加入时判断
#define kUrl_existJoinRace     ConvertUrl(@"/joinRace") //加入
#define kUrl_existGetMyRace     ConvertUrl(@"/getMyRace") //获取自己的任务
#define kUrl_existGetRaceDetaile     ConvertUrl(@"/getRaceDetail") //记录排名列表
#define kUrl_existGetMyRaceDetaile     ConvertUrl(@"/getMyRaceDetail") //自己每天的详情记录

#pragma mark --- newHistory
//历史页面(String userId) month:按月份分组的信息 records:默认展开的最上边的月份的详细骑行记录
#define kUrl_historyGetHistory     ConvertUrl(@"/qqGetHistory")

//(String userId,String date)点击别的月份的时候调用这个接口,参数date用上个接口month返回的month字段 records:每月的详细骑行记录
#define kUrl_historyGetRecord     ConvertUrl(@"/qqGetRecord")

//记录详情页面(String ridingId)参数为上个接口的id返回一个record为骑行记录详细信息 还有一个photo,是照片
#define kUrl_historyGetRecordDetail     ConvertUrl(@"/qqGetRecordDetail")

#define kUrl_historyGetYearStatistics     ConvertUrl(@"/qqGetYearStatistics")//记录统计页面(String userId,String date) date可以为空,为空是默认调用当前年份的记录
#define kUrl_historyGetMonthStatistics     ConvertUrl(@"/qqGetMonthStatistics")  //记录统计页面(String userId,String date)




#pragma refresh  start 

// 任务页面 刷新  骑行页面  一致  都刷新

#define refreshTaskUpdateHomeAndRedingHome  @"refreshTaskUpdateHomeAndRedingHome"


#define refreshSportHomeForSportEndSaveData @"refreshSportHomeForSportEndSaveData"





#pragma refresh  end



#pragma -------------taskUpdate ---------start 


#define NOTIFICATION_GOODSDETAIL_TIME_CELL  @"NotificationGoodsDetailTimeCell"  // 商品详情 定时器

#define NOTIFICATION_ORDERLIST_TIME_CELL  @"NotificationOrderListTimeCell"  // 订单列表 定时器

#define NOTIFICATION_ORDERDETAIL_TIME_CELL  @"NotificationOrderDetailTimeCell"  // 订单列表 定时器

//http://localhost:8085/q7bike/mall/task/newIndex?
#define kNewUrl_taskHome            ConvertUrl(@"/task/newIndex")           // 任务首页
///task/detai
#define kNewUrl_taskDetail            ConvertUrl(@"/task/detail")           // 任务详情
//order/checkHaveOrder
#define kNewUrl_taskState            ConvertUrl(@"/order/checkHaveOrder")   // 检测是否有订单

/**
 *  取消订单
 *
 *
 */
#define kNewUrl_cancelOrderByOrderId            ConvertUrl(@"/order/cancelOrderByOrderId")



/**
 *  确认订单
 *
 *
 */
#define kNewUrl_confirmReceipt           ConvertUrl(@"/order/confirmReceipt")



typedef NS_ENUM(NSInteger, SegmentedControlTaskSelected) {
    //以下是枚举成员
    SegmentedControlTaskSelectedOngoing = 0,
    SegmentedControlTaskSelectedUnstart = 1,
    SegmentedControlTaskSelectedOver = 2
};


// 现在活动是三种玩法


typedef NS_ENUM(NSInteger,TaskCategory) {
    //以下是枚举成员
    TaskCategoryRegularActivity = 0,
    TaskCategoryDayByDayActivity,
    TaskCategoryAscendingActivity
};



/**
 *  订单 状态
 */
typedef NS_ENUM(NSInteger,OrderStatus) {
    OrderWaitPay = 0,     //待付款
    OrderHavePay,    //已支付
    OrderRefund,        //退款
    OrderWaitComment,   //待评论
    OrderHaveComment,   //已评论
    OrderAgreeRefund,   //同意退款
    OrderHaveRefund,   //已经退款
    OrderPrepareGood,   //备货中
    OrderNeedExtract,    //可提取
    OrderHaveExtract,   //已提取
    OrderHaveShipping,   //已发货
    OrderClose,  //交易关闭
    OrderPaySome,   //支付一部分
    OrderCancel,     //取消订单
    OrderTemporary // 临时订单
};



#pragma -------------taskUpdate ---------end




#pragma mark--------UmengStatistic  -----start

/**
 *  商城首页
 */
#define kShopHome @"Shop"
/**
 *  商品详情页
 */
#define kGoodsDetails @"GoodsDetails"
/**
 *  活动详情页
 */
#define kEventDetails @"EventDetails"
/**
 *  商品评价页
 */
#define kGoodsEvaluation @"GoodsEvaluation"
/**
 *  活动评价页
 */
#define kEventEvaluation @"EventEvaluation"
/**
 *  6. 订单确认页：OrderConfirmation
 */
#define kOrderConfirmation @"OrderConfirmation"
/**
*   7. 收货地址页：ReceiptAddress
*/
#define kReceiptAddress @"ReceiptAddress"
/**
 *   8. 支付中心：paymentCenter
 */
#define kPaymentCenter @"paymentCenter"
/**
 *  9. 支付成功页：PaymentSuccess
 */
#define kPaymentSuccess @"PaymentSuccess"
/**
 *   10. 类型页：Type
 */
#define kTypeHome @"Type"
/**
 *   11. 类型页-运动休闲：TypeSports
 */
#define kTypeSports @"TypeSports"
/**
 *   12. 类型页-城市通勤：TypeCity
 */
#define kTypeCity @"TypeCity"
/**
 *  13. 类型页-专业挑战：TypeChallenge
 */
#define kTypeChallenge @"TypeChallenge"
/**
 *  14. 类型页-智能骑行：TypeSmart
 */
#define kTypeSmart @"TypeSmart"
/**
 *   15. 品牌页：Brand
 */
#define kBrandHome @"Brand"
/**
 *   16. 品牌页-各个品牌页：BrandDetails
 */
#define kBrandDetails @"BrandDetails"
/**
 *   17. 活动页：Event
 */
#define kEventHome @"Event"
/**
 *  18. 活动页-100-499元奖金：EventLevel1
 */
#define kEventLevel1 @"EventLevel1"
/**
 *   19. 活动页-500-999元奖金：EventLevel2
 */
#define kEventLevel2 @"EventLevel2"
/**
 *   20. 活动页-1000-1999元奖金：EventLevel3
 */
#define kEventLevel3 @"EventLevel3"
/**
 *   21. 活动页-2000元以上：EventLevel4
 */
#define kEventLevel4 @"EventLevel4"
/**
 *   22. 搜索页：Search
 */
#define kSearchHome @"Search"


typedef  NS_ENUM(NSInteger ,QDCurrentPage)
{
    QDShopHomePage = 0,
    QDBrandHomePage,
    QDTypeHomePage,
    QDEventHomePage
    
    
};


typedef NS_ENUM(NSInteger ,QDShopShowCurrentPage)
{
    QDShopShowTypeSports,
    QDShopShowTypeCity,
    QDShopShowTypeChallenge,
    QDShopShowTypeSmart,
    QDShopShowEventLevel1,
    QDShopShowEventLevel2,
    QDShopShowEventLevel3,
    QDShopShowEventLevel4
    
};

#pragma mark--------UmengStatistic  -----end









#pragma mark --- 新任务
#define kUrl_getTask_index            ConvertUrl(@"/task/index")  //任务首页

#define kUrl_getDTRidingRecord            ConvertUrl(@"/getDTRidingRecord")  //骑行首页

#pragma mark --- 新商城
#define kUrl_banner            ConvertUrl(@"/banner")           // 商城的轮播图
#define kUrl_shop            ConvertUrl(@"/shop")               // 商城首页
#define kUrl_brand            ConvertUrl(@"/brand")             // 商城品牌
#define kUrl_orderBy            ConvertUrl(@"/orderBy")         //搜索
#define kUrl_hotsearch            ConvertUrl(@"/hotsearch")     //热门搜索标签
  
#define kUrl_checkOrder            ConvertUrl(@"/order/checkOrder")     //检测 活动是否冲突


#define kUrl_getGoodsAddress   ConvertUrl(@"/getGoodsAddress")     //查找用户所有的收货地址
#define kUrl_saveGoodsAddress            ConvertUrl(@"/saveGoodsAddress")   //保存收获地址
#define kUrl_deleteGoodsAddress            ConvertUrl(@"/delGoodsAddress")  //删除收获地址

#define kUrl_getComment            ConvertUrl(@"/getComment")     //获取评论
#define kUrl_saveComment            ConvertUrl(@"/saveComment")     //保存评论
#define kUrl_getCommonMessage            ConvertUrl(@"/getCommonMessage")     //查询商品的好中差评
#define kUrl_search           ConvertUrl(@"/search")     //查询商品的好中差评
//点击类型或者品牌的排序
#define kUrl_getMessageSearch            ConvertUrl(@"/getMessageSearch")     //综合排序
#define kUrl_getMessageSearchByPrice            ConvertUrl(@"/getMessageSearchByPrice")     //根据价格排序
//点击活动的排序
#define kUrl_getActivity            ConvertUrl(@"/getActivity")     //活动的综合排序
#define kUrl_getActivityBrderByPrice   ConvertUrl(@"/getActivityBrderByPrice")     //活动的价格排序
//商品详情的两个接口
#define kUrl_detail_index   ConvertUrl(@"/detail/index") // 商城首页的cell点击进入商品详情
#define kUrl_detail_activity  ConvertUrl(@"/detail/activity") // 商品详情选择完活动，然后请求
//商城首页点击更多车款---也叫热门商品
#define kUrl_getIndexDetail    ConvertUrl(@"/getIndexDetail") // 商城首页点击更多车款
#define kUrl_indexOrderByPrice     ConvertUrl(@"/indexOrderByPrice") // 热门价格排序
/**---订单页面---**/
#define kUrl_checkOrder            ConvertUrl(@"/order/checkOrder") 
#define kUrl_saveOrder            ConvertUrl(@"/order/saveOrder") // 点击立即购买
#define kUrl_getOrderByStatus  ConvertUrl(@"/order/getOrderByStatus")//根据订单状态获取订单记录
#define kUrl_getOrderById    ConvertUrl(@"/order/getOrderById") // 根据订单号获取某个订单
#define kUrl_cancelOrderByOrderId    ConvertUrl(@"/order/cancelOrderByOrderId") //取消订单和退款
//支付 ---payOrderNo
//
#define kUrl_payCallBack    ConvertUrl(@"/alipay/callback") //支付宝回调

#define kUrl_payWechat    ConvertUrl(@"/alipay/createWxPayPara") //微信回调 

#define kWeChatAPPID    @"wx35e1aa6c867f5356" //微信回调

#define kUrl_checkPaySuccess    ConvertUrl(@"/alipay/checkPaySuccess") // 判断支付是否成功 
#define kUrl_uploadComment    ConvertUrl(@"/uploadComment") //上传评论图片

/**
 *  支付宝参数
 */

#define kPayAliPayPartner   @"2088021186855969" //支付宝partner
#define kPayAliPaySeller   @"caiwu@7dbike.com" //支付宝帐号
#define kPayAliPayPrivateKey   @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAK3hasD6TmAflz4IeTava3PkoiV/fs61AgjTDh4LsqeZgtAyLYX/mmZpRyO2vHChJd3KEgBmy2nbopmPh2s9ijVBKuUiNJhM6apBBoRY9IFzlHxvXgKr2D87dXH38g3ckpHh4VyODpnPe580l+/JLuKnbpwIj86OphqnNe0ac6qTAgMBAAECgYAuUwPR7d27li8BA9jnTMzfz2Wzf8gU4fxsxW3Za1xpcmh7dyLRtEs6RYoCZcjGaOhhslgha0F+Llmfd7GoTHjpToNsYrhS+He/5WrieotX/qG/9nAN4c6deda8hiSqWDLBxYJJJEZ+YSIzs0o0ZwusaA50ac2Cu2Io8SIh+XC6IQJBAOKDdxoRAxTDxFY5+KUi/8Af2XcaL/00cw3tc0LT0G5OtvcpDU8rKpTsYy/CR8ytUWyYYSr836XwOwy1HWSW0r8CQQDEg/a1q0U2HTZ7nqAmVPWAo/yF5oI/fnL3kldP7qtEMrNxUSq6lUamSblUGWZIKU9BIP/rkA03lFJjgS0kuiEtAkA83y+GpcO6NNHyiimz1y/7pZN/Wl5DIXE58PHkp59/xU+OJE4bVHJhCxWso/0/l+Ql1t1l/AbuRRzZUWLQwWdpAkEAmGp5mOGjppr1vN+E+vX+C64kl333G2Ppq1bXXWmRcC2au5Lmfxx0VVjs4utoRyOzEqKTm5J4jdj+Jar05n1uaQJASi+SN7Y+gAi6pBIyEE4lK52pnlEdbMB+YKtUkIAOoFOgi3OMfPbKUTGQ8/pwE1YSayTWgUwLUjNCa6MCKU0FAg==" //支付宝私钥


