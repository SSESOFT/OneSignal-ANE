# OneSignal-ANE
OneSignal is a very powerful platform for sending rich notifications on Android/iOS apps and we have now transpiled the whole framework fully to AdobeAIR! You can send rich notifications to your Android/iOS apps built with AdobeAIR.

![OneSignal ANE](https://myflashlab.github.io/resources/android_and_ios_notification_image.gif)

**Main Features:**
* Supports notifications with media attachments
* Supports app icon badges
* Supports user privacy consent
* Highly customizable properties
* receiving notification payloads when app is or is not running
* Supports EVERYTHING that OneSignal supports!

[find the latest **asdoc** for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/onesignal/package-detail.html)  

# Air Usage
For detailed AS3 code usage, see the [demo project](https://github.com/myflashlab/OneSignal-ANE/blob/master/AIR/src/Main.as). below is a basic example showing how to initialize the OneSignal ANE.

```actionscript
import com.myflashlab.air.extensions.onesignal.*;

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

// add listeners
OneSignal.listener.addEventListener(OneSignalEvents.NOTIFICATION_RECEIVED, onNotificationReceived);
OneSignal.listener.addEventListener(OneSignalEvents.NOTIFICATION_OPENED, onNotificationOpened);

/*
    if settings.autoPrompt is false on iOS, you must ask for user's permission by calling:

    OneSignal.promptForPushNotifications(function ($accepted:Boolean):void
    {
        trace("promptForPushNotifications, result: " + $accepted);
    });
*/

function onNotificationReceived(e:OneSignalEvents):void
{
    trace("onNotificationReceived: " + e.msg);
}

function onNotificationOpened(e:OneSignalEvents):void
{
    trace("onNotificationOpened: " + e.msg);
}
```

# AIR .xml manifest

```xml
<!--
FOR ANDROID:
-->

<!-- 
    should be added under the <manifest> tag 
-->

<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

<!-- add only if you want to send location based notifications -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>

<!-- put your app package name instead of [PACKAGE_NAME] for example air.com.site.app -->
<uses-sdk android:minSdkVersion="15" android:targetSdkVersion="28"/>
<permission android:name="[PACKAGE_NAME].permission.C2D_MESSAGE" android:protectionLevel="signature"/>
<uses-permission android:name="[PACKAGE_NAME].permission.C2D_MESSAGE"/>
<uses-permission android:name="com.google.android.c2dm.permission.RECEIVE"/>

<!-- Samsung -->
<uses-permission android:name="com.sec.android.provider.badge.permission.READ"/>
<uses-permission android:name="com.sec.android.provider.badge.permission.WRITE"/>

<!-- HTC -->
<uses-permission android:name="com.htc.launcher.permission.READ_SETTINGS"/>
<uses-permission android:name="com.htc.launcher.permission.UPDATE_SHORTCUT"/>

<!-- Sony -->
<uses-permission android:name="com.sonyericsson.home.permission.BROADCAST_BADGE"/>
<uses-permission android:name="com.sonymobile.home.permission.PROVIDER_INSERT_BADGE"/>

<!-- Apex -->
<uses-permission android:name="com.anddoes.launcher.permission.UPDATE_COUNT"/>

<!-- Solid -->
<uses-permission android:name="com.majeur.launcher.permission.UPDATE_BADGE"/>

<!-- Huawei -->
<uses-permission android:name="com.huawei.android.launcher.permission.CHANGE_BADGE"/>
<uses-permission android:name="com.huawei.android.launcher.permission.READ_SETTINGS"/>
<uses-permission android:name="com.huawei.android.launcher.permission.WRITE_SETTINGS"/>

<!-- ZUK -->
<uses-permission android:name="android.permission.READ_APP_BADGE"/>

<!-- OPPO -->
<uses-permission android:name="com.oppo.launcher.permission.READ_SETTINGS"/>
<uses-permission android:name="com.oppo.launcher.permission.WRITE_SETTINGS"/>

<!-- EvMe -->
<uses-permission android:name="me.everything.badger.permission.BADGE_COUNT_READ"/>
<uses-permission android:name="me.everything.badger.permission.BADGE_COUNT_WRITE"/>


<!-- 
    should be added under the <application> tag 
-->

    <!-- put your OneSignal App ID instead of [OneSignalAppID] -->
    <meta-data android:name="onesignal_app_id" android:value="[OneSignalAppID]"/>
    <meta-data android:name="onesignal_google_project_number" android:value="REMOTE"/>

    <!-- put your app package name instead of [PACKAGE_NAME] for example air.com.site.app -->
    <receiver
        android:name="com.onesignal.GcmBroadcastReceiver"
        android:permission="com.google.android.c2dm.permission.SEND">

        <intent-filter android:priority="999">
            <action android:name="com.google.android.c2dm.intent.RECEIVE"/>
            <category android:name="[PACKAGE_NAME]"/>
        </intent-filter>
    </receiver>

    <receiver android:name="com.onesignal.NotificationOpenedReceiver"/>
    <service android:name="com.onesignal.GcmIntentService"/>
    <service android:name="com.onesignal.GcmIntentJobService" android:permission="android.permission.BIND_JOB_SERVICE"/>
    <service android:name="com.onesignal.RestoreJobService" android:permission="android.permission.BIND_JOB_SERVICE"/>
    <service android:name="com.onesignal.RestoreKickoffJobService" android:permission="android.permission.BIND_JOB_SERVICE"/>
    <service android:name="com.onesignal.SyncService" android:stopWithTask="true"/>
    <service android:name="com.onesignal.SyncJobService" android:permission="android.permission.BIND_JOB_SERVICE"/>

    <activity android:name="com.onesignal.PermissionsActivity" android:theme="@android:style/Theme.Translucent.NoTitleBar"/>
    <service android:name="com.onesignal.NotificationRestoreService"/>
    
    <receiver android:name="com.onesignal.BootUpReceiver">
        <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED"/>
            <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
        </intent-filter>
    </receiver>

    <receiver android:name="com.onesignal.UpgradeReceiver">
        <intent-filter>
            <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        </intent-filter>
    </receiver>


    <!--dependency.firebase.messaging-->
    <service android:name="com.google.firebase.messaging.FirebaseMessagingService" android:exported="true">
        <intent-filter android:priority="-500">
            <action android:name="com.google.firebase.MESSAGING_EVENT"/>
        </intent-filter>
    </service>


    <!--dependency.firebase.iid-->
    <service android:name="com.google.firebase.components.ComponentDiscoveryService" android:exported="false">
        <meta-data 
            android:name="com.google.firebase.components:com.google.firebase.iid.Registrar" 
            android:value="com.google.firebase.components.ComponentRegistrar"/>
    </service>

    <receiver 
        android:name="com.google.firebase.iid.FirebaseInstanceIdReceiver"
        android:exported="true"
        android:permission="com.google.android.c2dm.permission.SEND">
        <intent-filter>
            <action android:name="com.google.android.c2dm.intent.RECEIVE"/>
        </intent-filter>
    </receiver>

    <service android:name="com.google.firebase.iid.FirebaseInstanceIdService" android:exported="true">
        <intent-filter android:priority="-500">
            <action android:name="com.google.firebase.INSTANCE_ID_EVENT"/>
        </intent-filter>
    </service>


    <!--dependency.googlePlayServices.basement-->
    <meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version"/>

    <!--dependency.firebase.common-->
    <!-- put your app package name instead of [PACKAGE_NAME] for example air.com.site.app -->
    <provider 
        android:name="com.google.firebase.provider.FirebaseInitProvider"
        android:authorities="[PACKAGE_NAME].firebaseinitprovider"
        android:exported="false"
        android:initOrder="100"/>


    <!--dependency.googlePlayServices.base-->
    <activity 
        android:name="com.google.android.gms.common.api.GoogleApiActivity"
        android:exported="false"
        android:theme="@android:style/Theme.Translucent.NoTitleBar"/>





<!--
FOR iOS:
-->

<!-- 
    should be added under the <InfoAdditions> tag 
-->

<key>MinimumOSVersion</key>
<string>10.0</string>

<!-- put your OneSignal App ID instead of [OneSignalAppID] -->
<key>onesignal_app_id</key>
<string>[OneSignalAppID]</string>

<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>

    <!-- add only if you want to send location based notifications -->
    <string>location</string>
</array>

<!-- add only if you want to send location based notifications -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>I need location reason</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>I need location reason</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>I need location reason</string>



<!-- 
    should be added to the <Entitlements> tag 
-->
<Entitlements>
	
		<!--
			Open your *.mobileprovision file with a text editor and find
			the Entitlements tag. copy it all here like the sample below.
			
			BUT, make sure you are reading the comments below to know what
			you have to change when you are trying to build for adhoc or
			distribution vs development mode.
		-->
		
		<key>keychain-access-groups</key>
		<array>
			<string>57AX1RU6SZ.*</string>		
		</array>
		
		<!-- 
			set to 'true' when debugging your app and set to 'false' when 
			building for adhoc or distribution.
		-->
		<key>get-task-allow</key>
		<true/>


		
		<key>application-identifier</key>
		<string>57AX1RU6SZ.your.app.package.name</string>
		<key>com.apple.developer.team-identifier</key>
		<string>57AX1RU6SZ</string>
		
		<!-- 
			set to 'development' when debugging your app and set to 
			'production' when building for adhoc or distribution.
		-->
		<key>aps-environment</key>
		<string>development</string>
		
		<!-- 
			Apple has silently added this key which is required ONLY 
			when you are trying to upload your binary to itunesconnect 
		-->
		<!--<key>beta-reports-active</key>
		<false/>-->	
	
	</Entitlements>









<!--
Embedding the ANE:
-->

<extensions>

    <extensionID>com.myflashlab.air.extensions.onesignal</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.androidSupport.core</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.androidSupport.customtabs</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.androidSupport.v4</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.firebase.common</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.firebase.iid</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.firebase.measurement.connector</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.firebase.messaging</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.base</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.basement</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.location</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.measurementBase</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.places</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.stats</extensionID>
    <extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.tasks</extensionID>
    
</extensions>
```

# Requirements
* Android SDK 19+
* iOS 10.0+
* AIR 31+

# Permissions
Inase you want to send location based notifications, you would need the [PermissionCheck ANE](http://www.myflashlabs.com/product/native-access-permission-check-settings-menu-air-native-extension/) to ask users for these permissions:

Necessary | Optional
--------------------------- | ---------------------------
. | [SOURCE_LOCATION (Android)](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/nativePermissions/PermissionCheck.html#SOURCE_LOCATION)  
. | [SOURCE_LOCATION_WHEN_IN_USE (iOS)](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/nativePermissions/PermissionCheck.html#SOURCE_LOCATION_WHEN_IN_USE)  
. | [SOURCE_LOCATION_ALWAYS (iOS)](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/nativePermissions/PermissionCheck.html#SOURCE_LOCATION_ALWAYS) 

# Commercial Version
https://www.myflashlabs.com/product/onesignal-ane-adobe-air-native-extension/

[![OneSignal ANE](https://www.myflashlabs.com/wp-content/uploads/2019/04/product_adobe-air-ane-onesignal.jpg)](https://www.myflashlabs.com/product/onesignal-ane-adobe-air-native-extension/)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  
[Send OneSignal notifications with custom icon from AdobeAIR app](https://www.youtube.com/watch?v=gb298grbZ-s)  
[Supporting iOS 10+ rich notifications in your AIR app](https://youtu.be/yqn6E1R1uzs)  

# Premium Support #
[![Premium Support package](https://www.myflashlabs.com/wp-content/uploads/2016/06/professional-support.jpg)](https://www.myflashlabs.com/product/myflashlabs-support/)
If you are an [active MyFlashLabs club member](https://www.myflashlabs.com/product/myflashlabs-club-membership/), you will have access to our private and secure support ticket system for all our ANEs. Even if you are not a member, you can still receive premium help if you purchase the [premium support package](https://www.myflashlabs.com/product/myflashlabs-support/).