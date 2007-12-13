/*
 *  6.7.7 Cancel Asynchronous I/O Operation, P1003.1b-1993, p. 163
 *
 *  COPYRIGHT (c) 1989-2007.
 *  On-Line Applications Research Corporation (OAR).
 *
 *  The license and distribution terms for this file may be
 *  found in the file LICENSE in this distribution or at
 *  http://www.rtems.com/license/LICENSE.
 *
 *  $Id$
 */

#if HAVE_CONFIG_H
#include "config.h"
#endif

#include <aio.h>
#include <errno.h>

#include <rtems/system.h>
#include <rtems/seterr.h>

int aio_cancel(
  int            filedes,
  struct aiocb  *aiocbp
)
{
  rtems_set_errno_and_return_minus_one( ENOSYS );
}
