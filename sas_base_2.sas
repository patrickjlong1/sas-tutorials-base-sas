/*Section 2 - Manage Data */

/*1.Sort observations in a SAS data set.*/
/*- Use the SORT Procedure to re-order observations in place or output to a new dataset with the OUT= option.*/
proc sort data=sashelp.cars
          out=cars_by_price;
   by msrp;
run;

proc sort data=sashelp.cars
          out=cars_by_price_high;
   by descending msrp;
run;

/*- Remove duplicate observations with the SORT Procedure.*/
data duplicate;
   set cars_by_price cars_by_price;
run;    

proc sort data=duplicate nodup
          out=deduped;
   by make model msrp;
run; 


/*2. Conditionally execute SAS statements.*/
/*? Use IF-THEN/ELSE statements to process data conditionally.*/

data cars_if_then;
   set cars_by_price_high;
   
   if origin in ('Asia', 'Europe' ) then do;
      import = 'YES';
   end;
   else do;
      import = 'NO';
   end;
   
run;


/* Use DO and END statements to execute multiple statements conditionally. */

data baseball_do_loop (drop = i);
   set sashelp.baseball (keep = team);
   
   do i = 1 to 5;
      length = length(team) * i;
      output;
   end;
   
run;


/*3. Use assignment statements in the DATA step.*/
/*? Create new variables and assign a value.*/

data versicolor;
   set sashelp.iris (where=(species='Versicolor'));
   
   petalArea = petalLength * petalWidth;
   
run;




/*? Assign a new value to an existing variable.*/

data versicolor;
   set versicolor;
   
   petalArea = petalArea / 10;
   
run;


/*? Assign the value of an expression to a variable.*/

data versicolor;
   set versicolor;
   
   size = 'large';
   if petalArea < 48 then size = 'small';
   
run;

/*? Assign a constant date value to a variable. */

data versicolor;
   set versicolor;
   
   format dateUpdated MONYY5.;
   dateUpdated = today();
   
run;


/*4. Modify variable attributes using options and statements in the DATA step.*/

/*- Change the names of variables by using the RENAME= data set option.*/
data versicolor;
   set versicolor (rename = size=leafsize);
run;

/*- Use LABEL and FORMAT statements to modify attributes in a DATA step.*/
data baseball;
   set sashelp.baseball (keep = name nrbi nhome salary);
   
   label salary = 'Salary in Thousands of US Dollars';
   
   format salary dollar10.2;
   
run;


/*- Define the length of a variable using the LENGTH statement.*/

data baseball;
   set baseball;
   
   length shortname $4.;
   
   shortname = name;
   
run;    


/*5. Accumulate sub-totals and totals using DATA step statements.*/
/*- Use the BY statement to aggregate by subgroups.*/
/*- Use first. and last. processing to identify where groups begin and end.*/   
/*- Use the RETAIN and SUM statements.*/
proc sort data=sashelp.cars out=cars_inventory;
   by make model;
run;

data cars_inventory;
   set cars_inventory (keep=make model msrp invoice);
   
   by make model;
   
   if first.make then model_id =0;
   
   model_id + 1; /* example of the sum statement */
  
   retain model_id; /*retain statement*/
  
run;  
   
proc sort data=sashelp.cars out=cars_inventory2;
   by make msrp;
run;

data cars_inventory2; /*last. processing example*/
   set cars_inventory2 (keep=make model msrp invoice);
   
   by make msrp;
  
   most_expensive='NO';
   
   if last.make then most_expensive='YES';
  
   retain most_expensive; /*retain statement*/
  
run;  












/*6.Use SAS functions to manipulate character data, numeric data, and SAS date values.*/
/*- Use SAS functions such as SCAN, SUBSTR, TRIM, UPCASE, and LOWCASE to perform*/
/*tasks such as the tasks shown below.*/
/*o Replace the contents of a character value.*/
/*o Trim trailing blanks from a character value.*/
/*o Search a character value and extract a portion of the value.*/
/*o Convert a character value to upper or lowercase.*/

data baseball;
   set sashelp.baseball (keep= name team yrmajor);
   
      first_name = scan(name, -1, ' ');
      last_name = scan(name, 1, ',');
      
run;

data baseball;
   set baseball;
   
   team_code = substr(team, 1, 3);
   team_upper = upcase(team);
   team_lower = lowcase(team);
   
run;

data baseball;
   set baseball;
   
   team_trailing_blanks = cat(team, '           ');
   team_no_whitespace = trim(team_trailing_blanks);
   
run;

data baseball;
   set baseball;
   
   yrmajor_char = put(yrmajor, $3.);
   
run;

/*- Use SAS numeric functions such as SUM, MEAN, RAND, SMALLEST, LARGEST, ROUND,*/
/*and INT.*/
data applianc;
   set sashelp.applianc;
   
   applianc_sum = sum(of units_1-units_24);
   applianc_mean = mean(of units_1-units_24);
   
   applianc_sum_dec = applianc_sum*0.99999;
   applianc_sum_round = round(applianc_sum_dec);
   
run;

data applianc;
   set sashelp.applianc;
   
   largest_1 = largest(1, of units_1-units_24);
   largest_5 = largest(5, of units_1-units_24);
   
   rand1 = rand('normal');
   
   smallest_1 = smallest(1, of units_1-units_24);
   smallest_5 = smallest(5, of units_1-units_24);
run;


/*- Create SAS date values by using the functions MDY, TODAY, DATE, and TIME.*/
/*- Extract the month, year, and interval from a SAS date value by using the functions*/
/*YEAR, QTR, MONTH, and DAY.*/

data retail;
   set sashelp.retail (drop=date);
   
   date = mdy(month,day, year);
   
run;

data retail;
   set retail (drop = day month year);
   
   month = month(date);
   day = day(date);
   year = year(date);

run;
/*? Perform calculations with date and datetime values and time intervals by using the*/
/*functions INTCK, INTNX, DATDIF and YRDIF. */

data retail;
   set retail;
   
   days_before = intck('day', today(), date);
   years_before = intck('year', today(), date);
   
   years_later_40 = intnx('year', date, 40);
   
   date_difference = datdif(date, today(), 'act/act');
   year_difference = yrdif(date, today(), 'act/act');
run;

/*7. Use SAS functions to convert character data to numeric and vice versa.*/
/*- Explain the automatic conversion that SAS uses to convert values between data types.*/
data mycars;
   input make $ model $ mpg_highway $;
   datalines;
Acurra MDX 25
Buick Regal 20
GMC Yukon 14
;
run;

proc contents data=mycars; 
run;

data mycars_1;
   set mycars;
   
   mpg_highway_num = mpg_highway * 1;
   
run;

proc contents data=mycars_1; 
run;


/*- Use the INPUT function to explicitly convert character data values to numeric values.*/
data mycars_2;
   set mycars;
   
   mpg_highway_num = input(mpg_highway, 6.);
   
run;

proc contents data=mycars_2; 
run;

/*- Use the PUT function to explicitly convert numeric data values to character values.*/

data mycars_3;
   set mycars_2;
   
   mpg_highway_str = put(mpg_highway_num, $6.);
   
run;

proc contents data=mycars_3; 
run;


/*Process data using DO LOOPS.*/
/*- Explain how iterative DO loops function.*/
data ice_cream_sales;
   sales = 0;
   
   do sales = 1 to 100 by 2;
      total = sales * 1.5;
      output;
   end;
   
run;


/*- Use DO loops to eliminate redundant code and to perform repetitive calculations.*/
/*- Use conditional DO loops.*/

data ice_cream_sale_while;
   inventory = 350;
   total = 0;
   do while(inventory > 0);
       inventory = inventory - 1;
       total = total + 0.75;
       output;
   end;
run;
/*- Use nested DO loops.*/

data ice_cream_id;

   do i = 1 to 7;
   
      ice_cream_id = i;
      do j = 1 to 5;
      
         topping_id = j;
         output;
      end;
   end;
   drop i j;
   
run;

/*8. Restructure SAS data sets with PROC TRANSPOSE.*/
/*- Select variables to transpose with the VAR statement.*/

proc transpose data=sashelp.shoes;

   var inventory;
   
run;
  
/*- Rename transposed variables with the ID statement.*/
/*- Process data within groups using the BY statement.*/
proc sort data=sashelp.shoes out=shoes;
   by subsidiary;
run;

proc transpose data=shoes;

   var inventory;
   by subsidiary;
   id product;
   
run;



/*- Use PROC TRANSPOSE options (OUT=, PREFIX= and NAME=).*/

proc transpose data=shoes out=shoesT prefix=group name=category;
   
run;


/*9. Use macro variables to simplify program maintenance.*/
/*- Create macro variables with the %LET statement*/


%let name = pat;
%put name = &name.;
%let date = %sysfunc(today());
%put date = &date.;

/*- Use macro variables within SAS programs. */
%let audit_id = 17;
%put audit_id = &audit_id.;

data shoest_modified;
   set shoesT;
   
   format modified_date ddmmyy10.;
   
   modified_date = 22000;
   modified_by = .;
   
   if category eq "Returns" then do;
      group1 = group1 + 10000;
      modified_date = &date.;
      modified_by = &audit_id.;
   end;
   
run;

