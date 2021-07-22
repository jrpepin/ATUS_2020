# ATUS_2020
This project analyzes the American Time Use Surveys (2003-2020). 

Download and extract data available at: https://www.bls.gov/tus/data.htm

The current ATUS-CPS 2003-2020 file is not downloading, so the repository currently uses the 2003-2019 Multi-Year files and merges them with the 2020 Single-Year ATUS Microdata Files.

ATUS 2003-2019 Respondent file  
ATUS 2003-2019 Roster file  
ATUS 2003-2019 Activity file  
ATUS-CPS 2003-2019 file  
  
  
ATUS 2020 Respondent file  
ATUS 2020 Roster file   
ATUS 2020 Activity file  
ATUS-CPS 2020 file  
  
  
__Users should change the file paths in the script ATUS2020_00_setup and packages.__

The data file structure is setup as follows:
   
ATUS
* ATUS0319
   * atusact_0319
   * atuscps_0319
   * atusresp_0319
   * atusrost_0319
* ATUS2020
   * atusact_2020
   * atuscps_2020
   * atusresp_2020
   * atusrost_2020
