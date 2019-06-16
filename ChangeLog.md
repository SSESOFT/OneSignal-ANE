OneSignal AIR Native Extension

*Jun 17, 2019 - V1.0.0*
* Updated OneSignal Android SDK to V3.10.9 - min Android API to run the ANE is 19+
* Updated OneSignal iOS SDK to V2.10.0 - min iOS to run the ANE is V10+
* Added this attribute ```android:exported="false"``` to the following service tag:
```xml
<service android:name="com.google.firebase.components.ComponentDiscoveryService" android:exported="false">
```

* Removed ```<category android:name="[PACKAGE_NAME].onesignal"/>``` from ```<receiver android:name="com.google.firebase.iid.FirebaseInstanceIdReceiver"``` now, the receiver tag looks like this:
```xml
<receiver
    android:name="com.google.firebase.iid.FirebaseInstanceIdReceiver"
    android:exported="true"
    android:permission="com.google.android.c2dm.permission.SEND">
    <intent-filter>
        <action android:name="com.google.android.c2dm.intent.RECEIVE"/>
    </intent-filter>
</receiver>
```

* Update all the dependency ANEs to make sure they are synced with other ANEs. And more over, we now have a new dependency for OneSignal:
```xml
<extensionID>com.myflashlab.air.extensions.dependency.googlePlayServices.measurementBase</extensionID>
```

*Mar 6, 2019 - V0.0.35*
* Fixed a bug where the static library .a was included inside the .ipa resources directory.

*Jan 18, 2019 - V0.0.34*
* beginning of the journey!
* Using OneSignal iOS SDK V2.9.4
* Using OneSignal Android SDK V3.10.5