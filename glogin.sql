--
-- Copyright (c) 1988, 2005, Oracle.  All Rights Reserved.
--
-- NAME
--   glogin.sql
--
-- DESCRIPTION
--   SQL*Plus global login "site profile" file
--
--   Add any SQL*Plus commands here that are to be executed when a
--   user starts SQL*Plus, or uses the SQL*Plus CONNECT command.
--
-- USAGE
--   This script is automatically run
--
DEFINE_EDITOR="code --wait"

set null (null)
set pagesize 30
set linesize 200
col first_name for a15
col last_name for a15
col name for a15
col empno for 9999
col ename for a15
col yomi for a15
col job for a15
col deptno for 999
col job_id for a10
col pname for a20
col department_name for a20
col city for a20
col region_name for a30
col country_name for a30
col job_title for a20
col email for a10
col region for a4
col dname for a20
col tname for a20
set editfile sqlplus.sql