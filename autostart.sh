#!/bin/sh

#xrandr --output HDMI1 --mode 1920x1080 --left-of eDP1;
nitrogen --restore;
picom &

WiFi=""
B=""
B0=""
B1=""
B2=""
B3=""
B4=""
V0=""
V1=""
V2=""
V3=""
BATTERY=""
VOLUME=""

a="^c#f9a82b^"
b="^c#f9e2c0^"
c="^c#373b41^|"

while true; do
 BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT1/capacity)
 VOL_LEVEL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep "Volume:" | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
 STATE=$(cat /sys/class/power_supply/BAT1/status)

 if [ "$STATE" = "Charging" ] || [ "$STATE" = "Full" ];  then
  BATTERY=$B
 elif [ "$BATTERY_LEVEL" -lt "10" ];  then
  BATTERY=$B0
 elif [ "$BATTERY_LEVEL" -gt "10" ] && [ "$BATTERY_LEVEL" -lt "30" ];  then 
  BATTERY=$B1
 elif [ "$BATTERY_LEVEL" -gt "30" ] && [ "$BATTERY_LEVEL" -lt "50" ];  then 
  BATTERY=$B2
 elif [ "$BATTERY_LEVEL" -gt "50" ] && [ "$BATTERY_LEVEL" -lt "80" ];  then 
  BATTERY=$B3
 elif [ "$BATTERY_LEVEL" -gt "80" ];  then
  BATTERY=$B4
 fi
 if [ "$VOL_LEVEL" -lt "10" ];  then
  VOLUME=$V0
 elif [ "$VOL_LEVEL" -gt "10" ] && [ "$VOL_LEVEL" -lt "30" ];  then 
  VOLUME=$V1
 elif [ "$VOL_LEVEL" -gt "30" ] && [ "$VOL_LEVEL" -lt "70" ];  then 
  VOLUME=$V2
 elif [ "$VOL_LEVEL" -gt "70" ];  then
  VOLUME=$V3
 fi
 SSID=$(iwctl station wlan0 show | grep Connected\ network | sed 's/Connected\ network//')
 SSIDCLEANED=${SSID//[[:blank:]]/}
 echo ${#SSIDCLEANED} > ~/test.txt
 if [ ${#SSIDCLEANED} = 0 ]; then
  SSIDCLEANED=" not connected"
 else
  SSIDCLEANED=$SSIDCLEANED
 fi
 xsetroot -name "   $a$V3  $b$VOL_LEVEL%  $c  $a$WiFi  $b$SSIDCLEANED   $c  $a$BATTERY  $b$(cat /sys/class/power_supply/BAT1/capacity)%  $c  $b$(date +'%d %b, %y %l:%M %p')     ";
 sleep 30
done