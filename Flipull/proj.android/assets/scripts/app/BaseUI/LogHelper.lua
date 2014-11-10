--
-- Author: yyj
-- Date: 2014-06-09 19:48:51
--
LogHelper =
{
	adb = 1,
	printRect = function(rect,preInfo)
		if not rect then echoInfo("rect == nil ") return end
		preInfo = preInfo or "rect"
		echoInfo("%s: (%d,%d,%d,%d)",preInfo,rect.origin.x,rect.origin.y,rect.size.width,rect.size.height)
	end,
	printSize = function(size,preInfo)
		if not size then echoInfo("size == nil ") return end
		preInfo = preInfo or "size"
		echoInfo("%s: (%d,%d)",preInfo,size.width,size.height)
	end,
	printPoint = function(size,preInfo)
		if not size then echoInfo("point == nil ") return end
		preInfo = preInfo or "point"
		echoInfo("%s: (%d,%d)",preInfo,size.x,size.y)
	end,
}