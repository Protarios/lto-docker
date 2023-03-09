# lto-docker
A dockerfile including all tools necessary for working with LTO drives.

Contains LTFS drivers, mt-st and stenc for using encryption.

The container is terminal only with out gui!

To use LTFS in docker, you'll need to run it with --cap-add SYS_ADMIN, pass in the the fuse device --device /dev/fuse, and pass in the tape drive's generic scsi device --device /dev/sgX (find it via lsscsi -g)

The docker container is available from docker hub at: zerginator/ltfs

As the docker is terminal only I currently cannot install it directly from UnRaid Webinterface, as it immidately closes, so run it from the unraid console with an added execution of /bin/bash

docker run -it --name='LTFS' --net='bridge' --privileged=true -e TZ="Europe/Berlin" -e HOST_OS="Unraid" -e HOST_HOSTNAME="NAS" -e HOST_CONTAINERNAME="LTFS" -e 'USER_LOCALES'='de_DE.UTF-8 UTF-8' -l net.unraid.docker.managed=dockerman -l net.unraid.docker.icon='https://www.storageheaven.com/v/vspfiles/assets/images/ltfs.png' -p '5544:5543/tcp' -v '/mnt/user/LTO/ToLTO/':'/backup':'rw' -v '/mnt/user/LTO/FromLTO/':'/restore':'rw' --device='/dev/st0' --device='/dev/fuse' --device='/dev/sg19' --device='/dev/nst0' --cap-add SYS_ADMIN 'zerginator/ltfs' /bin/bash

Most important terminal commands for working with this container:

# List of available drives

ltfs -o device_list

# Status of the Ultrium drive

mt -f /dev/nst0 status

# Encrytion

## Status of enryption (enabled/disabled)

stenc -f /dev/nst0

## Create a encryption key

stenc -g 256 -k /media/vtape/myaes.key -kd "Backup Key Name"

## Activate encryption

stenc -f /dev/nst0 -e on -k /media/vtape/myaes.key -a 1

## Deactivate encryption

stenc -f /dev/nst0 -e off -a 1

# Prepare a LTO disc for usage with LTFS

## Unparition an non-empty disc

mkltfs -d HUJ41304EV -w

## Create LTFS partitions

mkltfs -d HUJ41304EV -n "Filme Full 2023 Part 2" -s "050042" -c

Here HUJ41304EV is the decive name you get from "ltfs -o device_list", alternatively you can access it directly with /dev/sgX

mkltfs --device=HUJ41304EV --volume-name="Volume Name" --tape-serial="012345" --no-compression

# Mount LTFS parition

mkdir /ltfs

ltfs -o devname=HUJ41304EV /ltfs

# Unmount LTFS parition and eject medium

umount /ltfs
ltfs -o devname=HUJ41304EV -o release_device -o eject
