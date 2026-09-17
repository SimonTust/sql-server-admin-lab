USE master;
IF DB_ID(N'LabContactos') IS NULL THROW 50002, 'No existe LabContactos.', 1;
DECLARE @Archivo nvarchar(4000) = N'C:\SQLLab\backup\LabContactos_'
    + CONVERT(nvarchar(36),NEWID()) + N'.bak';
-- COPY_ONLY para que esta copia de demostración no altere la base diferencial.
-- Archivo único; no se usa FORMAT, INIT ni se sobrescribe un backup conocido.
BACKUP DATABASE LabContactos TO DISK=@Archivo WITH COPY_ONLY,CHECKSUM,STATS=10;
RESTORE VERIFYONLY FROM DISK=@Archivo WITH CHECKSUM;
SELECT @Archivo AS RutaBackup;
