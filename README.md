# RIWI Analytics Data Pipeline

## Description

This project implements a complete data processing pipeline for the RIWI analytics system. The pipeline consists of two main components:

1. **Data Cleaning**: An automated script that cleans and preprocesses sales data from a raw CSV file.

2. **Database Loading**: A loader that inserts the cleaned data into a structured PostgreSQL database for analytics.

The goal is to transform raw sales data into a clean and structured format, optimized for analytical queries and reports.

## Pipeline Architecture

```
Raw Data (CSV) → Cleaning → Cleaned Data (CSV) → Loading → PostgreSQL Analytics

↓ ↓ ↓ ↓
Assessment/Data.csv cleans.ipynb clean_data.csv Load_of_the_data.ipynb
```

## Components

### 1. Data Cleaning (`cleans.ipynb`)

**Functionality**:
- Loads and validates CSV files with sales data.

- Applies a sequential cleaning pipeline to eliminate inconsistencies.

- Generates detailed statistics of the cleaning process.

- Exports clean data in optimized CSV format.

**Cleaning Steps**:
1. **Validation**: Verifies the existence and structure of the CSV file.

2. **Duplicate Removal**: Identifies and removes duplicate records based on key columns.

3. **Null Handling**: Removes rows with critical null values ​​and fills in non-critical values.

4. **Sales Filtering**: Removes transactions with negative or zero amounts.

5. **Region Validation**: Removes records without valid geographic information.

6. **Date Cleaning**: Filters out invalid or out-of-range dates.

7. **Text Normalization**: Standardizes text formats (products, locations, types).

8. **Data Enrichment**: Creates additional columns for analysis (year, month, quarter, financial calculations).

### 2. Database Loading (`Data_Load.ipynb`)

**Functionality**:
- Establishes secure connections to PostgreSQL.

- Loads data into an optimized dimensional schema.

- Handles bulk inserts with transaction control.

- Creates automatic indexes for query optimization.

- Performs post-load verifications and generates reports.

**Data Structure**:
- **Dimensions**: `regions`, `products`, `customer_types`, `sales_channels`
- **Facts**: `sales` (with foreign keys to dimensions)
- **Indexes**: Optimized for queries by date, product, region, etc.

## System Requirements

### Software
- **Python**: Version 3.8 or higher
- **PostgreSQL**: Version 12 or higher with `analytics` schema configured
- **Jupyter Notebook**: To run interactive scripts

### Python Dependencies
Dependencies are listed in `requirements.txt`:
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

### Data Files
- `Assessment/Datos.csv`: CSV file with raw sales data
- Pre-built PostgreSQL schema with dimensional and fact tables

## Installation and Configuration

1. **Clone or download the repository**.

2. **Install dependencies**:

``bash

cd Cleanup_of_the_dataset

`pip install -r requirements.txt

``

3. **Configure PostgreSQL**:

- Create database `riwi_analytics`

- Run SQL scripts to create the `analytics` schema with the required tables

- Ensure write permissions for the configured user

4. **Prepare input data**:

- Place `Datos.csv` in the `Assessment/` folder

- Verify that the CSV file has the expected columns

## Connection Configuration

### For the Data Loader
Edit the configuration in `Load_of_the_data.ipynb`:

```python
DB_CONFIG = {
'database': 'riwi_analytics',
'user': 'your_username',
'password': 'your_secure_password',

'host': 'localhost',

'port': 5432
}
```

**⚠️ Security**: Never store passwords in code. Use environment variables or `.env` files.


### For the Cleaner
Configure file paths in `limpiesa.ipynb`:

```python
INPUT_FILE = "../Assessment/Datos.csv"
OUTPUT_FILE = "riwi_datos_limpios.csv"
```

## Using the Pipeline

### Step 1: Data Cleaning

1. Open `limpiesa.ipynb` in Jupyter Notebook
2. Run all cells in order
3. Check the `riwi_cleaner.log` log for details
4. Verify the generated `riwi_datos_limpios.csv` file

### Step 2: Loading to Database

1. Open `Carga_de_los_datos.ipynb` in Jupyter Notebook
2. Verify database configuration
3. Run all cells
4. Review logs and statistics Loading

### Automated Execution

To run from the command line:

```bash
# Cleaning
python -c ""
from cleanup import CSVCleaner
cleaner = CSVCleaner('../Assessment/Data.csv', 'riwi_clean_data.csv')
cleaner.run_cleanup()
"

# Loading (requires (Previous configuration)
python -c ""
from carga_datos import PostgreSQLLoaderFinal
cargador = PostgreSQLLoaderFinal(DB_CONFIG, 'riwi_datos_limpios.csv')
cargador.ejecutar_carga_completa()
"
```

## Outputs and Logs

### Cleaning
- **File**: `riwi_datos_limpios.csv` - Processed and cleaned data
- **Log**: `riwi_cleaner.log` - Cleaning process details
- **Statistics**: Displayed in console and log

### Loading
- **Database**: Data populated in `analytics` schema
- **Log**: `riwi_loader.log` - Loading process details
- **Statistics**: `riwi_carga_estadisticas.json` - Loading metrics

## Structure of the Project

```
Ascam/
├── README.md
├── Assessment/
│ └── Data.csv # Raw input data
└── Dataset_cleaning/
├── cleanse.ipynb # Cleaning script

├── Load_data.ipynb # Loading script

├── requirements.txt # Python dependencies

├── riwi_clean_data.csv # Cleaning output

├── riwi_cleaner.log # Cleaning log

├── riwi_loader.log # Loading log

└── riwi_carga_estadisticas.json # Load Statistics
```

## Technical Characteristics

### Data Cleaning
- **Memory Management**: Efficient processing of large files
- **Robust Validation**: Multiple integrity checks
- **Flexibility**: Adaptable to different CSV structures
- **Enrichment**: Automatic creation of derived columns
- **Detailed Logging**: Complete tracking of the process

### Data Loading
- **Secure Connections**: Use of psycopg2 and SQLAlchemy
- **Transactions**: Complete integrity control
- **Bulk Loading**: Optimized for large volumes
- **Automatic Indexes**: Performance optimization
- **Verification**: Post-load data validation

## Error Handling

- **Initial Validations**: Checks before processing
- **Recovery**: Rollbacks Error handling during loading
- **Logging**: Detailed logging of all events
- **Statistics**: Metrics to identify problems

## Performance

- **Cleaning**: Optimized sequential processing
- **Loading**: Insertion in chunks of 5000 records
- **Indexes**: Automatic creation for fast queries
- **Memory**: Efficient handling of large DataFrames

## Contribution

1. Fork the repository
2. Create a branch for your feature (`git checkout -b feature/new-feature`)
3. Commit changes (`git commit -am 'Adds new feature'`)
4. Push to branch (`git push origin feature/new-feature`)
5. Open a pull request

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Support

For technical support or questions:
- Review the generated logs
- Verify database configuration
- Ensure version compatibility

---
