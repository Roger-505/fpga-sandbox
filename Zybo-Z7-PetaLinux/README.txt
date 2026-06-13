## To build 

First, follow the steps in the follow link, including the installation of PetaLinux Tools v2025.2.

  https://digilent.com/reference/programmable-logic/zybo-z7/demos/petalinux

Then, execute the following commands: 

 wget https://github.com/Digilent/Zybo-Z7/releases/download/20%2FPetalinux%2F2022.1-1/Zybo-Z7-20-Petalinux-2022-1.bsp
 petalinux-create -t project -s Zybo-Z7-20-Petalinux-2022-1.bsp
 cd os/
 CORES=$(nproc)
 sed -i 's/honister/scarthgap/' project-spec/meta-user/conf/layer.conf
 sed -i 's/CONFIG_alsa-oss=y/CONFIG_alsa-oss=n/' project-spec/configs/rootfs_config
 sed -i "s/CONFIG_YOCTO_BB_NUMBER_THREADS=\"\"/CONFIG_YOCTO_BB_NUMBER_THREADS=\"$CORES\"/" project-spec/configs/config
 sed -i "s/CONFIG_YOCTO_BB_NUMBER_PARSE_THREADS=\"\"/CONFIG_YOCTO_BB_NUMBER_PARSE_THREADS=\"$CORES\"/" project-spec/configs/config
 sed -i "s/CONFIG_YOCTO_PARALLEL_MAKE=\"\"/CONFIG_YOCTO_PARALLEL_MAKE=\"$CORES\"/" project-spec/configs/config
 petalinux-build

TODO: Update this README with correct information for building binaries with Petalinux
