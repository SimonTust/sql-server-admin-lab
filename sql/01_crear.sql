USE master;
SET NOCOUNT ON;
IF DB_ID(N'LabContactos') IS NOT NULL
    THROW 50001, 'LabContactos ya existe. Revisar manualmente; no se sobrescribe.', 1;
EXEC(N'CREATE DATABASE LabContactos');
ALTER DATABASE LabContactos SET RECOVERY SIMPLE;
-- Sin GO: si falla la guarda anterior no se continúa en otro lote.
EXEC(N'USE LabContactos;
CREATE TABLE dbo.Area (
    AreaId int IDENTITY PRIMARY KEY,
    Nombre nvarchar(50) NOT NULL UNIQUE
);
CREATE TABLE dbo.Contacto (
    ContactoId int IDENTITY PRIMARY KEY,
    Nombre nvarchar(80) NOT NULL,
    Apellido nvarchar(80) NOT NULL,
    Email varchar(254) NOT NULL UNIQUE,
    AreaId int NOT NULL REFERENCES dbo.Area(AreaId),
    Observacion varchar(100) NULL,
    FechaCarga datetime2 NOT NULL DEFAULT SYSUTCDATETIME()
);
INSERT dbo.Area(Nombre) VALUES (N''Compras''),(N''Ventas''),(N''TI'');');
