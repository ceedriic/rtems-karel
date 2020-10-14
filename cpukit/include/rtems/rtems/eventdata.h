/**
 * @file
 *
 * @ingroup ClassicEventImpl
 *
 * @brief This header file provides the API used by the Application
 *   Configuration to define the configured Thread Control Block (TCB).
 */

/* COPYRIGHT (c) 1989-2008.
 * On-Line Applications Research Corporation (OAR).
 *
 * The license and distribution terms for this file may be
 * found in the file LICENSE in this distribution or at
 * http://www.rtems.org/license/LICENSE.
 */

#ifndef _RTEMS_RTEMS_EVENTDATA_H
#define _RTEMS_RTEMS_EVENTDATA_H

#include <rtems/rtems/event.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @addtogroup ClassicEventImpl
 *
 * @{
 */

/**
 * @brief This structure is used to manage a set of events.
 */
typedef struct {
  /**
   * @brief The member contains the pending events.
   */
  rtems_event_set pending_events;
} Event_Control;

/** @} */

#ifdef __cplusplus
}
#endif

#endif
/* end of include file */
