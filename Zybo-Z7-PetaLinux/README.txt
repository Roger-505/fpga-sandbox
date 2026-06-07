## To build 

wget https://github.com/Digilent/Zybo-Z7/releases/download/20%2FPetalinux%2F2022.1-1/Zybo-Z7-20-Petalinux-2022-1.bsp
petalinux-create -t project -s Zybo-Z7-20-Petalinux-2022-1.bsp
cd os/
petalinux-build
