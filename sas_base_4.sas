/*Section 4 - Generate Reports and Output */


/*1. Generate list reports using the PRINT procedure.*/
proc print data=sashelp.cars(obs=5);
run;

/*• Modify the default behavior of PROC PRINT by adding statements and options such as*/
/*o use the VAR statement to select and order variables.*/
proc print data=sashelp.cars(obs=5);
   var make model msrp invoice;
run;

/*o calculate totals with a SUM statement.*/
proc print data=sashelp.cars(obs=5);
   var make model msrp invoice;
   sum msrp invoice;
run;

/*o select observations with a WHERE statement.*/
proc print data=sashelp.cars(obs=50);
   where type = 'SUV';
   var type make model msrp invoice;
   sum msrp invoice;
run;

/*o use the ID statement to identify observations.*/
proc print data=sashelp.cars(obs=50);
   id type;
   var make model msrp invoice;
   sum msrp invoice;
run;
 

/*o use the BY statement to process groups.*/
proc sort data=sashelp.cars out=cars;
   by type;
run;

proc print data=cars(obs=20);
   by type;
   var make model msrp invoice;
   sum msrp invoice;
run;


/*Generate summary reports and frequency tables using base SAS procedures.*/

/*• Produce one-way and two-way frequency tables with the FREQ procedure.*/
proc freq data=sashelp.class;
   tables age;
run;

proc freq data=sashelp.class;
   tables age*sex;
run;   
 

/*• Enhance frequency tables with options (NLEVELS, ORDER=).*/
proc freq data=sashelp.class nlevels;
run;

proc freq data=sashelp.class order=freq;
   tables age;
run;
 

/*• Use PROC FREQ to validate data in a SAS data set.*/

%let student_name = Pat;
%let height = 70;
%let weight = 120;
%let age = 35;
%let sex = M;

data new_student;
   set sashelp.class(obs=1);
   
   name = symget('student_name');
   weight = &weight;
   age = &age.;
   sex = symget('sex');
   height = &height.;
run;

data class_updated;
   set sashelp.class new_student;
run;

proc freq data=class_updated;
   tables age;
run;


/*• Calculate summary statistics and multilevel summaries using the MEANS procedure*/

proc means data=sashelp.baseball;
run;

/*• Enhance summary tables with options.*/

proc means data=sashelp.baseball(where=(league='National')) mean;
   class division team;
   types division*team;
   var nHome;
run;

/*• Identify extreme and missing values with the UNIVARIATE procedure. */

proc univariate data=class_updated;
   var age;
run;


 
/*3 - Enhance reports system user-defined formats, titles, footnotes and SAS System reporting options.*/

/*• Use PROC FORMAT to define custom formats.*/
/*o VALUE statement*/
proc format;
   value prices
      low-15000 = 'low price'
      15001-45000 = 'mid price'
      45001-high = 'high price'
  ;
run;

data cars;
   set sashelp.cars(keep=make model msrp);
   
   price = put(msrp, prices.);
   
run;
   
/*o CNTLIN= option*/

data bbformat;
   input fmtname $ start end label $;
   datalines;
hr_group 1 10 low
hr_group 11 29 midrange
hr_group 30 90 slugger
;
run;

proc format cntlin=bbformat;
run;

proc freq data=sashelp.baseball;
   table nHome;
   format nHome hr_group.;
run;
 

/*• Use the LABEL statement to define descriptive column headings.*/

proc print data=sashelp.cars (obs=10);
   var make model msrp;
run;

data cars;
   set sashelp.cars;
   label msrp = 'Recommended Retail Price (in USD)';
run;

proc contents data=cars;
run;


/*• Control the use of column headings with the LABEL and SPLIT=options in PROC PRINT*/

proc print data=cars (obs=10) label;
   var make model msrp;
run;

/*split = option specifies a line break*/
proc print data=cars (obs=10) split='(';
   var make model msrp;
run;



/*4 - Generate reports using ODS statements.*/

/*• Identify the Output Delivery System destinations.*/
/*• Create HTML, PDF, RTF, and files with ODS statements.*/
/* ods html file='my_report.html'; */
ods html file='/folders/myfolders/my_report.html';
   proc print data=cars (obs=10) label;
      var make model msrp;
   run;
ods html close;

/* ods pdf file='my_report.pdf'; */
ods pdf file='/folders/myfolders/my_report.pdf';
   proc print data=cars (obs=10) label;
      var make model msrp;
   run;
ods pdf close;

/* ods rtf file='my_report.rtf'; */
ods rtf file='/folders/myfolders/my_report.rtf';
   proc print data=cars (obs=10) label;
      var make model msrp;
   run;
ods rtf close;

/*• Use the STYLE=option to specify a style template.*/
ods rtf file='/folders/myfolders/my_report_bp.rtf' style=Blockprint;
   proc print data=cars (obs=10) label;
      var make model msrp;
   run;
ods rtf close;
 



/*• Create files that can be viewed in Microsoft Excel.*/

ods excel file='/folders/myfolders/my_report.xlsx';
   proc print data=cars (obs=10) label;
      var make model msrp;
   run;
ods excel close;
 

/*Export data*/

/*• Create a simple raw data file by using the EXPORT procedure as an alternative to the DATA step.*/
proc export data=cars
            outfile='/folders/myfolders/cars.csv'
            dbms=csv replace;
   putnames=yes;
run;


/*• Export data to Microsoft Excel using the SAS/ACCESS XLSX engine.*/

libname xlsxout xlsx '/folders/myfolders/new_cars.xlsx';

data xlsxout.cars;
   set cars;
run;


