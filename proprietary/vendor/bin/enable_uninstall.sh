#!/system/bin/sh
# This script installs apks in /system/uninstallable directory
# when the phone is first booted after the factory reset.
#
# Apks installed via this script can be uninstalled by user.
# However, uninstallation does not remove an apk from the system image.
# Furthermore, the apks are again installed after a factory reset.
#
# Apks listed in the config file /cust/config/appmanager.cfg won't
# be neither installed or managed by Application Manager.


CURRENT=`getprop ro.build.version.incremental 0`
tag3=`getprop persist.lge.appman.errc_done 1`
if [ "$tag3" != "$CURRENT" ]; then

# should be removed on N OS
    if [ -f /system/etc/uid_lgapp.cfg ]; then
        for module in $(cat /system/etc/uid_lgapp.cfg); do
			for userNum in $(ls /data/user); do
			    userExp=`expr $userNum \* 100000 + 2901`
				chown -R ${userExp}:${userExp} /data/user/${userNum}/${module}
			done
	    done
	fi
	
	if [ -f /system/etc/uid_system.cfg ]; then
        for module in $(cat /system/etc/uid_system.cfg); do
			for userNum in $(ls /data/user); do
			    userExp=`expr $userNum \* 100000 + 1000`
				chown -R ${userExp}:${userExp} /data/user/${userNum}/${module}
			done
	    done
	fi
	
    if [ -f /system/etc/errc_devA.cfg ]; then     	       
        for module in $(cat /system/etc/errc_devA.cfg); do
            rm -rf /data/app-system/${module}
            rm -rf /data/app-system/${module}.apk
            rm -rf /data/app-system/${module}-*
            
            rm -rf /data/app/${module}
            rm -rf /data/app/${module}.apk
            rm -rf /data/app/${module}-*
			
            rm -rf /data/preload/${module}
            rm -rf /data/preload/${module}.apk
            rm -rf /data/preload/${module}-*
        done
    fi
    
    if [ -f /system/etc/errc_list.cfg ]; then     	       
        for module in $(cat /system/etc/errc_list.cfg); do
            rm -rf /data/app-system/${module}
            rm -rf /data/app-system/${module}.apk
            rm -rf /data/app-system/${module}-*
            
            rm -rf /data/app/${module}
            rm -rf /data/app/${module}.apk
            rm -rf /data/app/${module}-*
			
            rm -rf /data/preload/${module}
            rm -rf /data/preload/${module}.apk
            rm -rf /data/preload/${module}-*
        done
    fi
	
    setprop persist.lge.appman.errc_done $CURRENT
fi


exit 0
