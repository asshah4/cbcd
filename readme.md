# Computational Biorepository for Cardiovascular Disease

This serves as a code-based hub for the EMR-based cardiovascular data from the University of Illinois Chicago as part of an IRB-approved, HIPAA compliant registry. No data is available on this site or on Github directly. However, the code that could generate or organize the data is available and intended to be shared by any co-authors or collaborators.

The data is located on a UIC-based cluster, currently an AWS spin-up. This cannot be accessed without 1) UIC approval, 2) IRB approval, 3) a cluster account, 4) read/write access to the project home. This is under two-factor authentication. 

For inquiries, can reach out to members of the Darbar lab for further information. If looking for the lab name on the AWS/ACER server, its named:

AWS ID = CARDIO_DARBAR

## Clinical data

**Pipeline**:

1. File transfer from the Clinical Data Warehouse to the Cluster
	a. Download from the UIC Box folder (or however CCTS delivers it) the respective data pulls on all EMR data-types. This must be done on a local computer.
	a. SSH the *.zip files to the cluster under 'cbcd/data/raw/*'. Be careful not to replace old, potentially important, files based on the name. 
	a. Unzip the files on the remote server (cluster), and rename them to the nomenclature listed below. This is key so other code can utilize the common names for retrieval/manipulation.
1. Partition the CSV files into an out-of-memory friendly format for analysis
	a. Using the `partition-ccts.sh` script located in the project directory, send a batch job to start processing the files.
	a. There is a folder called `csv` under the `ccts` folder where data is stored. All of the RAW files will be split by year and placed under this folder with their respective names as __CSV__ files. 
	a. Then, now that the files are more appropriate in size, can convert to a nested/hive-like file structure using Apache Arrow and the respective __PARQUET__ format. 

The data is rescued from the EMR through a CDW pull from the UIC CCTS. This process is somewhat "limited" in that it always results in a pull of data that is a whole system refresh. E.g. the file sizes can be upwards of 10 Gb each. These are zipped files. They are likely too large to host on a local computer. Additionally, each file is formatted and de-identified using a REDCap key that can be found on the main REDCap site (as well as their encounter ID, date/time, etc). 

The data is stored in... 

~/project/cbcd/data/raw/*

...and in a CSV format. These have not been processed, but are first part of the pipeline to organize the data. This data is broken up into several types, which are explained below. For our usage, we rename them for simplicity. 

- demographics.csv = REDCap and MRN key data, along with baseline intake information
- diagnosis.csv = diagnosis code which may be in ICD9 or ICD10 format
- labs.csv = lab type and lab value (+/- units)
- medications.csv = medication, dosage, unit, route
- notes.csv = clinical notes from ALL encounters, including non-physician documentation (very large file)
- procedure-dates.csv = name and date of procedure along with CPT codes
- procedure-reports.csv = available textual results of procedures performed (limited when data was stored as PDF earlier on)
- visits.csv = record of every visit or encounter, including location
- vitals.csv = vitals at every visit or encounter

These raw files need to be managed in a referential way, e.g. database, SQL, or potential parquet format (via Apache Arrow). The current infrastructure is oriented around parquet for ease of manipulation within R (and other languages, including Python). 

To convert a CSV file to PARQUET, use the following script located in the root folder for the **cbcd** project

XXX

This contains the appropriate variables that can be manipulated to write out files in parquet format. The current structure is a HIVE style using the YEAR and MONTH of the relevant date for the data, which will lead to a reasonable file size.

## Electrocardiography (ECG) data

__Pipeline__:

1. Digitize ECG data and store on the Cluster
1. Convert to WFDB format

The data-pull for the above *clinical* data is also paired with digitized ECG data. They are all stored in an XML format as their raw extraction from MUSE. There is a pipeline of how they are extracted below for future repeat efforts, as well as which ECGs have been extracted thus far.

The current data that has been added to the cluster includes the following, most recently updated on:

- 2010
- 2011
- 2012
- 2013
- 2014
- 2015
- 2016
- 2017
- 2018
- 2019
- 2020
- 2021
- 2022, 06/29/23 by ashah282@uic.edu
- 2023 (January to end of June), 09/01/23 by ashah282@uic.edu


Pipeline for feature extraction:

1.  Convert ECG full disclosure data into XML (can be done through MUSE)
1.  Subsequently convert XML format to WFDB format for signal analysis and annotation
1.  QRS annotation files can be created
1. 	Identification of rhythm using human-labeling + machine learning
1.  Segmentation can be performed if in sinus rhythm (may or may not be accurate) using PhysioNet toolbox

Specific parameters
1.  Can generate GEH data from 12-lead ECG with orthogonal points
1.  Generate HRV indices off of 10-second ECG lead
1.  Generate short-PRD values (periodic repolarization dynamics) from 10-second strip
1.  Generate median beats

These will rely primarily on WFDB-based scripts, utilizing the XML files from MUSE which are converted to DAT and HEA files and other annotation files.

### Conversion of XML to WFDB

convert-xml2wfdb.R

### Identification of ECG diagnoses

Identifying ECGs based on a diagnosis (e.g. AF), which creates and manipulates a file called "ECG-AFDiagnosis.tsv". This files contains a table of MUSE file names, MRNs, and dates and times. 

find-wfdb2diagnosis.R
match-diagnosis2mrn.R

