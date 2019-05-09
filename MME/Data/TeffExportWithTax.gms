* Teff export is blocked by artificially setting high storage cost at External node. Resetting that to allow Teff Exports here.
* This implies a 25 percent duty for teff, roughly.
CS_L('Teff', 'External', Season, Year) = 725*0.25;

* Changing the demand curve of Teff exteernally, to set that there is demand for teff externally.
* Demand SLope is Elasticity*Consumption/Price
DemSlope("Teff", "External", Season, Year) = 0.9*2500/725;
* Demand intercept is Price + Slop/Consumption
DemInt("Teff", "External", Season, Year) = 725 + DemSlope("Teff", "External", Season, Year)/2500;
