#!/bin/bash

o=$(ls origin)
if [ -z "$o" ]; then
    echo "origin is empty"
    exit 1
else
    echo "origin is NOT empty"
    j=$(ls destiny)
    if [ -z "$j" ]; then
        echo "destiny is empty..."
        for i in $(ls origin) ; do 
            ARCH=$(echo $i | awk -F'.' '{print $1}')
            EXTE=$(echo $i | awk -F'.' '{print $2}')
            ORIMD5=$(md5sum origin/$i | awk -F' ' '{print $1}');
            TIME=$(date +%m-%d-%Y_%H-%M-%S-%N)
            SUF="BKP_$TIME"
            # echo "$ARCH"_"$SUF"."$EXTE >>>>> $ORIMD5"
            echo "backing up $i"
            cp "origin/$i" "destiny/$ARCH"_"$SUF"."$EXTE" 
        done
    else
        echo "destiny is NOT empty..."
        
        for i in $(ls origin) ; do 
            ARCH=$(echo $i | awk -F'.' '{print $1}')
            EXTE=$(echo $i | awk -F'.' '{print $2}')
            ORIMD5=$(md5sum origin/$i | awk -F' ' '{print $1}');
            TIME=$(date +%m-%d-%Y_%H-%M-%S-%N)
            SUF="BKP_$TIME"
            # echo "$ARCH"_"$SUF"."$EXTE >>>>> $ORIMD5"
            # echo "backing up $i"
            # cp "origin/$i" "destiny/$ARCH"_"$SUF"."$EXTE" 
            a=0
            for j in $(ls destiny) ; do
                DARCH=$(echo $j | awk -F'_' '{print $1}')
                if [ "$ARCH" == "$DARCH" ]; then
                    DESTMD5=$(md5sum destiny/$j | awk -F' ' '{print $1}')
                    if [ "$ORIMD5" == "$DESTMD5" ]; then 
                        ((a=a+1))
                    fi
                    # echo "$i has $a copies on destiny folder."
                fi
            done
            x=$((a+1))
            if [ $x -le 5 ]; then
                echo "copying "$x"nd backup of $i"
                TIME=$(date +%m-%d-%Y_%H-%M-%S-%N)
                cp "origin/$i" "destiny/$ARCH"_"$SUF"."$EXTE"
            else
                echo "$i has $a copies on destiny."
                echo "replacing oldest copy of $i"
                rm "destiny/$(ls destiny -l | grep "$ARCH" | head -1 | awk -F' ' '{print $9}')"
                TIME=$(date +%m-%d-%Y_%H-%M-%S-%N)
                cp "origin/$i" "destiny/$ARCH"_"$SUF"."$EXTE"
            fi
        done
    fi  
fi