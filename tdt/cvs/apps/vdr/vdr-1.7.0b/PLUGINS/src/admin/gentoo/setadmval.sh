#!/bin/sh
#set -x
source /etc/vdr.d/conf/gen2vdr.cfg
VDR_CONF="/etc/vdr.d/conf/vdr"

[ "$3" != "" ] && [ -f $3 ] && ADMIN_CFG_FILE=$3
[ "$4" != "" ] && [ -f $4 ] && VDR_CONF=$4

NAME=$1
VAL=$2

if [ "$NAME" = "PLUGINS" ] ; then
   /etc/vdr/plugins/admin/cfgplg.sh "$VAL"
   exit 0
fi

NLINE=$(grep -m 1 ":$NAME:" $ADMIN_CFG_FILE)

if [ "$NLINE" = "" ] ; then
   logger -s "AdmVar: <$NAME> not found"
   exit 1
fi

TYPE=$(echo $NLINE | cut -f 4 -d ":")
OLDVAL=$(echo $NLINE | cut -f 3 -d ":")
DEFVAL=$(echo $NLINE | cut -f 5 -d ":")
ALLOWED=$(echo $NLINE | cut -f 6 -d ":")
COMMENT=$(echo $NLINE | cut -f 7 -d ":")
NEWVAL=""

case "$TYPE" in
   L)
      OV=""
      for IDX in $(seq 1 99) ; do
         VALC=$(echo "$ALLOWED," | cut -f $IDX -d ",")
         if [ "$VALC" = "" ] ; then
            break
         fi   
         [ "${VAL}" = "${VALC}" ] && NEWVAL=$VAL
         [ "${OLDVAL}" = "${VALC}" ] && OV=$OLDVAL
	 [ $IDX -eq 1 ] && DEFVAL=$VALC
      done
      if [ "$NEWVAL" = "" ] ; then
         logger -s "Value <$VAL> is not valid for $NAME"
         if [ "$OV" != "" ] ; then
            NEWVAL=$OV
         else   
            logger -s "Old Value <$OLDVAL> is not valid for $NAME"
            NEWVAL=$DEFVAL
         fi     
         VAL=$NEWVAL
      fi   
      ;;
   A | F)
      LEN=$(echo "$VAL" | wc -c)
      if [ $(($LEN - 1)) -gt $DEFVAL ] ; then
         logger -s "<$VAL> is too long for $NAME"
         NEWVAL=$OLDVAL
      else
         if [ "$ALLOWED" = "-d" -o "$ALLOWED" = "-f" ] ; then
            if [ $ALLOWED "$VAL" ] ; then
               NEWVAL=$VAL
            else
               logger -s "<$VAL> does not exist ($NAME)"
               NEWVAL=$OLDVAL
            fi
         elif [ "$ALLOWED" = "-D" -o "$ALLOWED" = "-F" ] ; then 
            if [ "$(echo "$VAL" | grep "^[/]")" != "" ] ; then
               NEWVAL=$VAL
            else
               logger -s "<$VAL> is not valid for $NAME"
               NEWVAL=$OLDVAL
            fi
         else
            if [ "$(echo "$VAL" | grep -v "^[${ALLOWED}]*\$")" = "" ] ; then
               NEWVAL=$VAL
            else
               logger -s "<$VAL> is not valid for $NAME"
               NEWVAL=$OLDVAL
            fi
         fi
      fi
      VAL=$NEWVAL
      ;;
   B)
      if [ "$VAL" = "0" ] || [ "$VAL" = "1" ] ; then
         NEWVAL=$VAL
      else    
         logger -s "Value <$VAL> is not valid for $NAME"
         if [ "$OLDVAL" = "0" ] || [ "$OLDVAL" = "1" ] ; then
            NEWVAL=$OLDVAL
         else    
            logger -s "Old value <$VAL> is not valid for $NAME"
            if [ "$DEFVAL" = "0" ] || [ "$DEFVAL" = "1" ] ; then
               NEWVAL=$VAL
            else    
               logger -s "Def value <$VAL> is not valid for $NAME - setting to 0"
               NEWVAL=0
            fi
         fi
      fi
      VAL=$NEWVAL
      ;;
   I)
      MINVAL=$(echo $ALLOWED |cut -f 1 -d ",")
      MAXVAL=$(echo $ALLOWED |cut -f 2 -d ",")
      if [ $VAL -ge $MINVAL ] && [ $VAL -le $MAXVAL ] ; then
         NEWVAL=$(printf "%d" $VAL)
      else   
         logger -s "Value <$VAL> is not valid for $NAME"
         if [ $OLDVAL -ge $MINVAL ] && [ $OLDVAL -le $MAXVAL ] ; then
            NEWVAL=$(printf "%d" $OLDVAL)
         else   
            logger -s "Old Value <$OLDVAL> is not valid for $NAME"
            if [ $DEFVAL -ge $MINVAL ] && [ $DEFVAL -le $MAXVAL ] ; then
               NEWVAL=$(printf "%d" $DEFVAL)
            else   
               logger -s "Def Value <$DEFVAL> is not valid for $NAME - setting to $MINVAL"
               NEWVAL=$(printf "%d" $MINVAL)
            fi
         fi      
      fi
      VAL=$NEWVAL
      ;;
   *)  
      logger -s "Illegal line in $ADMIN_CFG_FILE :"
      logger -s "$NLINE"
      exit 1
      ;;
esac

if [ "$NEWVAL" = "" -a "$TYPE" != "A" ] ; then
   logger -s "Value <$VAL> is not valid for $NAME"
   exit 1
fi

if [ "$NEWVAL" != "$OLDVAL" ] ; then
   logger -s "Changing $NAME to <$NEWVAL> from <$OLDVAL> in $ADMIN_CFG_FILE"
   sed -i $ADMIN_CFG_FILE -e "s|\:$NAME\:$OLDVAL\:|\:$NAME\:$NEWVAL\:|"
fi   

if [ "$(echo "${NAME}" | grep "^PLG_")" = "" ] ; then
   VE=$(grep "^${NAME}=" $VDR_CONF)
   if [ "$VE" = "" ] ; then
      logger -s "Adding ${NAME}=\"${VAL}\" to $VDR_CONF"
      echo "" >> $VDR_CONF
      echo "# $COMMENT" >> $VDR_CONF
      echo "${NAME}=\"${VAL}\"" >> $VDR_CONF
   else
      OLDVAL=$(echo $VE | cut -f 2 -d '"' )
      if [ "$VAL" != "$OLDVAL" ] ; then
         logger -s "Changing ${NAME} to <${VAL}> from <$OLDVAL> in $VDR_CONF"
         sed -i $VDR_CONF -e "s|^${NAME}=.*|${NAME}=\"${VAL}\"|"
      fi   
   fi
else  
   # if PLG variable change PLUGINS in /etc/vdr.d/conf/vdr
   /etc/vdr/plugins/admin/cfgplg.sh
fi
