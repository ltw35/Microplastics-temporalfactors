# Microplastics-temporalfactors
Does time of day or flow condition affect measured riverine microplastic pollution?
View the related 2019 publication in [Environmental Science and Pollution Research](https://doi.org/10.1007/s11356-019-04663-8)<br>
*Watkins, L., Sullivan, P.J. & Walter, M.T. A case study investigating temporal factors that influence microplastic concentration in streams under different treatment regimes. Environ Sci Pollut Res 26, 21797–21807 (2019). DOI:* [10.1007/s11356-019-04663-8](https://doi.org/10.1007/s11356-019-04663-8)<br>
Please don't hesitate to contact me if you have trouble accessing the full-text of our publication.
      
## Contents of this repo (NEEDS UPDATING)
*****
1. `Dams_Microplastics_full.csv`: field data file (see below for metadata) <br>
2. `Dams_analysis_in_paper_clean.R`: code used to produce analysis and plots included in our paper published in *Science of the Total Environment* (2019). <br>
3. `Microplastics-dams.Rproj`: If running this locally, .RProj file will allow `.R` code to find `.csv` data file. Be sure to store `.Rproj` file in the same directory with `.R` and `.csv` to be able to run.
<br>
    
## Notes about this project
*****
* Goal for this project: to better understand how sample collection choices, specifically hourly (given daily fluctuations in wastewater treatment plant releases) and seasonal timing (given seasonal flowrate differences), may affect resulting measured concentration.
    
* Samples were collected in one stream downstream of a wastewater treatment plant and a second nearby without wastewater effluent inputs. Sampling occurred repeatedly over a 24 hour period, once in Fall and once in Spring.
<br>
    
## Metadata about this project & our methods
*****
        
#### Column headers of 24hr_combined.csv   (These have not yet been updated for this .csv)

1. `DamID` the code given to each individual dam in the study.    
+ `FR` = Flatrock, Fall Creek (42.4546706,-76.4562607)    
+ `BL` = Beebe Lake, Fall Creek (42.4519266,-76.4795704)     
+ `SD` = Sediment Dam, Six Mile Creek (42.4091457,-76.4537273)    
+ `3D` = 3rd Dam, Six Mile Creek (42.4137404,-76.5299637)     
+ `2D` = 2nd Dam, Six Mile Creek (42.4247749,-76.5444474)     
+ `1D` = 1st Dam, Six Mile Creek (42.4329239,-76.4848986)
     
2. `Weight` entered **in kg** for both surface water and sediment samples. Surface water weights are calculated based on an estimated density of 1kg/L. Where for water samples, `Weight` = Sample Volume.
     
3. `nFiber`-`nBead` The count of particles of each category found via visual inspection for a given sample.

#### Site selection & Sample collection <br>
* Surface water and sediment samples collected in Fall Creek & Six Mile Creek in Ithaca, NY USA during _____ by _____.
    
<br>
    
## Want to use this data?  
*****
    
*Attribution 4.0 International*<br>
We are pleased to allow this data to be used freely in the public, with proper attribution. Please cite this data or the resulting publication:   <br>     
*Watkins, L., Sullivan, P.J. & Walter, M.T. A case study investigating temporal factors that influence microplastic concentration in streams under different treatment regimes. Environ Sci Pollut Res 26, 21797–21807 (2019). DOI:* [10.1007/s11356-019-04663-8](https://doi.org/10.1007/s11356-019-04663-8)
