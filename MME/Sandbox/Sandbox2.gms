Parameters
a /0/
b /0.000000001/
tol /1e-9/
;


if (a<=tol,
	Display "a is 0");

if (b<=tol,
	Display "b is 0";
else
	Display "b is ", b;
	);