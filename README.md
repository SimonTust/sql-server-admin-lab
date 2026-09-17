# Laboratorio de administración de SQL Server

Simon Tust · SQL Server 2022 · Windows

Material revisado y aprobado para publicación. Scripts no ejecutados: resultados pendientes de validación práctica. Basado en tareas de importación de contactos, consultas, cambios de columnas, backups y restauraciones. Todos los registros son ficticios y los correos usan example.com. No representa una implementación productiva ni acredita resultados de pruebas.

## Preparación

Usar una instancia de laboratorio y SSMS. No usar una base empresarial. Crear manualmente `C:\SQLLab\import`, `C:\SQLLab\backup` y `C:\SQLLab\restore` en el equipo donde corre SQL Server. Copiar `data/contactos.csv` a la carpeta import. Las rutas de los scripts se refieren al servidor, no al equipo cliente de SSMS.

La identidad que accede al CSV debe tener lectura; el servicio del motor necesita escritura en backup y restore. La identidad efectiva de BULK INSERT depende de la autenticación. Se requieren permisos SQL de creación de bases, carga masiva, backup y restore según el paso; no se incluyen concesiones automáticas de permisos.

## Orden de revisión y ejecución manual

1. `sql/01_crear.sql`: crea LabContactos, tablas y catálogo de áreas. Se detiene si la base existe. El laboratorio usa recuperación SIMPLE; no demuestra recuperación a un punto en el tiempo.
2. `sql/02_importar.sql`: carga el CSV UTF-8 en una tabla temporal, muestra rechazos y conserva registros válidos. Correos duplicados dentro del lote se rechazan todos; correos ya existentes no se vuelven a insertar. No ejecutar cargas simultáneas.
3. `sql/03_consultar_y_alterar.sql`: JOIN, agrupación, ampliación de una columna y comparación de tipos. Ejemplo de evolución de esquema, no una migración de producción.
4. `sql/04_backup.sql`: genera un archivo nuevo y devuelve su ruta. Copiar esa ruta en el script siguiente.
5. `sql/05_restaurar.sql`: inspecciona el backup y restaura como LabContactos_Restaurada. Revisar nombres lógicos y rutas antes de ejecutar. No usa REPLACE ni elimina bases existentes.
6. `sql/06_verificar.sql`: historial, integridad y comparación de contenido. Comparar sin cambios concurrentes en la base origen.

## Qué revisar

Con el CSV incluido, en una base nueva se esperan 3 contactos aceptados y 5 filas rechazadas: dos por correo duplicado, una sin nombre, una con correo inválido y una con área desconocida. Es una expectativa derivada de lectura, todavía no comprobada ejecutando SQL. Repetir la carga debe insertar cero contactos adicionales.

La validación del correo es deliberadamente básica: no comprueba existencia del buzón ni implementa todas las reglas de direcciones de correo. Nombres y apellidos se almacenan en nvarchar para conservar Unicode; correo usa varchar y este ejemplo admite solo caracteres ASCII. No enviar mensajes a los contactos.

## Operación con SSMS y programación

Ver `docs/operacion.md` para realizar backup y restore desde la interfaz, programar un trabajo y registrar evidencias. La automatización se configura manualmente después de revisar los scripts; no hay trabajos activados por este proyecto.

## Referencias

- [BULK INSERT, CSV y UTF-8](https://learn.microsoft.com/en-us/sql/t-sql/statements/bulk-insert-transact-sql?view=sql-server-ver16)
- [RESTORE VERIFYONLY](https://learn.microsoft.com/en-us/sql/t-sql/statements/restore-statements-verifyonly-transact-sql?view=sql-server-ver16)
- [Historial de backups](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/backup-history-and-header-information-sql-server?view=sql-server-ver16)

VERIFYONLY comprueba el conjunto de backup, pero no sustituye una restauración real ni una comprobación de integridad sobre la base restaurada.
