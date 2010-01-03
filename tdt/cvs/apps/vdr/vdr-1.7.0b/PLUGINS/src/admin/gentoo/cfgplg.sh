#!/bin/sh
source /etc/vdr.d/conf/gen2vdr.cfg
source /etc/vdr.d/conf/vdr

FNAME=${0##*/}
#:docstring strstr:
# Usage: strstr s1 s2
# 
# Strstr echoes a substring starting at the first occurrence of string s2 in
# string s1, or nothing if s2 does not occur in the string.  If s2 points to
# a string of zero length, strstr echoes s1.
#:end docstring:

###;;;autoload
function strstr ()
{
   # if s2 points to a string of zero length, strstr echoes s1
   [ ${#2} -eq 0 ] && { echo "$1" ; return 0; }

   # strstr echoes nothing if s2 does not occur in s1
   case "$1" in
   *$2*) return 0;;
   *) return 1;;
   esac

   # use the pattern matching code to strip off the match and everything
   # following it
   first=${1/$2*/}

   # then strip off the first unmatched portion of the string
   echo "${1##$first}"
}

cp ${VDR_PLGCONFIG_DIR}/admin/admin.conf ${VDR_PLGCONFIG_DIR}/admin/admin.conf.old 
grep -v "${FNAME}:" ${VDR_PLGCONFIG_DIR}/admin/admin.conf > /tmp/admin.conf.new

grep "PLG_" ${VDR_PLGCONFIG_DIR}/admin/admin.conf | grep -v ":0:I:" | sort -t: +1 -2 -u| sort -t: +2 -3 -n > /tmp/plgs
sed -i /tmp/plgs -e "s%.*${FNAME}%${VDR_PLGCONFIG_DIR}/admin/${FNAME}%"

INST_PLG="$(cat /tmp/plgs | cut -f 2 -d ":" | cut -f 2- -d "_" | tr "\n" " ")"
INST_PLG="${INST_PLG% }"
if [ "$*" != "" ] ; then
   NEW_PLG="${*# }"
   NEW_PLG="${NEW_PLG% }"
   if [ "$NEW_PLG" != "$INST_PLG" ] ; then
      INST_PLG=""
      IDX=1
      [ -f /tmp/plgs ] && rm -f /tmp/plgs
      logger -s "Changing plugins to <$NEW_PLG>"      
      for i in $NEW_PLG ; do      
         if ( ! strstr " $INST_PLG "  " $i " ) ; then
            if [ "$(ls ${VDR_LIB_DIR}/libvdr-${i}.so.*)" != "" ] ; then
               echo "${VDR_PLGCONFIG_DIR}/admin/${FNAME}:PLG_${i}:$IDX:I:0:0,999:${i}:" >> /tmp/plgs
               IDX=$(($IDX+1))         
               INST_PLG="$INST_PLG $i"
            else
               logger -s "Unknown Plugin <${i}>"
	    fi
         fi
      done
   fi            
fi   
INST_PLG="${INST_PLG# }"
if ( ! strstr " $INST_PLG " " admin " ) ; then
   INST_PLG="$INST_PLG admin"
   echo "${VDR_PLGCONFIG_DIR}/admin/${FNAME}:PLG_admin:15:I:0:0,999:admin:" >> /tmp/plgs
fi

APIVERSION="$(grep "define APIVERSION " ${VDR_SOURCE_DIR}/config.h | cut -f 2 -d "\"")"

for i in $(ls -l ${VDR_LIB_DIR}/libvdr-*.so.$APIVERSION |sed -e "s/.*libvdr-//" -e "s/\.so\..*//") ; do
   if [ ! -f /etc/vdr.d/plugins/${i} ] ; then
      echo "Creating /etc/vdr.d/plugins/${i}"
      cp /etc/vdr.d/plugins/default.cfg /etc/vdr.d/plugins/${i}
      sed -i /etc/vdr.d/plugins/${i} -e "s/VDR plugin.*/VDR plugin $i/" -e "s/^PLUGIN_NAME=.*/PLUGIN_NAME=${i}/"
   fi
   echo "${VDR_PLGCONFIG_DIR}/admin/${FNAME}:PLG_${i}:0:I:0:0,999:${i}:" >> /tmp/plgs
done

# delete all Plugin-Links in /etc/vdr.d
rm /etc/vdr.d/1* > /dev/null 2>&1
 
IDX=1000
USED_PLG=""
for i in $INST_PLG ; do
    if [ -f ${VDR_LIB_DIR}/libvdr-${i}.so.$APIVERSION ] ; then
       ln -s plugins/${i} /etc/vdr.d/${IDX}-${i}
       IDX=$(($IDX+1))         
       # delete duplicate entry
       sed -i /tmp/plgs -e "/PLG_${i}:0:/d"
       USED_PLG="$USED_PLG $i"
    else
       logger -s "Plugin <$i> ist nicht vorhanden"
    fi   
done
echo "Plugins <$USED_PLG>"      

cat /tmp/admin.conf.new /tmp/plgs > ${VDR_PLGCONFIG_DIR}/admin/admin.conf
sed -i /etc/vdr.d/conf/vdr -e "s/^PLUGINS=.*/PLUGINS=\"${INST_PLG}\"/"
