#!/bin/bash
cd /work_proxmox/initrd/
chmod 777 -R /work_proxmox/initrd/
echo "Generate initrd..."
time find . | cpio -H newc -o | nice -n 17 gzip -9 > initrd.img && mv initrd.img /work_proxmox/ISO/boot/
cd /work_proxmox/SQUASHFS/
chmod 777 -R  /work_proxmox/SQUASHFS/
echo "Generate SQUASHFS..."
nice -n 10 mksquashfs squashfs-root/ pve-installer.squashfs -noappend -always-use-fragments -comp xz -Xbcj x86
mv pve-installer.squashfs /work_proxmox/ISO/
chmod 777 -R /work_proxmox
cd /work_proxmox/
echo "Generate ISO..."
nice -n 10 xorriso -as mkisofs -o /var/lib/vz/template/iso/proxmox.iso -r -V 'PVE'  --grub2-mbr /work_proxmox/proxmox.mbr --protective-msdos-label -efi-boot-part --efi-boot-image -c '/boot/boot.cat' -b '/boot/grub/i386-pc/eltorito.img' -no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info -eltorito-alt-boot -e '/efi.img' -no-emul-boot ISO/
