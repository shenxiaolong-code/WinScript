#!/bin/bash

bash_script_i

function mount_external_virtualbox_shared_folder()
{
    [[  $# -lt 2 ]] && {
        dumpinfo "Usage: mount_external_virtualbox_shared_folder <mount_point_name>"
        return 1
    }

    local file_system="$1"
    local external_mount_point_name="$2"
    load external_mount_point="/mnt/${external_mount_point_name}"
    # create mount point if not exists
    if [[ -d ${external_mount_point} ]] ; then
        dumpinfo "Removing exist mount point directory: ${external_mount_point}"
        sudo rm -rf ${external_mount_point}
    fi
    dumpinfo "Creating mount point directory: ${external_mount_point}"
    sudo mkdir -p ${external_mount_point}

    # mount the external folder
    if [[ -d ${external_mount_point} ]] ; then
        dumpinfo "Mounting external folder to ${external_mount_point}"
        # vboxsf : virtualbox shared folder
        # ext4   : ext4 filesystem
        # ntfs   : NTFS filesystem
        # cifs   : Common Internet File System (SMB/CIFS)
        # nfs    : Network File System
        dumpcmd "sudo mount -t vboxsf ${external_mount_point_name} ${external_mount_point}"
        # sudo mount -t $file_system "${@:2}"
        # mount -t vboxsf shared_folder_name /mnt/shared_folder
        # mount -t ext4 /dev/sdX1 /mnt/external_drive
        # mount -t ntfs /dev/sdX1 /mnt/external_drive
        # mount -t cifs //server/share /mnt/external_drive -o username=user,password=pass
        # mount -t nfs server:/exported/path /mnt/external_drive
        # mount -t nfs4 server:/exported/path /mnt/external_drive
        # mount -t nfs4 server:/exported/path /mnt/external_drive -o nfsvers=4
        # mount -t nfs server:/exported/path /
        sudo mount -t vboxsf ${external_mount_point_name} ${external_mount_point}
        if [[ $? -eq 0 ]] ; then
            dumpinfo "Successfully mounted ${external_mount_point_name} to ${external_mount_point}"
        else
            dumpinfo "Failed to mount ${external_mount_point_name} to ${external_mount_point}"
            return 1
        fi
    else
        dumpinfo "Mount point directory ${external_mount_point} does not exist, cannot mount."
        return 1
    fi
}

function unmount_external_folder()
{
    local external_mount_point_name="$1"
    [[ -z ${external_mount_point_name} ]] && {
        dumpinfo "Usage: unmount_external_folder <mount_point_name>"
        return 1
    }

    local external_mount_point="/mnt/${external_mount_point_name}"
    if mountpoint -q ${external_mount_point} ; then
        dumpinfo "Unmounting ${external_mount_point}"
        sudo umount ${external_mount_point}
        if [[ $? -eq 0 ]] ; then
            dumpinfo "Successfully unmounted ${external_mount_point}"
        else
            dumpinfo "Failed to unmount ${external_mount_point}"
            return 1
        fi
    else
        dumpinfo "${external_mount_point} is not a mount point."
    fi
}

function tc_mount_external_virtualbox_shared_folder()
{
    dumppos
    dumpcmdline
    cd $( mktemp -d -p ${TEMP_DIR}/to_del )
    mount_external_virtualbox_shared_folder scratch
}

alias mnt="mount_external_virtualbox_shared_folder"

# [[ $# -le 2 ]] && tc_mount_external_virtualbox_shared_folder "$@" || mount_external_virtualbox_shared_folder "$@"
# mount_external_virtualbox_shared_folder "$@"
tc_mount_external_virtualbox_shared_folder  "$@"


bash_script_o
