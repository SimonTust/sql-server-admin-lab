# Guía de operación y revisión

## Backups mediante SSMS

Sobre LabContactos, abrir Tasks / Back Up. Seleccionar copia Full y Copy-only; elegir un archivo nuevo en la carpeta de backup del servidor. Activar checksum y verificación si están disponibles en las opciones. Usar Script para revisar el T-SQL generado antes de ejecutarlo. Guardar la ruta y el mensaje final como evidencia solamente después de ejecutar.

## Restauración mediante SSMS

En Databases / Restore Database, seleccionar Device y el backup del laboratorio. Usar destino LabContactos_Restaurada, revisar Files y cambiar las rutas físicas para que sean distintas a las de origen. Mantener desactivada la opción de sobrescribir la base existente. Si ya existe el destino, detenerse y revisar manualmente. No modificar ni borrar la base origen.

## Trabajo programado

Confirmar edición con `SELECT SERVERPROPERTY('Edition');`. SQL Server Express no incluye SQL Server Agent. Si está disponible y el servicio está iniciado, crear manualmente un trabajo llamado LabContactos_Backup, inicialmente deshabilitado, con un paso T-SQL en master que contenga el script 04_backup.sql. El propietario debe ser una cuenta autorizada de laboratorio con los permisos necesarios; no se incluyen credenciales en archivos.

Agregar un horario diario, por ejemplo 20:00, y dejarlo deshabilitado hasta revisar la configuración. La hora corresponde al servidor. Verificar permisos de escritura del servicio del motor y revisar View History después de una ejecución manual autorizada. No habilitarlo como parte de la simple revisión de este repositorio.

En Express se puede planificar sqlcmd mediante el Programador de tareas de Windows, con autenticación integrada bajo una identidad autorizada. Requiere configurar la tarea y disponer de sqlcmd; no se instala ni configura aquí. La opción -b permite reportar errores al proceso que lo invoca. No usar contraseñas en la línea de comandos.

Los backups del ejemplo tienen nombres únicos: se acumulan. No se implementa borrado ni política de retención. Antes de habilitar una programación sostenida, definir frecuencia, espacio y retención. SIMPLE y copias completas sirven al alcance de este laboratorio, no a todos los requisitos de recuperación.

## Registro de revisión

Estado inicial: sin ejecutar. Completar después de la revisión de Simon.

| Comprobación | Resultado observado |
|---|---|
| Versión y edición | Pendiente |
| Creación de base y tablas | Pendiente |
| CSV: 3 aceptados / 5 rechazados | Pendiente |
| Segunda carga: 0 inserciones | Pendiente |
| JOIN y ALTER de columna | Pendiente |
| Backup y VERIFYONLY | Pendiente |
| Restore a destino separado | Pendiente |
| CHECKDB y diferencias de datos | Pendiente |
| Trabajo programado e historial, si corresponde | Pendiente |

No publicar capturas con nombres de servidores, rutas empresariales, correos reales o credenciales. Las evidencias deben provenir del laboratorio ficticio.
