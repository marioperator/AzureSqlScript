-- Azure Sql - Clean orphaned object Elastic Job
-- 2024
-- Supported By Microsoft 
-- When you have an active elastic job, bacpac export fails.
-- Before running it, make a copy of the database and run the following sql script on the database to clean up all orphaned objects.
-- Finally, comment out the sp_ at the bottom of this script to make it work.

-- begin script
declare @n char(1)
set @n = char(10)

declare @triggers nvarchar(max)
declare @procedures nvarchar(max)
declare @constraints nvarchar(max)
declare @FKs nvarchar(max)
declare @views nvarchar(max)
declare @tables nvarchar(max)
declare @udt nvarchar(max)

-- procedures
select @procedures = isnull( @procedures + @n, '' ) + 'drop procedure [' + schema_name(schema_id) + '].[' + name + ']'
from sys.procedures
where schema_name(schema_id) = 'jobs' or schema_name(schema_id) = 'jobs_internal'

-- foreign keys
select @FKs = isnull( @FKs + @n, '' ) + 'alter table [' + schema_name(schema_id) + '].[' + object_name( parent_object_id ) + '] drop constraint [' + name + ']'
from sys.foreign_keys
where schema_name(schema_id) = 'jobs' or schema_name(schema_id) = 'jobs_internal'

-- views
select @views = isnull( @views + @n, '' ) + 'drop view [' + schema_name(schema_id) + '].[' + name + ']'
from sys.views
where schema_name(schema_id) = 'jobs' or schema_name(schema_id) = 'jobs_internal'

-- tables
select @tables = isnull( @tables + @n, '' ) + 'drop table [' + schema_name(schema_id) + '].[' + name + ']'
from sys.tables
where schema_name(schema_id) = 'jobs_internal'

-- user defined types
select @udt = isnull( @udt + @n, '' ) + 'drop type [' + schema_name(schema_id) + '].[' + name + ']'
from sys.types
where is_user_defined = 1
and schema_name(schema_id) = 'jobs_internal'
order by system_type_id desc

declare @functions nvarchar(max)

-- functions
select @functions = isnull( @functions + @n, '' ) + 'drop function [' + schema_name(schema_id) + '].[' + name + ']'
from sys.objects
where type in ( 'FN', 'IF', 'TF' )
and schema_name(schema_id) = 'jobs_internal'

declare @stmt nvarchar(max)

set @stmt = isnull(@stmt + @n, '') + 'DROP SCHEMA IF EXISTS [jobs]'
set @stmt = isnull(@stmt + @n, '') + 'DROP SCHEMA IF EXISTS [jobs_internal]'

set @stmt = isnull(@stmt + @n, '') + 'DROP USER IF EXISTS [##MS_JobAccount##]'
set @stmt = isnull(@stmt + @n, '') + 'DROP USER IF EXISTS [##MS_JobsResourceManager##]'

set @stmt = isnull(@stmt + @n, '') + 'DROP ROLE IF EXISTS [jobs_admin]'
set @stmt = isnull(@stmt + @n, '') + 'DROP ROLE IF EXISTS [jobs_reader]'
set @stmt = isnull(@stmt + @n, '') + 'DROP ROLE IF EXISTS [jobs_resource_manager]'


print @procedures 
print @FKs
print @views
print @tables
print @udt 
print 'GO'
print @functions
print 'GO'
print @stmt 


--exec sp_executesql @procedures 
--exec sp_executesql @FKs
--exec sp_executesql @views
--exec sp_executesql @tables
--exec sp_executesql @udt 
--exec sp_executesql @functions 
--exec sp_executesql @stmt 
--print 'clean up finished'
