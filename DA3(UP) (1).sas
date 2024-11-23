/* Generated Code (IMPORT) */
/* Source File: rm_data.csv */
/* Source Path: /home/u63826292/825 */
/* Code generated on: 11/20/24, 9:57 PM */

%web_drop_table(WORK.IMPORT1);


FILENAME REFFILE '/home/u63826292/825/rm_data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=data;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=data; RUN;

%web_open_table(WORK.IMPORT1);


/*Mixed Model*/
data data;
    set data;
    if not missing('Final.Calf.BW'n) then Final_Calf_BW = input('Final.Calf.BW'n, best12.);
run;

proc mixed data=data method=reml plots=residualpanel;
    class 'Calan.Treatment'n SEX 'Pen..'n Sire;
    model Final_Calf_BW = 'Calan.Treatment'n|SEX ;
    random intercept / subject='Pen..'n;
    random intercept / subject=Sire;
    lsmeans 'Calan.Treatment'n*SEX / adjust=tukey pdiff;
run;

/*ANCOVA*/
proc glm data=data ;
    class 'Calan.Treatment'n SEX;
    model Final_Calf_BW = 'Calan.Treatment'n|SEX 'Initial BW'n ;
    means 'Calan.Treatment'n / tukey cldiff;
    lsmeans 'Calan.Treatment'n*SEX / adjust=tukey pdiff cl;
    output out=diagnostics r=residuals p=predicted;
run;

/* Diagnostic plots */
proc sgplot data=diagnostics;
    scatter x=predicted y=residuals / markerattrs=(symbol=circlefilled);
    refline 0 / axis=y lineattrs=(color=red);
run;

proc univariate data=diagnostics normal;
    var residuals;
    histogram residuals / normal;
    qqplot residuals / normal(mu=est sigma=est);
run;

/* OLR-Calf Vigor*/
proc logistic data=data order=internal plots=all;
    class 'Calan.Treatment'n SEX / param=ref;
    model 'Calf.Vigor'n = 'Calan.Treatment'n SEX 'Calan.Treatment'n*SEX;
    lsmeans 'Calan.Treatment'n*SEX / pdiff adjust=tukey;
run;

/*Binomial Calf Vigor*/
data data;
    set data;
    /* Recode Calf.Vigor: 1 = Low, 2 and 3 = High */
    if 'Calf.Vigor'n = 1 then Binary_Vigor = "Low";
    else if 'Calf.Vigor'n in (2, 3) then Binary_Vigor = "High";
run;

proc freq data=data;
    tables Binary_Vigor;
run;
data data;
    set data;
    Binary_Vigor = strip(Binary_Vigor);
run;
data data;
    set data;
    Binary_Vigor = propcase(Binary_Vigor); /* Ensure consistent capitalization */
run;

proc logistic data=data descending;
    class 'Calan.Treatment'n SEX / param=ref;
    model Binary_Vigor = 'Calan.Treatment'n SEX;
    oddsratio 'Calan.Treatment'n;
    oddsratio SEX;
run;

/* Binomial Calving_Ease Model */
data data;
    set data;
    if 'Calving.Ease'n in (2, 3) then Binary_Ease = "High";
    else if 'Calving.Ease'n = 1 then Binary_Ease = "Low";
run;

proc freq data=data;
    tables Binary_Ease;
run;

/* Logistic regression model */
proc logistic data=data;
    class 'Calan.Treatment'n SEX / param=ref;
    model Binary_Ease(event='High') = 'Calan.Treatment'n SEX;
    oddsratio 'Calan.Treatment'n;
    oddsratio SEX;
run;


