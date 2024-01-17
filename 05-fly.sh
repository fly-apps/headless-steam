#!/usr/bin/env bash

bindmount() {
	mkdir -p {/data,}"$1"
	mount -o bind {/data,}"$1"
}
bindmount /mnt/games
bindmount /home/default

# nvidia-settings dinamically loads libjasson4 but base image doesn't include it
if [[ ! -f /usr/lib/x86_64-linux-gnu/libjansson.so.4 ]]; then
  apt update -q && apt install -y --no-install-recommends libjansson4
fi

# /etc/cont-init.d/70-configure_xorg.sh expects file to be named "nvidia-drm-outputclass.conf"
mv /usr/share/X11/xorg.conf.d/10-nvidia.conf /usr/share/X11/xorg.conf.d/nvidia-drm-outputclass.conf

# Overriding ModulePath doesn't work, symlink to Xorg default.
ln -sf /usr/lib/x86_64-linux-gnu/nvidia/xorg/nvidia_drv.so /usr/lib/xorg/modules/drivers/
