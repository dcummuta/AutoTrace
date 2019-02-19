#--https://stackoverflow.com/questions/27856229/how-to-change-extension-of-a-file
#-- This needs to be created first in order to allow file creation/name changing

USE [master]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ReplaceFileOrDirNames] 
  (@pathToObject varchar(200),
   @oldName      varchar(50),
   @newName      varchar(50))
AS
BEGIN
  DECLARE @winCmd           varchar(400)
  DECLARE @isFileThere      bit
  DECLARE @isDirectory      bit
  DECLARE @parentDirExists  bit
  DECLARE @fullNamewithPath varchar(250)
    SET NOCOUNT ON 
    SET @fullNamewithPath = @pathToObject+'\'+@oldName 
      CREATE TABLE #tempxxx (isFileThere     bit,
                          isDirectory     bit,
                          parentDirExists bit)
    INSERT #tempxxx exec master..xp_fileExist @fullNamewithPath
      SELECT @isFileThere = isFileThere,
             @isDirectory = isDirectory 
      FROM #tempxxx
      IF (@isFileThere = 1)
        BEGIN 
          SET @winCmd = 'rename ' + 
            @pathToObject+'\'+@oldName + ' ' + @newName
        END 
      ELSE 
        BEGIN 
          IF (@isDirectory = 1)
            BEGIN 
              SET @winCmd = 'move /Y ' + @pathToObject+ '\' + 
                @oldName + ' '+ @pathToObject+'\'+@newName
            END
        END
      PRINT @winCmd
      EXEC master..xp_cmdShell @winCmd
      DROP TABLE #tempxxx
      SET NOCOUNT OFF
END

GO
