/* SPDX-License-Identifier: BSD-2-Clause */

/*
 *  COPYRIGHT (c) 1989-2013.
 *  On-Line Applications Research Corporation (OAR).
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <errno.h>
#include <fcntl.h>
#include <semaphore.h>
#include <tmacros.h>
#include <timesys.h>
#include "test_support.h"
#include <pthread.h>
#include <sched.h>
#include <rtems/btimer.h>

const char rtems_test_name[] = "PSXTMSEM 04";

/* forward declarations to avoid warnings */
void *POSIX_Init(void *argument);
void *Blocker(void *argument);

#define MAX_SEMS  2

sem_t           sem1;
sem_t           *n_sem1;

void *Blocker( void *argument)
{
  (void) sem_wait(&sem1);
  /* should never return */
  rtems_test_assert( FALSE );

  return NULL;
}

void *POSIX_Init(void *argument)
{
  int        status;
  pthread_t  threadId;
  benchmark_timer_t end_time;

  TEST_BEGIN();

  status = pthread_create( &threadId, NULL, Blocker, NULL );
  rtems_test_assert( status == 0 );
  
  /*
   * Deliberately create the semaphore after the threads.  This way if the
   * threads do run before we intend, they will get an error.
   */
  status = sem_init( &sem1, 0, 1 );
  rtems_test_assert( status == 0 );

  /*
   * Ensure the semaphore is unavailable so the other threads block.
   * Lock semaphore resource to ensure thread blocks.
   */
  status = sem_wait(&sem1);
  rtems_test_assert( status == 0 );

  /*
   * Let the other thread start so the thread startup overhead,
   * is accounted for.  When we return, we can start the benchmark.
   */
  sched_yield();
    /* let other thread run */

  benchmark_timer_initialize();
    status = sem_post( &sem1 ); /* semaphore unblocking operation */
  end_time = benchmark_timer_read();
  rtems_test_assert( status == 0 );

  put_time(
    "sem_post: thread waiting no preempt",
    end_time,
    1,
    0,
    0
  );

  TEST_END();
  rtems_test_exit( 0 );

  return NULL;
}

/* configuration information */

#define CONFIGURE_APPLICATION_NEEDS_SIMPLE_CONSOLE_DRIVER
#define CONFIGURE_APPLICATION_NEEDS_TIMER_DRIVER

#define CONFIGURE_MAXIMUM_POSIX_THREADS     2
#define CONFIGURE_POSIX_INIT_THREAD_TABLE

#define CONFIGURE_INIT

#include <rtems/confdefs.h>
  /* end of file */
