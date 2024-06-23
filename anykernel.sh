### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Kernel at 25:00 - Galaxy A05 (k25/kanade)
do.devicecheck=0
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
} # end attributes

# boot shell variables
block=/dev/block/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

ui_print "- Unpacking boot image";


## AnyKernel install
dump_boot;

mount /system/
mount /system_root/

# Change permissions
chmod 755 /system/bin/busybox;

# Deepsleep fix (@Chainfire)
for i in `ls /sys/class/scsi_disk/`; do
 cat /sys/class/scsi_disk/$i/write_protect 2>/dev/null | grep 1 >/dev/null
 if [ $? -eq 0 ]; then
  echo 'temporary none' > /sys/class/scsi_disk/$i/cache_type
 fi
done;

umount /system;
umount /system_root;

ui_print "- Installing new boot image";

write_boot;

ui_print "- Done";
ui_print " ";

## end install

