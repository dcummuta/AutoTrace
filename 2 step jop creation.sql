
/* *******David Cummuta auto trace and file renamer********
                     Created 2019-02-11  
this creates the job that has two job steps
step 1 renames any existing files so they are not over written
step 2 runs the trace for 1 hour and saves the file(s) to d:/ drive
The schedule would have to be adjusted for your needs in MSSMS
Modifying the save directory or name of the file will break this script unless 
you change the directory and file names everywhere
else in the script
This script was modified from several other jobs I found from the internet
https://stackoverflow.com/questions/27856229/how-to-change-extension-of-a-file
https://www.itprotoday.com/analytics-and-reporting/9-steps-automated-trace
Be careful with this script because it can fill up a hard drive if it is not monitored
Microsoft will be depreciating SQL profiler in favor of extended events in future sql versions
therefore this will only work in Microsoft SQL 2008-2016
I am not responsible for anything that happens from the use of this script or the profiler readings.
*/
USE [msdb]
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'810Trace', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Rename to prevent overwrite]    Script Date: 02/11/2019 16:27:21 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Rename to prevent overwrite', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=2, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- turns on xp_cmdshell so we can use the Windows shell command prompt from SQL
--sets configure mode to allow cmd functions
EXEC sp_configure ''show advanced options'',1
RECONFIGURE
GO
EXEC sp_configure ''xp_cmdshell'',1
GO
RECONFIGURE
GO


declare @filename varchar (50)
--creates filename with date and time appended
set @filename=''Traces''+CONVERT(VARCHAR(10),GETDATE(),20)+''_''
+CONVERT(varchar(2),DATEPART(HOUR, GETDATE()))+''h''+''_''
+CONVERT(varchar(2),DATEPART(MINUTE, GETDATE()))+''m''+''_''
+CONVERT(varchar(2),DATEPART(SECOND, GETDATE()))+''s''+''.trc''


--Begins itteration through list of potential trace files that have been created to rename them every second
--Waiting is required to create a unique file name for each file otherwise it crashes into itself 

begin
exec sp_ReplaceFileOrDirNames
	@pathToObject= ''D:\'',
	@oldName=''Traces.trc'',
	@newName=@filename;
	
WAITFOR DELAY ''00:00:01'';
end

set @filename=''Traces''+CONVERT(VARCHAR(10),GETDATE(),20)+''_''
+CONVERT(varchar(2),DATEPART(HOUR, GETDATE()))+''h''+''_''
+CONVERT(varchar(2),DATEPART(MINUTE, GETDATE()))+''m''+''_''
+CONVERT(varchar(2),DATEPART(SECOND, GETDATE()))+''s''+''.trc''

begin
exec sp_ReplaceFileOrDirNames
	@pathToObject= ''D:\'',
	@oldName=''Traces_1.trc'',
	@newName=@filename;
	
WAITFOR DELAY ''00:00:01'';
end

set @filename=''Traces''+CONVERT(VARCHAR(10),GETDATE(),20)+''_''
+CONVERT(varchar(2),DATEPART(HOUR, GETDATE()))+''h''+''_''
+CONVERT(varchar(2),DATEPART(MINUTE, GETDATE()))+''m''+''_''
+CONVERT(varchar(2),DATEPART(SECOND, GETDATE()))+''s''+''.trc''


begin	
exec sp_ReplaceFileOrDirNames
	@pathToObject= ''D:\'',
	@oldName=''Traces_2.trc'',
	@newName=@filename;
	
WAITFOR DELAY ''00:00:01'';
end 

set @filename=''Traces''+CONVERT(VARCHAR(10),GETDATE(),20)+''_''
+CONVERT(varchar(2),DATEPART(HOUR, GETDATE()))+''h''+''_''
+CONVERT(varchar(2),DATEPART(MINUTE, GETDATE()))+''m''+''_''
+CONVERT(varchar(2),DATEPART(SECOND, GETDATE()))+''s''+''.trc''


begin
exec sp_ReplaceFileOrDirNames
	@pathToObject= ''D:\'',
	@oldName=''Traces_3.trc'',
	@newName=@filename;
	
WAITFOR DELAY ''00:00:01'';
end	


set @filename=''Traces''+CONVERT(VARCHAR(10),GETDATE(),20)+''_''
+CONVERT(varchar(2),DATEPART(HOUR, GETDATE()))+''h''+''_''
+CONVERT(varchar(2),DATEPART(MINUTE, GETDATE()))+''m''+''_''
+CONVERT(varchar(2),DATEPART(SECOND, GETDATE()))+''s''+''.trc''

Begin	
exec sp_ReplaceFileOrDirNames
	@pathToObject= ''D:\'',
	@oldName=''Traces_4.trc'',
	@newName=@filename;
	
WAITFOR DELAY ''00:00:01'';
end

set @filename=''Traces''+CONVERT(VARCHAR(10),GETDATE(),20)+''_''
+CONVERT(varchar(2),DATEPART(HOUR, GETDATE()))+''h''+''_''
+CONVERT(varchar(2),DATEPART(MINUTE, GETDATE()))+''m''+''_''
+CONVERT(varchar(2),DATEPART(SECOND, GETDATE()))+''s''+''.trc''

begin
exec sp_ReplaceFileOrDirNames
	@pathToObject= ''D:\'',
	@oldName=''Traces_5.trc'',
	@newName=@filename;
	
WAITFOR DELAY ''00:00:01'';
end


set @filename=''Traces''+CONVERT(VARCHAR(10),GETDATE(),20)+''_''
+CONVERT(varchar(2),DATEPART(HOUR, GETDATE()))+''h''+''_''
+CONVERT(varchar(2),DATEPART(MINUTE, GETDATE()))+''m''+''_''
+CONVERT(varchar(2),DATEPART(SECOND, GETDATE()))+''s''+''.trc''

begin	
exec sp_ReplaceFileOrDirNames
	@pathToObject= ''D:\'',
	@oldName=''Traces_6.trc'',
	@newName=@filename;
	
WAITFOR DELAY ''00:00:01'';
end

set @filename=''Traces''+CONVERT(VARCHAR(10),GETDATE(),20)+''_''
+CONVERT(varchar(2),DATEPART(HOUR, GETDATE()))+''h''+''_''
+CONVERT(varchar(2),DATEPART(MINUTE, GETDATE()))+''m''+''_''
+CONVERT(varchar(2),DATEPART(SECOND, GETDATE()))+''s''+''.trc''

begin
exec sp_ReplaceFileOrDirNames
	@pathToObject= ''D:\'',
	@oldName=''Traces_7.trc'',
	@newName=@filename;
	
WAITFOR DELAY ''00:00:01'';
end

set @filename=''Traces''+CONVERT(VARCHAR(10),GETDATE(),20)+''_''
+CONVERT(varchar(2),DATEPART(HOUR, GETDATE()))+''h''+''_''
+CONVERT(varchar(2),DATEPART(MINUTE, GETDATE()))+''m''+''_''
+CONVERT(varchar(2),DATEPART(SECOND, GETDATE()))+''s''+''.trc''

begin
exec sp_ReplaceFileOrDirNames
	@pathToObject= ''D:\'',
	@oldName=''Traces_8.trc'',
	@newName=@filename;
	
WAITFOR DELAY ''00:00:01'';
end

EXEC sp_configure ''xp_cmdshell'',0
GO
RECONFIGURE
GO
EXEC sp_configure ''show advanced options'',0
GO
RECONFIGURE
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Trace Files at D drive', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/****************************************************/



-- Create a Queue
declare @rc int
declare @TraceID int
declare @maxfilesize bigint
declare @filecount int
declare @DateTime datetime
declare @Schedule datetime


-- Create Schedule to run for 1 hour after sql agent initiates script
set @Schedule = GETDATE()
set @DateTime = DATEADD(hh, +1,@Schedule)


-- Set max tracefile size to 20mb and rollover file count to only allow 7 of these to be created before stoping
-- to make sure this doesn''t grow out of control
set @maxfilesize = 20
set @filecount = 8


-- Please replace the text InsertFileNameHere, with an appropriate
-- filename prefixed by a path, e.g., c:\MyFolder\MyTrace. The .trc extension
-- will be appended to the filename automatically. If you are writing from
-- remote server to local drive, please use UNC path and make sure server has
-- write access to your network share

-- The  2 after output sets the options to 2 which allows for rollover 
-- this ensures this trace increment to the next file when it goes to the max file size 
-- it will keep creating files up until file count that was set above has been reached
-- below executes the script and saves file to D:\ directory 

exec @rc = sp_trace_create @TraceID output, 2, N''D:\Traces'', @maxfilesize, @Datetime, @filecount
if (@rc != 0) goto error

-- Client side File and Table cannot be scripted

-- Set the events
declare @on bit
set @on = 1
exec sp_trace_setevent @TraceID, 14, 1, @on
exec sp_trace_setevent @TraceID, 14, 9, @on
exec sp_trace_setevent @TraceID, 14, 6, @on
exec sp_trace_setevent @TraceID, 14, 10, @on
exec sp_trace_setevent @TraceID, 14, 14, @on
exec sp_trace_setevent @TraceID, 14, 11, @on
exec sp_trace_setevent @TraceID, 14, 12, @on
exec sp_trace_setevent @TraceID, 15, 15, @on
exec sp_trace_setevent @TraceID, 15, 16, @on
exec sp_trace_setevent @TraceID, 15, 9, @on
exec sp_trace_setevent @TraceID, 15, 17, @on
exec sp_trace_setevent @TraceID, 15, 6, @on
exec sp_trace_setevent @TraceID, 15, 10, @on
exec sp_trace_setevent @TraceID, 15, 14, @on
exec sp_trace_setevent @TraceID, 15, 18, @on
exec sp_trace_setevent @TraceID, 15, 11, @on
exec sp_trace_setevent @TraceID, 15, 12, @on
exec sp_trace_setevent @TraceID, 15, 13, @on
exec sp_trace_setevent @TraceID, 17, 1, @on
exec sp_trace_setevent @TraceID, 17, 9, @on
exec sp_trace_setevent @TraceID, 17, 6, @on
exec sp_trace_setevent @TraceID, 17, 10, @on
exec sp_trace_setevent @TraceID, 17, 14, @on
exec sp_trace_setevent @TraceID, 17, 11, @on
exec sp_trace_setevent @TraceID, 17, 12, @on
exec sp_trace_setevent @TraceID, 10, 15, @on
exec sp_trace_setevent @TraceID, 10, 16, @on
exec sp_trace_setevent @TraceID, 10, 9, @on
exec sp_trace_setevent @TraceID, 10, 17, @on
exec sp_trace_setevent @TraceID, 10, 2, @on
exec sp_trace_setevent @TraceID, 10, 10, @on
exec sp_trace_setevent @TraceID, 10, 18, @on
exec sp_trace_setevent @TraceID, 10, 11, @on
exec sp_trace_setevent @TraceID, 10, 12, @on
exec sp_trace_setevent @TraceID, 10, 13, @on
exec sp_trace_setevent @TraceID, 10, 6, @on
exec sp_trace_setevent @TraceID, 10, 14, @on
exec sp_trace_setevent @TraceID, 12, 15, @on
exec sp_trace_setevent @TraceID, 12, 16, @on
exec sp_trace_setevent @TraceID, 12, 1, @on
exec sp_trace_setevent @TraceID, 12, 9, @on
exec sp_trace_setevent @TraceID, 12, 17, @on
exec sp_trace_setevent @TraceID, 12, 6, @on
exec sp_trace_setevent @TraceID, 12, 10, @on
exec sp_trace_setevent @TraceID, 12, 14, @on
exec sp_trace_setevent @TraceID, 12, 18, @on
exec sp_trace_setevent @TraceID, 12, 11, @on
exec sp_trace_setevent @TraceID, 12, 12, @on
exec sp_trace_setevent @TraceID, 12, 13, @on
exec sp_trace_setevent @TraceID, 13, 1, @on
exec sp_trace_setevent @TraceID, 13, 9, @on
exec sp_trace_setevent @TraceID, 13, 6, @on
exec sp_trace_setevent @TraceID, 13, 10, @on
exec sp_trace_setevent @TraceID, 13, 14, @on
exec sp_trace_setevent @TraceID, 13, 11, @on
exec sp_trace_setevent @TraceID, 13, 12, @on


-- Set the Filters to avoid too much rxworks app traffic that isn''t 810 related
declare @intfilter int
declare @bigintfilter bigint

-- Set the trace status to start
exec sp_trace_setstatus @TraceID, 1

-- display trace id for future references
select TraceID=@TraceID
goto finish

error: 
select ErrorCode=@rc

finish: 
go
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'5 to 6 AM', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20190208, 
		@active_end_date=99991231, 
		@active_start_time=50000, 
		@active_end_time=235959, 
		@schedule_uid=N'9e52bde7-98ca-4edf-ab17-4cb1d4eaa4e5'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

