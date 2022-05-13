-- SPDX-License-Identifier: BSD-2-Clause

--
--  SPTEST / BODY
--
--  DESCRIPTION:
--
--  This package is the implementation of Test 1 of the RTEMS
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
      TEXT_IO.PUT_LINE( "Creating and starting an application task" );

      SPTEST.TASK_NAME( 1 ) := RTEMS.BUILD_NAME(  'T', 'A', '1', ' ' );

      RTEMS.TASKS.CREATE( 
         SPTEST.TASK_NAME( 1 ), 
         1, 
         2048, 
         RTEMS.INTERRUPT_LEVEL( 0 ),
         RTEMS.DEFAULT_ATTRIBUTES,
         SPTEST.TASK_ID( 1 ),
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_CREATE OF TA1" );

      RTEMS.TASKS.START(
         SPTEST.TASK_ID( 1 ),
         SPTEST.APPLICATION_TASK'ACCESS,
         0,
         STATUS
      );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_START OF TA1" );

      RTEMS.TASKS.DELETE( RTEMS.SELF, STATUS );
      TEST_SUPPORT.DIRECTIVE_FAILED( STATUS, "TASK_DELETE OF SELF" );

   end INIT;

-- 
--  APPLICATION_TASK
--

   procedure APPLICATION_TASK (
      ARGUMENT : in     RTEMS.TASKS.ARGUMENT
   ) is
      TID    : RTEMS.ID;
      STATUS : RTEMS.STATUS_CODES;
   begin

      RTEMS.TASKS.IDENT( RTEMS.SELF, RTEMS.SEARCH_ALL_NODES, TID, STATUS );
   
      TEXT_IO.PUT( "Application task was invoked with argument (" );
      UNSIGNED32_IO.PUT( ARGUMENT );
      TEXT_IO.PUT( ") and has id of 0x" );
      UNSIGNED32_IO.PUT( TID, BASE => 16 );
      TEXT_IO.NEW_LINE;

      TEST_SUPPORT.ADA_TEST_END;

      RTEMS.SHUTDOWN_EXECUTIVE( 0 );

   end APPLICATION_TASK;

end SPTEST;
