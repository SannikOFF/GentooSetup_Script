#! /bin/bash

installRoot="/media/gentoo/"
architecture="x86"
mirror="http://mirror.yandex.ru/gentoo-distfiles"

#echo -e "Welcome to Gentoo Linux Installer\n"

if [ "$(whoami)" != 'root' ];
then
    dialog --backtitle "Welcome to Gentoo Linux Installer" \
        --title "User authentication" \
        --msgbox "Permission denied. Istallation can not be continue.\nStart installation from root privileges.\n" 30 100
    exit 1;
else
    dialog --backtitle "Welcome to Gentoo Linux Installer" \
        --title "User authentication" \
        --msgbox "Welcome to the installation of Gentoo Linux. \
              To properly install the product, you must correctly answer all the questions, \
              and follow the instructions of the program. More information can be found in \
              the official guide at Gentoo http://www.gentoo.org/doc/en/handbook/" 30 100
fi

function Level1 ()
{

#echo -e "Level 1. Creating Filesystems.\n"
#Begin creating filesystems

partcount=0

if [ ! -d "$installRoot"  ]
then
    mkdir "$installRoot"
fi

while :
do
    dialog --backtitle "Level 1. Creating Filesystems" \
        --title "Partitioning disks" \
        --yesno "Do you want to partition your disks?" 30 100
    case "$?"
    in
        0 ) dialog --backtitle "Level 1. Creating Filesystems" \
                --title "Partitioning disks" \
                --inputbox "Enter hard drive name" 30 100 2> /tmp/diskName
            cfdisk `cat /tmp/diskName`
            rm /tmp/diskName
            ;;
        1 ) break
            ;;
    esac
done

while :
do
    dialog --backtitle "Level 1. Creating Filesystems" \
        --title "Making filesystems" \
        --yesno "Do you want to make filesystem on your partition?" 30 100
    case "$?"
    in
        0 ) partname=""
            while :
            do
                dialog --backtitle "Level 1. Creating Filesystems" \
                    --title "Making filesystems" \
                    --inputbox "Enter hard drive partition name" 30 100 2> /tmp/partName
                partname=`cat /tmp/partName`
                rm /tmp/partName
                
                if [ "$partname" = ""  ]
                then
                    break
                fi

                if [ ! -b "$partname" ]
                then
                    dialog --backtitle "Level 1. Creating Filesystems" \
                        --title "Making filesystems" \
                        --msgbox "Wrong partition name: `echo $partname`. Retry." 30 100
                    continue
                fi
        
                while :
                do
                    dialog --backtitle "Level 1. Creating Filesystems" \
                        --title "Making filesystems" \
                        --radiolist "Please pick one type of file system" 30 100 10 \
                            1 "bfs" "off" \
                            2 "btrfs" "off" \
                            3 "cramfs" "off" \
                            4 "ext2" "off" \
                            5 "ext3" "off" \
                            6 "ext4" "off" \
                            7 "ext4dev" "off" \
                            8 "jfs" "off" \
                            9 "minix" "off" \
                            10 "msdos" "off" \
                            11 "nilfs2" "off" \
                            12 "ntfs" "off" \
                            13 "reiserfs" "off" \
                            14 "vfat" "off" \
                            15 "xfs" "off" \
                            16 "swap" "off" \
                            2>/tmp/fstype
                    cm=`cat /tmp/fstype`
                    rm /tmp/fstype
                    case "$cm"
                    in
                        1)  mkfs.bfs "$partname"
                            break
                            ;;
                        2)  mkfs.btrfs "$partname"
                            break
                            ;;
                        3)  mkfs.cramfs "$partname"
                            break
                            ;;
                        4)  mkfs.ext2 "$partname"
                            break
                            ;;
                        5)  mkfs.ext3 "$partname"
                            break
                            ;;
                        6)  mkfs.ext4 "$partname"
                            break
                            ;;
                        7)  mkfs.ext4dev "$partname"
                            break
                            ;;
                        8)  mkfs.jfs "$partname"
                            break
                            ;;
                        9)  mkfs.minix "$partname"
                            break
                            ;;
                        10) mkfs.msdos "$partname"
                            break
                            ;;
                        11) mkfs.nilfs2 "$partname"
                            break
                            ;;
                        12) mkfs.ntfs "$partname"
                            break
                            ;;
                        13) mkfs.reiserfs "$partname"
                            break
                            ;;
                        14) mkfs.vfat "$partname"
                            break
                            ;;
                        15) mkfs.xfs "$partname"
                            break
                            ;;
                        16) mkswap "$partname"
                            swapon "$partname"
                            break
                            ;;
                    esac
                done
        
                if [ "$cm" != "16"  ]
                then
                    dialog --backtitle "Level 1. Creating Filesystems" \
                        --title "Making filesystems" \
                        --inputbox "Please specify partition" 30 100 2> /tmp/partFolder
                    ch=`cat /tmp/partFolder`
                    rm /tmp/partFolder
                    if [ "$ch" = "/"  ]
                    then
                        mount "$partname" "$installRoot"
                    else
                        mkdir "$installRoot""$ch"
                        mount "$partname" "$installRoot""$ch"
                    fi
                fi
            
                break
            done
            ;;
        1 ) break
            ;;
    esac
done

}

function Level2 ()
{

while :
do
        dialog --backtitle "Level 2. Date and Time Settings" \
        --title "Date and time configuration" \
        --yesno "Is it correct time: `date`" 30 100
    case "$?"
    in
        0 ) break
            ;;
        1 )     while :
            do
                dialog --backtitle "Level 2. Date and Time Settings" \
                    --title "Date and time checking" \
                    --inputbox "Please specify date and time (like this MMDDhhmmYYYY)" 30 100 2> /tmp/currentDate
                date `cat /tmp/currentDate`
                if [ "$?" = "0" ]
                then
                    dialog --backtitle "Level 2. Date and Time Settings" \
                        --title "Date and time configuration" \
                        --msgbox "Date and time set. Current time: `date`" 30 100
                    break
                fi
                rm /tmp/currentDate
            done
            ;;
    esac
done

}

function Level3 ()
{

while :
do
    dialog --backtitle "Level 3. Downloading the Stage Tarball" \
        --title "Computer architecture" \
        --radiolist "Choose the available architecture" 30 100 10 \
            "1" "alpha" "off" \
            "2" "amd64" "off" \
            "3" "ia64" "off" \
            "4" "ppc" "off" \
            "5" "sparc" "off" \
            "6" "x86" "off" \
            2>/tmp/archtype
    cm=`cat /tmp/archtype`
    rm /tmp/archtype
    case "$cm"
    in
        1 | 2 | 3 | 4 | 5 | 6 ) architecture="$cm"
            break
            ;;
        * )
            ;;
    esac
done

#emerge mirrorselect

mirrorselect -i -o > "$installRoot"GENTOO_MIRRORS

cd "$installRoot"

dialog --backtitle "Level 3. Installing the Gentoo Installation Files" \
    --title "Downloading and unpacking Stage tarball" \
    --infobox "Downloading Stage Tarball" 30 100
sleep 2
wget --no-parent -nd -c -t inf -A "*.tar.bz2" "$mirror/releases/$architecture/current-stage3/"

dialog --backtitle "Level 3. Installing the Gentoo Installation Files" \
    --title "Downloading and unpacking Stage tarball" \
    --infobox "Unpacking Stage Tarball" 30 100
sleep 2
tar xjpf "$installRoot"stage3-* -C "$installRoot"

dialog --backtitle "Level 3. Installing the Gentoo Installation Files" \
    --title "Downloading and unpacking Portage Files" \
    --infobox "Downloading Portage Files" 30 100
sleep 2
wget --no-parent -nd -c -t inf -A "portage-latest.tar.bz2" "$mirror/releases/snapshots/current/"

dialog --backtitle "Level 3. Installing the Gentoo Installation Files" \
    --title "Downloading and unpacking Potage Files" \
    --infobox "Unpacking Portage  Files" 30 100
sleep 2
tar xjf "$installRoot"portage-latest.tar.bz2 -C "$installRoot"usr

}

function Level4 ()
{

sed -i 's/^CFLAGS.*/CFLAGS="-O2 -march=native -pipe -fomit-frame-pointer"/g' "$installRoot"etc/make.conf
sed -i 's/^CXXFLAGS.*/CXXFLAGS="${CFLAGS}"/g' "$installRoot"etc/make.conf
let procCount=`grep -c processor /proc/cpuinfo`*2+1
sed -i '/MAKEOPTS/d' "$installRoot"etc/make.conf
sed -i '/GENTOO_MIRRORS/d' "$installRoot"etc/make.conf
sed -i '/SYNC/d' "$installRoot"etc/make.conf
sed -i '/LINGUAS/d' "$installRoot"etc/make.conf
echo "MAKEOPTS=\"-j$procCount\"" >> "$installRoot"etc/make.conf
echo "RSYNC=\"rsync://rsync.gentoo.org/gentoo-portage\"" >> "$installRoot"etc/make.conf
echo "LINGUAS=\"en ru\""
cat "$installRoot"GENTOO_MIRRORS >> "$installRoot"etc/make.conf

dialog --backtitle "Level 4. Start configuring system for current machine." \
    --title "Configuring Gentoo USE Flags" \
    --msgbox "In next step choose all flags you want to be added in make.conf" 30 100

ufed

while :
do
    dialog --backtitle "Level 4. Start configuring system for current machine." \
        --title "Please modify make.conf if you want, but it autoconfigured for your system" \
        --editbox "$installRoot"etc/make.conf 30 100 \
        2>"$installRoot"tmp/make.conf.tmp
    cm="$?"
    cp "$installRoot"tmp/make.conf.tmp "$installRoot"etc/make.conf
    case "$cm"
    in
        0 ) break
            ;;
        1 ) dialog --backtitle "Level 4. Start configuring system for current machine." \
                --title "Please modify make.conf if you want, but it autoconfigured for your system" \
                --yesno "Do you want to continue?" 30 100
            case "$?"
            in
                0 ) break
                    ;;
                1 ) true
                    ;;
            esac
            ;;
    esac
done

cp -L /etc/resolv.conf "$installRoot"etc/

mount -t proc none "$installRoot"proc
mount --rbind /dev "$installRoot"dev

cp dGentooInstallChroot.sh "$installRoot"
cp 02locale "$installRoot"etc/env.d/
cp locale.gen "$installRoot"etc
chmod +x "$installRoot"GentooInstallChroot.sh
chroot "$installRoot" /bin/bash --rcfile /dGentooInstallChroot.sh

}

Level1
Level2
Level3
Level4

exit 0
