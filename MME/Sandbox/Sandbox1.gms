*$ontext
set i / 2005*2007
        /,
        j(i);

j(i) = no;
j('2006') = yes;

alias(i,ii);
Parameter t1(i), t2(i), s(i, ii);

scalar temp;

t1(i) = sqr(ord(i)) + 4*ord(i) - 4;

$setglobal point "point"

Variables x,  z;
Variable y;

Equations eq1,eq2,eq3,eq4;

eq1.. z =e= 2*x + 3*y ;
eq2.. x =l= 5;
eq3.. y =l= temp;
eq4.. 3*x + 2*y =l= temp ;

Model M /all/;

M.savepoint = 2;


Parameter report(*,i);
File F;
Put F;
scalar sri /0/;
loop(i,
*$if not exist "asdasd."i.tl:0"gdx" put_utility "log" / "------------ *********** HAHAH *********** ------------ ";
*put_utility "shell" / "touch asdasd"i.tl:0".gdx" ;
put_utility "gdxin" / "asdasd"i.tl:0 ;
abort$(F.errors) "Errors in put:", F.errors;
execute_load$(j(i)) ; 
temp = t1(i) - 5;
Solve M max z use LP;
sri = sri+1;
Display x.L, y.L, z.L;
report('x',i) = x.L;
report('y',i) = y.L;
report('z',i) = z.L;
report('temp',i) = temp;
report('3x+2y',i) = 3*x.l + 2*y.l;
put_utility 'shell' / 'mv M_p'sri:0:0'.gdx temp/%point%_'sri:0:0'.gdx' ;
*put_utility 'shell' / 'mv M_p'i.ord:0:0'.gdx temp/M_'i.tl:0'.gdx' ;
	);

Display report;
put_utility "winMsg" / "My Message";
put_utility "log" / "-------------------- Log Message ---------------------";
execute_unload "my_gdx";
scalar pi_val2 /3.14159/;
put_utility "gdxout" / "my_gdx";
execute_unload;
$ontext

File gx2, gx1;
loop(i,
*		put_utility gx1 'gdxin' / 'yearData'i.tl;
*		execute_load t2 ;
		t2(ii) = ord(i);
		s(i,ii) = t1(i)*2 - t2(ii);
		temp = t1(i) - 5;
		put_utility gx2 'gdxout' / 'yearData'i.tl:0;
		execute_unload
		put_utility 'shell' / 'ren yearData'i.tl:0'.gdx ' 'year'i.ord:0:0'.gdx' ; 
		put_utility 'log' / 'ren yearData'i.tl:0'.gdx ' 'year'i.ord:0:0'.gdx' ;
*		execute_unload
	);
scalar random;


execute_unload "sarva_shaktaha"
*$offtext

put_utility 'shell' / 'mv sarva_shaktaha.gdx Sriram.gdx';

loop(i,
	random = uniformint(0,100);
	put_utility 'shell' / 'echo ' random:0:0 ;
	 );
$offtext