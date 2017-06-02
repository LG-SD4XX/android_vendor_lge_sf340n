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


    OPERATOR=`getprop ro.build.target_operator GLOBAL`
    COUNTRY=`getprop ro.build.target_country COM`
    
if [ $OPERATOR != GLOBAL ]; then
    CUST=`getprop ro.lge.capp_cupss.rootdir /cust`   #/cust/VDF_COM
 
    #avoid apk overlay model
    if [ "$CUST" != /system/cust ]; then
    
        #avoid single cust model - need to check?
        if [ "$CUST" != /cust ]; then
        
            NTCODE_LIST=`getprop persist.sys.ntcode "0","XXX,FFF,FFFFFFFF,FFFFFFFF,FF"`
            NTCODE=${NTCODE_LIST#*,}
            NTCODE=${NTCODE:1:3}

            MCCMNC_LIST=`getprop persist.sys.mccmnc-list "FFFFF"`
            DEDICATE_OPERATOR_MCCMNC="XXXXXX"
            if [[ "$MCCMNC_LIST" == *"999"* ]]; then
                DEDICATE_OPERATOR_MCCMNC=${MCCMNC_LIST%%999*}
                DEDICATE_MCCMNC_INDEX=${#DEDICATE_OPERATOR_MCCMNC}
                DEDICATE_OPERATOR_MCCMNC=${MCCMNC_LIST:$DEDICATE_MCCMNC_INDEX:6}
                DEDICATE_OPERATOR_MCCMNC=${DEDICATE_OPERATOR_MCCMNC%,}
            fi

            mkdir /data/local/etc
            chown system:system /data/local/etc
            chmod 771 /data/local/etc
            restorecon -R /data/local/etc

            CONF=$CUST/config
            PRODUCT=`getprop ro.product.name`
            IS_MULTISIM=`getprop ro.lge.sim_num`        
    
            if [ $IS_MULTISIM == "2" ]; then
                OPPATH=${OPERATOR}_${COUNTRY}_DS
            elif [ $IS_MULTISIM == "3" ]; then
                OPPATH=${OPERATOR}_${COUNTRY}_TS
            else
                OPPATH=${OPERATOR}_${COUNTRY}
            fi        

            CUST_PROPPATH=${CONF}/apps_prop
            if [ -d /OP ]; then
                PROPPATH=/OP/${OPPATH}/prop
            else
                PROPPATH=/data/.OP/${OPPATH}/prop
            fi
        
            if [ -d /OP ]; then
                APPPATH=/OP/${OPPATH}/apps
            else
                APPPATH=/data/.OP/${OPPATH}/apps
            fi

            case "$NTCODE" in 
            "XXX")
                #Nothing to do - fail to read ntcode
                echo "Nothing to do"
                ;;
            *)
                CURRENT=`getprop ro.build.version.incremental 0`
                TAG2=`getprop persist.lge.appbox.ntcode 0`
               
                if [ "$TAG2" != "$CURRENT" ]; then 
                # copy 3rd party app properties for LGE to /data
                    LGE_3RD_PARTY_KEY_PATH=/system/vendor/etc/LGE
                    if [ -d $LGE_3RD_PARTY_KEY_PATH ]; then
                        for file0 in $(ls -a $LGE_3RD_PARTY_KEY_PATH); do
                            if [ "$file0" != "." -a "$file0" != ".." ]; then
                                `cat ${LGE_3RD_PARTY_KEY_PATH}/${file0} > /data/local/etc/${file0}`
                                chown system:system /data/local/etc/${file0}
                                chmod 644 /data/local/etc/${file0}
                            fi
                        done
                    fi
                    if [ -d ${CUST_PROPPATH}/${NTCODE} ]; then
                        for file1 in $(ls -a ${CUST_PROPPATH}/${NTCODE}); do
                            if [ "$file1" != "." -a "$file1" != ".." ]; then
                                `cat ${CUST_PROPPATH}/${NTCODE}/${file1} > /data/local/etc/${file1}`
                                chown system:system /data/local/etc/${file1}
                                chmod 644 /data/local/etc/${file1}
                            fi
                        done
                    elif [ -d ${CUST_PROPPATH}/${DEDICATE_OPERATOR_MCCMNC} ]; then
                        for file2 in $(ls -a ${CUST_PROPPATH}/${DEDICATE_OPERATOR_MCCMNC}); do
                            if [ "$file2" != "." -a "$file2" != ".." ]; then
                                echo "file2 = $file2"
                                `cat ${CUST_PROPPATH}/${DEDICATE_OPERATOR_MCCMNC}/${file2} > /data/local/etc/${file2}`
                                chown system:system /data/local/etc/${file2}
                                chmod 644 /data/local/etc/${file2}
                            fi
                        done
                    elif [ -d ${CUST_PROPPATH}/FFF ]; then
                        for file3 in $(ls -a ${CUST_PROPPATH}/FFF); do
                            if [ "$file3" != "." -a "$file3" != ".." ]; then
                                `cat ${CUST_PROPPATH}/FFF/${file3} > /data/local/etc/${file3}`
                                chown system:system /data/local/etc/${file3}
                                chmod 644 /data/local/etc/${file3}
                            fi
                        done
                    elif [ -d ${PROPPATH}/${NTCODE} ]; then
                        for file4 in $(ls -a ${PROPPATH}/${NTCODE}); do
                            if [ "$file4" != "." -a "$file4" != ".." ]; then
                                `cat ${PROPPATH}/${NTCODE}/${file4} > /data/local/etc/${file4}`
                                chown system:system /data/local/etc/${file4}
                                chmod 644 /data/local/etc/${file4}
                            fi
                        done
                    elif [ -d ${PROPPATH}/${DEDICATE_OPERATOR_MCCMNC} ]; then
                        for file5 in $(ls -a ${CUST_PROPPATH}/${DEDICATE_OPERATOR_MCCMNC}); do
                            if [ "$file5" != "." -a "$file5" != ".." ]; then
                                `cat ${PROPPATH}/${DEDICATE_OPERATOR_MCCMNC}/${file5} > /data/local/etc/${file5}`
                                chown system:system /data/local/etc/${file5}
                                chmod 644 /data/local/etc/${file5}
                            fi
                        done
                    elif [ -d ${PROPPATH}/FFF ]; then
                        for file6 in $(ls -a ${PROPPATH}/FFF); do
                            if [ "$file6" != "." -a "$file6" != ".." ]; then
                                `cat ${PROPPATH}/FFF/${file6} > /data/local/etc/${file6}`
                                chown system:system /data/local/etc/${file6}
                                chmod 644 /data/local/etc/${file6}
                            fi
                        done
                    fi
        
                    DATA_SYSTEM=/data/app-system
                   
                    if [ -f $CONF/ntcode_list_${NTCODE}.cfg ]; then                
                        for apk1 in $(cat $CONF/ntcode_list_${NTCODE}.cfg); do
                            `cat ${APPPATH}/${apk1} > ${DATA_SYSTEM}/${apk1}`
                            chown system:system ${DATA_SYSTEM}/${apk1}
                            chmod 644 ${DATA_SYSTEM}/${apk1}
                        done
                    elif [ -f $CONF/ntcode_list_FFF.cfg ]; then           
                        for apk2 in $(cat $CONF/ntcode_list_FFF.cfg); do
                            `cat ${APPPATH}/${apk2} > ${DATA_SYSTEM}/${apk2}`
                            chown system:system ${DATA_SYSTEM}/${apk2}
                            chmod 644 ${DATA_SYSTEM}/${apk2}
                        done
                    fi
                   
                    if [ -f $CONF/errc_list.cfg ]; then                
                        for module in $(cat $CONF/errc_list.cfg); do
                            
                            ERRC_TYPE=${module#*,}
                            module=${module%%,*}
                            
                            rm -rf ${DATA_SYSTEM}/${module}
                            rm -rf ${DATA_SYSTEM}/${module}.apk
                            rm -rf ${DATA_SYSTEM}/${module}-*
                            rm -rf ${DATA_SYSTEM}/${module}-*.apk
         
                            if [ "$ERRC_TYPE" != "system" ]; then
                                rm -rf /data/app/${module}
                                rm -rf /data/app/${module}.apk
                                rm -rf /data/app/${module}-*
                                rm -rf /data/app/${module}-*.apk
                                  
                                rm -rf ${APPPATH}/${module}
                                rm -rf ${APPPATH}/${module}.apk
                            fi
                        done
                    fi
                   
                    setprop persist.lge.appbox.ntcode ${CURRENT}
                fi 
                ;;
            esac  
        fi    
    fi     
fi        
          
exit 0