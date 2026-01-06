# RIWI Analytics Data Pipeline

## Descripción

Este proyecto implementa un pipeline completo de procesamiento de datos para el sistema de analytics de RIWI. El pipeline consta de dos componentes principales:

1. **Limpieza de Datos**: Un script automatizado que limpia y preprocesa datos de ventas desde un archivo CSV crudo.
2. **Carga a Base de Datos**: Un cargador que inserta los datos limpios en una base de datos PostgreSQL estructurada para analytics.

El objetivo es transformar datos de ventas crudos en un formato limpio y estructurado, optimizado para consultas analíticas y reportes.

## Arquitectura del Pipeline

```
Datos Crudos (CSV) → Limpieza → Datos Limpios (CSV) → Carga → PostgreSQL Analytics
     ↓                    ↓             ↓                    ↓
 Assessment/Datos.csv  limpiesa.ipynb  riwi_datos_limpios.csv  Carga_de_los_datos.ipynb
```

## Componentes

### 1. Limpieza de Datos (`limpiesa.ipynb`)

**Funcionalidad**:
- Carga y valida archivos CSV con datos de ventas.
- Aplica un pipeline de limpieza secuencial para eliminar inconsistencias.
- Genera estadísticas detalladas del proceso de limpieza.
- Exporta datos limpios en formato CSV optimizado.

**Pasos de Limpieza**:
1. **Validación**: Verifica existencia y estructura del archivo CSV.
2. **Eliminación de Duplicados**: Identifica y remueve registros duplicados basados en columnas clave.
3. **Manejo de Nulos**: Elimina filas con valores críticos nulos y rellena valores no críticos.
4. **Filtrado de Ventas**: Elimina transacciones con montos negativos o cero.
5. **Validación de Regiones**: Remueve registros sin información geográfica válida.
6. **Limpieza de Fechas**: Filtra fechas inválidas o fuera de rango.
7. **Normalización de Textos**: Estandariza formatos de texto (productos, ubicaciones, tipos).
8. **Enriquecimiento**: Crea columnas adicionales para análisis (año, mes, trimestre, cálculos financieros).

### 2. Carga a Base de Datos (`Carga_de_los_datos.ipynb`)

**Funcionalidad**:
- Establece conexiones seguras a PostgreSQL.
- Carga datos en un esquema dimensional optimizado.
- Maneja inserciones masivas con control de transacciones.
- Crea índices automáticos para optimización de consultas.
- Realiza verificaciones post-carga y genera reportes.

**Estructura de Datos**:
- **Dimensiones**: `regiones`, `productos`, `tipos_cliente`, `canales_venta`
- **Hechos**: `ventas` (con claves foráneas a dimensiones)
- **Índices**: Optimizados para consultas por fecha, producto, región, etc.

## Requisitos del Sistema

### Software
- **Python**: Versión 3.8 o superior
- **PostgreSQL**: Versión 12 o superior con esquema `analytics` configurado
- **Jupyter Notebook**: Para ejecutar los scripts interactivos

### Dependencias de Python
Las dependencias están listadas en `requirements.txt`:
- pandas==2.1.4
- numpy==1.24.3
- psycopg2-binary==2.9.9
- SQLAlchemy==2.0.23
- matplotlib==3.8.2
- seaborn==0.13.0
- tqdm==4.66.1
- python-dateutil==2.8.2
- jupyter==1.0.0
- ipykernel==6.27.1
- pydantic==2.5.2
- python-dotenv==1.0.0

### Archivos de Datos
- `Assessment/Datos.csv`: Archivo CSV con datos de ventas crudos
- Esquema PostgreSQL pre-creado con tablas dimensionales y de hechos

## Instalación y Configuración

1. **Clona o descarga el repositorio**.

2. **Instala dependencias**:
   ```bash
   cd Limpieza_del_dataset
   pip install -r requirements.txt
   ```

3. **Configura PostgreSQL**:
   - Crea base de datos `riwi_analytics`
   - Ejecuta scripts SQL para crear el esquema `analytics` con las tablas requeridas
   - Asegura permisos de escritura para el usuario configurado

4. **Prepara datos de entrada**:
   - Coloca `Datos.csv` en la carpeta `Assessment/`
   - Verifica que el CSV tenga las columnas esperadas

## Configuración de Conexión

### Para el Cargador de Datos
Edita la configuración en `Carga_de_los_datos.ipynb`:

```python
DB_CONFIG = {
    'database': 'riwi_analytics',
    'user': 'tu_usuario',
    'password': 'tu_password_segura',
    'host': 'localhost',
    'port': 5432
}
```

**⚠️ Seguridad**: Nunca almacenes contraseñas en código. Usa variables de entorno o archivos `.env`.

### Para el Limpiador
Configura rutas de archivos en `limpiesa.ipynb`:

```python
ARCHIVO_ENTRADA = "../Assessment/Datos.csv"
ARCHIVO_SALIDA = "riwi_datos_limpios.csv"
```

## Uso del Pipeline

### Paso 1: Limpieza de Datos

1. Abre `limpiesa.ipynb` en Jupyter Notebook
2. Ejecuta todas las celdas en orden
3. Revisa el log `riwi_cleaner.log` para detalles
4. Verifica el archivo `riwi_datos_limpios.csv` generado

### Paso 2: Carga a Base de Datos

1. Abre `Carga_de_los_datos.ipynb` en Jupyter Notebook
2. Verifica configuración de base de datos
3. Ejecuta todas las celdas
4. Revisa logs y estadísticas de carga

### Ejecución Automatizada

Para ejecutar desde línea de comandos:

```bash
# Limpieza
python -c "
from limpiesa import CSVCleaner
limpiador = CSVCleaner('../Assessment/Datos.csv', 'riwi_datos_limpios.csv')
limpiador.ejecutar_limpieza()
"

# Carga (requiere configuración previa)
python -c "
from carga_datos import PostgreSQLLoaderFinal
cargador = PostgreSQLLoaderFinal(DB_CONFIG, 'riwi_datos_limpios.csv')
cargador.ejecutar_carga_completa()
"
```

## Salidas y Logs

### Limpieza
- **Archivo**: `riwi_datos_limpios.csv` - Datos procesados y limpios
- **Log**: `riwi_cleaner.log` - Detalles del proceso de limpieza
- **Estadísticas**: Mostradas en consola y log

### Carga
- **Base de Datos**: Datos poblados en esquema `analytics`
- **Log**: `riwi_loader.log` - Detalles del proceso de carga
- **Estadísticas**: `riwi_carga_estadisticas.json` - Métricas de carga

## Estructura del Proyecto

```
Ascam/
├── README.md
├── Assessment/
│   └── Datos.csv                    # Datos crudos de entrada
└── Limpieza_del_dataset/
    ├── limpiesa.ipynb               # Script de limpieza
    ├── Carga_de_los_datos.ipynb     # Script de carga
    ├── requirements.txt             # Dependencias Python
    ├── riwi_datos_limpios.csv       # Salida de limpieza
    ├── riwi_cleaner.log             # Log de limpieza
    ├── riwi_loader.log              # Log de carga
    └── riwi_carga_estadisticas.json # Estadísticas de carga
```

## Características Técnicas

### Limpieza de Datos
- **Manejo de Memoria**: Procesamiento eficiente de archivos grandes
- **Validación Robusta**: Múltiples checks de integridad
- **Flexibilidad**: Adaptable a diferentes estructuras de CSV
- **Enriquecimiento**: Creación automática de columnas derivadas
- **Logging Detallado**: Seguimiento completo del proceso

### Carga de Datos
- **Conexiones Seguras**: Uso de psycopg2 y SQLAlchemy
- **Transacciones**: Control completo de integridad
- **Carga Masiva**: Optimizada para grandes volúmenes
- **Índices Automáticos**: Optimización de rendimiento
- **Verificación**: Validación post-carga de datos

## Manejo de Errores

- **Validaciones Iniciales**: Checks antes de procesar
- **Recuperación**: Rollbacks en caso de errores durante carga
- **Logging**: Registro detallado de todos los eventos
- **Estadísticas**: Métricas para identificar problemas

## Rendimiento

- **Limpieza**: Procesamiento secuencial optimizado
- **Carga**: Inserción en chunks de 5000 registros
- **Índices**: Creación automática para consultas rápidas
- **Memoria**: Manejo eficiente de DataFrames grandes

## Contribución

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a rama (`git push origin feature/nueva-funcionalidad`)
5. Abre Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver archivo `LICENSE` para detalles.

## Soporte

Para soporte técnico o preguntas:
- Revisa los logs generados
- Verifica configuración de base de datos
- Asegura compatibilidad de versiones

---

**Nota**: Este pipeline asume un esquema PostgreSQL pre-configurado. Los scripts SQL para crear las tablas deben ejecutarse antes de la carga.#   - A s s e s s m e n t - E m p l e a b i l i d a d - - - E n u n c i a d o - y - e n t r e g a  
 