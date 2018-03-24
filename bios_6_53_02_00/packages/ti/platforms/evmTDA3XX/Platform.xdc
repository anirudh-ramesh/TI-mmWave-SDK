/*
 * Copyright (c) 2016, Texas Instruments Incorporated
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * *  Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * *  Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * *  Neither the name of Texas Instruments Incorporated nor the names of
 *    its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 *  ======== Platform.xdc ========
 *  Platform support for TDA3XX
 *
 */

/*!
 *  ======== Platform ========
 *  Platform support for TDA3XX
 *
 *  This module implements xdc.platform.IPlatform and defines configuration
 *  parameters that correspond to this platform's Cpu's, Board's, etc.
 *
 *  The configuration parameters are initialized in this package's
 *  configuration script (package.cfg) and "bound" to the TCOM object
 *  model.  Once they are part of the model, these parameters are
 *  queried by a program's configuration script.
 *
 *  This particular platform has 1 EVE, 1 Benelli/IPU sub-system (Dual M4's)
 *  and 2 C66x DSP's.
 */
metaonly module Platform inherits xdc.platform.IPlatform
{
    readonly config xdc.platform.IPlatform.Board BOARD = {
        id:             "0",
        boardName:      "evmTDA3XX",
        boardFamily:    "evmTDA3XX",
        boardRevision:  null,
    };

    readonly config xdc.platform.IExeContext.Cpu DSP = {
        id:             "0",
        clockRate:      600.0,
        catalogName:    "ti.catalog.c6000",
        deviceName:     "TDA3XX",
        revision:       "1.0",
    };

    /* Benelli M4 Subsystem */
    readonly config xdc.platform.IExeContext.Cpu M4 = {
        id:             "1",
        clockRate:      212.8,
        catalogName:    "ti.catalog.arm.cortexm4",
        deviceName:     "TDA3XX",
        revision:       "1.0",
    };

    /* EVE */
    readonly config xdc.platform.IExeContext.Cpu EVE = {
        id:             "2",
        clockRate:      535.0,
        catalogName:    "ti.catalog.arp32",
        deviceName:     "TDA3XX",
        revision:       "1.0"
    };

instance:

    /*!
     *  ======== externalMemoryMap ========
     *  Memory regions as defined in the TDA3XX Specification
     */
    override readonly config xdc.platform.IPlatform.Memory
        externalMemoryMap[string] = [
            ["EXT_RAM", {
                comment: "1 GB External RAM Memory",
                name: "EXT_RAM",
                base: 0x80000000,
                len:  0x40000000
            }]
        ];

    /*
     *  ======== l1PMode ========
     *  Define the amount of L1P RAM used for L1 Program Cache.
     *
     *  Check the device documentation for valid values.
     */
    config String l1PMode = "32k";

    /*
     *  ======== l1DMode ========
     *  Define the amount of L1D RAM used for L1 Data Cache.
     *
     *  Check the device documentation for valid values.
     */
    config String l1DMode = "32k";

    /*
     *  ======== l2Mode ========
     *  Define the amount of L2 RAM used for L2 Cache.
     *
     *  Check the device documentation for valid values.
     */
    config String l2Mode = "0k";
};
