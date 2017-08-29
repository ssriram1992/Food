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