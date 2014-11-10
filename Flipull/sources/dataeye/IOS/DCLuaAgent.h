//
//  DCAgent.h
//  coco2d-sdk
//
//  Created by xqwang on 13-11-4.
//
//
#ifndef __DCAGENT_IOS_H__
#define __DCAGENT_IOS_H__
#include <map>
#include <string>
#include "cocos2d.h"
#include "DCAccountType.h"
#include "DCGender.h"
#include "DCTaskType.h"
#include "DCReportMode.h"

using namespace std;
using namespace cocos2d;

//SDK初始化接口
class DCLuaAgent
{
public:
	/************************************************* 
	* Description: 初始化接口
	* appId      : 游戏在DataEye平台上申请的ID
    * channelId  : 游戏所要发往的渠道ID	
	*************************************************/
    static void onStart(const char* appId, const char* channelId);
	
	/************************************************* 
	* Description: SDK调试模式，为true时SDK会将内部日志输出到XCODE中
	* mode       : 内部日志输出开关
	*************************************************/
    static void setDebugMode(bool mode);
	
	/************************************************* 
	* Description: SDK上报模式，值为DCReportMode中定义的枚举，
				   具体使用请参数接入文档，该接口需要在onStart前调用
	* mode       : 上报模式
	*************************************************/
    static void setReportMode(DCReportMode mode);
	
	/************************************************* 
	* Description: 游戏自定义版本号
	* version    : 游戏版本号
	*************************************************/
    static void setVersion(const char* version);
	
	/************************************************* 
	* Description: 自定义错误接口
	* title      : 错误名
    * error      : 错误内容，建议传入错误堆栈信息	
	*************************************************/
    static void reportError(const char* title, const char* content);
};

//玩家信息接口
class DCLuaAccount
{
public:
	/************************************************* 
	* Description: 玩家登陆，在DC_AFTER_LOGIN模式下使用
	* accountId  : 玩家账号ID，该参数请保证全局唯一   
	*************************************************/ 
    static void login(const char* accountId);
    
	/************************************************* 
	* Description: 玩家登出，在DC_AFTER_LOGIN模式下使用
	*************************************************/ 
    static void logout();

	/************************************************* 
	* Description: 设置玩家账号类型
	* accountType: 玩家账号类型，值为DCAccountType中的枚举   
	*************************************************/ 
    static void setAccountType(DCAccountType accountType);

	/************************************************* 
	* Description: 设置玩家等级
	* level      : 玩家账号等级   
	*************************************************/
    static void setLevel(int level);

	/************************************************* 
	* Description: 设置玩家性别
	* gender     : 玩家性别   
	*************************************************/ 
    static void setGender(DCGender gender);

	/************************************************* 
	* Description: 设置玩家年龄
	* age        : 玩家年龄   
	*************************************************/
    static void setAge(int age);

	/************************************************* 
	* Description: 设置玩家所在区服
	* gameServer : 玩家账号所在区服   
	*************************************************/
    static void setGameServer(const char* gameServer);
	
	/************************************************* 
	* Description: 给玩家打标签，用户SDK的后续推送功能
	* tag        : 玩家标签   
	*************************************************/
    static void tag(const char* tag);
	
	/************************************************* 
	* Description: 取消玩家标签，用户SDK的后续推送功能
	* tag        : 玩家标签   
	*************************************************/ 
    static void unTag(const char* tag);
};

//付费接口
class DCLuaVirtualCurrency
{
public:
	/************************************************* 
	* Description: 付费开始，玩家点击付费按钮时调用，与onChargeSuccess配合使用，该接口将已经废弃，建议使用paymentSuccess接口
	* orderId       : 订单ID
    * currencyAmount: 付费金额
	* currencyType  : 付费币种
	* paymentType   : 付费途径
	*************************************************/
    static void onCharge(const char* orderId, double currencyAmount, const char* currencyType, const char* paymentType);
    
	/************************************************* 
	* Description: 付费结束，支付SDK付费成功回调时调用，与onCharge配合使用，该接口将已经废弃，建议使用paymentSuccess接口
	* orderId    : 订单ID
	*************************************************/
    static void onChargeSuccess(const char* orderId);
    
	/************************************************* 
	* Description: 付费接口，支付SDK付费成功回调时调用，该接口将已经废弃，建议使用paymentSuccess接口
    * currencyAmount: 付费金额
	* currencyType  : 付费币种
	* paymentType   : 付费途径
	*************************************************/
    static void onChargeOnlySuccess(double currencyAmount, const char* currencyType, const char* paymentType);
	
	/************************************************* 
	* Description: 付费接口，支付SDK付费成功回调时调用
	* orderId       : 订单ID
    * currencyAmount: 付费金额
	* currencyType  : 付费币种
	* paymentType   : 付费途径
	*************************************************/
	static void paymentSuccess(const char* orderId, const double currencyAmount, const char* currencyType, const char* paymentType);
};

//道具接口
class DCLuaItem
{
public:
	/************************************************* 
	* Description: 购买道具
	* itemId    : 道具ID
    * itemType  : 道具类型
	* itemCount : 购买的道具数量
	* virtualCurrency:购买的道具的虚拟价值
	* currencyType:支付方式
	* consumePoint:消费点，如关卡内消费，可以为空
	*************************************************/
    static void buy(const char* itemId, const char* itemType, int itemCount, long long virtualCurrency, const char* currencyType, const char* consumePoint);
    
	/************************************************* 
	* Description: 获得道具
	* itemId    : 道具ID
    * itemType  : 道具类型
	* itemCount : 道具数量
	* reason    : 获得道具的原因
	*************************************************/
	static void get(const char* itemId, const char* itemType, int itemCount, const char* reason);
    
	/************************************************* 
	* Description: 消耗道具
	* itemId    : 道具ID
    * itemType  : 道具类型
	* itemCount : 道具数量
	* reason    : 消耗道具的原因
	*************************************************/
	static void consume(const char* itemId, const char* itemType, int itemCount, const char* reason);
};

//任务接口
class DCLuaTask
{
public:
	/************************************************* 
	* Description: 开始任务
	* taskId     : 任务ID
    * taskType   : 任务类型
	*************************************************/
    static void begin(const char* taskId, DCTaskType type);
	
	/************************************************* 
	* Description: 任务完成
	* taskId     : 任务ID
	*************************************************/
    static void complete(const char* taskId);
	
	/************************************************* 
	* Description: 任务失败
	* taskId     : 任务ID
    * reason     : 任务失败原因
	*************************************************/
    static void fail(const char* taskId, const char* reason);
};

//自定义事件
class DCLuaEvent
{
public:
	/************************************************* 
	* Description: 登陆前自定义事件，用户登陆之后该接口无效
	* eventId    : 事件ID
    * map        : 事件发生时关注的属性map
	* duration   : 事件发生时长
	*************************************************/
	static void onEventBeforeLogin(const char* eventId, map<string, string>* map, long long duration);
	
	/************************************************* 
	* Description: 事件计数
	* eventId    : 事件ID
    * count      : 事件发生次数
	*************************************************/
    static void onEventCount(const char* eventId, int count);
	
	/************************************************* 
	* Description: 事件发生
	* eventId    : 事件ID
	*************************************************/
    static void onEvent(const char* eventId);
	
	/************************************************* 
	* Description: 事件发生
	* eventId    : 事件ID
    * label      : 事件发生时关注的一个属性
	*************************************************/
    static void onEvent(const char* eventId, const char* label);
	
	/************************************************* 
	* Description: 事件发生
	* eventId    : 事件ID
    * label      : 事件发生时关注的多个属性map
	*************************************************/
    static void onEvent(const char* eventId, map<string, string>* map);
    
	/************************************************* 
	* Description: 时长事件发生
	* eventId    : 事件ID
    * duration   : 事件发生时长
	*************************************************/
    static void onEventDuration(const char* eventId, long long duration);
	
	/************************************************* 
	* Description: 时长事件发生
	* eventId    : 事件ID
	* label      : 事件发生时关注的单个属性
    * duration   : 事件发生时长
	*************************************************/
    static void onEventDuration(const char* eventId, const char* label, long long duration);
	
	/************************************************* 
	* Description: 时长事件发生
	* eventId    : 事件ID
	* map        : 事件发生时关注的多个属性
    * duration   : 事件发生时长
	*************************************************/
    static void onEventDuration(const char* eventId, map<string, string>* map, long long duration);
    
	/************************************************* 
	* Description: 过程性事件开始，与onEventEnd(eventId)配合使用
	* eventId    : 事件ID
	*************************************************/
    static void onEventBegin(const char* eventId);
	
	/************************************************* 
	* Description: 过程性事件开始，与onEventEnd(eventId)配合使用
	* eventId    : 事件ID
	* map        : 事件发生时关注的多个属性
	*************************************************/
    static void onEventBegin(const char* eventId, map<string, string>* map);
	
	/************************************************* 
	* Description: 过程性事件结束，与onEventBegin(eventId)或onEventBegin(eventId, map)配合使用
	* eventId    : 事件ID
	*************************************************/
    static void onEventEnd(const char* eventId);
    
	/************************************************* 
	* Description: 过程性事件开始，与onEventEnd(eventId, flag)配合使用
	* eventId    : 事件ID
	* map        : 事件发生时关注的多个属性
	* flag       : eventId的一个标识，与eventId共同决定一个事件，比如玩家升级事件，
	               eventId可以为玩家升级，flag则为玩家具体的等级
	*************************************************/
    static void onEventBegin(const char* eventId, map<string, string>* map, const char* flag);
	
	/************************************************* 
	* Description: 过程性事件结束，与onEventBegin(eventId, map, flag)配合使用
	* eventId    : 事件ID
	* flag       : eventId的一个标识，与eventId共同决定一个事件，比如玩家升级事件，
	               eventId可以为玩家升级，flag则为玩家具体的等级
	*************************************************/
    static void onEventEnd(const char* eventId, const char* flag);
};

//虚拟币接口
class DCLuaCoin
{
public:
	/************************************************* 
	* Description: 设置虚拟币总量
	* coinNum    : 虚拟币总量
    * coinType   : 虚拟币类型
	*************************************************/
    static void setCoinNum(long long total, const char* coinType);
	
	/************************************************* 
	* Description: 消耗虚拟币
	* id         : 消耗虚拟币时关注的属性，如消耗原因
    * coinType   : 虚拟币类型
	* lost       : 消耗虚拟币的数量
	* left       : 玩家剩余虚拟总量
	*************************************************/ 
    static void lost(const char* reason, const char* coinType, long long lost, long long left);
	
	/************************************************* 
	* Description: 消耗虚拟币
	* id         : 消耗虚拟币时关注的属性，如消耗原因
    * coinType   : 虚拟币类型
	* gain       : 消耗虚拟币的数量
	* left       : 玩家剩余虚拟总量
	*************************************************/
    static void gain(const char* reason, const char* coinType, long long gain, long long left);
};

#define DCCONFIGPARAMS_UPDATE_SUCCESS "DataeyeConfigParamsSuccess"

static void DCConfig_UpdateSuccess(const char* event);

//在线参数配置
class DCLuaConfigParams:public CCObject
{
public:
	/************************************************* 
	* Description: 在线参数更新接口
	*************************************************/
    static void update();
	
	/************************************************* 
	* Description: 获取String型参数
	* key        : 需要获取的参数的key值
    * defaultValue: 需要获取的参数的默认值
	*************************************************/
    static const char* getParameterString(const char* key, const char* defaultValue);
	
	/************************************************* 
	* Description: 获取int型参数
	* key        : 需要获取的参数的key值
    * defaultValue: 需要获取的参数的默认值
	*************************************************/
    static int getParameterInt(const char* key, int defaultValue);
	
	/************************************************* 
	* Description: 获取long long型参数
	* key        : 需要获取的参数的key值
    * defaultValue: 需要获取的参数的默认值
	*************************************************/
	static long long getParameterLong(const char* key, long long defaultValue);
	
	/************************************************* 
	* Description: 获取bool型参数
	* key        : 需要获取的参数的key值
    * defaultValue: 需要获取的参数的默认值
	*************************************************/
    static bool getParameterBool(const char* key, bool defaultValue);
};

//关卡接口
class DCLuaLevels
{
public:
	/************************************************* 
	* Description: 开始关卡
	* levelNumber: 关卡顺序号
    * levelId    : 关卡ID
	*************************************************/
	static void begin(int levelNumber, const char* levelId);
	
	/************************************************* 
	* Description: 成功完成关卡
    * levelId    : 关卡ID
	*************************************************/
	static void complete(const char* levelId);
	
	/************************************************* 
	* Description: 关卡失败，玩家关卡中退出游戏时，建议调用该接口
    * levelId    : 关卡ID
	* failPoint  : 失败原因
	*************************************************/
	static void fail(const char* levelId, const char* failPoint);
};

class DCLuaCardsGame
{
public:
    /**
     *  @brief 玩家房间完成一局游戏后调用
     *  @brief lostOrGainCoin    获得或者丢失的虚拟币数量（不能为零）
     *  @param taxCoin  完成一局游戏时系统需要回收的虚拟币数量（税收）
     *  @param leftCoin   玩家剩余的虚拟币总量
     */
    static void play(const char* roomId, const char* label, const char* coinType, long long lostOrGainCoin, long long taxCoin, long long leftCoin);
    
    /**
     *  @brief 玩家房间内丢失虚拟币时调用（完成一局游戏调用play接口后不必再调用该接口）
     *  @brief reason    虚拟币丢失原因
     *  @param lostCoin  丢失的虚拟币数量
     *  @param leftCoin   剩余的虚拟币数量
     */
    static void lost(const char* roomId, const char* reason, const char* coinType, long long lostCoin, long long leftCoin);
    
    /**
     *  @brief 玩家房间内获得虚拟币时调用（完成一局游戏调用play接口后不必再调用该接口）
     *  @param reason    虚拟币获得原因
     *  @param gainCoin   赢得的虚拟币数量
     *  @param leftCoin  剩余的虚拟币数量
     */
    static void gain(const char* roomId, const char* reason, const char* coinType, long long gainCoin, long long leftCoin);
};

#endif