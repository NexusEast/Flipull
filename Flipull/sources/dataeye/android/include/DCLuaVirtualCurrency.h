/************************************************* 
Copyright:DataEye 
Author: xqwang
Date:2014-09-24 
Description:���ѽӿ� 
**************************************************/

#ifndef __DATAEYE_DCVIRTUALCURRENCY_H__
#define __DATAEYE_DCVIRTUALCURRENCY_H__
class DCLuaVirtualCurrency
{
public:
	/************************************************* 
	* Description: ���ѿ�ʼ����ҵ�����Ѱ�ťʱ���ã���onChargeSuccess���ʹ�ã��ýӿڽ��Ѿ�����������ʹ��paymentSuccess�ӿ�
	* orderId       : ����ID
    * currencyAmount: ���ѽ��
	* currencyType  : ���ѱ���
	* paymentType   : ����;��
	*************************************************/
	static void onCharge(const char* orderId, const double currencyAmount, const char* currencyType, const char* paymentType);

	/************************************************* 
	* Description: ���ѽ�����֧��SDK���ѳɹ��ص�ʱ���ã���onCharge���ʹ�ã��ýӿڽ��Ѿ�����������ʹ��paymentSuccess�ӿ�
	* orderId    : ����ID
	*************************************************/
	static void onChargeSuccess(const char* orderId);
	
	/************************************************* 
	* Description: ���ѽӿڣ�֧��SDK���ѳɹ��ص�ʱ���ã��ýӿڽ��Ѿ�����������ʹ��paymentSuccess�ӿ�
    * currencyAmount: ���ѽ��
	* currencyType  : ���ѱ���
	* paymentType   : ����;��
	*************************************************/
	static void onChargeOnlySuccess(const double currencyAmount, const char* currencyType, const char* paymentType);
	
	/************************************************* 
	* Description: ���ѽӿڣ�֧��SDK���ѳɹ��ص�ʱ����
	* orderId       : ����ID
    * currencyAmount: ���ѽ��
	* currencyType  : ���ѱ���
	* paymentType   : ����;��
	*************************************************/
	static void paymentSuccess(const char* orderId, const double currencyAmount, const char* currencyType, const char* paymentType);
};
#endif

