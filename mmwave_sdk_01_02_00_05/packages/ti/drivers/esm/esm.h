/*
 * Copyright (c) 2015, Texas Instruments Incorporated
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
/** ============================================================================
*  @file       esm.h
*
*  @brief      ESM driver interface
*
*/

/** @mainpage ESM Driver
*
*  The ESM driver provides APIs to configure and handle errors coming from the ESM H/W module
*
*  The ESM header file should be included in an application as follows:
*  @code
*  #include <ti/drivers/esm/esm.h>
*  @endcode
*
*  ## Initializing the driver #
*  The ESM Driver is initialized using the #ESM_init.
*  None of the ESM API can be used without invoking
*  this API. <br>
*  **Note**: If you using TI RTOS, then ESM errors are cleared before
*        entering main and this flag can be set to 0. For any other RTOS, check the
*        the RTOS implementation or set this flag to 1
*
*  ## Using the driver #
*  Following is a psuedo code for using the ESM driver
*
*  @code
*
  ESM_init(0); //ClearErrors is set to 0 i.e. false

  *  @endcode
*
*  ## Handling Interrupts on MSS#
*  The ESM drivers when run on R4F, registers for high priority FIQ to handle the MSS ESM errors.
*  When ESM errors occurs on DSS, the MSS is notified via a Group2 error signal. The ESM driver
*  registers for low priority IRQ to handle these errors.
*

*  ## Handling Interrupts on DSS#
*  The DSS ESM errors have to be unmasked for them to generate an NMI. Note: This is applicable for xWR16xx DSS only.
*  The API #SOC_configureDSSESMMask is provided. Drivers/Applications will have to unmask the bits for the error
*  signals it is interested in. e.g., Watchdog driver internally unmasks the watchdog expiry NMI
*  error bits to generate the NMI.
*
*  The DSS ESM errors generate a NMI that is first captured by the RTOS NMI exception handler.
*  Hence applications have to populate the NMI exception handler to use the ESM driver's high
*  priority FIQ processing API in the .cfg file.
 *
 *  @code
 *
     Exception.nmiHook           = "&ESM_highpriority_FIQ";

 *  @endcode

*  ## Registering the notifiers #
*  The application can register callback functions for the ESM errors that need additional handling. One
*  such example is the watch dog timeout on the DSS.
*  When the watchdog timeout causes a NMI to occur on DSS, that event inturn generates a group1 ESM error
*  on the MSS. The application can register a callback using the ESM notifier to handle these errors.
*

*  ## Instrumentation #
*  Uses DebugP_log functions for debug messages
*
*  ## Hardware Register Map #
*  The hardware register map used by this driver can be found at include/reg_esm.h
*
*  ============================================================================
*/
/**
@defgroup ESM_DRIVER_EXTERNAL_FUNCTION            ESM Driver External Functions
@ingroup ESM_DRIVER
@brief
*   The section has a list of all the exported API which the applications need to
*   invoke in order to use the driver
*/
/**
@defgroup ESM_DRIVER_EXTERNAL_DATA_STRUCTURE      ESM Driver External Data Structures
@ingroup ESM_DRIVER
@brief
*   The section has a list of all the data structures which are exposed to the application
*/

/**
@defgroup ESM_DRIVER_ERROR_CODE                   ESM Driver Error Codes
@ingroup ESM_DRIVER
@brief
*   The section has a list of all the error codes which are generated by the ESM Driver
*   module
*/
#ifndef ti_drivers_esm__include
#define ti_drivers_esm__include

#ifdef __cplusplus
    extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>
#include <ti/common/mmwave_error.h>


/** @addtogroup ESM_DRIVER_ERROR_CODE
 *
 * @brief
 *  Base error code for the ESM module is defined in the
 *  \include ti/common/mmwave_error.h
 *
 @{ */

/**
 * @brief   Error Code: Invalid argument
 */
#define ESM_EINVAL                 (MMWAVE_ERRNO_ESM_BASE-1)

/**
 * @brief   Error Code: Operation cannot be done as ESM_init is not done.
 */
#define ESM_ENOINIT                (MMWAVE_ERRNO_ESM_BASE-2)

/**
 * @brief   Error Code: Operation cannot be done as ESM_init is already done and re-init is not permitted
 */
#define ESM_EREINIT                (MMWAVE_ERRNO_ESM_BASE-3)

/**
 * @brief   Error Code: Out of memory
 */
#define ESM_ENOMEM                  (MMWAVE_ERRNO_SOC_BASE-4)

/** @}*/

/** @addtogroup CAN_DRIVER_EXTERNAL_DATA_STRUCTURE
 @{ */


/*!
 *  @brief      ESM module handle returned by the ESM_init() API call.
 */
typedef void* ESM_Handle;

/**
 * @brief
 * Callback function which is invoked by the ESM module if a notify function is registered
 * using the ESM_registerNotifier() API.
 *
 *  @param[in]  arg
 *      Argument passed back when the Notify function is invoked.
 *
 *  @retval
 *      Not applicable
 */
typedef void (*ESM_CallBack)(void* arg);

/*!
 * @brief
 *  Parameters used to register the ESM notify function to handle
 *  Group1 and Group2 errors. The notify function will be invoked post
 *  the ESM FIQ interrupt handler processing.
 */
typedef struct ESM_NotifyParams_t
{
    /*! Group number to which the following error number belongs. */
    uint32_t            groupNumber;

    /*! Error number for which the notify function is registered. */
    uint32_t            errorNumber;

    /*! Argument passed back when the Notify function is invoked. */
    void*               arg;

    /*! Notify function called by the ESM driver. */
    ESM_CallBack        notify;
} ESM_NotifyParams;

/** @}*/

/** @addtogroup ESM_DRIVER_EXTERNAL_FUNCTION
 *
 * @brief
 *  External APIs for ESM driver
 *
 @{ */


/** @brief Function intializes the ESM driver
*
*    @param[in] bClearErrors: boolean value to indicate if old ESM pending errors should be cleared or not
*                             value = 0: do not clear
*                             value = 1: clear all ESM group errors
*                             hint: If you using TI RTOS, then ESM errors are cleared before
*                                   entering main and this flag can be set to 0. For any other RTOS, check the
*                                   the RTOS implementation or set this flag to 1
*
*    @return    Success -   Handle to the ESM Driver
*               Error   -   NULL
*
*/
extern ESM_Handle ESM_init(uint8_t bClearErrors);

/** @fn int32_t ESM_close(void)
*   @brief Close the ESM driver
*
*    @param[in] handle: Handle to the ESM Driver
*
*
*    @return    Value < 0 - in case of error
*               Value > 0 - Success
*
*/
extern int32_t ESM_close(ESM_Handle handle);

/** @brief Register the notifers the ESM module will call back if error interrupt is detected.
*
*   @param[in] handle: Handle to the ESM Driver.
*
*   @param[in] params: Notifier error number and callback function.
*
*   @param[out]  errCode
*      Error code populated on error.
*
*    @return    Success -   Notifier index. Used when deregistering the notifier.
*               Error   -   ESM Error code
*
*/
extern int32_t ESM_registerNotifier(ESM_Handle handle, ESM_NotifyParams* params, int32_t* errCode);

/** @brief Deregister the ESM notifers.
*
*   @param[in] handle: Handle to the ESM Driver.
*
*   @param[in] notifyIndex: Notifier index returned when the notifier was registered.
*
*   @param[out]  errCode
*      Error code populated on error.
*
*    @return    Success -   0
*               Error   -   ESM Error code
*
*/
extern int32_t ESM_deregisterNotifier(ESM_Handle handle, int32_t notifyIndex, int32_t* errCode);
/** @}*/


#ifdef __cplusplus
}
#endif

#endif /* ti_drivers_esm__include */

