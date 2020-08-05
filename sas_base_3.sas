/* Section 3 - Error Handling */

/* Identify and resolve programming logic errors. */
/* • Use the PUTLOG Statement in the Data Step to help identify logic errors. */

%let student_name = Pat;
%let height = 70;
%let weight = 120;
%let age = 15;
%let sex = M;

data new_student;
   set sashelp.class (obs=1);
   
   name = symget('student_name');
   weight = &weight;
   age = &age.;
   sex = symget('sex');
   
   if &height. not in (12:100) then do;
      height = .;
      putlog "NOTE: The height is not a valid number. It has been set to missing.";
   end;
   
   else do;
      height = &height.;
      putlog "NOTE: The height is a valid number. It has been set to &height..";
   end;
   
run;  
   



/* • Use PUTLOG to write the value of a variable, formatted values, or to write values of all */
/* variables. */

data class_updated;
   set sashelp.class new_student;
   
   putlog "NOTE: Their name is " name ;
   putlog "NOTE: Their Age is " age ;
   
run;

/* • Use PUTLOG with Conditional logic. */

data class_updated;
   set class_updated;
  
   if age ge 15 then do;
   
      putlog "NOTE: Their name is " name ;
      putlog "NOTE: Their Age is " age ;
   
   end;
   
run;


/* • Use temporary variables N and ERROR to debug a DATA step. */

data class_updated;
   set class_updated (obs=5);
   
      putlog _N_ ;
      putlog name;
      putlog _ERROR_ ;
   
   
run;


/* Recognize and correct syntax errors. */


/* • Identify the characteristics of SAS statements. */
/*  */
/* NO CODE: */
/* "A SAS statement is a string of SAS keywords, SAS names, special characters, and */
/* operators that instructs SAS to perform an operation or that gives information to */
/* SAS. Each SAS statement ends with a semicolon." */
/* Source: https://documentation.sas.com/api/docsets/lestmtsref/9.4/content/lestmtsref.pdf?locale=en */

/* • Define SAS syntax rules including the typical types of syntax errors such as misspelled */
/* keywords, unmatched quotation marks, missing semicolons, and invalid options. */

dota mycars;
   set sashelp.cars;
run;

/* not valid option */
data mycars;
   set sashelp.cars(notvalidoption=this);
run;

/* missing semicolon */
data mycars;
   set sashelp.cars;
run;

/* • Use the log to help diagnose syntax errors in a given program.  */
/* no code */
