DECLARE @PAGE_ID AS INT
DECLARE @TAB_ID AS INT
DECLARE @FIELD_ID AS INT
DECLARE @FILTER_ID AS INT
DECLARE @FILTERFIELD_ID AS INT
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'AggregateValue' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'AggregateValue' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('AggregateValue','AggregateValue','tblAggregateValue','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ProdTaskId','ProdTaskId','int',1,'',0,1,'hidden',1,'','ProdTaskId',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ProductId','ProductId','int',1,'',1,2,'inputbox',0,'','Product_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Product_ID',1,'Product_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TaskId','TaskId','int',1,'',1,3,'inputbox',0,'','Task_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Task_ID',2,'Task_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Value','Value','decimal',1,'',1,4,'inputbox',0,'','Value',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Value',3,'Value','cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'CalidadOrdenes' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'CalidadOrdenes' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('CalidadOrdenes','Ordenes Liberadas Calidad','CalidadOrdenesVW','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_Nombre','Orden','varchar',1,'',1,1,'inputbox',1,'','ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Orden',1,'ITE_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Producto','Descripcion','varchar',1,'',1,3,'inputbox',0,'','Producto',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Descripcion',3,'Producto','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Numero','No.Parte','varchar',0,'',1,4,'inputbox',0,'','Numero',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'No.Parte',4,'Numero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Terminal','Term.','varchar',0,'',1,5,'inputbox',0,'','Terminal',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Term.',5,'Terminal','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'OrdenCompra','Orden Compra','varchar',0,'',1,6,'inputbox',0,'','OrdenCompra',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Orden Compra',6,'OrdenCompra','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Recibido','Fecha Recibido','date',0,'',1,7,'inputbox',0,'','Recibido',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha Recibido',7,'Recibido','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Interna','Fecha Interna','date',0,'',1,8,'inputbox',0,'','Interna',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha Interna',8,'Interna','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Entrega','Fecha Compromiso','date',0,'',1,9,'inputbox',0,'','Entrega',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha Compromiso',9,'Entrega','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITS_DTStop','ITS_DTStop','datetime',0,'',1,10,'inputbox',0,'','ITS_DTStop',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Ordenada','Cantidad','int',0,'',1,2,'inputbox',0,'','Ordenada',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Cantidad',2,'Ordenada','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ClientId','ClientId','varchar',1,'',1,11,'inputbox',0,'','ClientId',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Clientes' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Clientes' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Clientes','Clientes','tblClientes','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,3,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Clave','Codigo','varchar',1,'',1,1,'inputbox',0,'','Clave',1,1,'cbeltra',GETDATE(),'{"maxlength":"3"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,100,'Codigo',1,'Clave','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Nombre','Cliente','varchar',1,'',1,3,'inputbox',0,'','Nombre',1,1,'cbeltra',GETDATE(),'{"maxlength":"150","colSpan":"3"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,250,'Cliente',2,'Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Contacto','Contacto','varchar',0,'',1,4,'inputbox',0,'','Contacto',1,1,'cbeltra',GETDATE(),'{"maxlength":"150","colSpan":"3"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,250,'Contacto',3,'Contacto','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Calle','Calle','varchar',0,'',1,5,'inputbox',0,'','Calle',1,1,'cbeltra',GETDATE(),'{"maxlength":"150","colSpan":"3"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Celular','Celular','varchar',0,'',1,12,'inputbox',0,'','Celular',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Ciudad','Ciudad','varchar',0,'',1,9,'inputbox',0,'','Ciudad',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Colonia','Colonia','varchar',0,'',1,7,'inputbox',0,'','Colonia',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'CP','CP','varchar',0,'',1,8,'inputbox',0,'','CP',1,1,'cbeltra',GETDATE(),'{"maxlength":"10"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Email','Email','varchar',0,'',1,15,'inputbox',0,'','Email',1,1,'cbeltra',GETDATE(),'{"maxlength":"150","colSpan":"3"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Estado','Estado','varchar',0,'',1,10,'inputbox',0,'','Estado',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Fax','Fax','varchar',0,'',1,13,'inputbox',0,'','Fax',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Numero','Numero','varchar',0,'',1,6,'inputbox',0,'','Numero',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Recordar','Recordar','int',0,'',1,14,'inputbox',0,'','Recordar',1,1,'cbeltra',GETDATE(),'{"maxlength":"5"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'RFC','RFC','varchar',0,'',1,2,'inputbox',0,'','RFC',1,1,'cbeltra',GETDATE(),'{"maxlength":"50","colSpan":"2"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,100,'RFC',4,'RFC','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Telefono','Telefono','varchar',0,'',1,11,'inputbox',0,'','Telefono',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Id','Id','int',1,'',0,16,'hidden',1,'','Id',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Empleados' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Empleados' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Empleados','Empleados','tblEmpleados','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,2,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Id','No. Empleado','int',1,'',1,1,'inputbox',1,'','Id',1,1,'cbeltra',GETDATE(),'{"readonly":"readonly"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,100,'No. Empleado',1,'Id','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Nombre','Nombre','varchar',1,'',1,2,'inputbox',0,'','Nombre',1,1,'cbeltra',GETDATE(),'{"maxlength":"150"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,200,'Nombre',2,'Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'CostoHora','Costo Hora','decimal',0,'',1,7,'inputbox',0,'','CostoHora',1,1,'cbeltra',GETDATE(),'{"maxlength":"10"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Departamento','Departamento','varchar',0,'',1,3,'inputbox',0,'','Departamento',1,1,'cbeltra',GETDATE(),'{"maxlength":"150"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,200,'Departamento',3,'Departamento','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'FechaNac','Fecha Nacimiento','date',0,'',1,8,'inputbox',0,'','FechaNac',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Percepciones','Percepciones','decimal',0,'',1,6,'inputbox',0,'','Percepciones',1,1,'cbeltra',GETDATE(),'{"maxlength":"10"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Puesto','Puesto','varchar',0,'',1,4,'inputbox',0,'','Puesto',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,200,'Puesto',4,'Puesto','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Turno','Turno','int',0,'',1,5,'inputbox',0,'','Turno',1,1,'cbeltra',GETDATE(),'{"maxlength":"1"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,60,'Turno',5,'Turno','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Activo','Activo','bit',1,'',1,9,'checkbox',0,'','Activo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,60,'Activo',6,'Activo','cbeltra',GETDATE())
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Entradas' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Entradas' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Entradas','Entradas','tblEntradas','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Entrada','',1,4,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Pedimento','Pedimento','varchar',1,'',1,1,'inputbox',0,'','ENT_Pedimento',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Pedimento',1,'ENT_Pedimento','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Dolares','Dolares','bit',0,'',1,4,'checkbox',0,'','ENT_Dolares',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_TipoImp','Tipo Importacion','varchar',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=PageListItem&entity={\"FieldName\":\"TipoImportacion\"}","valField":"Text","textField":"Text","cache":true}',1,7,'selectmenu',0,'','ENT_TipoImp',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_OrdenCompra','Orden Compra','varchar',1,'',1,10,'inputbox',0,'','ENT_OrdenCompra',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Orden Compra',5,'ENT_OrdenCompra','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_ID','ENT_ID','int',1,'',1,13,'hidden',1,'','ENT_ID',1,1,'cbeltra',GETDATE(),'{"search-type":"equals"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_ClavePedimento','Clave Pedimento','varchar',1,'',1,2,'inputbox',0,'','ENT_ClavePedimento',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Clave Pedimento',2,'ENT_ClavePedimento','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_PaisOrigen','Pais Origen','int',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Paises","valField":"PAIS_ID","textField":"PAIS_Nombre","cache":true}',1,5,'selectmenu',0,'{"TableName":"tblPaises","JoinType":"LEFT","JoinField":"PAIS_ID","JoinFields":"PAIS_Nombre"}','ENT_PaisOrigen',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_TipoCambio','Tipo Cambio','decimal',0,'',1,8,'inputbox',0,'','ENT_TipoCambio',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_ID','Provedor','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Provedores","valField":"PROV_ID","textField":"PROV_Nombre","cache":true}',1,11,'dropdownlist',0,'{"TableName":"tblProvedores","JoinType":"LEFT","JoinField":"PROV_ID","JoinFields":"PROV_Nombre"}','PROV_ID',1,1,'cbeltra',GETDATE(),'{"filter-type":"text"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Provedor',6,'PROV_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'USE_ID','USE_ID','int',0,'',1,14,'hidden',0,'','USE_ID',1,1,'cbeltra',GETDATE(),'{"defaultVal":"js:USER_ID"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Fecha','Fecha','date',1,'',1,3,'inputbox',0,'','ENT_Fecha',1,1,'cbeltra',GETDATE(),'{"filter-type":"date-range"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha',3,'ENT_Fecha','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Nacional','Tipo Entrada','varchar',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=PageListItem&entity={\"FieldName\":\"TipoEntrada\"}","valField":"Text","textField":"Text","cache":true}',1,6,'selectmenu',0,'','ENT_Nacional',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Factura','Factura','varchar',0,'',1,9,'inputbox',0,'','ENT_Factura',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Factura',4,'ENT_Factura','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_IVA','IVA','int',0,'',1,12,'inputbox',0,'','ENT_IVA',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,3,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Entrada' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ENT_Pedimento' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,1,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Entrada' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ENT_Factura' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,2,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Entrada' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'PROV_ID' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,3,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Entrada' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ENT_Fecha' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,4,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Entrada' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ENT_OrdenCompra' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,5,'cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'EntradasAlmacen' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'EntradasAlmacen' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('EntradasAlmacen','Reporte de Entradas Almacen','tblEntradasDetalle','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,2,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_Cantidad','Cantidad','decimal',0,'',1,5,'inputbox',0,'','ED_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,60,'Cantidad',3,'ED_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_Costo','Precio Unitario','decimal',0,'',1,7,'inputbox',0,'','ED_Costo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,70,'Precio Unitario',5,'ED_Costo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_Restante','ED_Restante','decimal',0,'',0,9,'inputbox',0,'','ED_Restante',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_ID','ED_ID','int',1,'',0,2,'hidden',1,'','ED_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_ID','ENT_ID','int',0,'',0,1,'inputbox',0,'{"TableName":"tblEntradas","JoinType":"INNER","JoinField":"ENT_ID","JoinFields":"ENT_Fecha,PROV_ID,ENT_Factura,ENT_TipoImp,ENT_Nacional,ENT_Pedimento,ENT_OrdenCompra"}','ENT_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ID','Descripcion','int',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Materiales","valField":"MAT_ID","textField":"MAT_Descripcion","cache":true,"filter":true,"header":true}',0,11,'multiselect',0,'{"TableName":"tblMateriales","JoinType":"LEFT","JoinField":"MAT_ID","JoinFields":"MAT_Numero,MAT_Descripcion,MAT_Cantidad,MAT_Tipo"}','MAT_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,0,1,0,'Descripcion',10,'MAT_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Tipo','MAT_Tipo','int',0,'',0,13,'hidden',0,'{"TableName":"tblTiposMaterial","JoinType":"LEFT","JoinField":"TIP_ID","JoinFields":"TIP_Descripcion"}','MAT_Tipo',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_ID','Provedor','int',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Provedores","valField":"PROV_ID","textField":"PROV_Nombre","cache":true,"filter":true,"header":true}',0,8,'multiselect',0,'{"TableName":"tblProvedores","JoinType":"LEFT","JoinField":"PROV_ID","JoinFields":"PROV_Nombre"}','PROV_ID',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,0,1,0,'Provedor',9,'PROV_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Fecha','Fecha Entrada','date',0,'',1,3,'inputbox',0,'','ENT_Fecha',0,0,'cbeltra',GETDATE(),'{"filter-type":"date-range"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'Fecha Entrada',1,'ENT_Fecha','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Numero','IDMaterial','varchar',0,'',1,4,'inputbox',0,'','MAT_Numero',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,100,'IDMaterial',2,'MAT_Numero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Descripcion','Descripcion','varchar',0,'',1,6,'inputbox',0,'','MAT_Descripcion',0,0,'cbeltra',GETDATE(),'{"nowrap":"true"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,200,'Descripcion',4,'MAT_Descripcion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Cantidad','SaldoAlmacen','decimal',0,'',1,10,'inputbox',0,'','MAT_Cantidad',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,70,'SaldoAlmacen',6,'MAT_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Nombre','Proveedor Name','varchar',0,'',1,15,'hidden',0,'','PROV_Nombre',0,0,'cbeltra',GETDATE(),'{"nowrap":"true","search-type":"text"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,150,'Proveedor',7,'PROV_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Factura','Factura','varchar',0,'',1,17,'inputbox',0,'','ENT_Factura',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_TipoImp','TipoImp','varchar',0,'',1,18,'inputbox',0,'','ENT_TipoImp',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_OrdenCompra','OrdenCompra','varchar',0,'',1,12,'inputbox',0,'','ENT_OrdenCompra',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'OrdenCompra',8,'ENT_OrdenCompra','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Nacional','TipoEntrada','varchar',0,'',1,14,'inputbox',0,'','ENT_Nacional',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Pedimento','Pedimento','varchar',0,'',1,16,'inputbox',0,'','ENT_Pedimento',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,2,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ENT_Fecha' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,1,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'PROV_ID' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,2,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'MAT_ID' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,3,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'MAT_Numero' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,4,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ENT_OrdenCompra' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,5,'cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'EntradasContraSalidas' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'EntradasContraSalidas' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('EntradasContraSalidas','Reporte de Entradas vs Salidas','EntradasSalidas_VW','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,3,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_Cantidad','Cantidad Entrada','decimal',0,'',1,1,'inputbox',0,'','ED_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Cantidad Entrada',3,'ED_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_ID','ED_ID','int',1,'',0,28,'inputbox',1,'','ED_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_Restante','ED_Restante','decimal',0,'',0,2,'inputbox',0,'','ED_Restante',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Saldo Almacen',20,'ED_Restante','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_ClavePedimento','Clave Pedimento','varchar',0,'',1,29,'inputbox',0,'','ENT_ClavePedimento',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Desp','ENT_Desp','int',0,'',0,3,'inputbox',0,'','ENT_Desp',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Dolares','Dolares','bit',0,'',1,33,'checkbox',0,'','ENT_Dolares',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Factura','Factura','varchar',0,'',1,4,'inputbox',0,'','ENT_Factura',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Factura',11,'ENT_Factura','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Fecha','Fecha Entrada','date',0,'',1,31,'inputbox',0,'','ENT_Fecha',1,1,'cbeltra',GETDATE(),'{"filter-type":"date-range"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha Entrada',1,'ENT_Fecha','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_IVA','Entrada IVA','int',0,'',1,5,'inputbox',0,'','ENT_IVA',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Nacional','Tipo Entrada','varchar',0,'',1,32,'inputbox',0,'','ENT_Nacional',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Tipo Entrada',12,'ENT_Nacional','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_OrdenCompra','Orden Compra','varchar',0,'',1,6,'inputbox',0,'','ENT_OrdenCompra',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Orden Compra',10,'ENT_OrdenCompra','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_PaisOrigen','Pais Origen','int',0,'',0,36,'inputbox',0,'','ENT_PaisOrigen',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Pedimento','Pedimento','varchar',0,'',1,7,'inputbox',0,'','ENT_Pedimento',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Pedimento',14,'ENT_Pedimento','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_TipoCambio','Tipo Cambio','decimal',0,'',1,34,'inputbox',0,'','ENT_TipoCambio',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_TipoImp','Tipo Importacion','varchar',0,'',1,8,'inputbox',0,'','ENT_TipoImp',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Tipo Importacion',13,'ENT_TipoImp','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_USE_ID','ENT_USE_ID','int',0,'',0,35,'inputbox',0,'','ENT_USE_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ES_Costo','ES_Costo','decimal',0,'',0,12,'inputbox',0,'','ES_Costo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Precio Unitario Salida',17,'ES_Costo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ES_ID','ES_ID','int',0,'',0,39,'inputbox',0,'','ES_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'IS_SL','IS_SL','bit',0,'',0,10,'checkbox',0,'','IS_SL',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Cantidad','MAT_Cantidad','decimal',0,'',0,37,'inputbox',0,'','MAT_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Costo','MAT_Costo','decimal',0,'',0,11,'inputbox',0,'','MAT_Costo',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_CostoPromedio','Costo Promedio','decimal',0,'',1,38,'inputbox',0,'','MAT_CostoPromedio',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Densidad','MAT_Densidad','decimal',0,'',0,15,'inputbox',0,'','MAT_Densidad',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Descripcion','Descripcion','varchar',0,'',1,42,'inputbox',0,'','MAT_Descripcion',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,0,0,'Descripcion',5,'MAT_Descripcion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Fecha','MAT_Fecha','datetime',0,'',0,13,'inputbox',0,'','MAT_Fecha',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Fraccion','Fraccion Arancelaria','varchar',0,'',1,40,'inputbox',0,'','MAT_Fraccion',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ID','Descripcion','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Materiales","valField":"MAT_ID","textField":"MAT_Descripcion","cache":true,"filter":true,"header":true}',1,14,'multiselect',0,'','MAT_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,0,1,0,'MAT_ID',22,'MAT_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Kilos','MAT_Kilos','bit',0,'',0,41,'checkbox',0,'','MAT_Kilos',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Maximo','Material Maximo','decimal',0,'',1,18,'inputbox',0,'','MAT_Maximo',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Minimo','Material Minimo','decimal',0,'',1,45,'inputbox',0,'','MAT_Minimo',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Numero','ID Material','varchar',0,'',1,16,'inputbox',0,'','MAT_Numero',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ID Material',2,'MAT_Numero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ProvNumero','MAT_ProvNumero','varchar',0,'',0,43,'inputbox',0,'','MAT_ProvNumero',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Stock','MAT_Stock','decimal',0,'',0,17,'inputbox',0,'','MAT_Stock',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Tipo','MAT_Tipo','int',0,'',0,44,'inputbox',0,'','MAT_Tipo',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Total','MAT_Total','decimal',0,'',0,21,'inputbox',0,'','MAT_Total',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Ubicacion','Material Ubicacion','varchar',0,'',1,48,'inputbox',0,'','MAT_Ubicacion',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_UltimoCosto','Ultimo Costo','decimal',0,'',1,19,'inputbox',0,'','MAT_UltimoCosto',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_UltimoProvedor','MAT_UltimoProvedor','int',0,'',0,46,'inputbox',0,'','MAT_UltimoProvedor',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Unidad','MAT_Unidad','int',0,'',0,20,'inputbox',0,'','MAT_Unidad',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Usuario','MAT_Usuario','int',0,'',0,47,'inputbox',0,'','MAT_Usuario',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_ID','PROV_ID','int',0,'',0,24,'inputbox',0,'','PROV_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Nombre','Provedor','varchar',0,'',1,51,'inputbox',0,'','PROV_Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Provedor',9,'PROV_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_Fecha','Fecha Salida','date',0,'',1,22,'inputbox',0,'','SAL_Fecha',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha Salida',15,'SAL_Fecha','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_ID','SAL_ID','int',0,'',0,49,'inputbox',0,'','SAL_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_Orden','Salida Orden','varchar',0,'',1,23,'inputbox',0,'','SAL_Orden',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_Solicitado','SAL_Solicitado','int',0,'',0,50,'inputbox',0,'','SAL_Solicitado',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_USE_ID','SAL_USE_ID','int',0,'',0,27,'inputbox',0,'','SAL_USE_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SD_Cantidad','Cantidad Salida','decimal',0,'',1,54,'inputbox',0,'','SD_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Cantidad Salida',16,'SD_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SD_ID','SD_ID','int',0,'',0,25,'inputbox',0,'','SD_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SL_Cantidad','SL_Cantidad','int',0,'',0,52,'inputbox',0,'','SL_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SL_Desp','SL_Desp','int',0,'',0,26,'inputbox',0,'','SL_Desp',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SL_Pedimento','SL_Pedimento','varchar',0,'',0,53,'inputbox',0,'','SL_Pedimento',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TIP_Descripcion','Tipo Material','varchar',0,'',1,30,'inputbox',0,'','TIP_Descripcion',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Tipo Material',4,'TIP_Descripcion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Total','Total Entrada','decimal',0,'',1,56,'inputbox',0,'','Total',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Total Entrada',7,'Total','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_Costo','Entrada Costo','decimal',1,'',1,9,'inputbox',0,'','ED_Costo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Precio Unitario',6,'ED_Costo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TotalSalida','TotalSalida','decimal',0,'',1,55,'inputbox',0,'','TotalSalida',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Total Salida',18,'TotalSalida','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SaldoAlmacenDinero','Saldo Almacen Dinero','decimal',0,'',1,57,'inputbox',0,'','SaldoAlmacenDinero',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Saldo Almacen Dinero',21,'SaldoAlmacenDinero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SaldoEntrda','SaldoEntrda','decimal',0,'',1,58,'inputbox',0,'','SaldoEntrda',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'SaldoEntrda',8,'SaldoEntrda','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SaldoSalida','SaldoSalida','decimal',0,'',1,59,'inputbox',0,'','SaldoSalida',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'SaldoSalida',19,'SaldoSalida','cbeltra',GETDATE())
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,2,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ENT_Fecha' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,1,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'MAT_ID' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,2,'cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'EntradasDetalle' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'EntradasDetalle' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('EntradasDetalle','Entradas Detalle','tblEntradasDetalle','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_Cantidad','Cantidad','decimal',1,'',1,3,'inputbox',0,'','ED_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Cantidad',4,'ED_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_ID','ENT_ID','int',0,'',1,6,'hidden',0,'','ENT_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ID','Material','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Materiales","valField":"MAT_ID","textField":"MAT_Descripcion","cache":true}',1,2,'dropdownlist',0,'{"TableName":"tblMateriales","JoinType":"INNER","JoinField":"MAT_ID","JoinFields":"MAT_Numero,MAT_ProvNumero,MAT_Descripcion"}','MAT_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_Costo','Costo','decimal',1,'',1,4,'inputbox',0,'','ED_Costo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Costo',5,'ED_Costo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_Restante','Restante','decimal',0,'',1,7,'hidden',0,'','ED_Restante',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_ID','ED_ID','int',1,'',1,8,'hidden',1,'','ED_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Descripcion','Material Descripcion','varchar',0,'',0,5,'hidden',0,'','MAT_Descripcion',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Material',3,'MAT_Descripcion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Numero','ID','varchar',0,'',0,9,'hidden',0,'','MAT_Numero',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ID',1,'MAT_Numero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ProvNumero','Proveedor ID','varchar',0,'',0,1,'inputbox',0,'','MAT_ProvNumero',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ProvedorID',2,'MAT_ProvNumero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Total','Total','varchar',0,'',0,10,'hidden',0,'','Total',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,0,0,'Total',6,'Total','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Salida','Salida','varchar',0,'',0,11,'hidden',0,'','Salida',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Prev_Cantidad','Prev_Cantidad','varchar',0,'',0,12,'hidden',0,'','Prev_Cantidad',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_Saldo','ED_Saldo','decimal',0,'',1,13,'hidden',0,'','ED_Saldo',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'EntradasSalidas' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'EntradasSalidas' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('EntradasSalidas','EntradasSalidas','tblEntradasSalidas','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ES_ID','ES_ID','int',1,'',1,1,'inputbox',1,'','ES_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ES_ID',1,'ES_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_ID','ED_ID','int',0,'',1,2,'inputbox',0,'','ED_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ED_ID',2,'ED_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SD_ID','SD_ID','int',0,'',1,3,'inputbox',0,'','SD_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'SD_ID',3,'SD_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_Cantidad','ED_Cantidad','decimal',0,'',1,4,'inputbox',0,'','ED_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ED_Cantidad',4,'ED_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ES_Costo','ES_Costo','decimal',0,'',1,5,'inputbox',0,'','ES_Costo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ES_Costo',5,'ES_Costo','cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'EntradasSalidasConta' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'EntradasSalidasConta' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('EntradasSalidasConta','Entradas vs Salidas Conta','EntradasSalidasConta_VW','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Type','Tipo','varchar',1,'',1,1,'inputbox',0,'','Type',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'Tipo',1,'Type','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Fecha','Fecha','date',0,'',1,2,'inputbox',0,'','Fecha',1,1,'cbeltra',GETDATE(),'{"filter-type":"date-range"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'Fecha',2,'Fecha','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TIP_Descripcion','TipoMaterial','varchar',0,'',1,5,'inputbox',0,'','TIP_Descripcion',1,1,'cbeltra',GETDATE(),'{"nowrap":"true"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,200,'TipoMaterial',4,'TIP_Descripcion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Numero','IDMaterial','varchar',0,'',1,4,'inputbox',0,'','MAT_Numero',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,120,'IDMaterial',5,'MAT_Numero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Descripcion','Descripcion','varchar',0,'',1,3,'inputbox',0,'','MAT_Descripcion',1,1,'cbeltra',GETDATE(),'{"nowrap":"true"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,300,'Descripcion',3,'MAT_Descripcion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'CantidadEntrada','CantidadEntrada','decimal',1,'',1,6,'inputbox',0,'','CantidadEntrada',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'CantidadEntrada',6,'CantidadEntrada','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'CantidadSalida','CantidadSalida','decimal',0,'',1,7,'inputbox',0,'','CantidadSalida',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'CantidadSalida',7,'CantidadSalida','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Saldo','Saldo','decimal',0,'',1,8,'inputbox',0,'','Saldo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Saldo',8,'Saldo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'OrdenTrabajo','OrdenTrabajo','varchar',0,'',1,10,'inputbox',0,'','OrdenTrabajo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'OrdenTrabajo',10,'OrdenTrabajo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Nombre','Provedor','varchar',0,'',1,11,'inputbox',0,'','PROV_Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Provedor',11,'PROV_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Factura','Factura','varchar',0,'',1,12,'inputbox',0,'','ENT_Factura',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Factura',12,'ENT_Factura','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_OrdenCompra','OrdenCompra','varchar',0,'',1,13,'inputbox',0,'','ENT_OrdenCompra',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'OrdenCompra',13,'ENT_OrdenCompra','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ENT_Pedimento','ENT_Pedimento','varchar',0,'',1,14,'inputbox',0,'','ENT_Pedimento',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ID','Descripcion','int',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Materiales","valField":"MAT_ID","textField":"MAT_Descripcion","cache":true,"filter":true,"header":true}',1,15,'multiselect',1,'','MAT_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,0,1,0,'MAT_ID',14,'MAT_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_ID','PROV_ID','int',0,'',1,16,'inputbox',0,'','PROV_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Costo','Precio Unitario','decimal',0,'',1,9,'inputbox',0,'','Costo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Precio Unitario',9,'Costo','cbeltra',GETDATE())
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,2,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Fecha' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,1,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'MAT_ID' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,2,'cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'ExistenciaMateriales' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'ExistenciaMateriales' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('ExistenciaMateriales','Existencia de Materiales','ExistenciaMateriales_VW','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ID','MAT_ID','int',0,'',1,1,'inputbox',1,'','MAT_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'MAT_ID',1,'MAT_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Existencia','Existencia','decimal',0,'',1,2,'inputbox',0,'','Existencia',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Existencia',2,'Existencia','cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'FechaEntrega' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'FechaEntrega' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('FechaEntrega','Relacion de Fecha de Entrega','tblOrdenes','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_Nombre','Orden','varchar',1,'',1,2,'inputbox',1,'','ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,90,'Orden',1,'ITE_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ProductId','Descripcion','int',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Productos","valField":"Id","textField":"Nombre","cache":true,"header":true,"filter":true}',1,3,'multiselect',0,'{"TableName":"tblProductos","JoinType":"INNER","JoinField":"Id","JoinFields":"Nombre AS ProductDesc"}','ProductId',1,1,'cbeltra',GETDATE(),'{"filter-type":"text"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Descripcion',4,'ProductDesc','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Interna','Interna','date',0,'',1,4,'inputbox',0,'','Interna',1,1,'cbeltra',GETDATE(),'{"filter-type":"date-range"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,70,'Fecha Interna',8,'Interna','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'OrdenCompra','Orden Compra','varchar',0,'',1,7,'inputbox',0,'','OrdenCompra',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'Orden Compra',6,'OrdenCompra','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Ordenada','Ordenada','int',0,'',1,8,'inputbox',0,'','Ordenada',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,0,50,'Cant. Larco',2,'Ordenada','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Numero','No. Parte','varchar',0,'',1,9,'inputbox',0,'','Numero',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'No. Parte',5,'Numero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Entrega','Compromiso','date',0,'',1,5,'inputbox',0,'','Entrega',1,1,'cbeltra',GETDATE(),'{"filter-type":"date-range"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'Fecha Compromiso',9,'Entrega','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Recibido','Recibido','date',0,'',1,6,'inputbox',0,'','Recibido',1,1,'cbeltra',GETDATE(),'{"filter-type":"date-range"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'Fecha Recibido',10,'Recibido','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Requerida','Requerida','int',0,'',1,10,'inputbox',0,'','Requerida',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,0,50,'Cant. Cliente',3,'Requerida','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Terminal','Terminal','varchar',0,'',1,11,'inputbox',0,'','Terminal',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,0,80,'Term.',7,'Terminal','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Observaciones','Observaciones','varchar',0,'',1,12,'inputbox',0,'','Observaciones',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,0,0,'Observaciones',15,'Observaciones','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TAS_Id','Tarea','int',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Tareas","valField":"Id","textField":"Nombre","cache":true,"header":true,"filter":true}',0,14,'multiselect',0,'{"TableName":"tblTareas","JoinType":"INNER","JoinField":"Id","JoinFields":"Nombre AS TaskName"}','TAS_Id',0,0,'cbeltra',GETDATE(),'{"filter-type":"text"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Tarea',11,'TaskName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITS_Status','ITS_Status','int',0,'',0,15,'inputbox',0,'{"TableName":"PageListItem","JoinType":"LEFT","JoinField":"Value","JoinFields":"Text AS TaskStatus","ExtraJoinDetails":" AND J#.FieldName = ''TaskStatus''"}','ITS_Status',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,0,0,'Status',12,'TaskStatus','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ClientId','Cliente','varchar',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Clientes","valField":"Clave","textField":"Clave","cache":true,"header":true,"filter":true}',1,13,'multiselect',0,'','ClientId',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,0,1,0,'Cliente',16,'ClientId','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITS_DTStart','ITS_DTStart','datetime',0,'',0,16,'inputbox',0,'','ITS_DTStart',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,0,120,'Fecha y hora',13,'ITS_DTStart','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'USE_Login','USE_Login','int',0,'',0,17,'inputbox',0,'{"TableName":"tblEmpleados","JoinType":"LEFT","JoinField":"Id","JoinFields":"Nombre AS EmployeeName"}','USE_Login',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,0,120,'Empleado',14,'EmployeeName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'OrdenId','OrdenId','int',1,'',1,1,'inputbox',0,'{"TableName":"tblItemTasks","JoinType":"INNER","JoinField":"OrdenId","JoinFields":"ITS_Status,TAS_Id,ITS_DTStart,USE_Login","ExtraJoinDetails":"AND J#.ITS_DTStart IS NOT NULL AND J#.ITS_DTStop IS NULL AND J#.ITS_Status <> 9"}','OrdenId',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,3,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Recibido' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,1,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ProductId' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,2,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Interna' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,3,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ClientId' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,4,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Entrega' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,5,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'TAS_Id' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,6,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ITE_Nombre' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,7,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Numero' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,8,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'OrdenCompra' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,9,'cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Items' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Items' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Items','Items','tblItems','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_ID','ITE_ID','int',1,'',1,1,'inputbox',1,'','ITE_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_Nombre','ITE_Nombre','varchar',1,'',1,2,'inputbox',0,'','ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PRO_Nombre','PRO_Nombre','varchar',1,'',1,3,'inputbox',0,'','PRO_Nombre',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ProductId','ProductId','int',1,'',1,4,'inputbox',0,'','ProductId',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'ItemTasks' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'ItemTasks' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('ItemTasks','ItemTasks','tblItemTasks','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_ID','ITE_ID','int',1,'',1,8,'hidden',0,'','ITE_Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_Nombre','ITE_Nombre','varchar',1,'',1,1,'inputbox',0,'','ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ItemTaskId','ItemTaskId','int',1,'',1,10,'hidden',1,'','ItemTaskId',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITS_DTStart','ITS_DTStart','datetime',0,'',1,2,'inputbox',0,'','ITS_DTStart',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITS_DTStop','ITS_DTStop','datetime',0,'',1,3,'inputbox',0,'','ITS_DTStop',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITS_Machine','ITS_Machine','varchar',0,'',1,4,'inputbox',0,'','ITS_Machine',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TAS_Id','TAS_Id','int',1,'',1,5,'inputbox',0,'{"TableName":"tblTareas","JoinField":"Id","JoinType":"INNER","JoinFields":"TAS_Order" }','TAS_Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'USE_Login','USE_Login','varchar',0,'',1,6,'inputbox',0,'','USE_Login',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITS_Status','ITS_Status','tinyint',0,'',1,7,'inputbox',0,'','ITS_Status',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'OrdenId','OrdenId','int',1,'',1,9,'hidden',0,'','OrdenId',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Materiales' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Materiales' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Materiales','Materiales','tblMateriales','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,2,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Cantidad','Existencia','decimal',0,'',1,10,'inputbox',0,'','MAT_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Existencia',2,'MAT_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Costo','MAT_Costo','decimal',0,'',1,18,'hidden',0,'','MAT_Costo',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_CostoPromedio','Costo Promedio','decimal',0,'',1,12,'inputbox',0,'','MAT_CostoPromedio',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Costo Promedio',4,'MAT_CostoPromedio','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Densidad','Densidad','decimal',0,'',1,9,'inputbox',0,'','MAT_Densidad',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Descripcion','Descripcion','varchar',0,'',1,4,'inputbox',0,'','MAT_Descripcion',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Descripcion',1,'MAT_Descripcion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Fecha','MAT_Fecha','datetime',0,'',1,20,'hidden',0,'','MAT_Fecha',1,1,'cbeltra',GETDATE(),'{"defaultVal":"GETDATE()"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Fraccion','Fraccion Arancelaria:','varchar',0,'',1,1,'inputbox',0,'','MAT_Fraccion',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ID','MAT_ID','int',1,'',1,21,'hidden',1,'','MAT_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Kilos','Conversion a Kilos','bit',0,'',1,8,'checkbox',0,'','MAT_Kilos',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Maximo','Maximo','decimal',0,'',1,13,'inputbox',0,'','MAT_Maximo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Maximo',5,'MAT_Maximo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Minimo','Minimo','decimal',0,'',1,14,'inputbox',0,'','MAT_Minimo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Minimo',6,'MAT_Minimo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ProvNumero','Provedor Id','varchar',0,'',1,3,'inputbox',0,'','MAT_ProvNumero',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Stock','Cantidad Ideal','decimal',0,'',1,15,'inputbox',0,'','MAT_Stock',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Tipo','Tipo de Material','int',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=TiposMaterial","valField":"TIP_ID","textField":"TIP_Descripcion","cache":true}',1,6,'selectmenu',0,'','MAT_Tipo',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Total','MAT_Total','decimal',0,'',1,17,'hidden',0,'','MAT_Total',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Ubicacion','Ubicacion Almacen','varchar',0,'',1,7,'inputbox',0,'','MAT_Ubicacion',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_UltimoCosto','Ultimo Costo','decimal',0,'',1,11,'inputbox',0,'','MAT_UltimoCosto',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Ultimo Costo',3,'MAT_UltimoCosto','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_UltimoProvedor','Ultimo Provedor','int',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Provedores","valField":"PROV_ID","textField":"PROV_Nombre","cache":true}',1,16,'selectmenu',0,'','MAT_UltimoProvedor',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Unidad','Unidad de Medida','int',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=UnidadesMedida","valField":"UNI_ID","textField":"UNI_Medida","cache":true}',1,5,'selectmenu',0,'','MAT_Unidad',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Usuario','MAT_Usuario','int',0,'',1,19,'hidden',0,'','MAT_Usuario',1,1,'cbeltra',GETDATE(),'{"defaultVal":"js:LOGIN_NAME"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Numero','Numero Id','varchar',0,'',1,2,'inputbox',0,'','MAT_Numero',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'MergeOrdenes' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'MergeOrdenes' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('MergeOrdenes','MergeOrdenes','tblMergeOrdenes','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Order_ITE_Nombre','ITE_Nombre','varchar',1,'',1,3,'hidden',0,'','ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MO_Cantidad','Cantidad','int',1,'',1,2,'inputbox',0,'','MO_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Cantidad',2,'MO_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MO_ID','MO_ID','int',1,'',0,6,'hidden',1,'','MO_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MO_ITE_Nombre','Orden','varchar',1,'',1,1,'selectmenu',0,'','MO_ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Orden',1,'MO_ITE_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Update_Date','Update_Date','datetime',0,'',1,4,'hidden',0,'','Update_Date',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Update_User','Update_User','int',0,'',1,5,'hidden',0,'','Update_User',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Modules' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Modules' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Modules','Modules','tblScreens','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_ID','ModuleId','int',1,'',0,1,'hidden',1,'','SCR_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ModuleId',1,'SCR_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ModuleOrder','Module Order','int',1,'',1,6,'inputbox',0,'','ModuleOrder',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Module Order',5,'ModuleOrder','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ParentModule','Parent Module','int',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Modules&entity={\"ParentModule\":\"NULL\"}","valField":"SCR_ID","textField":"ModuleName","cache":true}',1,7,'selectmenu',0,'{"TableName":"tblScreens","JoinField":"SCR_ID","JoinType":"LEFT","JoinFields":"SCR_NAME AS ParentModuleText" }','ParentModule',1,1,'cbeltra',GETDATE(),'{}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Parent Module',6,'ParentModuleText','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Description','Description','varchar',0,'',1,3,'inputbox',0,'','SCR_Description',1,1,'cbeltra',GETDATE(),'{"maxlength":"150"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'FormName','Form Name','varchar',0,'',1,4,'inputbox',0,'','SCR_FormName',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Form Name',3,'FormName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ModuleName','Module Name','varchar',1,'',1,2,'inputbox',0,'','SCR_Name',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Module Name',2,'ModuleName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Year','SCR_Year','varchar',0,'',1,8,'hidden',0,'','SCR_Year',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'URL','URL','nvarchar',0,'',1,5,'inputbox',0,'','URL',1,1,'cbeltra',GETDATE(),'{"maxlength":"100"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'URL',4,'URL','cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Ordenes' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Ordenes' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Ordenes','Ventas','tblOrdenes','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Detalles','',1,4,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Aprobacion','Aprobacion de Proceso','bit',0,'',1,15,'checkbox',0,'','Aprobacion',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Entrega','Fecha Compromiso','date',0,'',1,11,'inputbox',0,'','Entrega',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha Compromiso',7,'Entrega','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_ID','ITE_ID','int',0,'',1,30,'hidden',0,'','ITE_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'EmployeeId','Nombre','varchar',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Empleados&entity={\"Departamento\":\"LIST_Ventas,Administracion\"}","valField":"Id","textField":"Nombre","cache":true}',1,13,'selectmenu',0,'{"TableName":"tblEmpleados","JoinType":"INNER","JoinField":"Id","JoinFields":"Nombre AS EmployeeName"}','EmployeeId',1,1,'cbeltra',GETDATE(),'{"filter-type":"text"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Nombre',8,'EmployeeName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Observaciones','Observaciones','varchar',0,'',1,25,'multiline',0,'','Observaciones',1,1,'cbeltra',GETDATE(),'{"colSpan":"2","maxlength":"1000","rows":"2"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'OrdenCompra','Orden Compra','varchar',0,'',1,12,'inputbox',0,'','OrdenCompra',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Orden Compra',4,'OrdenCompra','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PN_Id','Numero de Plano','varchar',0,'',1,3,'inputbox',0,'{"TableName":"tblPlano","JoinType":"LEFT","JoinField":"PN_Id","JoinFields":"PN_Numero"}','PN_Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Recibido','Fecha Recibido','date',0,'',1,9,'inputbox',0,'','Recibido',1,1,'cbeltra',GETDATE(),'{"readonly":"true"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha Recibido',5,'Recibido','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Requisicion','Requisicion','varchar',0,'',1,14,'inputbox',0,'','Requisicion',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'StockParcial','StockParcial','bit',0,'',1,21,'checkbox',0,'','StockParcial',1,1,'cbeltra',GETDATE(),'{"readonly":"true"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Terminal','Revision','varchar',0,'',1,8,'inputbox',0,'','Terminal',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Total','Total','decimal',0,'',1,18,'inputbox',0,'','Total',1,1,'cbeltra',GETDATE(),'{"readonly":"true","maxlength":"7"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Update_Date','Update_Date','datetime',0,'',1,29,'hidden',0,'','Update_Date',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Urgente','Urgente','bit',0,'',1,16,'checkbox',0,'','Urgente',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Dolares','Dolares','bit',0,'',1,19,'checkbox',0,'','Dolares',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'FAC_Id','FAC_Id','int',0,'',1,24,'hidden',0,'','FAC_Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Interna','Fecha Interna','date',0,'',1,10,'inputbox',0,'','Interna',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha Interna',6,'Interna','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_Nombre','Orden de Trabajo','varchar',1,'',1,1,'inputbox',0,'','ITE_Nombre',1,1,'cbeltra',GETDATE(),'{"maxlength":"13"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Orden de Trabajo',1,'ITE_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Numero','Numero de Parte','varchar',0,'',1,4,'inputbox',0,'','Numero',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Numero',3,'Numero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Ordenada','Cantidad Larco','int',1,'',1,7,'inputbox',0,'','Ordenada',1,1,'cbeltra',GETDATE(),'{"maxlength":"5"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Otras','Otra Descripcion','varchar',0,'',1,26,'multiline',0,'','Otras',1,1,'cbeltra',GETDATE(),'{"colSpan":"2","maxlength":"500","rows":"2"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ProductId','Descripcion/Producto','varchar',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Productos","valField":"Id","textField":"Nombre","cache":true}',1,5,'dropdownlist',0,'{"TableName":"tblProductos","JoinType":"INNER","JoinField":"Id","JoinFields":"Nombre AS ProductDesc"}','ProductId',1,1,'cbeltra',GETDATE(),'{"filter-type":"text","colSpan":"2"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Descripcion',2,'ProductDesc','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Requerida','Cantidad Cliente','int',1,'',1,6,'inputbox',0,'','Requerida',1,1,'cbeltra',GETDATE(),'{"maxlength":"5"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ST_ID','ST_ID','int',0,'',1,27,'hidden',0,'','ST_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'StockParcialCantidad','StockParcialCantidad','int',0,'',1,34,'hidden',0,'','StockParcialCantidad',1,1,'cbeltra',GETDATE(),'{"maxlength":"5"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TipoProceso','Tipo Proceso','varchar',0,'',1,2,'inputbox',0,'','TipoProceso',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Unitario','Valor Unitario','decimal',1,'',1,17,'inputbox',0,'','Unitario',1,1,'cbeltra',GETDATE(),'{"maxlength":"7"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Update_User','Update_User','int',0,'',1,31,'hidden',0,'','Update_User',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Mezclado','Mezclar','bit',0,'',1,22,'checkbox',0,'','Mezclado',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'OrdenId','OrdenId','int',1,'',1,37,'hidden',1,'','OrdenId',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,0,1,0,'OrdenId',9,'OrdenId','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MezclarOrders','MezclarOrders','varchar',0,'',0,23,'inputbox',0,'','MezclarOrders',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Nombre','Old Employee Nombre','varchar',0,'',1,28,'hidden',0,'','Nombre',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Producto','Old Producto','varchar',0,'',1,33,'hidden',0,'','Producto',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Cantidad','Cantidad','int',0,'',1,32,'hidden',0,'','Cantidad',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'FileName','FileName','varchar',0,'',1,36,'hidden',0,'','FileName',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Stock','Stock','bit',0,'',1,20,'checkbox',0,'','Stock',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'AddBy','AddBy','varchar',0,'',1,39,'hidden',0,'','AddBy',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Programado','Programado','bit',0,'',1,40,'hidden',0,'','Programado',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'AddDate','AddDate','datetime',0,'',1,35,'hidden',0,'','AddDate',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ClientId','ClientId','varchar',1,'',1,38,'hidden',0,'','ClientId',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Instrucciones Especiales','',2,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Alerta','Instruciones Especiales','bit',0,'',1,1,'checkbox',0,'','Alerta',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Instrucciones','Instrucciones','nvarchar',0,'',1,3,'multiline',0,'','Instrucciones',1,1,'cbeltra',GETDATE(),'{"maxlength":"1000","readonly":"true","rows":"12"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'AlertaMsg','Mensaje en Orden de Trabajo','nvarchar',0,'',1,2,'inputbox',0,'','AlertaMsg',1,1,'cbeltra',GETDATE(),'{"maxlength":"50","readonly":"true"}')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,3,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Detalles' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ITE_Nombre' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,1,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Detalles' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ProductId' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,2,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Detalles' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Numero' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,3,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Detalles' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'OrdenCompra' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,4,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Detalles' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'EmployeeId' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,5,'cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'OrdenesInProd' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'OrdenesInProd' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('OrdenesInProd','Usada para llenar las listas en la pantalla de ventas','tblOrdenes','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_Nombre','ITE_Nombre','varchar',1,'',1,1,'inputbox',1,'{"TableName":"tblItemTasks","JoinType":"INNER","JoinField":"ITE_Nombre","JoinFields":"ITS_Status,TAS_Id,ITS_DTStart,ITS_DTStop,ITE_Nombre AS ITS_ITE_Nombre"}','ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Ordenada','Ordenada','int',0,'',1,2,'inputbox',0,'','Ordenada',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Requerida','Requerida','int',0,'',1,3,'inputbox',0,'','Requerida',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'StockParcialCantidad','StockParcialCantidad','int',0,'',1,4,'inputbox',0,'','StockParcialCantidad',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Numero','Numero','varchar',0,'',1,5,'inputbox',0,'','Numero',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TAS_Id','TAS_Id','int',0,'',0,6,'inputbox',0,'{"TableName":"tblTareas","JoinType":"INNER","JoinField":"Id","JoinFields":"Nombre AS Tarea"}','TAS_Id',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITS_ITE_Nombre','ITS_ITE_Nombre','varchar',0,'',0,7,'inputbox',0,'{"TableName":"tblMergeOrdenes","JoinType":"LEFT","JoinField":"MO_ITE_Nombre","JoinFields":"MO_Cantidad"}','ITE_Nombre',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITS_Status','ITS_Status','int',0,'',0,8,'inputbox',0,'{"TableName":"PageListItem","JoinType":"LEFT","JoinField":"Value","JoinFields":"Text AS TaskStatus","ExtraJoinDetails":" AND J#.FieldName = ''TaskStatus''"}','ITS_Status',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PN_Id','PN_Id','int',0,'',1,9,'inputbox',0,'','PN_Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'PageListItem' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'PageListItem' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('PageListItem','PageListItem','PageListItem','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'FieldName','FieldName','varchar',1,'',1,1,'inputbox',0,'','FieldName',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'FieldName',1,'FieldName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Value','Value','int',1,'',1,2,'inputbox',0,'','Value',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Value',2,'Value','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ShortText','ShortText','nchar',0,'',1,3,'inputbox',0,'','ShortText',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ShortText',3,'ShortText','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Text','Text','nvarchar',1,'',1,4,'inputbox',0,'','Text',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Text',4,'Text','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Enable','Enable','bit',1,'',1,5,'checkbox',0,'','Enable',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Enable',5,'Enable','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Selected','Selected','bit',1,'',1,6,'checkbox',0,'','Selected',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Selected',6,'Selected','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ItemId','ItemId','int',1,'',1,7,'hidden',1,'','ItemId',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Paises' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Paises' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Paises','Paises','tblPaises','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PAIS_Nombre','Nombre','varchar',1,'',1,1,'inputbox',0,'','PAIS_Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Nombre',1,'PAIS_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PAIS_ID','PAIS_ID','int',1,'',1,2,'hidden',1,'','PAIS_ID',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'PlanoAliasStock' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'PlanoAliasStock' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('PlanoAliasStock','PlanoAliasStock','tblPlanoAlias','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PN_Id','PN_Id','int',1,'',1,1,'inputbox',0,'{"TableName":"tblStock","JoinType":"INNER","JoinField":"PN_ID","JoinFields":"ST_Tipo,ST_Cantidad"}','PN_Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PA_Alias','PA_Alias','varchar',1,'',1,2,'inputbox',0,'','PA_Alias',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PA_Id','PA_Id','int',1,'',1,3,'inputbox',1,'','PA_Id',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'PlanosList' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'PlanosList' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('PlanosList','Use in Plano Autocomplete','tblPlano','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'value','PN_Id','int',1,'',1,1,'inputbox',1,'','PN_Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'label','PN_Numero','varchar',1,'',1,2,'inputbox',0,'','PN_Numero',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'desc','PN_Descripcion','varchar',1,'',1,3,'inputbox',0,'','PN_Descripcion',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'PlanoStock' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'PlanoStock' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('PlanoStock','PlanoStock','tblPlano','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PN_Id','PN_Id','int',1,'',1,1,'inputbox',1,'{"TableName":"tblStock","JoinType":"INNER","JoinField":"PN_ID","JoinFields":"ST_Tipo,ST_Cantidad"}','PN_Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PN_Numero','PN_Numero','varchar',1,'',1,2,'inputbox',0,'','PN_Numero',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'PorcentajeScrap' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'PorcentajeScrap' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('PorcentajeScrap','Porcentaje Scrap','ScrapVW','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_Nombre','Orden','varchar',1,'',1,1,'inputbox',1,'','ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Orden',1,'ITE_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Ordenada','Cantidad','int',0,'',1,2,'inputbox',0,'','Ordenada',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Cantidad',2,'Ordenada','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Cantidad','Scrapeado','int',0,'',1,3,'inputbox',0,'','SCR_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Scrapeado',3,'SCR_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Producto','Descripcion','varchar',1,'',1,4,'inputbox',0,'','Producto',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Descripcion',4,'Producto','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Numero','No.Parte','varchar',0,'',1,5,'inputbox',0,'','Numero',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'No.Parte',5,'Numero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Terminal','Term.','varchar',0,'',1,6,'inputbox',0,'','Terminal',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Term.',6,'Terminal','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Interna','Fecha Interna','date',0,'',1,7,'inputbox',0,'','Interna',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha Interna',7,'Interna','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_NewItem','Nueva Orden','varchar',0,'',1,8,'inputbox',0,'','SCR_NewItem',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Nueva Orden',8,'SCR_NewItem','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Fecha','Fecha Scrap','datetime',0,'',1,9,'inputbox',0,'','SCR_Fecha',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha Scrap',9,'SCR_Fecha','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TareaResponsable','Area Responsable','varchar',0,'',1,10,'inputbox',0,'','TareaResponsable',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Area Responsable',10,'TareaResponsable','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'EmpleadoResponsable','Empleado Responsable','varchar',0,'',1,11,'inputbox',0,'','EmpleadoResponsable',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Empleado Responsable',11,'EmpleadoResponsable','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TareaDetectado','Area Detectado','varchar',0,'',1,12,'inputbox',0,'','TareaDetectado',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Area Detectado',12,'TareaDetectado','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'EmpleadoDetectado','Empleado Detecto','varchar',0,'',1,13,'inputbox',0,'','EmpleadoDetectado',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Empleado Detecto',13,'EmpleadoDetectado','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Motivo','Motivo','varchar',0,'',1,14,'inputbox',0,'','SCR_Motivo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Motivo',14,'SCR_Motivo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Parcial','Parcial','bit',0,'',1,15,'checkbox',0,'','SCR_Parcial',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Parcial',15,'SCR_Parcial','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ClientId','ClientId','varchar',1,'',1,16,'inputbox',0,'','ClientId',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Productos' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Productos' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Productos','Productos','tblProductos','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Id','Id','int',1,'',1,1,'hidden',1,'','Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Nombre','Nombre','varchar',1,'',1,2,'inputbox',0,'','Nombre',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Nombre',1,'Nombre','cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Provedores' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Provedores' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Provedores','Provedores','tblProvedores','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,2,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Nombre','Nombre','varchar',0,'',1,1,'inputbox',0,'','PROV_Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Nombre',1,'PROV_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_RFC','RFC','varchar',0,'',1,3,'inputbox',0,'','PROV_RFC',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'RFC',3,'PROV_RFC','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Numero','Numero','varchar',0,'',1,5,'inputbox',0,'','PROV_Numero',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Ciudad','Ciudad','varchar',0,'',1,8,'inputbox',0,'','PROV_Ciudad',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Estado','Estado','varchar',0,'',1,9,'inputbox',0,'','PROV_Estado',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_ID','PROV_ID','int',1,'',1,13,'hidden',1,'','PROV_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Contacto','Contacto','varchar',0,'',1,2,'inputbox',0,'','PROV_Contacto',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Contacto',2,'PROV_Contacto','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Calle','Calle','varchar',0,'',1,4,'inputbox',0,'','PROV_Calle',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Colonia','Colonia','varchar',0,'',1,6,'inputbox',0,'','PROV_Colonia',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Celular','Celular','varchar',0,'',1,11,'inputbox',0,'','PROV_Celular',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Celular',5,'PROV_Celular','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_CP','CP','varchar',0,'',1,7,'inputbox',0,'','PROV_CP',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Fax','Fax','varchar',0,'',1,12,'inputbox',0,'','PROV_Fax',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fax',6,'PROV_Fax','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PROV_Telefono','Telefono','varchar',0,'',1,10,'inputbox',0,'','PROV_Telefono',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Telefono',4,'PROV_Telefono','cbeltra',GETDATE())
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'RelacionOrdenCompra' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'RelacionOrdenCompra' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('RelacionOrdenCompra','Relacion de Orden de Compra por Cliente','RelacionOrdenCompraVW','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_Nombre','Orden','varchar',1,'',1,1,'inputbox',0,'','ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,90,'Orden',1,'ITE_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Recibido','Recibido','date',0,'',1,2,'inputbox',0,'','Recibido',1,1,'cbeltra',GETDATE(),'{"filter-type":"date-range"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha Recibido',2,'Recibido','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'OrdenCompra','Ord. Compra','varchar',0,'',1,3,'inputbox',0,'','OrdenCompra',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Ord. Compra',3,'OrdenCompra','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Requerida','Cant. Cliente','int',0,'',1,5,'inputbox',0,'','Requerida',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Cant. Cliente',5,'Requerida','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Ordenada','Cant. Larco','int',0,'',1,4,'inputbox',0,'','Ordenada',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Cant. Larco',4,'Ordenada','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Producto','Descripcion','varchar',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Productos","valField":"Id","textField":"Nombre","cache":true,"header":true,"filter":true}',1,6,'multiselect',0,'','Producto',1,1,'cbeltra',GETDATE(),'{"filter-type":"text"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Descripcion',6,'Producto','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PN_Numero','No. Plano','varchar',0,'',1,7,'inputbox',0,'','PN_Numero',1,1,'cbeltra',GETDATE(),'{}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'No. Plano',7,'PN_Numero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Numero','No. Parte','varchar',0,'',1,8,'inputbox',0,'','Numero',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'No. Parte',8,'Numero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Entrega','Entrega','date',0,'',1,9,'inputbox',0,'','Entrega',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Entrega',9,'Entrega','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Interna','Interna','date',0,'',1,10,'inputbox',0,'','Interna',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Interna',10,'Interna','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TaskName','TaskName','varchar',1,'',1,11,'inputbox',0,'','TaskName',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Tarea',11,'TaskName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'StatusText','StatusText','nvarchar',0,'',1,12,'inputbox',0,'','StatusText',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Status',12,'StatusText','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Total','Total','decimal',0,'',1,13,'inputbox',0,'','Total',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Total',13,'Total','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Dolares','Dolares','bit',0,'',1,14,'checkbox',0,'','Dolares',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Dolares',14,'Dolares','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Stock','Stock','bit',0,'',1,15,'checkbox',0,'','Stock',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Stock',15,'Stock','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'StockParcial','StockParcial','bit',0,'',1,16,'checkbox',0,'','StockParcial',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'StockParcial',16,'StockParcial','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'StockParcialCantidad','StockParcialCantidad','int',0,'',1,17,'inputbox',0,'','StockParcialCantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'StockParcialCantidad',17,'StockParcialCantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Mezclado','Mezclado','bit',0,'',1,18,'checkbox',0,'','Mezclado',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Mezclado',18,'Mezclado','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MO_ITE_Nombre','MO_ITE_Nombre','varchar',0,'',1,19,'inputbox',0,'','MO_ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'MezcladoCon',19,'MO_ITE_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Requisicion','Requisicion','varchar',0,'',1,21,'inputbox',0,'','Requisicion',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Requisicion',21,'Requisicion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'OrdenId','OrdenId','int',1,'',1,22,'inputbox',1,'','OrdenId',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ClientId','Cliente','varchar',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Clientes","valField":"Clave","textField":"Clave","cache":true,"header":true,"filter":true}',1,23,'multiselect',0,'','ClientId',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,0,1,0,'ClientId',22,'ClientId','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'OrderYear','Año','varchar',0,'',1,24,'inputbox',0,'','OrderYear',1,1,'cbeltra',GETDATE(),'{"search-type":"equals"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,0,1,0,'OrderYear',23,'OrderYear','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Terminal','Revision','varchar',0,'',1,20,'inputbox',0,'','Terminal',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Revision',20,'Terminal','cbeltra',GETDATE())
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,3,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ClientId' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,1,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'ITE_Nombre' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,2,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'OrderYear' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,3,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'OrdenCompra' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,4,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Recibido' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,5,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Numero' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,6,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Producto' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,7,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'PN_Numero' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,8,'cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'RoleModuleMapping' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'RoleModuleMapping' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('RoleModuleMapping','RoleModuleMapping','tblGroup_Screens','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'GroupScreenId','GroupScreenId','int',1,'',1,1,'hidden',1,'','GroupScreenId',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'RoleId','Role','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Roles","valField":"RoleId","textField":"Group_Name"}',1,2,'selectmenu',0,'{"TableName":"tblGroups","JoinType":"INNER","JoinField":"Group_Id","ExtraJoinDetails":"", "JoinFields":"Group_Name AS RoleName"}','Group_Id',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Role',1,'RoleName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ModuleId','Module','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Modules","valField":"SCR_ID","textField":"ModuleName,Description"}',1,3,'selectmenu',0,'{"TableName":"tblScreens","JoinType":"INNER","JoinField":"SCR_ID","ExtraJoinDetails":"","JoinFields":"SCR_Name AS ModuleName,SCR_Description AS Description"}','SCR_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Module',2,'ModuleName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Borrar','Borrar','bit',0,'',1,4,'checkbox',0,'','Borrar',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Borrar',6,'Borrar','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Buscar','Buscar','bit',0,'',1,5,'checkbox',0,'','Buscar',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Buscar',7,'Buscar','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Editar','Editar','bit',0,'',1,6,'checkbox',0,'','Editar',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Editar',5,'Editar','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Nuevo','Nuevo','bit',0,'',1,7,'checkbox',0,'','Nuevo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Nuevo',4,'Nuevo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Description','Description','nvarchar',0,'',0,8,'hidden',0,'','Description',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Description',3,'Description','cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'RoleModules' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'RoleModules' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('RoleModules','RoleModules','tblGroup_Screens','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'GroupScreenId','RoleModId','int',1,'',1,1,'hidden',1,'','GroupScreenId',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'RoleModId',1,'GroupScreenId','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'RoleId','RoleId','int',0,'',1,2,'inputbox',0,'','Group_Id',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'RoleId',2,'RoleId','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ModuleId','ModuleId','int',0,'',1,3,'inputbox',0,'{"TableName":"tblScreens","JoinType":"INNER","JoinField":"SCR_ID","ExtraJoinDetails":"", "JoinFields":"SCR_Name AS ModuleName,SCR_Description AS Description,URL,ModuleOrder,ParentModule"}','SCR_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ModuleId',3,'ModuleId','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Borrar','Borrar','bit',0,'',1,4,'checkbox',0,'','Borrar',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Borrar',4,'Borrar','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Buscar','Buscar','bit',0,'',1,5,'checkbox',0,'','Buscar',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Editar','Editar','bit',0,'',1,6,'checkbox',0,'','Editar',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Editar',5,'Editar','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Nuevo','Nuevo','bit',0,'',1,7,'checkbox',0,'','Nuevo',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ModuleName','ModuleName','nvarchar',0,'',0,8,'inputbox',0,'','ModuleName',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Description','Description','nvarchar',0,'',0,9,'inputbox',0,'','Description',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'URL','URL','nvarchar',0,'',0,10,'inputbox',0,'','URL',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ModuleOrder','ModuleOrder','nvarchar',0,'',0,11,'inputbox',0,'','ModuleOrder',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ParentModule','ParentModule','nvarchar',0,'',0,12,'inputbox',0,'','ParentModule',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ParentModule',6,'ParentModule','cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Roles' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Roles' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Roles','Roles','tblGroups','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'RoleId','RoleId','int',1,'',1,1,'hidden',1,'','Group_Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Group_Name','Role Name','varchar',1,'',1,2,'inputbox',0,'','Group_Name',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Role Name',1,'Group_Name','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Priority','Priority','int',1,'',1,3,'inputbox',0,'','Priority',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Priority',2,'Priority','cbeltra',GETDATE())
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Routing' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Routing' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Routing','Rutas','tblRouting','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Nombre','Producto','varchar',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Productos","valField":"Nombre","textField":"Nombre","cache":true}',1,1,'selectmenu',0,'','Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Producto',1,'Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Rou_From','De La Tarea','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Tareas","valField":"TaskId","textField":"Nombre","cache":true}',1,2,'selectmenu',0,'{"TableName":"tblTareas","JoinType":"INNER","JoinField":"Id","ExtraJoinDetails":"", "JoinFields":"Nombre AS TareaFrom"}','Rou_From',1,1,'cbeltra',GETDATE(),'{"filter-type":"text"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'De La Tarea',2,'TareaFrom','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Rou_Code','Codigo','varchar',1,'',1,4,'inputbox',0,'','Rou_Code',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Codigo',4,'Rou_Code','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Rou_To','A La Tarea','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Tareas","valField":"TaskId","textField":"Nombre","cache":true}',1,3,'selectmenu',0,'{"TableName":"tblTareas","JoinType":"INNER","JoinField":"Id","ExtraJoinDetails":"", "JoinFields":"Nombre AS TareaTo"}','Rou_To',1,1,'cbeltra',GETDATE(),'{"filter-type":"text"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'A La Tarea',3,'TareaTo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Rou_Id','Rou_Id','int',1,'',0,5,'hidden',1,'','Rou_Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ProductId','ProductId','int',1,'',1,6,'hidden',0,'','ProductId',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,3,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Nombre' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,1,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Rou_From' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,2,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'Rou_To' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,3,'cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'RoutingVW' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'RoutingVW' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('RoutingVW','RoutingVW','RoutingVW','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ProductId','ProductId','int',1,'',1,2,'inputbox',1,'','ProductId',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ProductId',2,'ProductId','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ProductName','ProductName','varchar',1,'',1,1,'inputbox',0,'','ProductName',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'ProductName',1,'ProductName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TaskId','TaskId','int',1,'',1,3,'inputbox',0,'','TaskID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'TaskId',3,'TaskID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TaskOrder','TaskOrder','smallint',1,'',1,4,'inputbox',0,'','TAS_Order',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TaskName','TaskName','varchar',1,'',1,5,'inputbox',0,'','Nombre',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Salidas' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Salidas' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Salidas','Salidas Almacen','tblSalidas','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Salidas','',1,3,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_Orden','Orden','varchar',1,'',1,1,'inputbox',0,'','SAL_Orden',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Orden',1,'SAL_Orden','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'USE_ID','USE_ID','int',0,'',1,4,'hidden',0,'','USE_ID',1,1,'cbeltra',GETDATE(),'{"defaultVal":"js:USER_ID"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_Fecha','Fecha','date',1,'',1,2,'inputbox',0,'','SAL_Fecha',1,1,'cbeltra',GETDATE(),'{"filter-type":"date-range"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Fecha',2,'SAL_Fecha','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_ID','SAL_ID','int',1,'',1,5,'hidden',1,'','SAL_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_Solicitado','Solicitado Por','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Empleados","valField":"Id","textField":"Nombre","cache":true}',1,3,'dropdownlist',0,'{"TableName":"tblEmpleados","JoinType":"INNER","JoinField":"Id","JoinFields":"Nombre AS EmployeeName"}','SAL_Solicitado',1,1,'cbeltra',GETDATE(),'{"filter-type":"text","search-type":"equals"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Solicitado Por',3,'EmployeeName','cbeltra',GETDATE())
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,2,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Salidas' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'SAL_Orden' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,1,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Salidas' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'SAL_Solicitado' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,2,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Salidas' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'SAL_Fecha' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,3,'cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'SalidasAlmacen' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'SalidasAlmacen' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('SalidasAlmacen','Reporte Salidas Almacen','tblSalidasDetalle','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,2,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ED_ID','ED_ID','int',0,'',0,6,'hidden',0,'','ED_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_ID','SAL_ID','int',0,'',0,2,'hidden',0,'{"TableName":"tblSalidas","JoinType":"INNER","JoinField":"SAL_ID","JoinFields":"SAL_Fecha,SAL_Solicitado,SAL_Orden"}','SAL_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ID','Descripcion','int',0,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Materiales","valField":"MAT_ID","textField":"MAT_Descripcion","cache":true,"filter":true,"header":true}',0,3,'multiselect',0,'{"TableName":"tblMateriales","JoinType":"LEFT","JoinField":"MAT_ID","JoinFields":"MAT_Numero,MAT_Descripcion,MAT_Cantidad,MAT_Tipo"}','MAT_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,0,1,0,'Descripcion',8,'MAT_ID','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SD_ID','SD_ID','int',1,'',0,1,'hidden',1,'','SD_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SD_Cantidad','Cantidad','decimal',0,'',1,8,'inputbox',0,'','SD_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,60,'Cantidad',3,'SD_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'IS_SL','IS_SL','bit',0,'',1,14,'checkbox',0,'','IS_SL',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_Solicitado','SAL_Solicitado','int',0,'',0,5,'hidden',0,'{"TableName":"tblEmpleados","JoinType":"LEFT","JoinField":"ID","JoinFields":"Nombre"}','SAL_Solicitado',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Tipo','MAT_Tipo','int',0,'',0,4,'hidden',0,'{"TableName":"tblTiposMaterial","JoinType":"LEFT","JoinField":"TIP_ID","JoinFields":"TIP_Descripcion"}','MAT_Tipo',0,0,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_Fecha','Fecha Salida','date',0,'',1,7,'inputbox',0,'','SAL_Fecha',0,0,'cbeltra',GETDATE(),'{"filter-type":"date-range"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'Fecha Salida',1,'SAL_Fecha','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Numero','IDMaterial','varchar',0,'',1,9,'inputbox',0,'','MAT_Numero',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,100,'IDMaterial',2,'MAT_Numero','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TIP_Descripcion','Tipo Material','varchar',0,'',1,10,'hidden',0,'','TIP_Descripcion',0,0,'cbeltra',GETDATE(),'{"nowrap":"true"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,150,'Tipo Material',4,'TIP_Descripcion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Descripcion','Descripcion','varchar',0,'',1,11,'inputbox',0,'','MAT_Descripcion',0,0,'cbeltra',GETDATE(),'{"nowrap":"true"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,200,'Descripcion',5,'MAT_Descripcion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_Cantidad','SaldoAlmacen','decimal',0,'',1,12,'inputbox',0,'','MAT_Cantidad',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,70,'SaldoAlmacen',6,'MAT_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Nombre','SolicitadoPor','varchar',0,'',1,13,'inputbox',0,'','Nombre',0,0,'cbeltra',GETDATE(),'{"nowrap":"true","search-type":"equals","filter-type":"text"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,150,'SolicitadoPor',7,'Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_Orden','Orden de Trabajo','varchar',0,'',1,15,'hidden',0,'','SAL_Orden',0,0,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Orden de Trabajo',9,'SAL_Orden','cbeltra',GETDATE())
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,2,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'SAL_Fecha' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,1,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'MAT_ID' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,2,'cbeltra',GETDATE())
 
SELECT @TAB_ID = TabId FROM PageTab WHERE TabName = 'Details' AND PageId = @PAGE_ID
SELECT @FIELD_ID = FieldId from PageField WHERE FieldName = 'MAT_Numero' AND TabId = @TAB_ID
INSERT INTO [PageFilterField]([FilterId],[FieldId],[FilterOrder],[UpdatedBy],[UpdatedDate]) VALUES (@FILTER_ID,@FIELD_ID,3,'cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'SalidasDetalle' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'SalidasDetalle' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('SalidasDetalle','Salidas Detalle','tblSalidasDetalle','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Detalle','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ID','Material','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Materiales","valField":"MAT_ID","textField":"MAT_Descripcion","cache":true}',1,2,'dropdownlist',0,'{"TableName":"tblMateriales","JoinType":"INNER","JoinField":"MAT_ID","JoinFields":"MAT_Numero,MAT_ProvNumero,MAT_Descripcion"}','MAT_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Material',1,'MAT_Descripcion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SD_Cantidad','Cantidad','decimal',1,'',1,3,'inputbox',0,'','SD_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Cantidad',2,'SD_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SAL_ID','SAL_ID','int',0,'',1,4,'hidden',0,'','SAL_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SD_ID','SD_ID','int',1,'',1,5,'hidden',1,'','SD_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SD_Saldo','SD_Saldo','decimal',0,'',1,6,'hidden',0,'','SD_Saldo',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'MAT_ProvNumero','Proveedor ID','varchar',0,'',1,1,'inputbox',0,'','MAT_ProvNumero',0,0,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Scrap' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Scrap' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Scrap','Editor Scrap','tblScrap','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,2,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_Nombre','Orden de Trabajo','varchar',1,'',1,1,'inputbox',0,'','ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,90,'Orden',1,'ITE_Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Cantidad','Cantidad Scrapeada','int',1,'',1,8,'inputbox',0,'','SCR_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'Cantidad Scrapeada',7,'SCR_Cantidad','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_EmpleadoDetectado','Empleado Detectado','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Empleados","valField":"Id","textField":"Nombre","cache":true}',1,6,'selectmenu',0,'{"TableName":"tblEmpleados","JoinType":"INNER","JoinField":"Id","JoinFields":"Nombre AS EmpleadoDetectado"}','SCR_EmpleadoDetectado',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Empleado Detectado',5,'EmpleadoDetectado','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Fecha','Fecha','date',1,'',1,11,'inputbox',0,'','SCR_Fecha',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,70,'Fecha',8,'SCR_Fecha','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_NewItem','Nueva Orden','varchar',1,'',1,12,'inputbox',0,'','SCR_NewItem',1,1,'cbeltra',GETDATE(),'{"readonly":"true"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Repro','A Reprogramar','int',0,'',1,10,'inputbox',0,'','SCR_Repro',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_TareaDetectadoId','Area Detectado','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Tareas","valField":"TaskId","textField":"Nombre","cache":true}',1,5,'selectmenu',0,'{"TableName":"tblTareas","JoinType":"INNER","JoinField":"Id","JoinFields":"Nombre AS AreaDetectado"}','SCR_TareaDetectadoId',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Area Detectado',4,'AreaDetectado','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Update_Date','Update_Date','datetime',0,'',1,16,'hidden',0,'','Update_Date',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_ID','SCR_ID','int',1,'',1,17,'hidden',1,'','SCR_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Detectado','SCR_Detectado','varchar',0,'',1,14,'hidden',0,'','SCR_Detectado',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_EmpleadoRes','Empleado Responsable','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Empleados","valField":"Id","textField":"Nombre","cache":true}',1,4,'selectmenu',0,'{"TableName":"tblEmpleados","JoinType":"INNER","JoinField":"Id","JoinFields":"Nombre AS EmpleadoResponsable"}','SCR_EmpleadoRes',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Empleado Responsable',3,'EmpleadoResponsable','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Motivo','Motivo','varchar',1,'',1,2,'inputbox',0,'','SCR_Motivo',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Parcial','Parcial','bit',0,'',1,9,'checkbox',0,'','SCR_Parcial',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_Tarea','SCR_Tarea','varchar',0,'',1,13,'hidden',0,'','SCR_Tarea',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'SCR_TareaId','Area Responsable','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Tareas","valField":"TaskId","textField":"Nombre","cache":true}',1,3,'selectmenu',0,'{"TableName":"tblTareas","JoinType":"INNER","JoinField":"Id","JoinFields":"Nombre AS AreaResponsable"}','SCR_TareaId',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Area Responsable',2,'AreaResponsable','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'USE_Login','Scrapeado Por','varchar',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Empleados","valField":"Id","textField":"Nombre","cache":true}',1,7,'selectmenu',0,'{"TableName":"tblEmpleados","JoinType":"INNER","JoinField":"Id","JoinFields":"Nombre AS ScrapeadoPor"}','USE_Login',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Scrapeado Por',6,'ScrapeadoPor','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Update_User','Update_User','int',0,'',1,15,'hidden',0,'','Update_User',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Stock' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Stock' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Stock','Stock','tblStock','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ST_ID','ST_ID','int',1,'',1,1,'inputbox',1,'','ST_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_Nombre','ITE_Nombre','varchar',1,'',1,2,'inputbox',0,'','ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'PN_Id','PN_Id','int',1,'',1,3,'inputbox',0,'','PN_Id',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ST_Cantidad','ST_Cantidad','int',1,'',1,4,'inputbox',0,'','ST_Cantidad',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ST_Fecha','ST_Fecha','datetime',1,'',1,5,'inputbox',0,'','ST_Fecha',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ST_Tipo','ST_Tipo','varchar',1,'',1,6,'inputbox',0,'','ST_Tipo',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Update_Date','Update_Date','datetime',0,'',1,7,'inputbox',0,'','Update_Date',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Update_User','Update_User','int',0,'',1,8,'inputbox',0,'','Update_User',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Tareas' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Tareas' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Tareas','Tareas','tblTareas','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Nombre','Nombre','varchar',1,'',1,1,'inputbox',0,'','Nombre',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Nombre',2,'Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Tiempo','Tiempo','decimal',0,'',1,2,'inputbox',0,'','Tiempo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'Tiempo',3,'Tiempo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Interno','Interno','decimal',0,'',1,3,'inputbox',0,'','Interno',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'Interno',4,'Interno','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TaskOrder','Orden','smallint',1,'',1,4,'inputbox',0,'','TAS_Order',1,1,'cbeltra',GETDATE(),'{"readonly":"true"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,80,'Orden',1,'TaskOrder','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'IsPutOnly','Es Primera Tarea','bit',0,'',1,5,'checkbox',0,'','IsPutOnly',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,100,'Es Primera Tarea',5,'IsPutOnly','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'IsLast','Es Ultima Tarea','bit',0,'',1,6,'checkbox',0,'','IsLast',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,100,'Es Ultima Tarea',6,'IsLast','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TaskId','Id','int',1,'',0,7,'hidden',1,'','Id',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'TareasProductos' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'TareasProductos' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('TareasProductos','TareasProductos','tblTareas','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Id','Id','int',1,'',1,1,'inputbox',1,'','Id',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,100,'Valor Agregado',3,'Id','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Nombre','Nombre','varchar',1,'',1,2,'inputbox',0,'','Nombre',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Tareas',2,'Nombre','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TAS_Order','TAS_Order','smallint',1,'',1,3,'inputbox',0,'','TAS_Order',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,0,20,'_',1,'TAS_Order','cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Templates' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Templates' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Templates','Templates','Templates','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,2,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TemplateName','Name','nvarchar',1,'',1,2,'inputbox',0,'','TemplateName',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Name',2,'TemplateName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Template','Template','escapetext',1,'',1,3,'multiline',0,'','Template',1,1,'cbeltra',GETDATE(),'{"colSpan":"2"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TemplateType','Type','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=PageListItem&entity={\"FieldName\":\"TemplateType\"}","valField":"ItemId","textField":"Text","cache":true}',1,1,'selectmenu',0,'{"TableName":"PageListItem","JoinField":"ItemId","JoinFields":"Text AS TemplateTypeText","JoinType":"LEFT"}','TemplateType',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Type',1,'TemplateTypeText','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TemplateId','TemplateId','int',1,'',1,4,'hidden',1,'','TemplateId',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'TiposMaterial' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'TiposMaterial' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('TiposMaterial','Tipos de Material','tblTiposMaterial','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TIP_Tipo','Tipo','varchar',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=PageListItem&entity={\"FieldName\":\"TipoMaterial\"}","valField":"Text","textField":"Text","cache":true}',1,1,'selectmenu',0,'','TIP_Tipo',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Tipo',1,'TIP_Tipo','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TIP_Descripcion','Nombre','varchar',1,'',1,2,'inputbox',0,'','TIP_Descripcion',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Nombre',2,'TIP_Descripcion','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'TIP_ID','TIP_ID','int',1,'',1,3,'hidden',1,'','TIP_ID',1,1,'cbeltra',GETDATE(),'')
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'UnidadesMedida' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'UnidadesMedida' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('UnidadesMedida','Unidades de Medida','tblUnidadesMedida','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'UNI_ID','UNI_ID','int',1,'',1,1,'hidden',1,'','UNI_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'UNI_Medida','Unidad de Medida','varchar',1,'',1,2,'inputbox',0,'','UNI_Medida',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Unidad de Medida',1,'UNI_Medida','cbeltra',GETDATE())
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'UserRoles' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'UserRoles' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('UserRoles','User Roles','tblUser_Groups','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'Group_ID','Role','int',1,'{"url":"AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Roles","valField":"RoleId","textField":"RoleName"}',1,1,'selectmenu',0,'{"TableName":"tblGroups","JoinType":"INNER","JoinField":"Group_Id","ExtraJoinDetails":"", "JoinFields":"Group_Name AS RoleName"}','Group_ID',1,1,'cbeltra',GETDATE(),'')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,200,'Role',1,'RoleName','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'USE_ID','UserId','int',1,'',1,2,'hidden',0,'','USE_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'UserGroupId','UserGroupId','int',1,'',1,3,'hidden',1,'','UserGroupId',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'Users' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'Users' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('Users','Usuarios','tblUsers','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Detalles','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'USE_Name','Nombre','varchar',1,'',1,1,'inputbox',0,'','USE_Name',1,1,'cbeltra',GETDATE(),'{"maxlength":"150"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Nombre',2,'USE_Name','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'USE_Login','Login','varchar',1,'',1,2,'inputbox',0,'','USE_Login',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
SET @FIELD_ID = scope_identity()
INSERT INTO [PageGridColumn]([FieldId],[PageId],[Visible],[Searchable],[Width],[ColumnLabel],[ColumnOrder],[ColumnName],[UpdatedBy],[UpdatedDate]) VALUES (@FIELD_ID,@PAGE_ID,1,1,0,'Login',1,'USE_Login','cbeltra',GETDATE())
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'USE_Password','Password','varchar',1,'',0,3,'inputbox',0,'','USE_Password',1,1,'cbeltra',GETDATE(),'{"type":"password","maxlength":"50"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'USE_Role','Role','varchar',0,'',0,4,'hidden',0,'','USE_Role',1,1,'cbeltra',GETDATE(),'{"maxlength":"50"}')
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'USE_ID','UserId','int',1,'',0,5,'hidden',1,'','USE_ID',1,1,'cbeltra',GETDATE(),'')
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Permisos','',2,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageFilter]([PageId],[FilterCols],[FilterText],[ShowClear],[FilterProps],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,1,'Filter',1,'','cbeltra',GETDATE())
SET @FILTER_ID = scope_identity()
 
 
IF EXISTS (SELECT PageId FROM Page WHERE Name = 'ValidateOrden' ) BEGIN
	SELECT @PAGE_ID = PageId FROM Page WHERE Name = 'ValidateOrden' 
	DELETE FROM [PageGridColumn] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilterField] WHERE [FilterId] IN (SELECT [FilterId] FROM PageFilter WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageField] WHERE [TabId] IN (SELECT [TabId] FROM [PageTab] WHERE [PageId] = @PAGE_ID)
	DELETE FROM [PageTab] WHERE [PageId] = @PAGE_ID
	DELETE FROM [PageFilter] WHERE [PageId] = @PAGE_ID
	DELETE FROM [Page] WHERE [PageId] = @PAGE_ID
END
 
INSERT INTO [Page]([Name],[Title],[TableName],[UpdatedBy],[UpdatedDate]) VALUES ('ValidateOrden','Orden','tblOrdenes','cbeltra',GETDATE())
SET @PAGE_ID = scope_identity()
 
INSERT INTO [PageTab]([PageId],[TabName],[URL],[TabOrder],[Cols],[UpdatedBy],[UpdatedDate]) VALUES (@PAGE_ID,'Details','',1,1,'cbeltra',GETDATE())
SET @TAB_ID = scope_identity()
 
INSERT INTO [PageField]([TabId],[FieldName],[Label],[Type],[Required],[DropDownInfo],[Exportable],[FieldOrder],[ControlType],[IsId],[JoinInfo],[DBFieldName],[Insertable],[Updatable],[UpdatedBy],[UpdatedDate],[ControlProps]) VALUES(@TAB_ID,'ITE_Nombre','ITE_Nombre','varchar',0,'',1,1,'inputbox',1,'','ITE_Nombre',1,1,'cbeltra',GETDATE(),'')
 
GO
