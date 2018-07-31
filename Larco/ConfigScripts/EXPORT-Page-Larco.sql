
DECLARE @APP_ID AS INT
DECLARE @PAGE_ID AS INT
DECLARE @TAB_ID AS INT
DECLARE @FIELD_ID AS INT
DECLARE @FILTER_ID AS INT
DECLARE @FILTERFIELD_ID AS INT
DECLARE @APPNAME AS VARCHAR(100)
DECLARE @PAGENAME AS VARCHAR(100)
DECLARE @FIELDNAME AS VARCHAR(100)
DECLARE @TABNAME AS VARCHAR(100)
DECLARE @ENTITYEVENT_ID AS INT
 

SET @APPNAME = 'Larco'


PRINT 'USE [EPEFrameworkService]'
PRINT 'GO'
PRINT ''

DECLARE @INSERT AS VARCHAR(MAX)
DECLARE @INSERTPAGE AS VARCHAR(4000)
SET @INSERTPAGE = 'INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate],[PageAppId],[ConnName]) VALUES ('''

PRINT 'DECLARE @PAGEAPP_ID AS INT'
PRINT 'DECLARE @PAGE_ID AS INT'
PRINT 'DECLARE @TAB_ID AS INT'
PRINT 'DECLARE @FIELD_ID AS INT'
PRINT 'DECLARE @FILTER_ID AS INT'
PRINT 'DECLARE @FILTERFIELD_ID AS INT'

PRINT ''
PRINT 'SELECT TOP 1 @PAGEAPP_ID = PageAppId FROM PageApp WHERE AppName = ''' + @APPNAME + ''''
PRINT ''

PRINT 'IF @PAGEAPP_ID IS NULL BEGIN'
PRINT '  INSERT INTO PageApp(AppName,UpdatedBy,UpdatedDate) VALUES(''' + @APPNAME + ''',''cbeltra'',GETDATE())	'
PRINT '  SELECT TOP 1 @PAGEAPP_ID = PageAppId FROM PageApp WHERE AppName = ''' + @APPNAME + ''''
PRINT 'END'

DECLARE Page_Cursor CURSOR FOR

	SELECT PageId,Name FROM [Page] ORDER BY Name

OPEN Page_Cursor
FETCH NEXT FROM Page_Cursor INTO @PAGE_ID, @PAGENAME
WHILE @@FETCH_STATUS = 0 
BEGIN
		PRINT ''
		PRINT 'IF EXISTS (SELECT PageId FROM Page WHERE Name = ''' + @PAGENAME + ''' AND PageAppId = @PAGEAPP_ID) BEGIN'
		PRINT '	SELECT @PAGE_ID = PageId FROM Page WHERE Name = ''' + @PAGENAME + ''' AND PageAppId = @PAGEAPP_ID'
		PRINT '	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID'
		PRINT '	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)'
		PRINT '	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)'
		PRINT '	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID'
		PRINT '	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID'
		PRINT '	DELETE FROM [EntityEvents] WHERE [PageId] = @PAGE_ID'
		PRINT '	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID'
		PRINT 'END'
		

		SELECT @INSERT = @INSERTPAGE + [Name] + ''',''' + [Title] + ''',''' + [TableName] + + ''',''cbeltra'',GETDATE(),@PAGEAPP_ID,''' + CASE WHEN [ConnName] IS NULL THEN '' ELSE [ConnName] END + ''')'
		FROM Page WHERE PageId = @PAGE_ID

		PRINT ''
		PRINT @INSERT
		PRINT 'SET @PAGE_ID = scope_identity()'
		PRINT ''

		DECLARE @TABINSERT AS VARCHAR(MAX)
		SET @TABINSERT = 'INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'''

		DECLARE @FIELDINSERT AS VARCHAR(MAX)
		SET @FIELDINSERT = 'INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'''

		DECLARE @COLINSERT AS VARCHAR(MAX)
		SET @COLINSERT = 'INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,'

		DECLARE PageTab_Cursor CURSOR FOR

			SELECT TabId FROM PageTab WHERE PageId = @PAGE_ID

		OPEN PageTab_Cursor
		FETCH NEXT FROM PageTab_Cursor INTO @TAB_ID
		WHILE @@FETCH_STATUS = 0 /*do while not end of cursor*/
		BEGIN

			SELECT @INSERT = @TABINSERT + [TabName] + ''',''' + [URL] + ''',' + CAST([TabOrder] AS VARCHAR(10)) + ',' + CAST([Cols] AS VARCHAR(10)) + ',''cbeltra'',GETDATE())'
			FROM PageTab WHERE TabId = @TAB_ID
			
			PRINT @INSERT
			PRINT 'SET @TAB_ID = scope_identity()'
			PRINT ''
			/**
			Starting field cursor
			*/
			DECLARE Field_Cursor CURSOR FOR

				SELECT FieldId FROM PageField WHERE TabId = @TAB_ID

			OPEN Field_Cursor
			FETCH NEXT FROM Field_Cursor INTO @FIELD_ID
			WHILE @@FETCH_STATUS = 0 
			BEGIN
			
				SELECT @INSERT = @FIELDINSERT + [FieldName] + ''',''' + [Label] + ''',''' + [Type] + ''',' + 
				CAST([Required] AS VARCHAR(1)) + ',''' + CASE WHEN DropDownInfo IS NULL THEN '' ELSE REPLACE(DropDownInfo,'''','''''') END + ''',' + CAST([Exportable] AS VARCHAR(1)) + ',' +
				CAST([FieldOrder] AS VARCHAR(10)) + ',''' + ControlType + ''',' + CAST([IsId] AS VARCHAR(1)) + ',''' +
				CASE WHEN [JoinInfo] IS NULL THEN '' ELSE REPLACE([JoinInfo],'''','''''') END + ''',''' + DBFieldName + ''',' + CAST([Insertable] AS VARCHAR(1)) + ',' +  
				CAST([Updatable] AS VARCHAR(1)) + ',''cbeltra'',GETDATE(),''' + 
				CASE WHEN [ControlProps] IS NULL THEN '' ELSE REPLACE([ControlProps],'''','''''') END + ''')'
				FROM PageField WHERE FieldId = @FIELD_ID	
			
				PRINT @INSERT
				PRINT ''
				IF EXISTS (SELECT ColumnId from PageGridColumn WHERE PageId = @PAGE_ID AND FieldId  = @FIELD_ID)
				BEGIN			
					PRINT 'SET @FIELD_ID = scope_identity()'

					SELECT @INSERT = @COLINSERT + CAST([Visible] AS VARCHAR(1)) + ',' + 
					CAST([Searchable] AS VARCHAR(1)) + ',' + CAST([Width] AS VARCHAR(10)) + ',''' + 
					CASE WHEN ColumnLabel IS NULL THEN '' ELSE ColumnLabel END + ''',' + 
					CAST([ColumnOrder] AS VARCHAR(10)) + ',''' + 
					CASE WHEN ColumnName IS NULL THEN '' ELSE ColumnName END + ''',''cbeltra'',GETDATE())'
					FROM PageGridColumn WHERE PageId = @PAGE_ID AND FieldId = @FIELD_ID	
				
					PRINT @INSERT
					PRINT ''
				
				END

			   FETCH NEXT FROM Field_Cursor INTO @FIELD_ID
			END
			CLOSE Field_Cursor
			DEALLOCATE Field_Cursor	
			/*
			End of field cursor
			*/

		   FETCH NEXT FROM PageTab_Cursor INTO @TAB_ID
		END
		CLOSE PageTab_Cursor
		DEALLOCATE PageTab_Cursor


		------------------------------- STARTTING FILTER SECTION -------------------------------------------
		DECLARE @FILTERINSERT AS VARCHAR(MAX)
		SET @FILTERINSERT = 'INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'

		DECLARE @FILTERFIELDINSERT AS VARCHAR(MAX)
		SET @FILTERFIELDINSERT = 'INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,'

		DECLARE PageFilter_Cursor CURSOR FOR

			SELECT FilterId FROM PageFilter WHERE PageId = @PAGE_ID

		OPEN PageFilter_Cursor
		FETCH NEXT FROM PageFilter_Cursor INTO @FILTER_ID
		WHILE @@FETCH_STATUS = 0 /*do while not end of cursor*/
		BEGIN

			SELECT @INSERT = @FILTERINSERT + CAST([FilterCols] AS VARCHAR(10)) + ',''' + [FilterText] + ''',' + CAST([ShowClear] AS VARCHAR(1)) + ',''' + [FilterProps] + ''',''cbeltra'',GETDATE())'
			FROM PageFilter WHERE FilterId = @FILTER_ID
			
			PRINT @INSERT
			PRINT 'SET @FILTER_ID = scope_identity()'
			PRINT ''
			/**
			Starting filter field cursor
			*/
			DECLARE PageFilterField_Cursor CURSOR FOR

				SELECT FilterFieldId FROM PageFilterField WHERE FilterId = @FILTER_ID

			OPEN PageFilterField_Cursor
			FETCH NEXT FROM PageFilterField_Cursor INTO @FILTERFIELD_ID
			WHILE @@FETCH_STATUS = 0 
			BEGIN
				SELECT @FIELDNAME = F.FieldName, @TABNAME = T.TabName FROM PageFilterField FF INNER JOIN PageField F ON FF.FieldId = F.FieldId INNER JOIN PageTab T ON F.TabId = T.TabId WHERE FF.FilterFieldId = @FILTERFIELD_ID
				
				PRINT 'SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = ''' + @TABNAME + ''' AND PageId = @PAGE_ID'
				PRINT 'SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = ''' + @FIELDNAME + ''' AND TabId = @TAB_ID'
				
				
				SELECT @INSERT = @FILTERFIELDINSERT + CAST([FilterOrder] AS VARCHAR(10)) + ',''cbeltra'',GETDATE())'
				FROM PageFilterField WHERE FilterFieldId = @FILTERFIELD_ID	
			
				PRINT @INSERT
				PRINT ''

			   FETCH NEXT FROM PageFilterField_Cursor INTO @FILTERFIELD_ID
			END
			CLOSE PageFilterField_Cursor
			DEALLOCATE PageFilterField_Cursor	
			/*
			End of filter field cursor
			*/
		   FETCH NEXT FROM PageFilter_Cursor INTO @FILTER_ID
		END
		CLOSE PageFilter_Cursor
		DEALLOCATE PageFilter_Cursor


		------------------------------- STARTTING ENTITY EVENTS SECTION -------------------------------------------
		/*
		DECLARE Entity_Cursor CURSOR FOR

				SELECT [EntityEventId] FROM [EntityEvents] WHERE [PageId] = @PAGE_ID

		OPEN Entity_Cursor
		FETCH NEXT FROM Entity_Cursor INTO @ENTITYEVENT_ID
		WHILE @@FETCH_STATUS = 0 
		BEGIN

				SELECT @INSERT = 'INSERT INTO [EntityEvents]([PageId],[EventType],[EventName],[EventOrder],[BreakOnError],[ClassName],[EventProps],[UpdatedBy],[UpdatedDate]) VALUES(' + 
				'@PAGE_ID, ''' + [EventType] + ''',''' +
				[EventName] + ''',' + CAST([EventOrder] AS VARCHAR(10)) + ',' + CAST([BreakOnError] AS VARCHAR(10)) + ',''' + [ClassName] + ''',''' +
				[EventProps] + ''',''cbeltra'',GETDATE())'
				FROM [EntityEvents] WHERE [EntityEventId] = @ENTITYEVENT_ID
			
				PRINT @INSERT
				PRINT ''
								

			FETCH NEXT FROM Entity_Cursor INTO @ENTITYEVENT_ID
		END
		CLOSE Entity_Cursor
		DEALLOCATE Entity_Cursor	
		*/
		------------------------------- END OF ENTITY EVENTS SECTION -------------------------------------------


   FETCH NEXT FROM Page_Cursor INTO @PAGE_ID, @PAGENAME
END
CLOSE Page_Cursor
DEALLOCATE Page_Cursor

PRINT 'GO'
