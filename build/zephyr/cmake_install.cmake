# Install script for directory: /home/alex/zephyrproject/zephyr

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/home/alex/.espressif/tools/xtensa-esp32-elf/esp-2020r3-8.4.0/xtensa-esp32-elf/bin/xtensa-esp32-elf-objdump")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/zephyr/arch/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/zephyr/lib/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/zephyr/soc/xtensa/esp32/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/zephyr/boards/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/zephyr/subsys/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/zephyr/drivers/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/cmsis/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/atmel/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/altera/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/canopennode/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/civetweb/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/esp-idf/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/fatfs/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/cypress/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/infineon/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/nordic/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/openisa/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/nuvoton/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/microchip/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/silabs/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/st/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/stm32/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/ti/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/libmetal/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/quicklogic/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/lvgl/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/mbedtls/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/mcumgr/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/nxp/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/open-amp/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/loramac-node/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/openthread/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/segger/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/tinycbor/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/tinycrypt/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/littlefs/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/mipi-sys-t/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/nrf_hw_models/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/xtensa/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/modules/tfm/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/zephyr/kernel/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/zephyr/cmake/flash/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/zephyr/cmake/usage/cmake_install.cmake")
  include("/home/alex/zephyrproject/zephyr/samples/threads2/build/zephyr/cmake/reports/cmake_install.cmake")

endif()
