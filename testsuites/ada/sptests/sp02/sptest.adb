-- SPDX-License-Identifier: BSD-2-Clause

--
--  SPTEST / BODY
--
--  DESCRIPTION:
--
--  This package is the implementation of Test 2 of the RTEMS
--  Single Processor Test Suite.
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

with INTERFACES; use INTERFACES;
with TEST_SUPPORT;
with TEXT_IO;
with UNSIGNED32_IO;

package body SPTEST is

-- 
--  INIT
--

   procedure INIT (
      ARGUMENT : in     RTEMS.TASKS.ARGUMENT
   ) is
      pragma Unreferenced(ARGUMENT);
      STATUS : RTEMS.STATUS_CODES;
   begin

      TEXT_IO.NEW_LINE( 2 );
      TEST_SUPPORT.ADA_TEST_BEGIN;

      SPTEST.PREEMPT_TASK_NAME := RTEMS.BUILD_NAME(  'P', 'R', 'M', 'T' );

      RTEMS.TASKS.CREATE( 
         SPTEST.PREEMPT_TASK_NAME,
         1, 
         2048, 
         RTEMS.DEFAULT_MODES,
         RTEMS.DEFAULT_ATTRIBUTES,
         SPTEST.PREEMPT_TASK_ID,
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_CREATE OF PREEMPT" );

      RTEMS.TASKS.START(
         SPTEST.PREEMPT_TASK_ID,
         SPTEST.PREEMPT_TASK'ACCESS,
         0,
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_START OF PREEMPT" );

      TEXT_IO.PUT_LINE( "INIT - task_wake_after - yielding processor" );
      RTEMS.TASKS.WAKE_AFTER( RTEMS.YIELD_PROCESSOR, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_WAKE_AFTER" );

      SPTEST.TASK_NAME( 1 ) := RTEMS.BUILD_NAME(  'T', 'A', '1', ' ' );
      SPTEST.TASK_NAME( 2 ) := RTEMS.BUILD_NAME(  'T', 'A', '2', ' ' );
      SPTEST.TASK_NAME( 3 ) := RTEMS.BUILD_NAME(  'T', 'A', '3', ' ' );

      RTEMS.TASKS.CREATE( 
         SPTEST.TASK_NAME( 1 ), 
         3, 
         2048, 
         RTEMS.DEFAULT_MODES,
         RTEMS.DEFAULT_ATTRIBUTES,
         SPTEST.TASK_ID( 1 ),
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_CREATE OF TA1" );

      RTEMS.TASKS.CREATE( 
         SPTEST.TASK_NAME( 2 ), 
         3, 
         2048, 
         RTEMS.DEFAULT_MODES,
         RTEMS.DEFAULT_ATTRIBUTES,
         SPTEST.TASK_ID( 2 ),
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_CREATE OF TA2" );

      RTEMS.TASKS.CREATE( 
         SPTEST.TASK_NAME( 3 ), 
         3, 
         2048, 
         RTEMS.DEFAULT_MODES,
         RTEMS.DEFAULT_ATTRIBUTES,
         SPTEST.TASK_ID( 3 ),
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_CREATE OF TA3" );

      RTEMS.TASKS.START(
         SPTEST.TASK_ID( 1 ),
         SPTEST.TASK_1'ACCESS,
         0,
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_START OF TA1" );

      RTEMS.TASKS.START(
         SPTEST.TASK_ID( 2 ),
         SPTEST.TASK_2'ACCESS,
         0,
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_START OF TA2" );

      RTEMS.TASKS.START(
         SPTEST.TASK_ID( 3 ),
         SPTEST.TASK_3'ACCESS,
         0,
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_START OF TA3" );

      TEXT_IO.PUT_LINE( 
         "INIT - suspending TA2 while middle task on a ready chain"
      );
 
      RTEMS.TASKS.SUSPEND( SPTEST.TASK_ID( 2 ), STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_SUSPEND OF TA2" );

      RTEMS.TASKS.DELETE( SPTEST.TASK_ID( 1 ), STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_DELETE OF TA1" );

      RTEMS.TASKS.DELETE( SPTEST.TASK_ID( 2 ), STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_DELETE OF TA2" );

      RTEMS.TASKS.DELETE( SPTEST.TASK_ID( 3 ), STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_DELETE OF TA3" );

      RTEMS.TASKS.CREATE( 
         SPTEST.TASK_NAME( 1 ), 
         1, 
         2048, 
         RTEMS.DEFAULT_MODES,
         RTEMS.DEFAULT_ATTRIBUTES,
         SPTEST.TASK_ID( 1 ),
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_CREATE OF TA1" );

      RTEMS.TASKS.CREATE( 
         SPTEST.TASK_NAME( 2 ), 
         3, 
         2048, 
         RTEMS.DEFAULT_MODES,
         RTEMS.DEFAULT_ATTRIBUTES,
         SPTEST.TASK_ID( 2 ),
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_CREATE OF TA2" );

      RTEMS.TASKS.CREATE( 
         SPTEST.TASK_NAME( 3 ), 
         3, 
         2048, 
         RTEMS.DEFAULT_MODES,
         RTEMS.DEFAULT_ATTRIBUTES,
         SPTEST.TASK_ID( 3 ),
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_CREATE OF TA3" );

      RTEMS.TASKS.START(
         SPTEST.TASK_ID( 1 ),
         SPTEST.TASK_1'ACCESS,
         0,
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_START OF TA1" );

      RTEMS.TASKS.START(
         SPTEST.TASK_ID( 2 ),
         SPTEST.TASK_2'ACCESS,
         0,
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_START OF TA2" );

      RTEMS.TASKS.START(
         SPTEST.TASK_ID( 3 ),
         SPTEST.TASK_3'ACCESS,
         0,
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_START OF TA3" );

      RTEMS.TASKS.DELETE( RTEMS.SELF, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_DELETE OF SELF" );

   end INIT;

-- 
--  PREEMPT_TASK
--

   procedure PREEMPT_TASK (
      ARGUMENT : in     RTEMS.TASKS.ARGUMENT
   ) is
      pragma Unreferenced(ARGUMENT);
      STATUS            : RTEMS.STATUS_CODES;
   begin

      TEXT_IO.PUT_LINE( "PREEMPT - task_delete - deleting self" );
      RTEMS.TASKS.DELETE( RTEMS.SELF, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_DELETE OF PREEMPT" );

   end PREEMPT_TASK;

-- 
--  TASK_1
--

   procedure TASK_1 (
      ARGUMENT : in     RTEMS.TASKS.ARGUMENT
   ) is
      pragma Unreferenced(ARGUMENT);
      TID2              : RTEMS.ID;
      TID3              : RTEMS.ID;
      STATUS            : RTEMS.STATUS_CODES;
      PREVIOUS_PRIORITY : RTEMS.TASKS.PRIORITY;
   begin

      TEXT_IO.PUT_LINE( "TA1 - task_wake_after - sleep 1 second" );
      RTEMS.TASKS.WAKE_AFTER( TEST_SUPPORT.TICKS_PER_SECOND, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_WAKE_AFTER" );
          
      RTEMS.TASKS.IDENT( 
         SPTEST.TASK_NAME( 2 ), 
         RTEMS.SEARCH_ALL_NODES, 
         TID2, 
         STATUS 
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_IDENT OF TA2" );
   
      TEXT_IO.PUT( "TA1 - task_ident - tid of TA2 (" );
      UNSIGNED32_IO.PUT( TID2, WIDTH => 8, BASE => 10#16# );
      TEXT_IO.PUT_LINE( ")" );

      RTEMS.TASKS.IDENT( 
         SPTEST.TASK_NAME( 3 ), 
         RTEMS.SEARCH_ALL_NODES, 
         TID3, 
         STATUS 
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_IDENT OF TA3" );
   
      TEXT_IO.PUT( "TA1 - task_ident - tid of TA3 (" );
      UNSIGNED32_IO.PUT( TID3, WIDTH => 8, BASE => 10#16# );
      TEXT_IO.PUT_LINE( ")" );

      RTEMS.TASKS.SET_PRIORITY( TID3, 2, PREVIOUS_PRIORITY, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_SET_PRIORITY" );

      TEXT_IO.PUT_LINE( 
         "TA1 - task_set_priority - set TA3's priority to 2"
      );

      TEXT_IO.PUT_LINE( "TA1 - task_suspend - suspend TA2" );
      RTEMS.TASKS.SUSPEND( TID2, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_SUSPEND OF TA2" );

      TEXT_IO.PUT_LINE( "TA1 - task_delete - delete TA2" );
      RTEMS.TASKS.DELETE( TID2, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_DELETE OF TA2" );

      TEXT_IO.PUT_LINE( "TA1 - task_wake_after - sleep for 5 seconds" );
      RTEMS.TASKS.WAKE_AFTER( 5 * TEST_SUPPORT.TICKS_PER_SECOND, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_WAKE_AFTER" );

      TEST_SUPPORT.ADA_TEST_END;
      RTEMS.SHUTDOWN_EXECUTIVE( 0 );
   
   end TASK_1;

-- 
--  TASK_2
--

   procedure TASK_2 (
      ARGUMENT : in     RTEMS.TASKS.ARGUMENT
   ) is
      pragma Unreferenced(ARGUMENT);
      STATUS : RTEMS.STATUS_CODES;
   begin

      TEXT_IO.PUT_LINE( "TA2 - task_wake_after - sleep 1 minute" );
      RTEMS.TASKS.WAKE_AFTER( 60 * TEST_SUPPORT.TICKS_PER_SECOND, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_WAKE_AFTER IN TA2" );
          
   end TASK_2;

-- 
--  TASK_3
--

   procedure TASK_3 (
      ARGUMENT : in     RTEMS.TASKS.ARGUMENT
   ) is
      pragma Unreferenced(ARGUMENT);
      STATUS : RTEMS.STATUS_CODES;
   begin

      TEXT_IO.PUT_LINE( "TA3 - task_wake_after - sleep 5 seconds" );
      RTEMS.TASKS.WAKE_AFTER( 5 * TEST_SUPPORT.TICKS_PER_SECOND, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_WAKE_AFTER IN TA3" );

      TEXT_IO.PUT_LINE( "TA3 - task_delete - delete self" );
      RTEMS.TASKS.DELETE( RTEMS.SELF, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_DELETE OF TA3" );
          
   end TASK_3;

end SPTEST;
