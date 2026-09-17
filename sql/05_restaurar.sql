USE master;
DECLARE @Archivo nvarchar(4000)=N'PEGAR_RUTA_BACKUP';
DECLARE @Datos nvarchar(4000)=N'C:\SQLLab\restore\LabContactos_Restaurada.mdf';
DECLARE @Log nvarchar(4000)=N'C:\SQLLab\restore\LabContactos_Restaurada_log.ldf';
IF @Archivo=N'PEGAR_RUTA_BACKUP' THROW 50003, 'Configurar ruta del backup.', 1;
IF DB_ID(N'LabContactos_Restaurada') IS NOT NULL
    THROW 50004, 'La base destino ya existe. No se sobrescribe.', 1;
RESTORE HEADERONLY FROM DISK=@Archivo;
RESTORE FILELISTONLY FROM DISK=@Archivo;
-- Nombres lógicos esperados para la base creada por 01_crear.sql.
-- Si FILELISTONLY muestra otros nombres o más archivos, ajustar cada MOVE antes de continuar.
RESTORE VERIFYONLY FROM DISK=@Archivo WITH CHECKSUM;
RESTORE DATABASE LabContactos_Restaurada FROM DISK=@Archivo
WITH MOVE N'LabContactos' TO @Datos,
     MOVE N'LabContactos_log' TO @Log,
     RECOVERY,CHECKSUM,STATS=10;
