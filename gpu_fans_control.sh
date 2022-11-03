#!/bin/bash

while true
do
   echo `date`
   # 获取所有gpu的温度
   temp=`nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader`

   # 获取所有gpu的风扇转速
   fan_temp=`nvidia-settings -q all | grep \'GPUTargetFanSpeed\'\ \(`
   fan_temp=`echo ${fan_temp} | grep -oP '\d*\.'`
   fan=()
   for i in $fan_temp;do
      j=`expr ${#fan[@]} + 1`
      fan[${j}]=${i:0:2}
   done
   # echo ${fan[@]}


   # 设置GPU风扇转速的的函数
   # 传入两个参数 $1:需要设置的GPUid $2:想要设置的风扇转速
   setGPUFan(){
      gpu_i=`expr $1 + 1`
      fan_i=${fan[$gpu_i]}
      # echo $fan_i
      if [[ $fan_i != $2 ]]; then
         echo "设置gpu${1}风扇转速 ${2}, 原来为${fan_i} "
         nvidia-settings -a "[gpu:${1}]/GPUFanControlState=1" -a "[fan:${1}]/GPUTargetFanSpeed=$2"
      else
         echo "风扇${1}已经是目标值，无变动"
      fi
   }


   # 根据温度区间设置风扇转速
   gpuid=0
   for i in $temp; do

      #echo "gpuid = $gpuid"
      if [[ $i -gt 0 && $i -le 20 ]]; then
         # echo " =================== gpuid=${gpuid},温度为${i},设置风扇转速为25 ==================="
         setGPUFan $gpuid 20
      elif [[ $i -gt 20 && $i -le 35 ]]; then
         # echo " =================== gpuid=${gpuid},温度为${i},设置风扇转速为50 ==================="
         setGPUFan $gpuid 30
      elif [[ $i -gt 35 && $i -le 45 ]]; then
         # echo " =================== gpuid=${gpuid},温度为${i},设置风扇转速为50 ==================="
         setGPUFan $gpuid 40
      elif [[ $i -gt 45 && $i -le 60 ]]; then
         # echo " =================== gpuid=${gpuid},温度为${i},设置风扇转速为50 ==================="
         setGPUFan $gpuid 50
      elif [[ $i -gt 60 && $i -le 65 ]]; then
         # echo " =================== gpuid=${gpuid},温度为${i},设置风扇转速为50 ==================="
         setGPUFan $gpuid 65
      elif [[ $i -gt 65 && $i -le 70 ]]; then
         # echo " =================== gpuid=${gpuid},温度为${i},设置风扇转速为50 ==================="
         setGPUFan $gpuid 75
      elif [[ $i -gt 70 && $i -le 100 ]]; then
         # echo " =================== gpuid=${gpuid},温度为${i},设置风扇转速为50 ==================="
         setGPUFan $gpuid 80
      fi
      gpuid=`expr $gpuid + 1`

   done
   sleep 1m
done


