#Depricated use swww-daemon instead
#swww init

swww-daemon

#if [ -e "${HOME}/.cache/wal/colors" ]; then
#    wal -R 

#    echo "Cached colors exist. Using existing colors."
#else



#     DIR="$HOME/Pictures/wallpapers"
#     PICS=($(ls ${DIR}))

#     RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

#     swww img ${DIR}/${RANDOMPICS} --transition-type grow --transition-fps 60 --transition-duration 1.0 --transition-pos 0.810,0.972 --transition-bezier 0.65,0,0.35,1 --transition-step 255
#     wal -i ${DIR}/${RANDOMPICS} 
#     source $HOME/.config/hypr/scripts/set_colors_from_pywal.sh

#     echo "Successfully set a new wallpaper and generated colors from it."
# fi

# pywalfox update

swww restore
wal -R