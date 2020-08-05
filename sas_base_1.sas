/* Section 1 - Access and Create Data Structures */

/* 1. Create temporary and permanent SAS data sets. */
/* • Use a DATA step to create a SAS data set from an existing SAS data set. */

data mycars; /*temporary dataset in my work library*/
   input make $ model $ mpg_highway;
   datalines;
Acurra MDX 23
Buick Regal 20
GMC Yukon 16
;
run;

data iris;
   set sashelp.iris;
run;

libname mylib "/folders/myfolders";
/* libname badlib "/folders/myfolders/badlib"; */

data mylib.iris;
   set iris;
run;


/* 2. Investigate SAS data libraries using base SAS utility procedures. */
/* • Use a LIBNAME statement to assign a library reference name to a SAS library. */
/* • Investigate a library programmatically using the CONTENTS procedure. */

proc contents data=sashelp.cars directory;
run;

/* Access data */
/* • Access SAS data sets with the SET statement. */

data baseball;
   set sashelp.baseball;
   if team = 'Cleveland';
run;

/* • Use PROC IMPORT to access non-SAS data sources. */
proc export data=baseball
            outfile="/folders/myfolders/baseball.xlsx"
            dbms=xlsx replace;
            sheet="baseball";
run;

proc export data=baseball
            outfile="/folders/myfolders/baseball.csv"
            dbms=csv replace;

run; 

    
/* o Read delimited and Microsoft Excel (.xlsx) files with PROC IMPORT. */

proc import out=baseball_import
            datafile='/folders/myfolders/baseball.xlsx'
            dbms=xlsx replace;
            sheet = 'baseball';
            getnames=yes;
run;
/* o Use PROC IMPORT statement options (OUT=, DBMS=, REPLACE) */
/* o Use the GUESSINGROWS statement */
proc import out=baseball_csv_import
            datafile='/folders/myfolders/baseball.csv'
            dbms=csv replace;
            getnames=yes;
/*             guessingrows=2;  */
run;

proc contents data=baseball_csv_import;
run;

/* • Use the SAS/ACCESS XLSX engine to read a Microsoft Excel workbook.xlsx file. */

libname myxlsx xlsx "/folders/myfolders/baseball.xlsx";

/* 3. Combine SAS data sets. */

/* • Concatenate data sets. */
data concat;
   set sashelp.iris(where=(species='Setosa')) sashelp.iris(where=(species='Versicolor'));
run;

/* • Merge data sets one-to-one. */
data one_to_one;
   merge sashelp.buy(in=a) sashelp.countseries (in=b);
   by date;
   if a and b;
run;

/* • Merge data sets one-to-many. */
data one_to_many;
   merge sashelp.buy(in=a) sashelp.countseries (in=b);
   by date;
   if a and b;
run;

/* 4. Create and manipulate SAS date values. */
/* • Explain how SAS stores date and time values. */
/* • Use SAS informats to read common date and time expressions. */
/* • Use SAS date and time formats to specify how the values are displayed. */

data air;
   set sashelp.air;
   
   date0=date*1; 
   day = day(date);
   month = month(date);
   year = year(date);
   time = time();
   date_time = dhms(date, 0, 0, 0);
   
   format date_time datetime20.;

run;

/* 5.Control which observations and variables in a SAS data set are processed and */
/* output. */
/* • Use the WHERE statement in the DATA step to select observations to be processed. */
data iris;
   set sashelp.iris;
   
   where species = 'Setosa';
   
run;

/* • Subset variables to be output by using the DROP and KEEP statements. */

data baseball;
   set sashelp.baseball;
   
/*    keep name logsalary; */
   drop name logsalary;
   
run;
/* • Use the DROP= and KEEP= data set options to specify columns to be processed and/or */
/* output. */
data baseball;
   set sashelp.baseball (keep = name logsalary nhits natbat drop=logsalary);
run;   