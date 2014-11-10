/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package com.cmge.summoner;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxHelper;

//import com.dataeye.DCAgent;
//import com.dataeye.DCConfigParams;
//import com.dataeye.DCReportMode;

import android.os.Bundle;








//package Common;
import java.io.*;

import android.content.res.AssetManager;
import android.util.Log;




public class Summoner extends Cocos2dxActivity {

	private void copyFileOrDir(String path) {
	    AssetManager assetManager = Cocos2dxHelper.getAssetManager();
	    String assets[] = null;
	    try {
	        assets = assetManager.list(path);
	        if (assets.length == 0) {
	            copyFile(path);
	        } else {
	            String fullPath = Cocos2dxHelper.getCocos2dxWritablePath() +"/" + path;
	            File dir = new File(fullPath);
	            if (!dir.exists())
	                dir.mkdir();
	            for (int i = 0; i < assets.length; ++i) {
	                copyFileOrDir(path + "/" + assets[i]);
	            }
	        }
	    } catch (IOException ex) {
	        Log.e("tag", "I/O Exception", ex);
	    }
	}

	private void copyFile(String filename) {
	    AssetManager assetManager = Cocos2dxHelper.getAssetManager();

	    InputStream in = null;
	    OutputStream out = null;
	    try {
	        in = assetManager.open(filename);
	        String newFileName = Cocos2dxHelper.getCocos2dxWritablePath() +"/"+ filename;
	        
	        Log.d("cocos2d newFileName=",newFileName);
	        
	        out = new FileOutputStream(newFileName);

	        byte[] buffer = new byte[1024];
	        int read;
	        while ((read = in.read(buffer)) != -1) {
	            out.write(buffer, 0, read);
	        }
	        in.close();
	        in = null;
	        out.flush();
	        out.close();
	        out = null;
	    } catch (Exception e) {
	        Log.e("tag", e.getMessage());
	    }

	}
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
//		DCAgent.setDebugMode(true);
//        DCAgent.setReportMode(DCReportMode.DC_AFTER_LOGIN);
		String fileDir = Cocos2dxHelper.getCocos2dxWritablePath()+"/res_phone";
		File hFile=new File(fileDir); 
		if (!hFile.exists() || !hFile.isDirectory())
		{
			copyFileOrDir("res_phone");
			Log.d("cocos2d  dir res_phone have exsited--->path=",fileDir);
		}
		else
		{
			Log.d("cocos2d  dir res_phone have exsited--->path=",fileDir);
		}
	}

    static {
    	System.loadLibrary("game");
    }

	@Override
	protected void onResume() {
		super.onResume();
//		DCAgent.onResume(this);
	}

	@Override
	protected void onPause() {
		super.onPause();
//		DCAgent.onPause(this);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
//		DCAgent.onKillProcessOrExit();
	}
    
    
}
