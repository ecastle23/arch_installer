#!/bin/bash

# Never run pacman -Sy on your system!
pacman -Sy dialog --noconfirm

timedatectl set-ntp true

# Welcome message of type yesno - see `man dialog`
dialog --defaultno --title "Are you sure?" --yesno \
"This is my personnal arch linux install. \n\n\
This SHOULD only be run after partition, format, and GRUB! \n\n\
Don't say YES if you are not sure about what you're doing! \n\n\
Are you sure?" 15 60 || exit

dialog --no-cancel --inputbox "Enter a name for your computer." \
    10 60 2> comp

# Install Arch Linux! Glory and fortune!
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

# Persist important values for the next script
mv comp /mnt/comp

curl https://raw.githubusercontent.com/ecastle23\
/arch_installer/master/install_chroot.sh > /mnt/install_chroot_no_format.sh

arch-chroot /mnt bash install_chroot_no_format.sh

rm /mnt/install_chroot_no_format.sh
rm /mnt/comp

dialog --title "To reboot or not to reboot?" --yesno \
"Congrats! The install is done! \n\n\
Do you want to reboot your computer?" 20 60

response=$?

case $response in
    0) reboot;;
    1) clear;;
esac
