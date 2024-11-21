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

