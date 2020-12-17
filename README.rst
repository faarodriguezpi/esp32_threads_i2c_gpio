.. _96b_carbon_multi_thread_blinky:

ESP32 I2C - GPIO's en Zephyr RTOS
####################

Overview
********

Este es un ejemplo para el sensor CJMCU-75 LM75A y el sensor GY-BMP280-3.3, via protocolo I2C, junto con la API para controlar los gpio, provisto por el sistema operativo Zephyr.

EL sistema utiliza dos hilos, cada uno de los cuales se encarga de una funcionalidad; de esta forma, el i2c es atendido por un hilo, mientras que el manejo de gpio es soportado por un segundo hilo.

Trabajan de forma sincronizada, mediante la utilización de ``k_mutex`` soportada por Zephyr.

Los hilos generan información para el usuario a través de la función ``printk``, y se puede observar el comportamiento por el puerto serial (usualmente USB0).

Los detalles de la tarjeta usada, algunas características y demás se pueden encontrar acá: Tarjeta-ESP32_

.. _Tarjeta-ESP32: https://randomnerdtutorials.com/esp32-pinout-reference-gpios/

Pruebas del ejemplo
********************

Comando a correr::
    
    rm -rf build/
    west build -p auto -b esp32
    west flash

Cambiar ``esp32`` para soporte de otras boards.

Algunas veces es necesario hacer el flash mientras se mantiene el botón **Boot** para que el programa sea cargado.

En otra terminal::
    
    sudo minicom ttyUSB0 -s

Y el botón **En** para reiniciar el programa y ver su resultado.

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

Hilos
******

La función ``static void start_threads(void)`` es la que realiza la creación de los dos hilos, mientras que con ``k_object_access_grant`` se garantiza acceso al elemento de sincronización *kmutex*. 

Los hilos tienen la misma prioridad, por lo cual se espera que cumplan cada uno con un tiempo de Slicing (en main() #if CONFIG_TIMESLICING). No se ha revisado con certeza si los kmutex bloquean o alargan ese timeSlicing, o si una vez pasado ese tiempo, el *Scheduler* le da paso al otro hilo. Lo mas probable es que mientras el hilo en ejecución no suelte al *mutex*, el otro hilo no pueda hacer ejecución alguna.

Función blink1
============

Esta función trabaja con los *gpio's* de manera que hace una configuración inicial, para posteriormente tomar el mutex, realizar su rutina en el while, para posteriormente soltar el mutex.

Función temperatura
============

Esta función trabaja con los *i2c*, usando las funciones provistas por Zephyr. En el inicio se hacen algunas pruebas de escritura y lectura, pero la lectura de temperatura se  hace realmente en el while, usando la interface i2c0. Esta lectura se puede hacer inmediatamente es energizado el sensor LM75A.

Asi mismo, se encuentra un par de lecturas del BMP280, usando  la interface i2c1 (debe ser activada en el ``prj.conf`` explicitamente). Esta interface tambien depende del archivo ``.overlay`` en la carpeta *boards*. Las lecturas realizadas en el sensor solo indican el *ID*, pero es necesario realizar una serie de compensaciones que no han sido implementadas, pueden ser encontradas en una API_ provista por Bosch.
.. _API: https://github.com/BoschSensortec/BMP280_driver


Acá el sensor BMP280 con su pinout_.
.. _pinout: https://startingelectronics.org/pinout/GY-BMP280-pressure-sensor-module/

Otros Enlaces
*********

`Primeros pasos con ESP32 (en portugués) <https://www.embarcados.com.br/zephyr-rtos-no-esp32-primeiros-passos/>`_.

`Esquemático y detalles del LM75 <https://github.com/hpaluch/i2c-cjmcu-75>`_.

`Explicación e integración API BMP280 <http://electronicayciencia.blogspot.com/2018/10/la-presion-atmosferica-bmp280.html>`_. 

`Estructura del DTS en Zephyr <https://docs.zephyrproject.org/latest/guides/dts/howtos.html#get-a-struct-device-from-a-devicetree-node>`_. 

`Punteros y funciones en C <https://es.slideshare.net/CesarOsorio2/punteros-y-funciones>`_.
`Readme en RST <https://github.com/ralsina/rst-cheatsheet/blob/master/rst-cheatsheet.rst>`_.

`Instalación de herramientas ESP32 <https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html>`_.  -> estos pasos instalan el toolchain en una ubicación por defecto en $HOME (ctrl + H para ver carpeta *.espressif*). Si se quiere instalar en otra ubicación, ir al enlace a continuación.

`Python <https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/linux-setup-scratch.html>`_. -> Toolchain ESP32 en otra ubicación, from scratch.

`Python <http://www.python.org/>`_.


--
====


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


