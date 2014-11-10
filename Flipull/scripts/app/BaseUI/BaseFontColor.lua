--
-- Author: moon
-- Date: 2014-05-28 17:23:13
--
BaseFontColor = 
{
	green = ccc3( 58, 253, 13 ),
	greenDark = ccc3( 39, 120, 14 ),
	white = ccc3( 179,155,151 ),
	purWhite = ccc3( 200, 200,200 ),
	-- yellow = ccc3( 250,200, 50 ),
	yellow = ccc3( 248, 216, 117 ),
	dark = ccc3( 62, 39, 17),
	blue = ccc3( 15, 127, 222 ),
	red = ccc3( 222, 78, 15 ),

	cc3_COLOR_TIP_TITLE = ccc3(184, 184, 94),
	cc3_COLOR_TIP_CONTENT = ccc3(200, 179, 116),
	cc3_COLOR_TIP_TITLE_SMALL = ccc3(255, 253, 222),
	cc3_COLOR_ON_YELLOW_BG = ccc3(105, 74, 27),
	cc3_COLOR_TAB_LAYER_TITLE = ccc3(179, 163, 137),
	cc3_COLOR_PURPLE = ccc3(181, 33, 198),
	cc3_COLOR_ORANGE = ccc3(232, 78, 12),
	cc3_COLOR_GREEN = ccc3(86, 181, 53),
	cc3_COLOR_MAGIC_COMPOSE = ccc3(57, 57, 57),
    cc3_COLOR_REPORT_DEFAULT = ccc3(96, 86, 81),
	cc3_COLOR_SERVER_CHOOSE_YELLOW = ccc3(241, 195, 12),
	cc3_COLOR_SERVER_CHOOSE_GREEN = ccc3(12, 241, 28),

	--聊天界面专用
	cc3_COLOR_CHAT_TYPE = {
		ccc3(255,255,255),
		ccc3(121, 189, 35),
		ccc3(233, 114, 49)
	},
	cc3_COLOR_CHAT_TITLE = ccc3(228, 212, 177),
	cc3_COLOR_CHAT_WRITE = ccc3(113, 106, 82),
	cc3_COLOR_CHAT_TIME = ccc3(125, 119, 94),
	cc3_COLOR_CHAT_YELLOW = ccc3(238, 201, 95),
	cc3_COLOR_TYPE_1 = ccc3(40,255,11),
	cc3_COLOR_HERO_DETAIL = ccc3(147,109,60),

    --按钮字体颜色
    cc3_COLOR_BTN_SWITCH_STYLE1 = ccc3(158, 131, 114),--全部 好友
    cc3_COLOR_BTN_SWITCH_STYLE1_SELECTED = ccc3(240, 234, 136),
    cc3_COLOR_BTN_SWITCH_STYLE2 = ccc3(176, 79, 20),--全部 移动
    cc3_COLOR_BTN_SWITCH_STYLE2_SELECTED = ccc3(255, 255, 255),
    cc3_COLOR_BTN_STYLE1 = ccc3(212, 196, 145),--取消 确定
    cc3_COLOR_BTN_STYLE1_SELECTED = ccc3(251, 237, 194),
    cc3_COLOR_BTN_STYLE2 = ccc3(251, 237, 194),--技能升级 详细属性
    cc3_COLOR_BTN_STYLE2_SELECTED = ccc3(255, 255, 255),
    cc3_COLOR_BTN_STYLE3 = ccc3(237, 202, 152),--前往
    cc3_COLOR_BTN_STYLE3_SELECTED = ccc3(255, 237, 0),

    loseFont = ccc3( 247, 233, 204 ), --失败后字体提示
}

--字体大小规范
BaseFontSize = 
{
	SIZE_TIP_DESCRIP = 20,     --一般字体，例如tips文本，描述文字，头像名称，图标名称
	SIZE_TITLE = 22,           --标题；例如tips标题，描述文本的标题，带有描述文字的图标名称，任务名称，商城气泡
	SIZE_FUNC_TITLE = 24,      --功能模块弹框标题；游戏帮助分类标题，消耗的资源提示
	SIZE_HERO_DETAIL = 26,     --只使用在关卡详情标题；英雄详情的英雄昵称
	SIZE_TIP_SMALL = 18,       --只使用在小tips里
    SIZE_BTN = 26,             --普通按钮的字体大小
    SIZE_BTN_SWITCH_STYLE2 = 20,--设计为24--合成书里标签按钮的字体大小
}