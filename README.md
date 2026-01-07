
# 📊 AWaRe Quality Indicators – Inpatient Dashboard 

#### Overview 

This repository hosts the AWaRe Quality Indicators (QI) Inpatient Dashboard, including: 

- The R Shiny dashboard source code and prototypes 

- R Markdown source code and prototypes 

- Supporting documentation (User Manual, Interpretation Guides, Data Conversion Guide) 

- Relevant publications and resources 

The dashboard uses existing antimicrobial use (AMU) surveillance data, specifically Global Point Prevalence Survey (Global-PPS) data, to automatically generate AWaRe-based prescribing quality indicators. It supports antimicrobial stewardship (AMS) decision-making at hospital, national, and global levels. 

Although the dashboard is built on the Global-PPS data structure, a Data Standardisation (Conversion) Guide is provided to enable facilities using other surveillance systems (e.g. WHO PPS) to adapt their data and benefit from the dashboard outputs. 

##### Repository Structure  
``` text
AWaRe_QI_Inpatient/
├──Markdown  
├── R/
│   └── modules/
├── www/
│   └── css/
│   └── js/     
│   └── img/ 
└── data/
├──example/  
├──app.R  
├──LICENSE  
├──README
```
## Deployment


## How to Navigate the Application

The **Landing Page** shows the main entry view of the application.  
<img src="/examples/01_Dashboard_Landing_Page.png" alt="Landing Page" width="800" height="400">

The **Dashboard Overview** provides a summary of all the key metrics and sections of the dashboard.  
<img src="/examples/02_Dashboard_Overview_Page.png" alt="Dashboard Overview" width="800" height="400">

The **Patient Distribution** section displays how patients are distributed across different categories.  
<img src="/examples/03_Patient_Distibution.png" alt="Patient Distribution" width="800" height="400">

The **Antibiotic Use by AWaRe** chart visualizes antibiotic usage categorized according to AWaRe classification.  
<img src="/examples/04_Antibiotic_Use_by_AWaRe.png" alt="Antibiotic Use by AWaRe" width="800" height="400">

The **Antibiotic Use by Condition and AWaRe** section shows antibiotic usage patterns based on specific conditions and AWaRe classification.  
<img src="/examples/05_Antibiotic_Use_by_Condtion_and_AWaRe.png" alt="Antibiotic Use by Condition and AWaRe" width="800" height="400">

The **Antibiotic Use by Condition and AWaRe per Ward** chart breaks down antibiotic usage for each ward.  
<img src="/examples/06_Antibiotic_Use_by_Condition_and_AWaRe_per_Ward.png" alt="Antibiotic Use by Condition and AWaRe per Ward" width="800" height="400">

The **Treatment & Indication Patterns Across Age** section displays how treatment and indication patterns vary across different age groups.  
<img src="/examples/07_Treatment_&_Indication_Patterns_Across_Age.png" alt="Treatment & Indication Patterns Across Age" width="800" height="400">

The **Age-Specific Prophylaxis Patterns** chart shows prophylaxis patterns for different age groups.  
<img src="/examples/08_Age_Specific_Prophylaxis_Patterns.png" alt="Age-Specific Prophylaxis Patterns" width="800" height="400">

The **Clinical Conditions** section provides an overview of the clinical conditions in the dataset.  
<img src="/examples/09_Clinical_Conditions.png" alt="Clinical Conditions" width="800" height="400">

The **Condition-Specific Overview** gives a detailed look at metrics for each specific condition.  
<img src="/examples/10_Condition_Specific_Overview.png" alt="Condition-Specific Overview" width="800" height="400">

The **Condition-Specific AWaRe Choice Alignment Outputs** shows how antibiotic choices align with AWaRe classification for each condition.  
<img src="/examples/11_Condition_Specific_AWaRe_Choice_Alignmnet_Outputs.png" alt="Condition-Specific AWaRe Choice Alignment Outputs" width="800" height="400">

The **Condition-Specific AWaRe Dosage Alignment Outputs** presents how antibiotic dosages align with AWaRe classification for each condition.  
<img src="/examples/12_Condition_Specific_AWaRe_Dosage_Alignmnet_Outputs.png" alt="Condition-Specific AWaRe Dosage Alignment Outputs" width="800" height="400">

The **Download Annotated Source Dataset for QI Eligible Cases** section allows downloading the annotated dataset used for quality improvement analyses.  
<img src="/examples/13_Download_Annotated_Source_Dataset_for_QI_Eligible_Cases.png" alt="Download Annotated Source Dataset" width="800" height="400">



