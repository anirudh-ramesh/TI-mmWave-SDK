/*----------------------------------------------------------------------------*/
/* Linker Settings                                                            */
--retain="*(.intvecs)"

/*----------------------------------------------------------------------------*/
/* Section Configuration                                                      */
SECTIONS
{
    systemHeap      : { } > DATA_RAM
    .MCPILogBuffer  : { } > DATA_RAM
    .l3Data         : { } > L3_RAM
}
/*----------------------------------------------------------------------------*/

