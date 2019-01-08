USE [EPEFrameworkService]
GO
 
DECLARE @PAGEAPP_ID AS INT
DECLARE @MODULE_ID AS INT
DECLARE @ROLE_ID AS INT
 
SELECT TOP 1 @PAGEAPP_ID = PageAppId FROM PageApp WHERE AppName = 'Larco'
 
IF @PAGEAPP_ID IS NULL BEGIN
  INSERT INTO PageApp(AppName,UpdatedBy,UpdatedDate) VALUES('Larco','cbeltra',GETDATE())	
  SELECT TOP 1 @PAGEAPP_ID = PageAppId FROM PageApp WHERE AppName = 'Larco'
END
 
DELETE FROM [RoleModules] WHERE [ModuleId] IN (SELECT [ModuleId] FROM [Modules] WHERE PageAppId = @PAGEAPP_ID)
DELETE FROM [UserRoles] WHERE [RoleId] IN (SELECT [RoleId] FROM [Roles] WHERE PageAppId = @PAGEAPP_ID)
DELETE FROM [Modules] WHERE PageAppId = @PAGEAPP_ID
DELETE FROM [Roles] WHERE PageAppId = @PAGEAPP_ID
 
INSERT INTO [Roles]([RoleName],[Priority],[PageAppId]) VALUES('SYSADMIN',1, @PAGEAPP_ID)
SET @ROLE_ID = scope_identity()
 
INSERT INTO [UserRoles]([RoleId],[UserLogin]) VALUES (@ROLE_ID,'999')
 
INSERT INTO [Roles]([RoleName],[Priority],[PageAppId]) VALUES('ADMIN',2, @PAGEAPP_ID)
SET @ROLE_ID = scope_identity()
 
INSERT INTO [UserRoles]([RoleId],[UserLogin]) VALUES (@ROLE_ID,'19')
 
INSERT INTO [Roles]([RoleName],[Priority],[PageAppId]) VALUES('VENTAS_SUP',10, @PAGEAPP_ID)
SET @ROLE_ID = scope_identity()
 
INSERT INTO [UserRoles]([RoleId],[UserLogin]) VALUES (@ROLE_ID,'33')
 
INSERT INTO [Roles]([RoleName],[Priority],[PageAppId]) VALUES('ALMACEN',40, @PAGEAPP_ID)
SET @ROLE_ID = scope_identity()
 
INSERT INTO [UserRoles]([RoleId],[UserLogin]) VALUES (@ROLE_ID,'25')
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Home','Home','Default.aspx',10,NULL, @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ALMACEN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Herramientas','Herramientas','',20,NULL, @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Inventarios','Inventarios','',30,NULL, @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ALMACEN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Stock','Stock','',40,NULL, @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Catalogos','Administracion de Catalogos','',50,NULL, @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ALMACEN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Reportes','Reportes','',60,NULL, @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ALMACEN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Admin','Admin Pages','',100,NULL, @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Page Config','Configure Pages','Admin/PageConfig.aspx',60, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Admin'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Page List Items','Manage List Items','Admin/ListItemsConfig.aspx',70, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Admin'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Query Helper','Query Helper','Admin/QueryHelper.aspx',80, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Admin'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Refresh Cache','Refresh Cache','Admin/RefreshCache.aspx',90, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Admin'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Preview','Preview Page','Admin/Preview.aspx',100, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Admin'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ALMACEN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Current Users','Current Users','Admin/CurrentUsers.aspx',110, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Admin'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Clientes','Administracion de Clientes','Catalogos/Clientes.aspx',10, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Catalogos'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Empleados','Administracion de Empleados','Catalogos/Empleados.aspx',20, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Catalogos'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Productos','Administracion de Productos','Catalogos/Productos.aspx',30, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Catalogos'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Tareas','Administracion de Tareas','Catalogos/Tareas.aspx',40, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Catalogos'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Rutas','Administracion de Rutas','Catalogos/Rutas.aspx',50, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Catalogos'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Materiales','Administracion de Materiales','Catalogos/Materiales.aspx',60, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Catalogos'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ALMACEN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Templates','Administracion de Templates','Catalogos/Templates.aspx',70, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Catalogos'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Dias Vencido','Dias Vencido','Catalogos/DiasVencido.aspx',80, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Catalogos'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Ventas','Ventas','Herramientas/Ventas.aspx',10, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Herramientas'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,0,0,0)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Entradas Almacen','Entradas Inventarios','Inventarios/Entradas.aspx',10, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Inventarios'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ALMACEN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Salidas Almacen','Salidas Almacen','Inventarios/Salidas.aspx',20, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Inventarios'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ALMACEN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Entradas Vs Salidas Almacen','Reporte de Entradas Contra Salidas','Reportes/EntradasSalidasAlmacen.aspx',10, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Reportes'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ALMACEN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Entradas Almacen','Reporte de Entradas Almacen','Reportes/EntradasAlmacen.aspx',20, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Reportes'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ALMACEN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Salidas Almacen','Reporte de Salidas de Almacen','Reportes/SalidasAlmacen.aspx',30, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Reportes'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ALMACEN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Entradas Vs Salidas Almacen Conta','Reporte de Entradas Contra Salidas para el dep de conta','Reportes/EntradasSalidasAlmacenConta.aspx',40, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Reportes'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'ADMIN'), @MODULE_ID,1,1,1)
 
INSERT INTO [Modules]([ModuleName],[Description],[URL],[ModuleOrder],[ParentModule],[PageAppId]) VALUES ('Ordenes Urgentes y Vencidas Por Empleado','Ordenes Urgentes y Vencidas Por Empleado','Reportes/OrdenesUrgentesVencidasPorEmpleado.aspx',50, (SELECT [ModuleId] FROM Modules WHERE PageAppId =  @PAGEAPP_ID AND ParentModule IS NULL AND ModuleName = 'Reportes'), @PAGEAPP_ID)
SET @MODULE_ID = scope_identity()
 
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'SYSADMIN'), @MODULE_ID,1,1,1)
INSERT INTO [RoleModules]([RoleId],[ModuleId],[EditAccess],[DeleteAccess],[NewAccess]) VALUES ((SELECT [RoleId] FROM [Roles] WHERE [PageAppId] = @PAGEAPP_ID AND [RoleName] = 'VENTAS_SUP'), @MODULE_ID,1,1,1)
 
