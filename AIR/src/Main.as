package
{

import com.doitflash.consts.Direction;
import com.doitflash.consts.Orientation;
import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
import com.doitflash.starling.utils.list.List;
import com.doitflash.text.modules.MySprite;
import com.luaye.console.C;

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.InvokeEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import flash.utils.setTimeout;

import com.myflashlab.air.extensions.dependency.OverrideAir;
import com.myflashlab.air.extensions.onesignal.*;

/**
 * ...
 * @author Hadi Tavakoli - 1/6/2019 7:43 PM
 */
public class Main extends Sprite
{
	private const BTN_WIDTH:Number = 150;
	private const BTN_HEIGHT:Number = 60;
	private const BTN_SPACE:Number = 2;
	private var _txt:TextField;
	private var _body:Sprite;
	private var _list:List;
	private var _numRows:int = 1;
	
	public function Main()
	{
		Multitouch.inputMode = MultitouchInputMode.GESTURE;
		NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
		NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
		NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
		NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
		
		stage.addEventListener(Event.RESIZE, onResize);
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		C.startOnStage(this, "`");
		C.commandLine = false;
		C.commandLineAllowed = false;
		C.x = 20;
		C.width = 250;
		C.height = 150;
		C.strongRef = true;
		C.visible = true;
		C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
		
		_txt = new TextField();
		_txt.autoSize = TextFieldAutoSize.LEFT;
		_txt.antiAliasType = AntiAliasType.ADVANCED;
		_txt.multiline = true;
		_txt.wordWrap = true;
		_txt.embedFonts = false;
		_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>OneSignal ANE V" + OneSignal.VERSION + "</font>";
		_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
		this.addChild(_txt);
		
		_body = new Sprite();
		this.addChild(_body);
		
		_list = new List();
		_list.holder = _body;
		_list.itemsHolder = new Sprite();
		_list.orientation = Orientation.VERTICAL;
		_list.hDirection = Direction.LEFT_TO_RIGHT;
		_list.vDirection = Direction.TOP_TO_BOTTOM;
		_list.space = BTN_SPACE;
		
		init();
	}
	
	private function onInvoke(e:InvokeEvent):void
	{
		NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
	}
	
	private function handleActivate(e:Event):void
	{
		NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
	}
	
	private function handleDeactivate(e:Event):void
	{
		NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
	}
	
	private function handleKeys(e:KeyboardEvent):void
	{
		if(e.keyCode == Keyboard.BACK)
		{
			e.preventDefault();
			NativeApplication.nativeApplication.exit();
		}
	}
	
	private function onResize(e:* = null):void
	{
		if(_txt)
		{
			_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
			
			C.x = 0;
			C.y = _txt.y + _txt.height + 0;
			C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
			C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
		}
		
		if(_list)
		{
			_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
			_list.row = _numRows;
			_list.itemArrange();
		}
		
		if(_body)
		{
			_body.y = stage.stageHeight - _body.height;
		}
	}
	
	private function init():void
	{
		// Remove OverrideAir debugger in production builds
		OverrideAir.enableDebugger(function ($ane:String, $class:String, $msg:String):void
		{
			trace($ane + " (" + $class + ") " + $msg);
			C.log($ane + " (" + $class + ") " + $msg);
		});
		
		/*
			if you set to true, you must ask for user's consent and then pass the result to
			'consentGranted($granted:Boolean)' so the SDK can continue to work normally
		*/
		//OneSignal.requiresUserPrivacyConsent = true;
		
		OneSignal.setLogLevel(LogLevel.VERBOSE, LogLevel.NONE);
		
		var settings:InitSettings = new InitSettings();
		
		// iOS settings
		settings.autoPrompt = false;
		settings.inAppAlerts = true;
		settings.inAppLaunchURL = true;
		settings.promptBeforeOpeningPushURL = true;
		settings.providesAppNotificationSettings = true;
		
		// Android settings
		settings.autoPromptLocation = false;
		settings.disableGmsMissingPrompt = false;
		settings.unsubscribeWhenNotificationsAreDisabled = false;
		settings.filterOtherGCMReceivers = false;
		
		// Android + iOS settings
		settings.inFocusDisplayOption = DisplayType.IN_APP_ALERT;
		
		OneSignal.init(settings);
		
		// you may change how notifications are shown when your app is in focus
		OneSignal.inFocusDisplayType = DisplayType.IN_APP_ALERT;
		
		// On iOS, it is required to get the user's consent before collecting location.
		OneSignal.setlocationshared(true);
		
		// add listeners
		OneSignal.listener.addEventListener(OneSignalEvents.NOTIFICATION_RECEIVED, onNotificationReceived);
		OneSignal.listener.addEventListener(OneSignalEvents.NOTIFICATION_OPENED, onNotificationOpened);
		
		//----------------------------------------------------------------------
		var btn0:MySprite = createBtn("Ask for permission", 0xDFE4FF);
		btn0.addEventListener(MouseEvent.CLICK, askPermission);
		if(OverrideAir.os == OverrideAir.IOS) _list.add(btn0);
		
		function askPermission(e:MouseEvent):void
		{
			OneSignal.promptForPushNotifications(function ($accepted:Boolean):void
			{
				trace("promptForPushNotifications, result: " + $accepted);
			});
		}
		
		//----------------------------------------------------------------------
		var btn1:MySprite = createBtn("getPermissionSubscriptionState", 0xDFE4FF);
		btn1.addEventListener(MouseEvent.CLICK, getPermissionSubscriptionState);
		_list.add(btn1);
		
		function getPermissionSubscriptionState(e:MouseEvent):void
		{
			/*
				check permission state meaning in NotificationPermissionStatus
				NotificationPermissionStatus.NOT_DETERMINDED > 0
				NotificationPermissionStatus.DENIED > 1
				NotificationPermissionStatus.AUTHORIZED > 2
				NotificationPermissionStatus.PROVISIONAL > 3
			*/
			trace(OneSignal.getPermissionSubscriptionState());
		}
		
		//----------------------------------------------------------------------
		var btn2:MySprite = createBtn("getTags", 0xDFE4FF);
		btn2.addEventListener(MouseEvent.CLICK, getTags);
		_list.add(btn2);
		
		function getTags(e:MouseEvent):void
		{
			OneSignal.getTags(function($msg:String):void
			{
				trace($msg);
				
			});
		}
		
		//----------------------------------------------------------------------
		var btn3:MySprite = createBtn("sendTag", 0xDFE4FF);
		btn3.addEventListener(MouseEvent.CLICK, sendTag);
		_list.add(btn3);
		
		function sendTag(e:MouseEvent):void
		{
			OneSignal.sendTag("TagKey1", "TagValue1");
		}
		
		//----------------------------------------------------------------------
		var btn4:MySprite = createBtn("sendTags", 0xDFE4FF);
		btn4.addEventListener(MouseEvent.CLICK, sendTags);
		_list.add(btn4);
		
		function sendTags(e:MouseEvent):void
		{
			var tags:Object = {};
			tags.TagKey2 = "TagValue2";
			tags.TagKey3 = "TagValue3";
			tags["TagKey4"] = "TagValue4";
			tags.time = new Date().toLocaleTimeString();
			
			OneSignal.sendTags(tags, function ($msg:String):void
			{
				trace($msg);
				
			}, function ($error:String):void
			{
				trace($error);
			});
		}
		
		//----------------------------------------------------------------------
		var btn5:MySprite = createBtn("deleteTag", 0xDFE4FF);
		btn5.addEventListener(MouseEvent.CLICK, deleteTag);
		_list.add(btn5);
		
		function deleteTag(e:MouseEvent):void
		{
			OneSignal.deleteTag("TagKey4", function ($msg:String):void
			{
				trace($msg);
				
			}, function ($error:String):void
			{
				trace($error);
			});
		}
		
		//----------------------------------------------------------------------
		var btn6:MySprite = createBtn("deleteTags", 0xDFE4FF);
		btn6.addEventListener(MouseEvent.CLICK, deleteTags);
		_list.add(btn6);
		
		function deleteTags(e:MouseEvent):void
		{
			OneSignal.deleteTags(["TagKey3", "TagKey4"], function ($msg:String):void
			{
				trace($msg);
				
			}, function ($error:String):void
			{
				trace($error);
			});
		}
		
		//----------------------------------------------------------------------
		var btn7:MySprite = createBtn("promptLocation", 0xDFE4FF);
		btn7.addEventListener(MouseEvent.CLICK, promptLocation);
		_list.add(btn7);
		
		function promptLocation(e:MouseEvent):void
		{
			OneSignal.promptLocation();
		}
	}
	
	private function onNotificationReceived(e:OneSignalEvents):void
	{
		trace("onNotificationReceived: " + e.msg);
		C.log("onNotificationReceived: " + e.msg);
	}
	
	private function onNotificationOpened(e:OneSignalEvents):void
	{
		trace("onNotificationOpened: " + e.msg);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	private function createBtn($str:String, $bgColor:uint = 0xDFE4FF):MySprite
	{
		var sp:MySprite = new MySprite();
		sp.addEventListener(MouseEvent.MOUSE_OVER, onOver);
		sp.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		sp.addEventListener(MouseEvent.CLICK, onOut);
		sp.bgAlpha = 1;
		sp.bgColor = $bgColor;
		sp.drawBg();
		sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
		sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
		
		function onOver(e:MouseEvent):void
		{
			sp.bgAlpha = 1;
			sp.bgColor = 0xFFDB48;
			sp.drawBg();
		}
		
		function onOut(e:MouseEvent):void
		{
			sp.bgAlpha = 1;
			sp.bgColor = $bgColor;
			sp.drawBg();
		}
		
		var format:TextFormat = new TextFormat("Arimo", 16, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
		
		var txt:TextField = new TextField();
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.antiAliasType = AntiAliasType.ADVANCED;
		txt.mouseEnabled = false;
		txt.multiline = true;
		txt.wordWrap = true;
		txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
		txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
		txt.defaultTextFormat = format;
		txt.text = $str;
		
		txt.y = sp.height - txt.height >> 1;
		sp.addChild(txt);
		
		return sp;
	}
}
}
