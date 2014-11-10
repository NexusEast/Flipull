//
//  DCAgent.mm
//  coco2d-sdk
//
//  Created by xqwang on 13-11-4.
//
//

#import "DCLuaAgent.h"
#import "DEAgent.h"

void DCLuaAgent::onStart(const char* appId, const char* channelId)
{
    NSString* objcAppId = [NSString stringWithCString:appId encoding:NSUTF8StringEncoding];
    NSString* objcChannelId = [NSString stringWithCString:channelId encoding:NSUTF8StringEncoding];
    [DEAgent onStart:objcAppId withChannelId:objcChannelId];
}

void DCLuaAgent::setDebugMode(bool mode)
{
    [DEAgent setDebugMode:(BOOL)mode];
}

void DCLuaAgent::setReportMode(DCReportMode mode)
{
    [DEAgent setReportMode:mode];
}

void DCLuaAgent::setVersion(const char* version)
{
    NSString* objcVersion = [NSString stringWithCString:version encoding:NSUTF8StringEncoding];
    [DEAgent setVersion:objcVersion];
}

void DCLuaAgent::reportError(const char* title, const char* content)
{
    NSString* objcTitle = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
    NSString* objcContent = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
    [DEAgent reportError:objcTitle content:objcContent];
}

void DCLuaAccount::login(const char* accountId)
{
    NSString* objcAccountId = [NSString stringWithCString:accountId encoding:NSUTF8StringEncoding];
    [DEAccount login:objcAccountId];
}

void DCLuaAccount::logout()
{
    [DEAccount logout];
}

void DCLuaAccount::setAccountType(DCAccountType accountType)
{
    [DEAccount setAccountType:accountType];
}

void DCLuaAccount::setLevel(int level)
{
    [DEAccount setLevel:level];
}

void DCLuaAccount::setGender(DCGender gender)
{
    [DEAccount setGender:gender];
}

void DCLuaAccount::setAge(int age)
{
    [DEAccount setAge:age];
}

void DCLuaAccount::setGameServer(const char* gameServer)
{
    NSString* objcGameServer = [NSString stringWithCString:gameServer encoding:NSUTF8StringEncoding];
    [DEAccount setGameServer:objcGameServer];
}

void DCLuaAccount::tag(const char* tag)
{
    NSString* objcTag = [NSString stringWithCString:tag encoding:NSUTF8StringEncoding];
    [DEAccount tag:objcTag];
}

void DCLuaAccount::unTag(const char* tag)
{
    NSString* objcTag = [NSString stringWithCString:tag encoding:NSUTF8StringEncoding];
    [DEAccount unTag:objcTag];
}

void DCLuaVirtualCurrency::onCharge(const char *orderId, double currencyAmount, const char *currencyType, const char *paymentType)
{
    NSString* objcOrderId = [NSString stringWithCString:orderId encoding:NSUTF8StringEncoding];
    NSString* objcCurrencyType = [NSString stringWithCString:currencyType encoding:NSUTF8StringEncoding];
    NSString* objcPaymentType = [NSString stringWithCString:paymentType encoding:NSUTF8StringEncoding];
    
    [DEVirtualCurrency onCharge:objcOrderId currencyAmount:currencyAmount currencyType:objcCurrencyType paymentType:objcPaymentType];
}

void DCLuaVirtualCurrency::onChargeSuccess(const char *orderId)
{
    NSString* objcOrderId = [NSString stringWithCString:orderId encoding:NSUTF8StringEncoding];
    [DEVirtualCurrency onChargeSuccess:objcOrderId];
}

void DCLuaVirtualCurrency::onChargeOnlySuccess(double currencyAmount, const char* currencyType, const char* paymentType)
{
    NSString* objcCurrencyType = [NSString stringWithCString:currencyType encoding:NSUTF8StringEncoding];
    NSString* objcPaymentType = [NSString stringWithCString:paymentType encoding:NSUTF8StringEncoding];
    
    [DEVirtualCurrency onChargeOnlySuccess:currencyAmount currencyType:objcCurrencyType paymentType:objcPaymentType];
}

void DCLuaVirtualCurrency::paymentSuccess(const char* orderId, double currencyAmount, const char* currencyType, const char* paymentType)
{
	NSString* objcOrderId = [NSString stringWithCString:orderId encoding:NSUTF8StringEncoding];
    NSString* objcCurrencyType = [NSString stringWithCString:currencyType encoding:NSUTF8StringEncoding];
    NSString* objcPaymentType = [NSString stringWithCString:paymentType encoding:NSUTF8StringEncoding];
	
	[DEVirtualCurrency paymentSuccess:objcOrderId currencyAmount:currencyAmount currencyType:objcCurrencyType paymentType:objcPaymentType];
}

void DCLuaItem::buy(const char* itemId, const char* itemType, int itemCount, long long virtualCurrency, const char* currencyType, const char* consumePoint)
{
    NSString* objcItemId = [NSString stringWithCString:itemId encoding:NSUTF8StringEncoding];
    NSString* objcItemType = [NSString stringWithCString:itemType encoding:NSUTF8StringEncoding];
    NSString* objcCurrencyType = [NSString stringWithCString:currencyType encoding:NSUTF8StringEncoding];
    NSString* objcConsumePoint = [NSString stringWithCString:consumePoint encoding:NSUTF8StringEncoding];
    
    [DEItem buy:objcItemId type:objcItemType itemCount:itemCount virtualCurrency:virtualCurrency currencyType:objcCurrencyType consumePoint:objcConsumePoint];
}

void DCLuaItem::get(const char *itemId, const char *itemType, int itemCount, const char *reason)
{
    NSString* objcItemId = [NSString stringWithCString:itemId encoding:NSUTF8StringEncoding];
    NSString* objcItemType = [NSString stringWithCString:itemType encoding:NSUTF8StringEncoding];
    NSString* objcReason = [NSString stringWithCString:reason encoding:NSUTF8StringEncoding];
    
    [DEItem get:objcItemId type:objcItemType itemCount:itemCount reason:objcReason];
}

void DCLuaItem::consume(const char *itemId, const char *itemType, int itemCount, const char *reason)
{
    NSString* objcItemId = [NSString stringWithCString:itemId encoding:NSUTF8StringEncoding];
    NSString* objcItemType = [NSString stringWithCString:itemType encoding:NSUTF8StringEncoding];
    NSString* objcReason = [NSString stringWithCString:reason encoding:NSUTF8StringEncoding];
    
    [DEItem consume:objcItemId type:objcItemType itemCount:itemCount reason:objcReason];
}

void DCLuaTask::begin(const char *taskId, DCTaskType type)
{
    NSString* objcTaskId = [NSString stringWithCString:taskId encoding:NSUTF8StringEncoding];
    
    [DETask begin:objcTaskId taskType:type];
}

void DCLuaTask::complete(const char *taskId)
{
    NSString* objcTaskId = [NSString stringWithCString:taskId encoding:NSUTF8StringEncoding];
    
    [DETask complete:objcTaskId];
}

void DCLuaTask::fail(const char *taskId, const char *reason)
{
    NSString* objcTaskId = [NSString stringWithCString:taskId encoding:NSUTF8StringEncoding];
    NSString* objcReason = [NSString stringWithCString:reason encoding:NSUTF8StringEncoding];
    
    [DETask fail:objcTaskId reason:objcReason];
}

void DCLuaEvent::onEventBeforeLogin(const char* eventId, map<string, string>* map, long long duration)
{
	NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
	
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithCapacity:5];
    std::map<std::string, std::string>::iterator it;
    for (it = map->begin(); it != map->end(); ++it) {
        NSString* key = [NSString stringWithCString:it->first.c_str() encoding:NSUTF8StringEncoding];
        NSString* value = [NSString stringWithCString:it->second.c_str() encoding:NSUTF8StringEncoding];
        [dictionary setObject:value forKey:key];
    }
	
	[DEEvent onEventBeforeLogin:objcEventId dictionary:dictionary duration:duration];
}

void DCLuaEvent::onEvent(const char *eventId)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
    [DEEvent onEvent:objcEventId];
}

void DCLuaEvent::onEvent(const char* eventId, const char* label)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
    NSString* objcLabel = [NSString stringWithCString:label encoding:NSUTF8StringEncoding];
    [DEEvent onEvent:objcEventId label:objcLabel];
}

void DCLuaEvent::onEvent(const char *eventId, std::map<std::string, std::string>* map)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithCapacity:5];
    std::map<std::string, std::string>::iterator it;
    for (it = map->begin(); it != map->end(); ++it) {
        NSString* key = [NSString stringWithCString:it->first.c_str() encoding:NSUTF8StringEncoding];
        NSString* value = [NSString stringWithCString:it->second.c_str() encoding:NSUTF8StringEncoding];
        [dictionary setObject:value forKey:key];
    }
    
    [DEEvent onEvent:objcEventId dictionary:dictionary];
}

void DCLuaEvent::onEventCount(const char *eventId, int count)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
    [DEEvent onEventCount:objcEventId count:count];
}

void DCLuaEvent::onEventDuration(const char *eventId, long long duration)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
    [DEEvent onEventDuration:objcEventId duration:duration];
}

void DCLuaEvent::onEventDuration(const char *eventId, const char *label, long long duration)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
    NSString* objcLabel = [NSString stringWithCString:label encoding:NSUTF8StringEncoding];
    
    [DEEvent onEventDuration:objcEventId label:objcLabel duration:duration];
}

void DCLuaEvent::onEventDuration(const char *eventId, std::map<std::string, std::string> *map, long long duration)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding] ;
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithCapacity:5];
    std::map<std::string, std::string>::iterator it;
    for (it = map->begin(); it != map->end(); ++it) {
        NSString* key = [NSString stringWithCString:it->first.c_str() encoding:NSUTF8StringEncoding] ;
        NSString* value = [NSString stringWithCString:it->second.c_str() encoding:NSUTF8StringEncoding];
        [dictionary setObject:value forKey:key];
    }
    
    [DEEvent onEventDuration:objcEventId dictionary:dictionary duration:duration];
}

void DCLuaEvent::onEventBegin(const char *eventId)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
    
    [DEEvent onEventBegin:objcEventId];
}

void DCLuaEvent::onEventBegin(const char* eventId, std::map<std::string, std::string>* map)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithCapacity:5];
    std::map<std::string, std::string>::iterator it;
    for (it = map->begin(); it != map->end(); ++it) {
        NSString* key = [NSString stringWithCString:it->first.c_str() encoding:NSUTF8StringEncoding];
        NSString* value = [NSString stringWithCString:it->second.c_str() encoding:NSUTF8StringEncoding];
        [dictionary setObject:value forKey:key];
    }
    [DEEvent onEventBegin:objcEventId dictionary:dictionary];
}

void DCLuaEvent::onEventEnd(const char *eventId)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
    
    [DEEvent onEventEnd:objcEventId];
}

void DCLuaEvent::onEventBegin(const char *eventId, std::map<std::string, std::string> *map, const char *flag)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
    NSString* objFlag = [NSString stringWithCString:flag encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithCapacity:5];
    std::map<std::string, std::string>::iterator it;
    for (it = map->begin(); it != map->end(); ++it) {
        NSString* key = [NSString stringWithCString:it->first.c_str() encoding:NSUTF8StringEncoding];
        NSString* value = [NSString stringWithCString:it->second.c_str() encoding:NSUTF8StringEncoding];
        [dictionary setObject:value forKey:key];
    }
    [DEEvent onEventBegin:objcEventId dictionary:dictionary flag:objFlag];
}

void DCLuaEvent::onEventEnd(const char *eventId, const char *flag)
{
    NSString* objcEventId = [NSString stringWithCString:eventId encoding:NSUTF8StringEncoding];
    NSString* objFlag = [NSString stringWithCString:flag encoding:NSUTF8StringEncoding];
    
    [DEEvent onEventEnd:objcEventId flag:objFlag];
}

void DCLuaCoin::setCoinNum(long long total, const char* coinType)
{
    NSString* objcCoinType = [NSString stringWithCString:coinType encoding:NSUTF8StringEncoding];
    [DECoin setCoinNum:total coinType:objcCoinType];
}

void DCLuaCoin::lost(const char* reason, const char* coinType, long long lost, long long left)
{
    NSString* objcReason = [NSString stringWithCString:reason encoding:NSUTF8StringEncoding];
    NSString* objcCoinType = [NSString stringWithCString:coinType encoding:NSUTF8StringEncoding];
    [DECoin lost:objcReason coinType:objcCoinType lostCoin:lost leftCoin:left];
}

void DCLuaCoin::gain(const char* reason, const char* coinType, long long gain, long long left)
{
    NSString* objcReason = [NSString stringWithCString:reason encoding:NSUTF8StringEncoding];
    NSString* objcCoinType = [NSString stringWithCString:coinType encoding:NSUTF8StringEncoding];
    [DECoin gain:objcReason coinType:objcCoinType gainCoin:gain leftCoin:left];
}

void DCLuaConfigParams::update()
{
    DEConfigParams* config = [[DEConfigParams alloc] init];
    [config setCallBack:DCConfig_UpdateSuccess];
    [config update];
}

static void DCConfig_UpdateSuccess(const char* event)
{
    if(strcmp(event, DCCONFIGPARAMS_UPDATE_SUCCESS) == 0)
    {
        CCNotificationCenter::sharedNotificationCenter()->postNotification(DCCONFIGPARAMS_UPDATE_SUCCESS);
    }
}

const char* DCLuaConfigParams::getParameterString(const char *key, const char *defaultValue)
{
    NSString* objcKey = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
    NSString* objcValue = [NSString stringWithCString:defaultValue encoding:NSUTF8StringEncoding];
    NSString* objcResult = [DEConfigParams getParameterString:objcKey defaults:objcValue];
    return [objcResult UTF8String];
}

int DCLuaConfigParams::getParameterInt(const char *key, int defaultValue)
{
    NSString* objcKey = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
    return [DEConfigParams getParameterInt:objcKey defaults:defaultValue];
}

long long DCLuaConfigParams::getParameterLong(const char *key, long long defaultValue)
{
    NSString* objcKey = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
    return [DEConfigParams getParameterLong:objcKey defaults:defaultValue];
}

bool DCLuaConfigParams::getParameterBool(const char *key, bool defaultValue)
{
    NSString* objcKey = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
    return [DEConfigParams getParameterBool:objcKey defaults:defaultValue];
}

void DCLuaLevels::begin(int levelNumber, const char* levelId)
{
    NSString* objcLevelId = [NSString stringWithCString:levelId encoding:NSUTF8StringEncoding];
    
    [DELevels begin:levelNumber levelId:objcLevelId];
}

void DCLuaLevels::complete(const char *levelId)
{
    NSString* objcLevelId = [NSString stringWithCString:levelId encoding:NSUTF8StringEncoding];
    
    [DELevels complete:objcLevelId];
}

void DCLuaLevels::fail(const char *levelId, const char *failPoint)
{
    NSString* objcLevelId = [NSString stringWithCString:levelId encoding:NSUTF8StringEncoding];
    NSString* objcFailPoint = [NSString stringWithCString:failPoint encoding:NSUTF8StringEncoding];
    
    [DELevels fail:objcLevelId failPoint:objcFailPoint];
}

void DCLuaCardsGame::play(const char* roomId, const char* label, const char* coinType, long long lostOrGainCoin, long long taxCoin, long long leftCoin)
{
    NSString* objcRoomId = [NSString stringWithCString:roomId encoding:NSUTF8StringEncoding];
    NSString* objcLabel = [NSString stringWithCString:label encoding:NSUTF8StringEncoding];
    NSString* objcCoinType = [NSString stringWithCString:coinType encoding:NSUTF8StringEncoding];
	
    [DECardsGame play:objcRoomId label:objcLabel coinType:objcCoinType lostOrGainCoin:lostOrGainCoin taxCoin:taxCoin leftCoin:leftCoin];
}

void DCLuaCardsGame::lost(const char* roomId, const char* reason, const char* coinType, long long lostCoin, long long leftCoin)
{
    NSString* objcRoomId = [NSString stringWithCString:roomId encoding:NSUTF8StringEncoding];
    NSString* objcReason = [NSString stringWithCString:reason encoding:NSUTF8StringEncoding];
	NSString* objcCoinType = [NSString stringWithCString:coinType encoding:NSUTF8StringEncoding];
    
    [DECardsGame lost:objcRoomId reason:objcReason coinType:objcCoinType lostCoin:lostCoin leftCoin:leftCoin];
}

void DCLuaCardsGame::gain(const char* roomId, const char* reason, const char* coinType, long long gainCoin, long long leftCoin)
{
    NSString* objcRoomId = [NSString stringWithCString:roomId encoding:NSUTF8StringEncoding];
    NSString* objcReason = [NSString stringWithCString:reason encoding:NSUTF8StringEncoding];
	NSString* objcCoinType = [NSString stringWithCString:coinType encoding:NSUTF8StringEncoding];
    
    [DECardsGame gain:objcRoomId reason:objcReason coinType:objcCoinType gainCoin:gainCoin leftCoin:leftCoin];
}



