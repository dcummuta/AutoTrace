These are job creation scripts that I modded together from several other scripts to create a job that runs Microsoft SQL profiler automatically for 1 hour and saves the trace file(s) to the local D:\ drive 



                # !!!!!!!Knowledge of T-SQL and Microsoft SQL Server Manager Studio is necessary to use this!!!!!!!!!!
                # !!!!!!!!!!!!!!!!!!!!!!DO NOT USE THIS JOB IF YOU DO NOT KNOW WHAT IT IS DOING!!!!!!!!!!!!!!!!!!!!!!!



The first script SP_ReplaceFileOrDirNames.sql has to be ran first in order for the main script to work
This first Script creates a stored procedure that allows for changing file names outside of SQL on the actual server/client/nas/etc. depending on security setup of the environment this needs to be tested first to ensure the account running this full job has the ability to actually do this. 

The source of this wonderful SP can be found here:  https://stackoverflow.com/questions/27856229/how-to-change-extension-of-a-file


The second script is a combination of two things:
  
  
  1) A job step that renames any current trace files in the d:\ drive where it is saving by default.  This is to ensure that no current trace files are overwritten. This is using the SP_ReplaceFileOrDirNames stored procedure.  It has to activate an administrative feature of SQL "sp_configure" that is very dangerous if left on so it turns it off immediately after running.
  
  For more on these see: 
- https://stackoverflow.com/questions/27856229/how-to-change-extension-of-a-file
- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-configure-transact-sql?view=sql-server-2017
  


  2) A job step that is very commonly used by DBA's to run traces with SQL profiler that can be exported from SQL profiler as a script that uses a stored procedure called "sp_create_trace".  I modified it to actually run for only a small window of time automatically so the "stop time" time can be variable and not have to be explicitly stated.  (See lines 238,239,240 that create the time variable and inserts it later into the execute line 260 as "@Datetime" 
  
  For more on the stored procedure and its options/functionality see:
  - https://social.msdn.microsoft.com/Forums/sqlserver/en-US/ac75ee04-3e46-49ca-96e0-ff56c05909be/spcreatetrace?forum=transactsql

Once the job is created you can adjust time scheduling via the GUI to suit your exact needs.  Using SQL profiler to export a trace filter profiler may be necessary to exclude junk trace messages but, this would take comprehensive overhaul of the main trace job and should only be done by someone who can understand this script in depth as to not break its functionality.

Sadly SP_Create_Trace is protected IP owned by Microsoft so the "under the hood" code of that stored procedure does not exist anywhere on the internet that I have found so this feature is very locked down and modifying anything in line 260 can break this script.  

Lastly, Microsoft is depreciating SQL profiler (and therefore sp_create_trace) in favor of the much more versatile "Extended events" platform feature of SQL server manager that was introduced starting with SQL server 2012.  However, it is currently still available in all current SQL server versions starting with SQL 2008 and obviously many enterprises will be using SQL 2016 for some time.  After it is fully retired this will become a legacy feature and is not advised you use this job when they finally do this.  The move to using Extended Events can be quite like learning a new language so prepare ahead of time for this.  
  For more on Extended Events see:  
  - https://docs.microsoft.com/en-us/sql/relational-databases/extended-events/extended-events?view=sql-server-2017
