USE LabContactos;
SET NOCOUNT ON;
SET XACT_ABORT ON;
CREATE TABLE #Carga (
    Nombre nvarchar(4000), Apellido nvarchar(4000),
    Email nvarchar(4000), Area nvarchar(4000)
);
BULK INSERT #Carga FROM 'C:\SQLLab\import\contactos.csv'
WITH (FORMAT='CSV', FIRSTROW=2, CODEPAGE='65001',
      FIELDQUOTE='"', FIELDTERMINATOR=',', ROWTERMINATOR='0x0a');

UPDATE #Carga SET Nombre=TRIM(Nombre), Apellido=TRIM(Apellido),
    Email=LOWER(TRIM(Email)), Area=TRIM(REPLACE(Area, CHAR(13), ''));
SELECT c.*, a.AreaId,
    CASE
      WHEN NULLIF(c.Nombre,N'') IS NULL OR NULLIF(c.Apellido,N'') IS NULL
        THEN N'Nombre o apellido vacío'
      WHEN LEN(c.Nombre)>80 OR LEN(c.Apellido)>80 OR LEN(c.Email)>254
        THEN N'Longitud excedida'
      WHEN c.Email IS NULL OR c.Email NOT LIKE N'%_@_%._%'
        OR c.Email LIKE N'% %' OR c.Email LIKE N'%@%@%'
        OR c.Email COLLATE Latin1_General_100_BIN2 LIKE N'%[^ -~]%'
        THEN N'Correo inválido para este laboratorio'
      WHEN COUNT(*) OVER (PARTITION BY c.Email)>1 THEN N'Correo duplicado en lote'
      WHEN a.AreaId IS NULL THEN N'Área desconocida'
      WHEN EXISTS (SELECT 1 FROM dbo.Contacto e WHERE e.Email=c.Email)
        THEN N'Correo ya existente'
    END AS Motivo
INTO #Validacion
FROM #Carga c LEFT JOIN dbo.Area a ON a.Nombre=c.Area;

SELECT Nombre,Apellido,Email,Area,Motivo FROM #Validacion WHERE Motivo IS NOT NULL;
BEGIN TRANSACTION;
INSERT dbo.Contacto(Nombre,Apellido,Email,AreaId)
SELECT Nombre,Apellido,CONVERT(varchar(254),Email),AreaId
FROM #Validacion WHERE Motivo IS NULL;
SELECT @@ROWCOUNT AS ContactosInsertados;
COMMIT;
DROP TABLE #Validacion;
DROP TABLE #Carga;
