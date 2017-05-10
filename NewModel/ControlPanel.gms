$ontext
This file is in place to incorporate a set of controls with increased performance.

For example, if the model has to be run WITHOUT endogenous expansion,
then setting the cost of expansion to a very high value will achieve
the result but the model will take just as much time to run as it
would have taken without any endogenous expansion. But instead adjusting
the control for endogenous expansion here will result in reduced
number of equations, and hence increased performance (run speed).

$offtext

*"Crop Rotation"
Scalar CropRotation /0/;

*"Endogenous expansion of roads"
Scalar EndExpRoad /0/;

*"Crop Fallow"
Scalar Fallow /0/;

*"Cap for distributing individual food items"
Scalar FoodDistrCap /0/;
