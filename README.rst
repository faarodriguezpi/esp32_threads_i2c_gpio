.. _96b_carbon_multi_thread_blinky:

ESP32 I2C - GPIO's en Zephyr RTOS
####################

Overview
********

Este es un ejemplo para el sensor CJMCU-75 LM75A y el sensor GY-BMP280-3.3, via protocolo I2C, junto con la API para controlar los gpio, provisto por el sistema operativo Zephyr.

EL sistema utiliza dos hilos, cada uno de los cuales se encarga de una funcionalidad; de esta forma, el i2c es atendido por un hilo, mientras que el manejo de gpio es soportado por un segundo hilo.

Trabajan de forma sincronizada, mediante la utilización de ``k_mutex`` soportada por Zephyr.

Los hilos generan información para el usuario a través de la función ``printk``, y se puede observar el comportamiento por el puerto serial (usualmente USB0).




Pruebas del ejemplo
********************

Comando a correr::
    
    rm -rf build/
    west build -p auto -b esp32
    west flash

Change ``esp32`` de forma apropiada para soporte de otras boards.

Algunas veces es necesario hacer el flash mientras se mantiene el botón *Boot* para que el programa sea cargado.

En otra terminal::
    
    sudo minicom ttyUSB0 -s

Y el botón *En* para reiniciar el programa y su resultado.

Rutas de espressif en Zephyr
********************

Espressif se refiere al set de herramientas y toolchain para la ESP32, por lo cual es necesario indicarle al compilador las rutas de su ubicación.

En el directorio se encuentra el archivo CMakeLists.txt, allí se pueden colocar las variables de entorno para indicar las rutas del Toolchain de espressif - esp32.::

    set(ESPRESSIF_TOOLCHAIN_PATH "~/.espressif/tools/xtensa-esp32-elf/esp-2020r3-8.4.0/xtensa-esp32-elf/")
    set(ZEPHYR_TOOLCHAIN_VARIANT "espressif")

Por alguna razón, la siguiente variable debe esportarse expliícitamente en la terminal en que se trabaja::

    export ESP_IDF_PATH="${HOME}/esp/esp-idf"


Adicionalmente, este ejemplo contiene en /boards un archivo .overlay. Este permite sobreescribir algunas características, por lo que debe llevar el mismo nombre del archivo que se encuentra en el directorio de Zephyr/boards. O colocar un nombre, adicionando al archivo::

    set(DTC_OVERLAY_FILE "${CMAKE_CURRENT_SOURCE_DIR}/boards/esp32v1.overlay")



This example demonstrates spawning multiple threads using
:c:func:`K_THREAD_DEFINE`. It spawns three threads. Each thread is then defined
at compile time using K_THREAD_DEFINE.

The first two each control an LED. These LEDs, ``led0`` and ``led1``, have
loop control and timing logic controlled by separate functions.

- ``blink0()`` controls ``led0`` and has a 100ms sleep cycle
- ``blink1()`` controls ``led1`` and has a 1000ms sleep cycle

When either of these threads toggles its LED, it also pushes information into a
:ref:`FIFO <fifos_v2>` identifying the thread/LED and how many times it has
been toggled.

The third thread uses :c:func:`printk` to print the information added to the
FIFO to the device console.


