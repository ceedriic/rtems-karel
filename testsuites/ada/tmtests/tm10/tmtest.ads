-- SPDX-License-Identifier: BSD-2-Clause

--
--  TMTEST / SPECIFICATION
--
--  DESCRIPTION:
--
--  This package is the specification for Test 10 of the RTEMS
--  Timing Test Suite.
--
--  DEPENDENCIES: 
--
--  
--
--  COPYRIGHT (c) 1989-2011.
--  On-Line Applications Research Corporation (OAR).
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions
--  are met:
--  1. Redistributions of source code must retain the above copyright
--     notice, this list of conditions and the following disclaimer.
--  2. Redistributions in binary form must reproduce the above copyright
--     notice, this list of conditions and the following disclaimer in the
--     documentation and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

with RTEMS;
with RTEMS.TASKS;

package TMTEST is

--
--  Buffer Record similar to that used by RTEMS 3.2.1.  Using this
--  avoids changes to the test.
--

   type BUFFER is
      record
         FIELD1 : RTEMS.UNSIGNED32;   -- TEMPORARY UNTIL VARIABLE LENGTH
         FIELD2 : RTEMS.UNSIGNED32;
         FIELD3 : RTEMS.UNSIGNED32;
         FIELD4 : RTEMS.UNSIGNED32;
      end record;

--
--  The following is the ID of the message queue used for timing operations.
--

   QUEUE_ID  : RTEMS.ID;

--
--  The following variable is set to the execution time returned
--  by the timer.
--

   END_TIME  : RTEMS.UNSIGNED32;

--
--  INIT
--
--  DESCRIPTION:
--
--  This RTEMS task initializes the application.
--

   procedure INIT (
      ARGUMENT : in     RTEMS.TASKS.ARGUMENT
   );
   pragma Convention (C, INIT);

--
--  TEST_INIT
--
--  DESCRIPTION:
--
--  This subprogram performs test initialization.  After initialization
--  has been completed, the NO_WAIT case for MESSAGE_QUEUE_RECEIVE
--  is timed and reported.
--

   procedure TEST_INIT;

--
--  HIGH_TASK
--
--  DESCRIPTION:
--
--  This RTEMS task is the highest priority task in the system.  
--  It starts the timer and performs a blocking MESSAGE_QUEUE_RECEIVE.
--

   procedure HIGH_TASK (
      ARGUMENT : in     RTEMS.TASKS.ARGUMENT
   );
   pragma Convention (C, HIGH_TASK);

--
--  MIDDLE_TASKS
--
--  DESCRIPTION:
--
--  These RTEMS tasks perform a blocking MESSAGE_QUEUE_RECEIVE.
--

   procedure MIDDLE_TASKS (
      ARGUMENT : in     RTEMS.TASKS.ARGUMENT
   );
   pragma Convention (C, MIDDLE_TASKS);

--
--  LOW_TASK
--
--  DESCRIPTION:
--
--  This RTEMS task stops the timer and reports the execution time 
--  of a blocking MESSAGE_QUEUE_RECEIVE.
--

   procedure LOW_TASK (
      ARGUMENT : in     RTEMS.TASKS.ARGUMENT
   );
   pragma Convention (C, LOW_TASK);

end TMTEST;
