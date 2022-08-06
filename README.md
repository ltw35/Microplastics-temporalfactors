# Microplastics-temporalfactors
Does time of day or flow condition affect measured riverine microplastic pollution? And is the relationship, particularly with time of day, affected by the presence of an upstream wastewater treatment plant with diurnal release patterns? <br>

With this study, we investigate these using field data collected in two tributaries located near Ithaca, New York, USA.<br><br>
View the related 2019 publication in [Environmental Science and Pollution Research:](https://doi.org/10.1007/s11356-019-04663-8) 
*Watkins, L., Sullivan, P.J. & Walter, M.T. A case study investigating temporal factors that influence microplastic concentration in streams under different treatment regimes. Environ Sci Pollut Res 26, 21797–21807 (2019). DOI:* [10.1007/s11356-019-04663-8](https://doi.org/10.1007/s11356-019-04663-8).
Please don't hesitate to contact me if you have trouble accessing the full-text of our publication.
      
## Contents of this repo
*****
1. `24hr_combined.csv`: field data file (see below for metadata) <br>
2. `24hr_analysis.R`: code used to produce analysis and plots included in our paper published in *Environmental Science and Pollution Research* (2019). <br>
3. `Microplastics-temporalfactors.Rproj`: If running this locally, .RProj file will allow `.R` code to find `.csv` data file. Be sure to store `.Rproj` file in the same local directory with `.R` and `.csv` to be able to run.
<br>
    
## Notes about this project
*****
* Goal for this project: to better understand how sample collection choices, specifically hourly (given daily fluctuations in wastewater treatment plant releases) and seasonal timing (given seasonal flowrate differences), may affect resulting measured concentration.
    
* Samples were collected in one stream downstream of a wastewater treatment plant and a second nearby without wastewater effluent inputs. Sampling occurred repeatedly over a 24 hour period, once in Fall and once in Spring.
<br>
    
## Metadata about this project & our methods
*****
        
#### Column headers of 24hr_combined.csv   (These have not yet been updated for this .csv)

1. `Site` the sampling location revisited for each sample in this study (marked with rebar installed into the streambed)    
+ `SM` = Six Mile Creek at German Cross Road (42.40280556,-75.56394444)    
+ `FC` = Fall Creek on 366 in Etna (42.48955556,-75.62211111)     

     
2. `timepoint` denotes the field campaign during which sample was collected.
+ `t1` = Fall sample collected during August 24-25, 2016 field campaign
+ `t2` = Spring sample collected during April 26-27, 2017 field campaign
     
3. `timeish` is a string representation of sampling time, with numeric time of day of sampling in 24-hr time and letter denoting day of sampling (a for date 1, b for date 2). e.g. 8a was collected near 8:00am on the first day of sampling, either August 24 or April 26, depending on entry in `timepoint` column. Meanwhile *8b* was collected near 8:00am but on the second day of sampling, so either August 25 or April 27.

4. `SampleID` is `Site`.`timepoint`.`sample number`, where `sample number` labels each sample in field campaign subsequentially, with first sample of the field campaign (or `timepoint`) receiving `sample number` = 1.

5. `fiber.line` is count of particles of particle-type "fiber" or "line" in the sample. (Lab count data)

6. `film` is count of particles of particle-type "film" in the sample. (Lab count data)

7. `fragment` is count of particles of particle-type "fragment" in the sample. (Lab count data)

8. `foam` is count of particles of particle-type "foam" in the sample. (Lab count data)

9. `bead.pellet` is count of particles of particle-type "bead" or "pellet" in the sample. (Lab count data)

10. `Red_fiber` is a subcount of `fiber.line` including only "fibers" or "lines" colored red. (Lab count data)

11. `blue_fiber` is a subcount of `fiber.line` including only "fibers" or "lines" colored blue. (Lab count data)

12. `black_fiber` is a subcount of `fiber.line` including only "fibers" or "lines" colored black. (Lab count data)

13. `Time` is date and time of sampling collection. (Field data).

14. `StartTime` is repetition of `Time` including only the time. (Field data).

15. `StartVelocity_ft.s` is the stream velocity measured in the mouth of the sampling net at the start of the 10min sample collection, reported in feet per second. (Field data).

16. `WaterHeighta_in` is the height of water entering the mouth of the net on side "a" (designated at random), reported in inches. (Field data).

17. `EndVelocity_ft.s` is the stream velocity measured in the mouth of the sampling net at the end of the 10min sample collection, reported in feet per second. (Field data).

18. `SampleTime_min` is the total time net was deployed to capture the sample, measured in minutes. (Field data).

19. `SampleTime_s` is `SampleTime_min` converted into seconds.

20. `USGSStreamDischarge_ft3.s` is the river discharge at the day and time of sampling, as reported by USGS from the nearest streamgage in cubic feet per second. Six Mile Creek gage data from USGS gage 04233300. Fall Creek gage data from USGS gage 04234000.

21. `census` is upstream watershed population, calculated from US census 2010 block-level data clipped to watershed areas calculated by Lisa Watkins with Esri ArcMap. Numbers in units of "people".

22. `note` is a comment from Lisa Watkins about the sample processing. This column is unstandardized.

23. `date_counted` is the date when the fully-processed sample, previously transfered onto a filter paper protected in a small petri dish for safe storage and controlled counting, was counted in the laboratory under a dissecting microscope. 

24. `collector` is the name of the volunteer who assisted Lisa Watkins with sample collection in the field.


#### Site selection & Sample collection <br>
* Surface water samples collected in Fall Creek & Six Mile Creek in Ithaca, NY USA over two 24 hour periods. Each site was marked by rebar driven into the streambed such that the exact location was resampled on subsequent visits, at each site every 3 hours. Samples were collected over one 24 hour period in August and again over a second in April.

* Samples were collected by partially-submerged Sea-Gear neuston net with 335 μm mesh with a 1×0.5-m rectangular opening, such that even surface particles could be captured in the sample.

* NOAA wet peroxide oxidation + density separation methods for surface water microplastics samples were followed for processing, followed by filtration of the remaining floating sample onto a paper gridded 0.45-μm filters. All particles suspected to be microplastics were tested using hot needle and physical prodding. The full contents of the filter paper were quantified. 11 particles were randomly selected for confirmation by Raman: resulting sensitivity of 100% and precision of 88%.

* Three air blanks, consisting of filter paper left out uncovered in the shared teaching laboratory space for 24hr, were found to contain an average of 6.7 particles. This number was subtracted from calculated concentrations used in further analysis. An additional set of "maximum contamination" blanks were run through all procedural equipment after they were used (and abused) during teaching demonstrations and camps. An average of 60.66666 particles were found in these extreme case procedural blanks. This value is explored in our code & analysis, but not incorporated into the concentrations used for all analysis and conclusions.
    
<br>
    
## Want to use this data?  
*****
    
*Attribution 4.0 International*<br>
We are pleased to allow this data to be used freely in the public, with proper attribution. Please cite this data or the resulting publication:   <br>     
*Watkins, L., Sullivan, P.J. & Walter, M.T. A case study investigating temporal factors that influence microplastic concentration in streams under different treatment regimes. Environ Sci Pollut Res 26, 21797–21807 (2019). DOI:* [10.1007/s11356-019-04663-8](https://doi.org/10.1007/s11356-019-04663-8)
