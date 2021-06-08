# Copy Home Assistant Snapshots to a USB stick for protection.

### NOTE: this does NOT create the snaps, it merly copies them when manually or automatically created. 
### NOTE2: This requires rsync to be installed, so you need access to the underlying OS! HASSOS mostlikely won't work.

## Requirements
An EXT4 formatted USB stick with sufficient capacity

## Mount the USB Stick, als after reboot (automatic)

Create a folder to mount to:
`mkdir /media/habackup`

Find the disk position and UUID of your USB stick:
`sudo blkid -o list`

Mount the drive: 
`sudo mount -t ext4 /dev/sdb2 /media/habackup -o defaults`

Mount the drive on Linux boot:
`sudo nano /etc/fstab`

Add the line:
`UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /media/habackup ext4 defaults 0`

## install and first run rsync

Install rsync:
`sudo apt install rsync`

Test rysync from HA Back-up folder to USD Backup folder (Files on stick will be deleted!)
`sudo rsync --delete -avu "/usr/share/hassio/backup/" "/media/habackup"`

NOTE: use `SUDO` here since the EXT mounted flash drive is Root accessable only at first, but after reboot it's user accesable.

## Automate rsync to run every night

If you want rsync to run every night, add it to the crontab:

Open Crontab:
`sudo crontab -e`

Add the lines:

# Rsync backups to a mapped USB drive for back-up off system quick and dirty
0 5 * * * rsync --delete -avu "/usr/share/hassio/backup/" "/media/habackup"

For reference, a Crontab line to delte images shot from my webcam > 28 days:
# clean up old camera image files
0 4 * * * root find /usr/share/hassio/media/cameras/ \( -iname '*jpeg' -o -iname '*jpg' ! -iname '*latest*' \) -type f -mtime +28 -delete
