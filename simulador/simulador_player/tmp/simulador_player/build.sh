#!/bin/bash

# ##########################################################
# # EDITAR PARA OS CAMINHOS NA MAQUINA !

# LOCALD=/home/mc404/usr

# #export LD_LIBRARY_PATH=$LOCALD/systemC/lib-linux64:${PWD}/robot_interface
# #export PATH=$PATH:$LOCALD/archC/bin

# ARCHC_INCLUDE_DIR=$LOCALD/archC/include/archc
# SYSTEMC_INCLUDE_DIR=$LOCALD/systemC/include
# ARCHC_LIB_DIR=$LOCALD/archC/lib
# SYSTEMC_LIB_DIR=$LOCALD/systemC/lib-linux64

# ROBOT_INCLUDE_DIR=$PWD/robot_interface
# ROBOT_LIB_DIR=$PWD/robot_interface

# SIM=armv7/build/src/armsim

# export CROSS_COMPILE=arm-eabi-


# DEST=/home/mc404/usr

# #########################################################


##########################################################
# EDITAR PARA OS CAMINHOS NA MAQUINA !

LOCALD=/home/specg12-1/mc404/simulador/deps/stage_deps

export LD_LIBRARY_PATH=$LOCALD/systemC/lib-linux64
export PATH=$PATH:$LOCALD/archC/bin:/home/specg12-1/mc404/simulador/arm-eabi-4.4.3/bin

ARCHC_INCLUDE_DIR=$LOCALD/archC/include/archc
SYSTEMC_INCLUDE_DIR=$LOCALD/systemC/include
ARCHC_LIB_DIR=$LOCALD/archC/lib
SYSTEMC_LIB_DIR=$LOCALD/systemC/lib-linux64

ROBOT_INCLUDE_DIR=$PWD/robot_interface
ROBOT_LIB_DIR=$PWD/robot_interface

SIM=armv7/build/src/armsim

export CROSS_COMPILE=arm-eabi-

DEST=/home/specg12-1/mc404/simulador/simulador_player

#########################################################





######################## ROBOT INTERFACE #############################

cd robot_interface

make

cp -r -v librobot.so /home/specg12-1/mc404/simulador/simulador_player/lib/libgpio.so


cd ..


######################### SIMULADOR ARM v7 ##########################

cd armv7/build


 ../configure CXXFLAGS="-I $ARCHC_INCLUDE_DIR -I $SYSTEMC_INCLUDE_DIR " LDFLAGS="-L $ARCHC_LIB_DIR -L $SYSTEMC_LIB_DIR -ldl  "

make

cp -r -v src/armsim $DEST/bin/armsim_player   
cp -r -v tools/ivtgen $DEST/bin/


cd ../..

######################## DUMBOOT ###################################

cd dumboot

make

cp -r -v dumboot.bin $DEST/bin/       # mover para pasta pasta da disciplina dos labs

cd ..


######################## ROBOT OS ##################################

cd robot_os

make CROSS_COMPILE=arm-eabi-

cp -r -v knrl $DEST/bin/      # mover para pasta pasta da disciplina dos labs

cd ..


######################## USER ASM #############################

cd test_userASM

SIM=armsim_player

MKSD=/home/specg12-1/mc404/simulador/simulador_player/bin/mksd.sh
OS=$DEST/bin/knrl


USER_ASM=motors+sonar.s
#USER_ASM=test_gpio_i.s

${CROSS_COMPILE}as $USER_ASM -o test.o
${CROSS_COMPILE}ld test.o -o test  -Ttext=0x77802000

$MKSD --so $OS --user test


