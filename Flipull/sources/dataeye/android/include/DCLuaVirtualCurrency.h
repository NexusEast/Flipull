/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:付费接口 
**************************************************/

#ifndef __DATAEYE_DCVIRTUALCURRENCY_H__
#define __DATAEYE_DCVIRTUALCURRENCY_H__
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
	static void onCharge(const char* orderId, const double currencyAmount, const char* currencyType, const char* paymentType);

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
	static void onChargeOnlySuccess(const double currencyAmount, const char* currencyType, const char* paymentType);
	
	/************************************************* 
	* Description: 付费接口，支付SDK付费成功回调时调用
	* orderId       : 订单ID
    * currencyAmount: 付费金额
	* currencyType  : 付费币种
	* paymentType   : 付费途径
	*************************************************/
	static void paymentSuccess(const char* orderId, const double currencyAmount, const char* currencyType, const char* paymentType);
};
#endif

