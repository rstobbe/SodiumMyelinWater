# SodiumMyelinWater

This App was used to model sodium MRI signal in multiple sclerosis (Stobbe et al, Frontiers in Neurology, 2021).  
White matter volume calculations come from (Laule et al, Journal of Neurology, 2004). 

## Figure 7 in (Stobbe et al, Frontiers in Neurology, 2021)  

### (7A) Healthy Control White Matter
* MWF = 0.114 (Laule, 2004)
* Extracellular Volume Fraction = 0.2 (Sykova, 2008) 

### (7B) NAWM - Demyelination
* MWF = 0.0938 (Laule, 2004)
* Water Increase = 2.2% (Laule, 2004)

Entering a water increase >2.2% (for MWF = 0.0938) necessitates the inclusion of edema to fit both MWF and water increase.  
Entering a water increase <2.2% (for MWF = 0.0938) is not possible within the context of the model. Water increase will default to the smallest value possible.

### (7C) Lesion - Demyelination and Edema
* MWF = 0.046 - Estimation derived from (Laule, 2004)
* Water Increase = 8.624% - Estimation derived from (Laule, 2004) 
 
Note that while the use of 3 decimal places describes the water increase of the paper, all parameter values are estimates. Rounded values are given in the paper. Also note that Figure 3C2 does not include the 0.8% of volume occupied by edema macromolecules. The relative water content in edema / plasma of 0.92 comes from (Brust et al, Physical Review Letters, 2013)   

## Relaxation Weighting
Relative 23NaMRI weightings for the sequences used in (Stobbe et al, Frontiers in Neurology, 2021) are given in the text. 
Values of '1' for the 23NaMRI weightings are used to model sodium contributions to tissue in mmol/L-tissue
