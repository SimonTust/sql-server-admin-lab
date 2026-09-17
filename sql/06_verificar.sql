USE master;
SELECT TOP (20) b.database_name,b.backup_start_date,b.backup_finish_date,
    b.type,b.is_copy_only,b.has_backup_checksums,m.physical_device_name
FROM msdb.dbo.backupset b
JOIN msdb.dbo.backupmediafamily m ON m.media_set_id=b.media_set_id
WHERE b.database_name=N'LabContactos' ORDER BY b.backup_finish_date DESC;
SELECT TOP (20) destination_database_name,restore_date,restore_type
FROM msdb.dbo.restorehistory
WHERE destination_database_name=N'LabContactos_Restaurada' ORDER BY restore_date DESC;

IF DB_ID(N'LabContactos_Restaurada') IS NULL
    THROW 50005, 'Primero restaurar la base.', 1;
DBCC CHECKDB (N'LabContactos_Restaurada') WITH NO_INFOMSGS;
-- Cero filas en ambas diferencias, sin cambios posteriores al backup en origen.
SELECT * FROM LabContactos.dbo.Contacto
EXCEPT SELECT * FROM LabContactos_Restaurada.dbo.Contacto;
SELECT * FROM LabContactos_Restaurada.dbo.Contacto
EXCEPT SELECT * FROM LabContactos.dbo.Contacto;
SELECT * FROM LabContactos.dbo.Area
EXCEPT SELECT * FROM LabContactos_Restaurada.dbo.Area;
SELECT * FROM LabContactos_Restaurada.dbo.Area
EXCEPT SELECT * FROM LabContactos.dbo.Area;
