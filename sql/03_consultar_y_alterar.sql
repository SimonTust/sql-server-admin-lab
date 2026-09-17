USE LabContactos;
SELECT c.ContactoId,c.Nombre,c.Apellido,c.Email,a.Nombre AS Area
FROM dbo.Contacto c JOIN dbo.Area a ON a.AreaId=c.AreaId
ORDER BY a.Nombre,c.Apellido;

SELECT a.Nombre,COUNT(c.ContactoId) AS Contactos
FROM dbo.Area a LEFT JOIN dbo.Contacto c ON c.AreaId=a.AreaId
GROUP BY a.Nombre;

-- Ampliar longitud y admitir Unicode en una columna sin índices dependientes.
-- En producción: revisar dependencias, volumen, bloqueo y rollback antes de ALTER.
ALTER TABLE dbo.Contacto ALTER COLUMN Observacion nvarchar(200) NULL;
SELECT name,TYPE_NAME(user_type_id) AS Tipo,max_length AS LongitudEnBytes
FROM sys.columns WHERE object_id=OBJECT_ID(N'dbo.Contacto');
-- nvarchar mide capacidad en pares de bytes; max_length no es cantidad de caracteres.
-- varchar depende de la intercalación/página de códigos; puede usar UTF-8 si se configura.
