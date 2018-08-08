* Teff export is blocked by artificially setting high storage cost at External node. Resetting that to allow Teff Exports here.
CS_L('Teff', 'External', Season, Year) = 0.01;

* Changing the demand curve of Teff exteernally, to set that there is demand for teff externally.
* Demand SLope is Elasticity*Consumption/Price
DemSlope("Teff", "External", Season, Year) = 0.9*2500/750;
* Demand intercept is Price + Slop/Consumption
DemInt("Teff", "External", Season, Year) = 750 + DemSlope("Teff", "External", Season, Year)/2500;
