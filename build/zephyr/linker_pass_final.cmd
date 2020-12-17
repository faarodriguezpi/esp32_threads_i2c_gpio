PROVIDE ( __stack = 0x3ffe3f20 );
PROVIDE ( esp32_rom_uart_tx_one_char = 0x40009200 );
PROVIDE ( esp32_rom_uart_rx_one_char = 0x400092d0 );
PROVIDE ( esp32_rom_uart_attach = 0x40008fd0 );
PROVIDE ( esp32_rom_uart_tx_wait_idle = 0x40009278 );
PROVIDE ( esp32_rom_intr_matrix_set = 0x4000681c );
PROVIDE ( esp32_rom_gpio_matrix_in = 0x40009edc );
PROVIDE ( esp32_rom_gpio_matrix_out = 0x40009f0c );
PROVIDE ( esp32_rom_Cache_Flush = 0x40009a14 );
PROVIDE ( esp32_rom_Cache_Read_Enable = 0x40009a84 );
PROVIDE ( esp32_rom_ets_set_appcpu_boot_addr = 0x4000689c );
PROVIDE ( esp32_rom_i2c_readReg = 0x40004148 );
PROVIDE ( esp32_rom_i2c_writeReg = 0x400041a4 );
MEMORY
{
  iram0_0_seg(RX): org = 0x40080000, len = 0x20000
  iram0_2_seg(RX): org = 0x400D0018, len = 0x330000
  dram0_0_seg(RW): org = 0x3FFB0000, len = 0x50000
  drom0_0_seg(R): org = 0x3F400010, len = 0x800000
  rtc_iram_seg(RWX): org = 0x400C0000, len = 0x2000
  rtc_slow_seg(RW): org = 0x50000000, len = 0x1000
  IDT_LIST(RW): org = 0x3ebfe010, len = 0x2000
}
PHDRS
{
  iram0_0_phdr PT_LOAD;
  dram0_0_phdr PT_LOAD;
}
PROVIDE ( _ResetVector = 0x40000400 );
ENTRY("__start")
_rom_store_table = 0;
PROVIDE(_memmap_vecbase_reset = 0x40000450);
PROVIDE(_memmap_reset_vector = 0x40000400);
SECTIONS
{
 .rel.plt :
 {
 *(.rel.plt)
 PROVIDE_HIDDEN (__rel_iplt_start = .);
 *(.rel.iplt)
 PROVIDE_HIDDEN (__rel_iplt_end = .);
 }
 .rela.plt :
 {
 *(.rela.plt)
 PROVIDE_HIDDEN (__rela_iplt_start = .);
 *(.rela.iplt)
 PROVIDE_HIDDEN (__rela_iplt_end = .);
 }
 .rel.dyn :
 {
 *(.rel.*)
 }
 .rela.dyn :
 {
 *(.rela.*)
 }
  .rtc.text :
  {
    . = ALIGN(4);
    *(.rtc.literal .rtc.text)
    *rtc_wake_stub*.o(.literal .text .literal.* .text.*)
  } >rtc_iram_seg
  .rtc.data :
  {
    _rtc_data_start = ABSOLUTE(.);
    *(.rtc.data)
    *(.rtc.rodata)
    *rtc_wake_stub*.o(.data .rodata .data.* .rodata.* .bss .bss.*)
    _rtc_data_end = ABSOLUTE(.);
  } > rtc_slow_seg
  .rtc.bss (NOLOAD) :
  {
    _rtc_bss_start = ABSOLUTE(.);
    *rtc_wake_stub*.o(.bss .bss.*)
    *rtc_wake_stub*.o(COMMON)
    _rtc_bss_end = ABSOLUTE(.);
  } > rtc_slow_seg
  .iram0.vectors : ALIGN(4)
  {
    _init_start = ABSOLUTE(.);
    . = 0x0;
    KEEP(*(.WindowVectors.text));
    . = 0x180;
    KEEP(*(.Level2InterruptVector.text));
    . = 0x1c0;
    KEEP(*(.Level3InterruptVector.text));
    . = 0x200;
    KEEP(*(.Level4InterruptVector.text));
    . = 0x240;
    KEEP(*(.Level5InterruptVector.text));
    . = 0x280;
    KEEP(*(.DebugExceptionVector.text));
    . = 0x2c0;
    KEEP(*(.NMIExceptionVector.text));
    . = 0x300;
    KEEP(*(.KernelExceptionVector.text));
    . = 0x340;
    KEEP(*(.UserExceptionVector.text));
    . = 0x3C0;
    KEEP(*(.DoubleExceptionVector.text));
    . = 0x400;
    *(.*Vector.literal)
    *(.UserEnter.literal);
    *(.UserEnter.text);
    . = ALIGN (16);
    *(.entry.text)
    *(.init.literal)
    *(.init)
    _init_end = ABSOLUTE(.);
    _iram_start = ABSOLUTE(0);
  } > iram0_0_seg :iram0_0_phdr
 devices :
 {
  __device_start = .;
  __device_PRE_KERNEL_1_start = .; KEEP(*(SORT(.device_PRE_KERNEL_1[0-9]*))); KEEP(*(SORT(.device_PRE_KERNEL_1[1-9][0-9]*)));
  __device_PRE_KERNEL_2_start = .; KEEP(*(SORT(.device_PRE_KERNEL_2[0-9]*))); KEEP(*(SORT(.device_PRE_KERNEL_2[1-9][0-9]*)));
  __device_POST_KERNEL_start = .; KEEP(*(SORT(.device_POST_KERNEL[0-9]*))); KEEP(*(SORT(.device_POST_KERNEL[1-9][0-9]*)));
  __device_APPLICATION_start = .; KEEP(*(SORT(.device_APPLICATION[0-9]*))); KEEP(*(SORT(.device_APPLICATION[1-9][0-9]*)));
  __device_SMP_start = .; KEEP(*(SORT(.device_SMP[0-9]*))); KEEP(*(SORT(.device_SMP[1-9][0-9]*)));
  __device_end = .;
  FILL(0x00); __device_init_status_start = .; . = . + (((((__device_end - __device_start) / 0x10) + 31) / 32) * 4); __device_init_status_end = .;
 
 } > dram0_0_seg :dram0_0_phdr
 initshell :
 {
  __shell_module_start = .;
  KEEP(*(".shell_module_*"));
  __shell_module_end = .;
  __shell_cmd_start = .;
  KEEP(*(".shell_cmd_*"));
  __shell_cmd_end = .;
 } > dram0_0_seg :dram0_0_phdr
 log_dynamic_sections :
 {
  __log_dynamic_start = .;
  KEEP(*(SORT(.log_dynamic_*)));
  __log_dynamic_end = .;
 } > dram0_0_seg :dram0_0_phdr
 _static_thread_data_area : SUBALIGN(4) { __static_thread_data_list_start = .; KEEP(*(SORT(.__static_thread_data.static.*))); __static_thread_data_list_end = .; } > dram0_0_seg :dram0_0_phdr
 k_timer_area : SUBALIGN(4) { _k_timer_list_start = .; KEEP(*(SORT(._k_timer.static.*))); _k_timer_list_end = .; } > dram0_0_seg :dram0_0_phdr
 k_mem_slab_area : SUBALIGN(4) { _k_mem_slab_list_start = .; KEEP(*(SORT(._k_mem_slab.static.*))); _k_mem_slab_list_end = .; } > dram0_0_seg :dram0_0_phdr
 k_mem_pool_area : SUBALIGN(4) { _k_mem_pool_list_start = .; KEEP(*(SORT(._k_mem_pool.static.*))); _k_mem_pool_list_end = .; } > dram0_0_seg :dram0_0_phdr
 k_heap_area : SUBALIGN(4) { _k_heap_list_start = .; KEEP(*(SORT(._k_heap.static.*))); _k_heap_list_end = .; } > dram0_0_seg :dram0_0_phdr
 k_mutex_area : SUBALIGN(4) { _k_mutex_list_start = .; KEEP(*(SORT(._k_mutex.static.*))); _k_mutex_list_end = .; } > dram0_0_seg :dram0_0_phdr
 k_stack_area : SUBALIGN(4) { _k_stack_list_start = .; KEEP(*(SORT(._k_stack.static.*))); _k_stack_list_end = .; } > dram0_0_seg :dram0_0_phdr
 k_msgq_area : SUBALIGN(4) { _k_msgq_list_start = .; KEEP(*(SORT(._k_msgq.static.*))); _k_msgq_list_end = .; } > dram0_0_seg :dram0_0_phdr
 k_mbox_area : SUBALIGN(4) { _k_mbox_list_start = .; KEEP(*(SORT(._k_mbox.static.*))); _k_mbox_list_end = .; } > dram0_0_seg :dram0_0_phdr
 k_pipe_area : SUBALIGN(4) { _k_pipe_list_start = .; KEEP(*(SORT(._k_pipe.static.*))); _k_pipe_list_end = .; } > dram0_0_seg :dram0_0_phdr
 k_sem_area : SUBALIGN(4) { _k_sem_list_start = .; KEEP(*(SORT(._k_sem.static.*))); _k_sem_list_end = .; } > dram0_0_seg :dram0_0_phdr
 k_queue_area : SUBALIGN(4) { _k_queue_list_start = .; KEEP(*(SORT(._k_queue.static.*))); _k_queue_list_end = .; } > dram0_0_seg :dram0_0_phdr
 _net_buf_pool_area : SUBALIGN(4)
 {
  _net_buf_pool_list = .;
  KEEP(*(SORT("._net_buf_pool.static.*")))
 } > dram0_0_seg :dram0_0_phdr
 initlevel :
 {
  __init_start = .;
  __init_PRE_KERNEL_1_start = .; KEEP(*(SORT(.init_PRE_KERNEL_1[0-9]*))); KEEP(*(SORT(.init_PRE_KERNEL_1[1-9][0-9]*)));
  __init_PRE_KERNEL_2_start = .; KEEP(*(SORT(.init_PRE_KERNEL_2[0-9]*))); KEEP(*(SORT(.init_PRE_KERNEL_2[1-9][0-9]*)));
  __init_POST_KERNEL_start = .; KEEP(*(SORT(.init_POST_KERNEL[0-9]*))); KEEP(*(SORT(.init_POST_KERNEL[1-9][0-9]*)));
  __init_APPLICATION_start = .; KEEP(*(SORT(.init_APPLICATION[0-9]*))); KEEP(*(SORT(.init_APPLICATION[1-9][0-9]*)));
  __init_SMP_start = .; KEEP(*(SORT(.init_SMP[0-9]*))); KEEP(*(SORT(.init_SMP[1-9][0-9]*)));
  __init_end = .;
 } > iram0_0_seg :iram0_0_phdr
 sw_isr_table :
 {
  . = ALIGN(0);
  *(.gnu.linkonce.sw_isr_table*)
 } > iram0_0_seg :iram0_0_phdr
 initlevel_error :
 {
  KEEP(*(SORT(.init_[_A-Z0-9]*)))
 }
 ASSERT(SIZEOF(initlevel_error) == 0, "Undefined initialization levels used.")
 app_shmem_regions :
 {
  __app_shmem_regions_start = .;
  KEEP(*(SORT(.app_regions.*)));
  __app_shmem_regions_end = .;
 } > iram0_0_seg :iram0_0_phdr
 bt_l2cap_fixed_chan_area : SUBALIGN(4) { _bt_l2cap_fixed_chan_list_start = .; KEEP(*(SORT(._bt_l2cap_fixed_chan.static.*))); _bt_l2cap_fixed_chan_list_end = .; } > iram0_0_seg :iram0_0_phdr
 bt_gatt_service_static_area : SUBALIGN(4) { _bt_gatt_service_static_list_start = .; KEEP(*(SORT(._bt_gatt_service_static.static.*))); _bt_gatt_service_static_list_end = .; } > iram0_0_seg :iram0_0_phdr
 log_const_sections :
 {
  __log_const_start = .;
  KEEP(*(SORT(.log_const_*)));
  __log_const_end = .;
 } > iram0_0_seg :iram0_0_phdr
 log_backends_sections :
 {
  __log_backends_start = .;
  KEEP(*("._log_backend.*"));
  __log_backends_end = .;
 } > iram0_0_seg :iram0_0_phdr
 shell_area : SUBALIGN(4) { _shell_list_start = .; KEEP(*(SORT(._shell.static.*))); _shell_list_end = .; } > iram0_0_seg :iram0_0_phdr
 shell_root_cmds_sections :
 {
  __shell_root_cmds_start = .;
  KEEP(*(SORT(.shell_root_cmd_*)));
  __shell_root_cmds_end = .;
 } > iram0_0_seg :iram0_0_phdr
 font_entry_sections :
 {
  __font_entry_start = .;
  KEEP(*(SORT("._cfb_font.*")))
  __font_entry_end = .;
 } > iram0_0_seg :iram0_0_phdr
 tracing_backend_area : SUBALIGN(4) { _tracing_backend_list_start = .; KEEP(*(SORT(._tracing_backend.static.*))); _tracing_backend_list_end = .; } > iram0_0_seg :iram0_0_phdr
  text : ALIGN(4)
  {
    _iram_text_start = ABSOLUTE(.);
    *(.iram1 .iram1.*)
    *(.iram0.literal .iram.literal .iram.text.literal .iram0.text .iram.text)
    *(.literal .text .literal.* .text.*)
    _iram_text_end = ABSOLUTE(.);
  } > iram0_0_seg :iram0_0_phdr
  .dram0.data :
  {
    _data_start = ABSOLUTE(.);
    *(.data)
    *(.data.*)
    *(.gnu.linkonce.d.*)
    *(.data1)
    *(.sdata)
    *(.sdata.*)
    *(.gnu.linkonce.s.*)
    *(.sdata2)
    *(.sdata2.*)
    *(.gnu.linkonce.s2.*)
    KEEP(*(.jcr))
    *(.dram1 .dram1.*)
    _data_end = ABSOLUTE(.);
    . = ALIGN(4);
  } > dram0_0_seg :dram0_0_phdr
  rodata : ALIGN(4)
  {
    _rodata_start = ABSOLUTE(.);
    *(.rodata)
    *(.rodata.*)
    *(.gnu.linkonce.r.*)
    *(.rodata1)
    __XT_EXCEPTION_TABLE__ = ABSOLUTE(.);
    KEEP (*(.xt_except_table))
    KEEP (*(.gcc_except_table .gcc_except_table.*))
    *(.gnu.linkonce.e.*)
    *(.gnu.version_r)
    KEEP (*(.eh_frame))
    KEEP (*crtbegin.o(.ctors))
    KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
    KEEP (*crtbegin.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
    __XT_EXCEPTION_DESCS__ = ABSOLUTE(.);
    *(.xt_except_desc)
    *(.gnu.linkonce.h.*)
    __XT_EXCEPTION_DESCS_END__ = ABSOLUTE(.);
    *(.xt_except_desc_end)
    *(.dynamic)
    *(.gnu.version_d)
    . = ALIGN(4);
    _rodata_end = ABSOLUTE(.);
  } > dram0_0_seg :dram0_0_phdr
  bss (NOLOAD) :
  {
    . = ALIGN (8);
    _bss_start = ABSOLUTE(.);
    *(.dynsbss)
    *(.sbss)
    *(.sbss.*)
    *(.gnu.linkonce.sb.*)
    *(.scommon)
    *(.sbss2)
    *(.sbss2.*)
    *(.gnu.linkonce.sb2.*)
    *(.dynbss)
    *(.bss)
    *(.bss.*)
    *(.share.mem)
    *(.gnu.linkonce.b.*)
    *(COMMON)
    . = ALIGN (8);
    _bss_end = ABSOLUTE(.);
  } > dram0_0_seg :dram0_0_phdr
   app_noinit (NOLOAD) :
   {
     . = ALIGN (8);
     *(.app_noinit)
     *("app_noinit.*")
     . = ALIGN (8);
    _app_end = ABSOLUTE(.);
  } > dram0_0_seg :dram0_0_phdr
  noinit (NOLOAD) :
  {
    . = ALIGN (8);
    *(.noinit)
    *(".noinit.*")
    . = ALIGN (8);
    _heap_start = ABSOLUTE(.);
  } > dram0_0_seg :dram0_0_phdr
/DISCARD/ :
{
 KEEP(*(.irq_info*))
 KEEP(*(.intList*))
}
 .stab 0 : { *(.stab) }
 .stabstr 0 : { *(.stabstr) }
 .stab.excl 0 : { *(.stab.excl) }
 .stab.exclstr 0 : { *(.stab.exclstr) }
 .stab.index 0 : { *(.stab.index) }
 .stab.indexstr 0 : { *(.stab.indexstr) }
 .gnu.build.attributes 0 : { *(.gnu.build.attributes .gnu.build.attributes.*) }
 .comment 0 : { *(.comment) }
 .debug 0 : { *(.debug) }
 .line 0 : { *(.line) }
 .debug_srcinfo 0 : { *(.debug_srcinfo) }
 .debug_sfnames 0 : { *(.debug_sfnames) }
 .debug_aranges 0 : { *(.debug_aranges) }
 .debug_pubnames 0 : { *(.debug_pubnames) }
 .debug_info 0 : { *(.debug_info .gnu.linkonce.wi.*) }
 .debug_abbrev 0 : { *(.debug_abbrev) }
 .debug_line 0 : { *(.debug_line .debug_line.* .debug_line_end ) }
 .debug_frame 0 : { *(.debug_frame) }
 .debug_str 0 : { *(.debug_str) }
 .debug_loc 0 : { *(.debug_loc) }
 .debug_macinfo 0 : { *(.debug_macinfo) }
 .debug_weaknames 0 : { *(.debug_weaknames) }
 .debug_funcnames 0 : { *(.debug_funcnames) }
 .debug_typenames 0 : { *(.debug_typenames) }
 .debug_varnames 0 : { *(.debug_varnames) }
 .debug_pubtypes 0 : { *(.debug_pubtypes) }
 .debug_ranges 0 : { *(.debug_ranges) }
 .debug_macro 0 : { *(.debug_macro) }
  .xtensa.info 0 :
  {
    *(.xtensa.info)
  }
}
