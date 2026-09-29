#!/bin/bash

themes=(
    "Touhou 6 Menu [4:3]"
    "Touhou 6 Menu [4:3 HD]"
    "Touhou 6 Menu [16:9]"
    "Touhou 6 Menu [16:9 HD]"
    "Touhou 6 Menu [16:9 HD-2]"
)

themes_names=(
    "th06-menu-4x3"
    "th06-menu-4x3-HD"
    "th06-menu-16x9"
    "th06-menu-16x9-HD"
    "th06-menu-16x9-HD-2"
)

echo " _____         _                ___          _      _____ _"
echo "|_   _|__ _  _| |_  ___ _  _   / __|_ _ _  _| |__  |_   _| |_  ___ _ __  ___ ___"
echo "  | |/ _ \ || | ' \/ _ \ || | | (_ | '_| || | '_ \   | | | ' \/ -_) '  \/ -_|_-<"
echo "  |_|\___/\_,_|_||_\___/\_,_|  \___|_|  \_,_|_.__/   |_| |_||_\___|_|_|_\___/__/"
echo "                                                                   by KNZodiac24"
for i in ${!themes[@]}; do
    echo $(expr $i + 1). ${themes[$i]}
done
echo
read -p "Choose the theme to be installed: " op
echo

if ! [[ $op =~ ^[1-5]$ ]]; then
    echo "Invalid option. Please re-run the script."
    exit 1
fi

echo "Preparing theme assets..."

theme_name=${themes_names[$(expr $op - 1)]}

case $theme_name in
    ${themes_names[0]})
        cd ./themes/th06-menu/4:3/
        cp ../background-4x3.png .
        grub-mkfont ../DFPPOPCorn-W12.ttf -b -s 24 -o ./DFPPOPCorn-W12_24.pf2
        grub-mkfont ../DFPPOPCorn-W12.ttf -b -s 26 -o ./DFPPOPCorn-W12_26.pf2 ;;
    ${themes_names[1]})
        cd ./themes/th06-menu/4:3_HD/
        cp ../background-4x3.png .
        grub-mkfont ../DFPPOPCorn-W12.ttf -b -s 34 -o ./DFPPOPCorn-W12_34.pf2
        grub-mkfont ../DFPPOPCorn-W12.ttf -b -s 36 -o ./DFPPOPCorn-W12_36.pf2 ;;
    ${themes_names[2]})
        cd ./themes/th06-menu/16:9/
        cp ../background-16x9.png .
        grub-mkfont ../DFPPOPCorn-W12.ttf -b -s 24 -o ./DFPPOPCorn-W12_24.pf2
        grub-mkfont ../DFPPOPCorn-W12.ttf -b -s 26 -o ./DFPPOPCorn-W12_26.pf2 ;;
    ${themes_names[3]})
        cd ./themes/th06-menu/16:9_HD/
        cp ../background-16x9.png .
        grub-mkfont ../DFPPOPCorn-W12.ttf -b -s 36 -o ./DFPPOPCorn-W12_36.pf2
        grub-mkfont ../DFPPOPCorn-W12.ttf -b -s 38 -o ./DFPPOPCorn-W12_38.pf2 ;;
    ${themes_names[4]})
        cd ./themes/th06-menu/16:9_HD-2/
        cp ../background-16x9.png .
        grub-mkfont ../DFPPOPCorn-W12.ttf -b -s 50 -o ./DFPPOPCorn-W12_50.pf2
        grub-mkfont ../DFPPOPCorn-W12.ttf -b -s 52 -o ./DFPPOPCorn-W12_52.pf2 ;;
esac

theme_source_dir=$(pwd)

cd /boot/grub/themes/
rm -rf $theme_name
mkdir $theme_name
cd $theme_name
cp $theme_source_dir/* .

rm $theme_source_dir/*.pf2 $theme_source_dir/*.png

echo "Verifying GRUB_THEME variable..."

theme_var=$(grep GRUB_THEME /etc/default/grub)

if [[ $theme_var ]]; then
    sed -i '/GRUB_THEME/c\GRUB_THEME='$(pwd)'/theme.txt' /etc/default/grub
    echo "GRUB_THEME variable updated at /etc/default/grub"
else
    echo "GRUB_THEME variable not found. Adding it to /etc/default/grub"
    echo >> /etc/default/grub
    echo "GRUB_THEME=$(pwd)" >> /etc/default/grub
fi

echo "Theme installed successfully in $(pwd)"

echo "Updating grub config (/boot/grub/grub.cfg)..."
grub-mkconfig -o /boot/grub/grub.cfg
