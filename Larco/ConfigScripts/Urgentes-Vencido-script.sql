ALTER TABLE tblStockOrdenes
ADD CONSTRAINT uc_StockOrden UNIQUE ([ITE_Nombre]);

select ITE_Nombre,count(*) from tblStockOrdenes group by ITE_Nombre having count(*) > 2

select * from tblStockOrdenes where ITE_Nombre in (
'06-044-024-10',
'06-044-024-13',
'06-066-042-132',
'06-044-024-08',
'06-044-024-05',
'06-067-330-10',
'06-044-024-09',
'06-042-013-10',
'06-044-024-06',
'06-044-024-01')
order by ITE_Nombre

-----------------------------------------------------

ALTER TABLE tblItemTasks
ADD Vencida BIT NULL

ALTER TABLE tblItemTasks
ADD Urgente BIT NULL

UPDATE tblItemTasks SET Urgente = 0, Vencida = 0

ALTER TABLE tblItemTasks
ALTER COLUMN Vencida BIT NOT NULL

ALTER TABLE tblItemTasks
ALTER COLUMN Urgente BIT NOT NULL

ALTER TABLE tblItemTasks
ADD CONSTRAINT ItemTasks_Vencida  
DEFAULT 0 FOR Vencida 

ALTER TABLE tblItemTasks
ADD CONSTRAINT ItemTasks_Urgente  
DEFAULT 0 FOR Urgente 