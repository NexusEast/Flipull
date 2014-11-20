--
-- Author: Wayne Dimart
-- Date: 2014-02-18 15:52:42
--
 
require("app.Utitls.MiscTools")
  Resource =  {}


	Resource.Block = 
	{ 
		 MiscTools.parseResourceName("l.png"),
		 	MiscTools.parseResourceName("t.png"),
		 	MiscTools.parseResourceName("s.png"),
		 MiscTools.parseResourceName("c.png"),
		 MiscTools.parseResourceName("x.png"),
	}

	Resource.MainBoardLayer  =
	{
		line =  MiscTools.parseResourceName("b.png"),
	}


	Resource.Tip = {
		tipLine = MiscTools.parseResourceName("line.png","UI/Tip/"),
		tipBg = MiscTools.parseResourceName("tip_bg.png","UI/Tip/"),
		reddot = MiscTools.parseResourceName("reddot.png","UI/Tip/"),
	}

	Resource.LocalData = {
    	LocalSettingFile =  MiscTools.parseResourceName( "LocalSettingFile.dat","LocalData/"),
    	-- LocalEmailFile =  MiscTools.parseResourceName( "LocalEmailFile.dat","LocalData/"),
    	LocalAccountFile =  MiscTools.parseResourceName( "LocalAccountFile.dat","LocalData/"),
    	-- ChoosedHeroFile =  MiscTools.parseResourceName( "ChoosedHeroFile.dat","LocalData/"),
    	-- PackageFile =  MiscTools.parseResourceName( "PackageFile.dat","LocalData/"),
    	-- LevelsDataFile =  MiscTools.parseResourceName( "LevelsDataFile.dat","LocalData/"),
    	-- GuideDataFile =  MiscTools.parseResourceName( "GuideDataFile.dat","LocalData/"),
    	VipDescripFile = MiscTools.parseResourceName( "VipDescripFile.data","/"),
    	StoreWordsFile = MiscTools.parseResourceName( "StoreWords.data","/"),
    	taskGoFile = MiscTools.parseResourceName( "taskGoFile.data","/"),--日常任务前往按钮
    	PVPDataRecordTest = MiscTools.parseResourceName( "PVPDataRecordTest.dat","/"),
    	LastLoginTimeFile = MiscTools.parseResourceName("LastLoginTimeFile.dat","LocalData/"),
    	loginListFile=MiscTools.parseResourceName("loginListFile.dat","LocalData/"),
	}
