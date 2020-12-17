# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 3.13.1)

set(DTC_OVERLAY_FILE "${CMAKE_CURRENT_SOURCE_DIR}/boards/esp32v1.overlay") #este comando se debe colocar antes de practicamente todo, para que agarre la variable       

set(ESPRESSIF_TOOLCHAIN_PATH "~/.espressif/tools/xtensa-esp32-elf/esp-2020r3-8.4.0/xtensa-esp32-elf/")
#set(ESP_IDF_PATH "${HOME}/esp/esp-idf") #para despues hacer 'west flash' no funciona. Toca con   export ESP_IDF_PATH="${HOME}/esp/esp-idf"
set(ZEPHYR_TOOLCHAIN_VARIANT "espressif")

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(i2c_LM75A)

FILE(GLOB app_sources src/*.c)
target_sources(app PRIVATE ${app_sources})
