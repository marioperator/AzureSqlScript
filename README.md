# Azure SQL - Clean Orphaned Elastic Job Objects

This SQL script helps resolve issues related to orphaned objects from Elastic Jobs in Azure SQL, specifically when working with **Microsoft Dynamics NAV 2018**. When an active elastic job exists, exporting the database to a BACPAC file can fail due to the presence of orphaned objects, such as procedures, foreign keys, views, tables, and user-defined types.

## Problem

When attempting to export the database to a BACPAC file, you may encounter errors caused by orphaned objects left behind by active Elastic Jobs. These orphaned objects can lead to export failures, making it impossible to create a backup or migrate the database effectively.

## Solution

The script identifies and drops:
- Stored procedures (`jobs`, `jobs_internal`)
- Foreign keys (`jobs`, `jobs_internal`)
- Views (`jobs`, `jobs_internal`)
- Tables (`jobs_internal`)
- User-defined types (`jobs_internal`)
- Functions (`jobs_internal`)
- The schemas `jobs`, `jobs_internal`
- The users `##MS_JobAccount##`, `##MS_JobsResourceManager##`
- Roles related to jobs (`jobs_admin`, `jobs_reader`, `jobs_resource_manager`)

### Usage Instructions

1. **Backup**: Always create a backup of your database before running this script.
2. **Run the script**: Execute the SQL script on the affected database to clean up all orphaned objects.
3. **Final Step**: Uncomment the `sp_executesql` lines at the bottom of the script to fully execute the cleanup commands.
