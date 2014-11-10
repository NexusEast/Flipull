--
-- Author: moon
-- Date: 2014-05-27 17:58:20
--
local Resource = require( "app.Misc.Resource" )
local SQLMethods = require("app.Utitls.SQLMethods")

 

--获取货币icon
--t 1金币 2钻石 3竞技场 4远征币
function getCurrencyIconSpriteByType(t)
	local iconFile  = nil
	if t == 0 then t = 1 end
	local iconFileTB = {Resource.mainScreenCoin,Resource.mainScreenGem,Resource.UI.Icons.PVPCoin,Resource.UI.Icons.WuJinCoin}
	if iconFileTB[t] == nil then return nil end
	local icon = display.newSprite(iconFileTB[t])
	return icon
end
--heroColor英雄品质,佣兵系统才用
--delStar 不显示星星用 wrl
function getHeroPhotoByID( id, beforeAdvance ,heroColor, delStar )
	local isBeforeAdvance = false
	if beforeAdvance ~= nil then
		isBeforeAdvance = beforeAdvance
	end

	-- local color, star = HerosData.getHeroQuality( id ) 
	local color = heroColor or HerosData.getHeroQuality( id ) 
	if isBeforeAdvance then
		color = color - 1	
	end
	
	local frameName = Resource.Frames.heroFrames[1]
	if color ~= nil then
		echoInfo( "!!!!!!!!!!!!!!   id:%d   and  color:%s !!!!!!!!!!!!!!!!!", id, color)
		frameName = Resource.Frames.heroFrames[tonumber(color)]--"UI/Frames/quality" .. color .. "_lv1.png" --.. star .. ".png"
	end
	local itemFrame = display.newSprite( frameName )

	local thisHero = HerosData.getHeroDataByID(id)
	-- --photo
	local photo  = display.newSprite(Resource.HerosView.emptyBG)
	if thisHero ~= nil and thisHero.Movie_Name ~= nil and thisHero.Movie_Name ~= "" then
 		-- "Heroes/".. thisHero.Movie_Name.."/Avatar.png"
 		local middlePath = "Heroes/"
 		if tonumber(id) >= 20000 then
 			middlePath = "Enemies/"
 		end
 		local photoPath = MiscTools.parseResourceName("Avatar.png",middlePath.. thisHero.Movie_Name.."/") 
 		-- echoInfo("photoPath:%s", photoPath)
 		if io.exists(photoPath) == true then
 			photo = display.newSprite( photoPath )
 		end
		
		-- if photo == nil then return itemFrame end
		-- photo:setScale( 0.8 )
	end

		itemFrame:setPosition( photo:getContentSize().width / 2 , photo:getContentSize().height / 2 )
		photo:addChild( itemFrame )

		if delStar == true then --屏幕星星
			
		elseif color ~= nil then
			for i = 1, color do
				local star = nil
				-- if i > color then
				-- 	star = display.newSprite( Resource.Strengthen.starEnable )
				-- else
					star = display.newSprite( Resource.Strengthen.star )
				-- end
				star:setPosition( star:getContentSize().width / 3, star:getContentSize().height / 2 * i )
				photo:addChild( star )
			end
		end

	return  photo
end

function getHeroPhotoByIDForPVP( id,level,color )
    return getHeroHeadAndLv(id,level,color)
end

--英雄榜英雄信息
function getHeroPhotoByIDForPVP_( id,level,beforeAdvance )
    local isBeforeAdvance = false
    if beforeAdvance ~= nil then
        isBeforeAdvance = beforeAdvance
    end

    -- local color, star = HerosData.getHeroQuality( id )
    local color = heroColor or HerosData.getHeroQuality( id )
    if isBeforeAdvance then
        color = color - 1
    end

    local frameName = Resource.Frames.heroFrames[1]
    if color ~= nil then
        echoInfo( "!!!!!!!!!!!!!!   id:%d   and  color:%s !!!!!!!!!!!!!!!!!", id, color)
        frameName = Resource.Frames.heroFrames[tonumber(color)]--"UI/Frames/quality" .. color .. "_lv1.png" --.. star .. ".png"
    end
    frameName = Resource.Arena.headBorder
    local itemFrame = display.newSprite( frameName )
    local thisHeroInfo = SQLMethods.getValues(
        {
            db = Resource.TestScene.dbMain,
            tbl = "tb_hero_info",
            cond = "Hero_Id=".. id,
        })
    local thisHero = thisHeroInfo[1]
    -- --photo
    local photo  = display.newSprite(Resource.HerosView.emptyBG)
    if thisHero ~= nil and thisHero.Movie_Name ~= nil and thisHero.Movie_Name ~= "" then
        -- "Heroes/".. thisHero.Movie_Name.."/Avatar.png"
        local middlePath = "Heroes/"
        if tonumber(id) >= 20000 then
            middlePath = "Enemies/"
        end
        local photoPath = MiscTools.parseResourceName("Avatar.png",middlePath.. thisHero.Movie_Name.."/")
        -- echoInfo("photoPath:%s", photoPath)
        if io.exists(photoPath) == true then
            photo = display.newSprite( photoPath )
        end

        -- if photo == nil then return itemFrame end
        -- photo:setScale( 0.8 )
    end

    itemFrame:setPosition( photo:getContentSize().width / 2 , photo:getContentSize().height / 2 )
    local sizePhoto = photo:getContentSize()
    local sizeItemFrame = itemFrame:getContentSize()
    itemFrame:setScale((sizePhoto.width+5)/sizeItemFrame.width)
    photo:addChild( itemFrame )


    local sprLevelBg  = display.newSprite(Resource.Arena.LevelBg)
    local sizeSprLevelBg = sprLevelBg:getContentSize()


    local lbLevel = baseUI.newTTFLabel({
        text =  tostring(level),
        x = sizeSprLevelBg.width/2,
        y = sizeSprLevelBg.height/2,
        align = ui.TEXT_ALIGN_CENTER,
        size = BaseFontSize.SIZE_TIP_DESCRIP,
        color = BaseFontColor.cc3_COLOR_TIP_TITLE_SMALL,
    })
    lbLevel:setPosition(sizeSprLevelBg.width/2,sizeSprLevelBg.height/2)
    sprLevelBg:addChild(lbLevel)
    sprLevelBg:setPosition(sizePhoto.width/2,6)
    photo:addChild(sprLevelBg)
    return  photo
end


--技能图标
function getSkillByID( id , isGray )
	local gray = false
	if isGray ~= nil and isGray then
		gray = isGray
	end
	local skillItem = display.newSprite( Resource.Frames.skillFrame )
	if gray then
		skillItem =	CCGraySprite:create( Resource.Frames.skillFrame )
	end

	if id ~= nil then 
		local photoPath = "skills/".. id ..".png"
		local photo = display.newSprite( photoPath )
		if gray then
			photo = CCGraySprite:create( photoPath )
		end

		if photo == nil then return skillItem end

		photo:setPosition( skillItem:getContentSize().width / 2 , skillItem:getContentSize().height / 2 )
		skillItem:addChild( photo )
	end
	return skillItem
end

--普通物品（道具）
--isGray 灰
--isSelected 选中状态
--showStar 星级（只有装备有)
--Stone = 1,
--Runes  = 2,   --符文
--Equip  = 3,	 -- 装备
--Scroll = 4,	 --卷轴
--Fragment = 5, --碎片
--ConsumeItem = 6, --消耗品
--Others = 7, --消耗品
function getItemSpriteByID( id, isSelected, isGray, showStar )
	id = tonumber( id )
	local color = 1
	local isgray = false
	if isGray ~= nil  then
		isgray = isGray
	end
	local isShowStar = true 
	if showStar ~= nil then
		isShowStar = showStar
	end
	if id == nil then
		return display.newSprite( Resource.Frames.itemFrame )
	end

	local idType = math.floor( id / 10000 )
	if id > 1000000 then --装备改了 多2位
		idType = ITEMTYPE.Equip
		-- echoInfo("equip id :%d", id)
	end
	local itemFrame = nil --display.newSprite( Resource.UIButton.btnItemFrame )
	local retNode = display.newNode()
	if idType == ITEMTYPE.Stone then
		if isgray then
			itemFrame = CCGraySprite:create( Resource.Frames.stoneFrame )
		else
			itemFrame = display.newSprite( Resource.Frames.stoneFrame )
		end
	elseif idType == ITEMTYPE.Equip then
		-- echoInfo("&&&&&&&&&&&&&&& idType == 3 &&&&&&&&&&&&&&&" )
		color = PackageData.getEquipColor( id )
	 	--local path = "UI/Frames/equip_quality".. color ..".png"
        local path = Resource.Frames.getChildByName(tostring("equip_quality"..color))
        --echoInfo("path=%s",tostring(path))
	 	if isgray then
	 		itemFrame = CCGraySprite:create( path )
	 	else
			itemFrame = display.newSprite( path )
        end
    elseif idType == ITEMTYPE.Fragment then
        local path = Resource.Frames.getChildByName(tostring("fragment_quality1"))--碎片没品质之分--美术多给图
        --echoInfo("path=%s",tostring(path))
        if isgray then
            itemFrame = CCGraySprite:create( path )
        else
            itemFrame = display.newSprite( path )
        end
	else
		if isgray then
			itemFrame = CCGraySprite:create( Resource.Frames.stoneFrame )
		else
			itemFrame = display.newSprite( Resource.Frames.itemFrame )
		end
	end
	if isSelected ~= nil and isSelected == true then


        local fileName = Resource.Frames.equipSelectFrame
        if idType == ITEMTYPE.Fragment then
            fileName = Resource.Frames.fragmentSelect
        elseif idType == ITEMTYPE.Stone then
            fileName = Resource.Frames.fragmentSelect
        end
        local sprBorderSelect = display.newSprite( fileName)
        local sizeItemFrame = itemFrame:getContentSize()
        sprBorderSelect:setPosition(sizeItemFrame.width/2,sizeItemFrame.height/2)
		itemFrame:addChild(sprBorderSelect)
	end
	if id ~= nil  then
		local starNum = nil
		if idType == ITEMTYPE.Equip then
			starNum = PackageData.getEquipStar( id )
			-- echoInfo("!!! starNum :%d   !!!!!!", starNum )
			id = math.floor( id / 100 )
		end
		--local photoPath = "items/".. id ..".png"
		-- echoInfo("getItemSpriteByID id = %s",id)
        local photoPath = Resource.Item(id)

		local photo = display.newSprite( photoPath )
		if photo == nil then return itemFrame end
		if isgray then
			photo = CCGraySprite:create( photoPath )
		end
		photo:setPosition( itemFrame:getContentSize().width / 2, itemFrame:getContentSize().height / 2 )
		if starNum ~= nil and isShowStar then
			for i = 1, g_starMax[color] do
				local star = nil
				if i > starNum then
					star = display.newSprite( Resource.Strengthen.starEnable )
				else
					star = display.newSprite( Resource.Strengthen.star )
				end
				star:setPosition( star:getContentSize().width / 3, star:getContentSize().height / 2 * i )
				photo:addChild( star )
			end
		end
		retNode:addChild(photo)
		-- itemFrame:addChild( photo )
	end
	--维尼到此一游
	retNode:setContentSize(itemFrame:getContentSize())
	retNode:setAnchorPoint(itemFrame:getAnchorPoint())
	itemFrame:setPosition(ccp(retNode:getContentSize().width/2, retNode:getContentSize().height/2))
	retNode:addChild(itemFrame)
	return retNode 
end

-- function getEquipSpriteByID( id, heroLevel )
-- 	local itemFrame = display.newSprite( Resource.UIButton.btnItemFrame )
-- 	if id ~= nil  then
-- 	 	local photoPath = "items/".. id ..".png"
-- 		local photo = display.newSprite( photoPath )
-- 		if photo == nil then return itemFrame end
-- 		photo:setPosition( itemFrame:getContentSize().width / 2, itemFrame:getContentSize().height / 2 )
-- 		itemFrame:addChild( photo )
-- 	end
-- 	return itemFrame 
-- end


function createHeroHead(id,level,bIgnoreBoder)
    local sprBase = display.newSprite()
    local fileBoder = Resource.Arena.headBorder
    sprBase:setContentSize(display.newSprite(fileBoder):getContentSize())

    local sprHero = display.newSprite(Resource.DirHeroHead .. tostring(id) .. ".png")
    local sizeSprBase = sprBase:getContentSize()
    local sizeSprHero = sprHero:getContentSize()
    sprHero:setPosition(sizeSprBase.width/2,sizeSprBase.height/2)
    sprHero:setScale((sizeSprBase.width-8)/sizeSprHero.width)
    sprBase:addChild(sprHero)

    local sizeSprHero = sprHero:getContentSize()

    if not bIgnoreBoder then
        local sprBorder = display.newScale9Sprite(Resource.Arena.headBorder) --Resource.PlayerInfo.photoFrame
        sprBorder:setPosition(sizeSprBase.width / 2, sizeSprBase.height / 2)
        sprBase:addChild(sprBorder)
    end

    if level then
        local sprLevelBg  = display.newSprite(Resource.Arena.LevelBg)
        local sizeSprLevelBg = sprLevelBg:getContentSize()
        local lbLevel = baseUI.newTTFLabel({
            text = tostring(level),
            x = sizeSprLevelBg.width / 2,
            y = sizeSprLevelBg.height / 2,
            align = ui.TEXT_ALIGN_CENTER,
            size = BaseFontSize.SIZE_TIP_DESCRIP,
            color = BaseFontColor.cc3_COLOR_TIP_TITLE_SMALL,
        })
        lbLevel:setPosition(sizeSprLevelBg.width / 2, sizeSprLevelBg.height / 2)
        sprLevelBg:addChild(lbLevel)
        sprLevelBg:setPosition(sizeSprBase.width/2,6)
        sprBase:addChild(sprLevelBg)
    end

    return sprBase
end