* Electricity hit due to Irrigation

* Hydel capacity goes down, more electricity from other sources in Afar.
Cap_Elec(Node, Season, Year) = MAX(Cap_Elec(Node, Season, Year)-0.2,0);
Cap_Elec('Afar', Season, Year) = 40;

* Marginal increase in crop productivity
CYF(FoodItem, Node, Season, Year) = CYF(FoodItem, Node, Season, Year)*1.1;

* Marginal increase in farming cost
C_prod(FoodItem, Node, Season, Year) = C_prod(FoodItem, Node, Season, Year)*1.1;

***** Crop Failure
*** SNNPR
* All crops production reduce a bit
aFAO(FoodItem, 'SNNPR', Season, '2020') = aFAO(FoodItem, 'SNNPR', Season, '2020')*0.75;
* Teff takes a big hit
aFAO('Teff', 'SNNPR', Season, '2020') = aFAO('Teff', 'SNNPR', Season, '2020')*0.66;
* Maize is not affected much
aFAO('Maize', 'SNNPR', Season, '2020') = aFAO('Maize', 'SNNPR', Season, '2020')/0.8;

*** Oromia
* All crops production reduce a bit
aFAO(FoodItem, 'Oromia', Season, '2020') = aFAO(FoodItem, 'Oromia', Season, '2020')*0.75;
* Teff takes a big hit
aFAO('Teff', 'Oromia', Season, '2020') = aFAO('Teff', 'Oromia', Season, '2020')*0.66;
* Maize is not affected much
aFAO('Maize', 'Oromia', Season, '2020') = aFAO('Maize', 'Oromia', Season, '2020')/0.8;

***** Irrigation Effect
*** SNNPR
* All crops production reduce a bit
CYF(FoodItem, 'SNNPR', Season, '2020') = CYF(FoodItem, 'SNNPR', Season, '2020')/0.8;
* Teff takes a big hit
CYF('Teff', 'SNNPR', Season, '2020') = CYF('Teff', 'SNNPR', Season, '2020')/0.7;
* Maize is not affected much
CYF('Maize', 'SNNPR', Season, '2020') = CYF('Maize', 'SNNPR', Season, '2020')*0.8;
C_prod(FoodItem, 'SNNPR', Season, Year) = C_prod(FoodItem, 'SNNPR', Season, Year)*1.1;

*** Oromia
* All crops production reduce a bit
CYF(FoodItem, 'Oromia', Season, '2020') = CYF(FoodItem, 'Oromia', Season, '2020')/0.8;
* Teff takes a big hit
CYF('Teff', 'Oromia', Season, '2020') = CYF('Teff', 'Oromia', Season, '2020')/0.7;
* Maize is not affected much
CYF('Maize', 'Oromia', Season, '2020') = CYF('Maize', 'Oromia', Season, '2020')*0.8;
C_prod(FoodItem, 'Oromia', Season, Year) = C_prod(FoodItem, 'Oromia', Season, Year)*1.1;