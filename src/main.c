/*
 * Copyright (c) 2017 Linaro Limited
 *
 * SPDX-License-Identifier: Apache-2.0
 */
#include <errno.h>
#include <zephyr.h>

#if defined(CONFIG_STDOUT_CONSOLE)
#include <stdio.h>
#else
#include <sys/printk.h>
#endif

#include <device.h>
#include <devicetree.h>
#include <drivers/i2c.h>
#include <drivers/gpio.h>
#include <sys/printk.h>
#include <sys/__assert.h>
#include <stdarg.h>
#include <string.h>

#define I2C_DEV DT_LABEL(DT_ALIAS(i2c_0))
#define I2C_DEV1 DT_LABEL(DT_ALIAS(i2c_1))
#define LM75A_DEFAULT_ADDRESS   0x48
#define BMP280_DEFAULT_ADDRESS  0x76

/* size of stack area used by each thread */


/* scheduling priority used by each thread */


#define STACKSIZE 4096
#define PRIORITY 7
#define DT_DRV_COMPAT		espressif_esp32_gpio
#define SLEEP_TIME		10
#define LED_PIN		2

#define STACK_SIZE (768 + CONFIG_TEST_EXTRA_STACKSIZE)

static K_THREAD_STACK_ARRAY_DEFINE(stacks, 2, STACK_SIZE);
static struct k_thread threads[2];

K_MUTEX_DEFINE( cliblock );	

const float LM75A_DEGREES_RESOLUTION = 0.125;
const int LM75A_REG_ADDR_TEMP = 0;


void blink1(void *id, void *unused1, void *unused2)
{
	
	ARG_UNUSED(unused1);
	ARG_UNUSED(unused2);

	int my_id = POINTER_TO_INT(id);
	printk("Beginning execution; thread data is %d\n", my_id);

	const struct device *dev;
	bool led_on = true;
	int ret;
	
	dev = device_get_binding("GPIO_0");
	if(dev == NULL){
		return;
	}
	
	ret= gpio_pin_configure(dev, LED_PIN, GPIO_OUTPUT_ACTIVE);
	if(ret<0){
		return;
	}
	
	while (1){
	    k_mutex_lock(&cliblock, K_FOREVER);
		gpio_pin_set(dev, LED_PIN,  (int)led_on);
		printk("LED1 on\n");
		printk("LED2 %s\n", (led_on ? "on" : "off"));
		led_on = !led_on;

		//k_msleep(SLEEP_TIME);
		k_mutex_unlock(&cliblock);
	}

}

void temperatura(void *id, void *unused1, void *unused2)
{
	ARG_UNUSED(unused1);
	ARG_UNUSED(unused2);

	int my_id = POINTER_TO_INT(id);
	printk("Beginning execution; thread data is %d\n", my_id);




	const struct device *i2c_dev;
	const struct device *i2c_dev1;
	
	//uint8_t cmp_data[16];
	uint8_t data[16];
	//int i, 
	int ret;
	uint16_t temp = 0x00;
    uint8_t pointer = 0x00;

	i2c_dev = device_get_binding(I2C_DEV);
	i2c_dev1 = device_get_binding(I2C_DEV1);
	if (!i2c_dev1) {
		printk("I2C: Device driver not found.\n");
		return;
	}
	printk("----------->> -------------------- <<---------------\n");
    printk("---------->>   *** I2C LM75A ***   <<--------------\n\n");
	printk("I2C LM75A - Pruebas.\n");
	/* ----- */
	k_mutex_lock(&cliblock, K_FOREVER);
	pointer = 0x03; //Tos register pointer - 5000h por defecto
	i2c_write(i2c_dev, &pointer, 1, LM75A_DEFAULT_ADDRESS);
	k_msleep(5);
	ret = i2c_read(i2c_dev, &data[0], 2, LM75A_DEFAULT_ADDRESS);
	k_msleep(5);
	printk("----->> SetPoint - Tos Register: %x|%x\n\n", data[0], data[1]);
	
	pointer = 0x02; //Thyst register pointer - 4B00h por defecto
	i2c_write(i2c_dev, &pointer, 1, LM75A_DEFAULT_ADDRESS);
	k_msleep(5);
	ret = i2c_read(i2c_dev, &data[0], 2, LM75A_DEFAULT_ADDRESS);
	k_msleep(5);
	printk("----->> Hysteresis - Thyst Register: %x|%x\n\n", data[0], data[1]);
	
	pointer = 0x01; //Configuration register pointer - 00h por defecto
	i2c_write(i2c_dev, &pointer, 1, LM75A_DEFAULT_ADDRESS);
	k_msleep(5);
	ret = i2c_read(i2c_dev, &data[0], 1, LM75A_DEFAULT_ADDRESS);
	k_msleep(5);
	printk("----->>  Configuration - Register %x|%x\n\n", data[0], data[1]);
	
	
	//only 9 bits of the two bytes are used to store the set-point data in 2’s complement format with the resolution of 0.5 °C
	printk("----->>  Writing - Tos Register %x|%x\n", data[0], data[1]);
	pointer = 0x03;
	data[0] = pointer;
	temp = 24.5; //valor de setpoint que será enviado - resolución de 0.5°C solo si es float
	temp = temp*2; //dividir por 0.5 <=> multiplicar por 2
	data[1] = temp >> 8;//MSByte
	data[2] = (uint16_t)temp & 0x0F;//LSByte
	i2c_write(i2c_dev, &data[0], 3, LM75A_DEFAULT_ADDRESS);
	printk("----->>  Tos Register wrote temp: <%x>, MSByte <%x>, LSByte <%x>\n\n", temp, data[1], data[2]);
	k_msleep(5);
	
	//verificando el registro de Tos
	pointer = 0x03; //Tos register pointer - 5000h por defecto
	i2c_write(i2c_dev, &pointer, 1, LM75A_DEFAULT_ADDRESS);
	k_msleep(5);
	ret = i2c_read(i2c_dev, &data[0], 2, LM75A_DEFAULT_ADDRESS);
	k_msleep(5);
	printk("----->> SetPoint - Tos Register: %x|%x\n\n", data[0], data[1]);
	
	pointer = 0x00; // Temp register pointer
    i2c_write(i2c_dev, &pointer, 1, LM75A_DEFAULT_ADDRESS);
    // the pointer doesn't need to be set every i2c read. Once set, pointer is latched and the next readings will be made form the register pointed by pointer
    ret = 0;
    
    printk("----------->> -------------------- <<---------------\n");
    printk("---------->>   *** I2C BMP280 ***   <<--------------\n\n");
    
    
	pointer = 0xF7; //Tos register pointer - 5000h por defecto
	i2c_write(i2c_dev1, &pointer, 1, BMP280_DEFAULT_ADDRESS);
	
	k_msleep(5);
	ret = i2c_read(i2c_dev1, &data[0], 4, BMP280_DEFAULT_ADDRESS);
	k_msleep(5);
	printk("----->> presion %x temp %x\n\n", data[0], data[3]); // data[0] = 0xF7 reg info -  data[3] = 0xFA red info.
	
    k_mutex_unlock(&cliblock);
    
    
    ret = 0;
    while(1) {
        //int i2c_write(conststructdevice *dev, const uint8_t *buf, uint32_t num_bytes, uint16_t addr)
        
        // int i2c_read(const structdevice *dev, uint8_t *buf, uint32_t num_bytes, uint16_t addr)
        k_mutex_lock(&cliblock, K_FOREVER);
        ret = i2c_read(i2c_dev, &data[0], 2, LM75A_DEFAULT_ADDRESS);
        
        //int i2c_reg_read_byte(conststructdevice *dev, uint16_t dev_addr, uint8_t reg_addr, uint8_t *value)
        //ret = i2c_reg_read_byte(i2c_dev, LM75A_DEFAULT_ADDRESS, 0x00, &data[0]);
        
        if(~ret) {
            printk("Succesful read\n");
        }
        else {
            printk("Error read\n");
        }    
        
        printk("data[0]: %X data[1] %X \n", data[0], data[1]);
        
        temp = data[0] << 8 | (data[1] & 0x80 );
        temp = temp >> 5; //toma 11 MSBits. Como son 16 bits en temp, se debe hacer el corrimiento.
        temp = temp * LM75A_DEGREES_RESOLUTION;
        //temp = data[0] << 8 | data[1];
        printk("Temperatura en Celsius: %d\n", temp); //float not supported by printk
        //k_msleep(10);
        k_mutex_unlock(&cliblock);
    }
    	
	

}



static void start_threads(void)
{
	//Crear hilo 0	
	k_thread_create(&threads[0], &stacks[0][0], STACK_SIZE,
			blink1, INT_TO_POINTER(0), NULL, NULL,
			0, K_USER, K_FOREVER);
			
	
	
	k_thread_start(&threads[0]);
			
	k_thread_create(&threads[1], &stacks[1][0], STACK_SIZE,
			temperatura, INT_TO_POINTER(1), NULL, NULL,
			0, K_USER, K_FOREVER);
	
	k_thread_start(&threads[1]);
	
	k_object_access_grant(&cliblock, &threads[0]);
	k_object_access_grant(&cliblock, &threads[1]);
}

void main(void)
{
	//display_demo_description();

	#if CONFIG_TIMESLICING
	k_sched_time_slice_set(1000, 0); //antes 5000
#endif	
    	
	k_mutex_init(&cliblock);	//Inicializar Mutex	
	
	start_threads();
    
    #ifdef CONFIG_COVERAGE
	/* Wait a few seconds before main() exit, giving the sample the
	 * opportunity to dump some output before coverage data gets emitted
	 */
	k_sleep(K_MSEC(5000));
#endif

}


