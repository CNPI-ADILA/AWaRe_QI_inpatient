# Load required libraries
library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(dplyr)
library(tidyverse)
library(readxl)
library(glue)
library(purrr)
library(tidyr)
library(scales)
library(htmltools)
library(ggtext)
library(forcats)
library(kableExtra)
library(shinythemes)
library(shinyjs)
library(readr)
library(writexl)
library(openxlsx)

# Source all modules
source("R/modules/general_summary_module.R")
source("R/modules/sepsis_module.R")
source("R/modules/meningitis_module.R")
source("R/modules/pneumonia_module.R")
source("R/modules/iais_module.R")
source("R/modules/uti_module.R")
source("R/modules/ssti_module.R")
source("R/modules/bji_module.R")
source("R/modules/sp_module.R")


# Define UI
ui <- dashboardPage(
  dashboardHeader(
    title = div(
      style = "display: flex; align-items: center; padding: 5px 15px; height: 100px;",
    tags$a(href = "https://antibioticpolicy.org/", target = "_blank", style = "display: flex; align-items: center;",
           img(src = "img/APG_logo_primary.jpg", 
               height = "60px", 
               style = "margin-right: 15px;",
               class = "header-logo")
    ),
      span("AWaRe Antibiotic Use Quality Indicators Tool", 
           style = "font-size: 18px; font-weight: bold; color: white; white-space: nowrap; overflow: visible; line-height: 1.2;",
           class = "header-title")
    ),
    titleWidth = 700
  ),
  
  dashboardSidebar(
    width = 280,
    useShinyjs(),
    tags$div(
      id = "sidebar-close-btn",
      class = "sidebar-close-btn",
      onclick = "toggleSidebar()",
      icon("times")
    ),
    sidebarMenu(
      id = "sidebar",
      menuItem("Data Upload", tabName = "upload", icon = icon("upload"), selected = TRUE),
      menuItem("Overview", tabName = "overview", icon = icon("info-circle")),
      menuItem("General Summary", tabName = "general_summary", icon = icon("chart-line"),
               menuSubItem("Summary of patient distribution", tabName = "department"),
               menuSubItem("Overall antibiotic use and conditions", tabName = "diagnosis_antibiotic"),
               menuSubItem("Antibiotic use by AWaRe", tabName = "patient_summary"),
               menuSubItem("Antibiotic use by condition", tabName = "diagnostic"),
               menuSubItem("Antibiotic use by ward", tabName = "dept_heatmap"),
               menuSubItem("Indication-treatment patten by age", tabName = "age_patterns"),
               menuSubItem("Prophylaxis indications by age", tabName = "prophylaxis")
      ),
      
      menuItem("Clinical Conditions", tabName = "eligibility", icon = icon("check-circle")),
      # Dynamically shown/hidden menu items
      conditionalPanel(
        condition = "output.showSepsisMenu",
        menuItem("Sepsis Analysis", tabName = "sepsis", icon = icon("bacteria"),
                 menuSubItem("Overview", tabName = "sepsis_overview"),
                 menuSubItem("Choice Alignment", tabName = "sepsis_qi1"),
                 menuSubItem("Dosage Alignment", tabName = "sepsis_qi2")
        )
      ),
      conditionalPanel(
        condition = "output.showMeningitisMenu",
        menuItem("Meningitis", tabName = "meningitis", icon = icon("brain"),
                 menuSubItem("Overview", tabName = "meningitis_overview"),
                 menuSubItem("Choice Alignment", tabName = "meningitis_qi1"),
                 menuSubItem("Dosage Alignment", tabName = "meningitis_qi2")
        )
      ),
      conditionalPanel(
        condition = "output.showPneumoniaMenu",
        menuItem("Pneumonia", tabName = "pneumonia", icon = icon("lungs"),
                 menuSubItem("Overview", tabName = "pn_overview"),
                 menuSubItem("Antibiotic Use by AWaRe Category", tabName = "pn_watch_analysis"),
                 menuSubItem("Choice Alignment", tabName = "pn_choice_analysis"),
                 menuSubItem("Dosage Alignment", tabName = "pn_dosage_analysis")
                 
        )
      ),
      conditionalPanel(
        condition = "output.showIaisMenu",
        menuItem("Intra-abdominal Infections", tabName = "intra_abdominal", icon = icon("stomach"),
                 menuSubItem("Overview", tabName = "intra_abdominal_overview"),
                 menuSubItem("Antibiotic Use by Route", tabName = "intra_abdominal_iv"),
                 menuSubItem("Antibiotic Use by AWaRe Category", tabName = "intra_abdominal_watch"),
                 menuSubItem("Choice Alignment", tabName = "intra_abdominal_choice"),
                 menuSubItem("Dosage Alignment", tabName = "intra_abdominal_dosage")
                 
        )
      ),
      conditionalPanel(
        condition = "output.showUtiMenu",
        menuItem("Upper UTI", tabName = "uti", icon = icon("kidneys"),
                 menuSubItem("Overview", tabName = "uti_overview"),
                 menuSubItem("Antibiotic Use by Route", tabName = "uti_iv_analysis"),
                 menuSubItem("Antibiotic Use by AWaRe Category", tabName = "uti_watch_analysis"),
                 menuSubItem("Choice Alignment", tabName = "uti_choice_analysis"),
                 menuSubItem("Dosage Alignment", tabName = "uti_dosage_analysis")
                 
        )
      ),
      conditionalPanel(
        condition = "output.showSstiMenu",
        menuItem("SSTI", tabName = "ssti", icon = icon("hand-holding-medical"),
                 menuSubItem("Overview", tabName = "ssti_overview"),
                 menuSubItem("Choice Alignment", tabName = "ssti_choice_analysis"),
                 menuSubItem("Dosage Alignment", tabName = "ssti_dosage_analysis")
        )
      ),
      conditionalPanel(
        condition = "output.showBjiMenu",
        menuItem("Bone & Joint Infections", tabName = "bj", icon = icon("bone"),
                 menuSubItem("Overview", tabName = "bj_overview"),
                 menuSubItem("Antibiotic use by AWaRe category", tabName = "bj_access_watch_analysis"),
                 menuSubItem("Choice Alignment", tabName = "bj_choice_analysis"),
                 menuSubItem("Dosage Alignment", tabName = "bj_dosage_analysis")
                 
        )
      ),
      conditionalPanel(
        condition = "output.showSpMenu",
        menuItem("Surgical Prophylaxis", tabName = "sp", icon = icon("syringe"),
                 menuSubItem("Overview", tabName = "sp_overview"),
                 menuSubItem("Choice Alignment", tabName = "sp_choice_analysis"),
                 menuSubItem("Dosage Alignment", tabName = "sp_dosage_analysis")
        )
      ),
      
      menuItem("Download Raw Data", tabName = "download_rawdata")
      
    )
  ),
  
  dashboardBody(
    useShinyjs(),
    tags$head(
      tags$title("AWaRe QI Dashboard"),
      
      # Link to external CSS file
      tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css"),
      
      # Favicon links
      tags$link(rel = "icon", 
                type = "image/png",
                href = "https://raw.githubusercontent.com/CNPI-ADILA/Global_PPS_Rshinny/logos/APG%20logo_primary.jpg"),
      tags$link(rel = "shortcut icon", 
                type = "image/png",
                href = "https://raw.githubusercontent.com/CNPI-ADILA/Global_PPS_Rshinny/logos/APG%20logo_primary.jpg"),
      tags$link(rel = "apple-touch-icon", 
                type = "image/png",
                href = "https://raw.githubusercontent.com/CNPI-ADILA/Global_PPS_Rshinny/logos/APG%20logo_primary.jpg"),
      
      # Meta tags
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"),
      tags$meta(charset = "UTF-8"),
      
      # Link to external JavaScript file
      tags$script(src = "js/scripts.js")
    ),
    
    tabItems(
      tabItem(tabName = "upload",
              fluidRow(
                column(10, offset = 1,
                       div(class = "success-box",
                           h3("Welcome to AWaRe Antibiotic Use Quality Indicators Tool"),
                           p("This dashboard provides analysis of AWaRe qaulity indicators (QIs) based on condition-specific Global-PPS prescribing data according to the AWaRe book recommendations in inpatient settings."),
                           p(em("This dashboard is a supplementary tool to the Global PPS dashboard and will provide additional insights to your PPS data particularly around the AWaRe book.")),
                           p("Use the 📩", 
                             downloadLink("download_template", "template"), 
                             "provided as a guide to ensure all mandatory columns are included in your Excel file."),
                           h4("Getting Started"), 
                           
                           p("1.", strong("Download Firstline app:"), " ",
                             tags$a("https://app.firstline.org/", 
                                    href = "https://app.firstline.org/", 
                                    target = "_blank"),
                             " to familiarise yourself with the conditions and antibiotic recommendations listed in the WHO AWaRe book."),
                           p("2. Upload your data files below"),
                           p("3. Check eligible cases in the 'Clinical Conditions' tab"),
                           p("4. Click on condition value boxes to unlock specific analyses"),
                           p("5. Review quality indicators and recommendations")
                       )
                )
              ),
              
              fluidRow(
                column(10, offset = 1,
                       box(
                         title = "Upload Patient Data",
                         status = "primary",
                         solidHeader = TRUE,
                         width = 12,
                         fileInput("dataFile", 
                                   label = "Choose File (Global PPS Excel Export)",
                                   accept = c(".xlsx", ".xls")),
                         helpText("Upload Excel file containing Survey, Department forms, and Patient forms sheets"),
                        
                       )
                )
              )
      ),
      
      tabItem(tabName = "overview",
              fluidRow(
                column(10, offset = 1,
                       div(class = "collapsible-header",
                           h4("Overview")
                       ),
                       
                       div(class = "info-box",
                           h4("AWaRe Quality Indicator Analysis Report:"),
                           p("This report provides a summary analysis of the Global PPS inpatient dataset based on the WHO AWaRe system. The analysis specifically focuses on empiric antibiotic prescribing practices in adults diagnosed with any of the seven community-acquired infections (CAIs) or surgical prophylaxis (SP), for infections in the WHO AWaRe Antibiotic Book and covered by the AWaRe-based Quality Indicators (QIs)."),
                           h4("General Notes:"),
                           tags$ul(
                             tags$li("This tool uses standardised data from the Global-PPS, specifically extracted from the Excel-based outputs received from Global-PPS by participating hospitals."),
                             tags$li("Quality indicators (QIs) were mapped and interpreted based on clinical assumptions aligning WHO guidance with available Global-PPS diagnostic codes."),
                             tags$li("Intravenous (IV) administration was inferred from the Global-PPS 'Route' code 'P' (Parenteral), acknowledging that while this category may include intrathecal and intraperitoneal routes, it predominantly reflects IV use in clinical practice.")
                           ),
                           h4("Disclaimer:"),  
                           p(tags$span(
                             style = "color: red;",
                             "This version of the tool has not yet been formally validated. Outputs are intended to support antimicrobial stewardship, but should not be used in isolation to make clinical decisions or hospital policy changes. Results must always be interpreted in conjunction with local guidelines, clinical expertise, and institutional approval processes."
                           ))
                           
                       ),
                       
                       div(class = "collapsible-header",
                           h4("Condition Definitions", 
                              tags$i(class = "fa fa-chevron-down toggle-icon", style = "float: right;"))
                       ),
                       div(class = "collapsible-content",
                           div(class = "condition-box",
                               strong("1- Clinical Sepsis of Unknown Origin"), " (Based on WHO AWaRe book)", br(),
                               strong("Global-PPS diagnostic code:"), " SEPSIS", br(),
                               strong("Global-PPS definition:"), " Sepsis of any origin (e.g., urosepsis, pulmonary sepsis, etc.), sepsis syndrome, or septic shock with no clear anatomic site, including candidemia with septic symptoms."
                           ),
                           div(class = "condition-box",
                               strong("2- Meningitis"), " (Based on WHO AWaRe book)", br(),
                               strong("Global-PPS diagnostic code:"), " CNS", br(),
                               strong("Global-PPS definition:"), " Includes central nervous system infections."
                           ),
                           div(class = "condition-box",
                               strong("3- Community-acquired Pneumonia"), " (Based on WHO AWaRe book)", br(),
                               strong("Global-PPS diagnostic code:"), " Pneu", br(),
                               strong("Global-PPS definition:"), " Includes pneumonia and other lower respiratory tract infections (LRTIs)."
                           ),
                           div(class = "condition-box",
                               strong("4- Intra-abdominal Infections"), " (Based on WHO AWaRe book)", br(),
                               strong("Global-PPS diagnostic code:"), " IA", br(),
                               strong("Global-PPS definition:"), " Includes hepatobiliary infections, intra-abdominal abscesses, and general abdominal sepsis."
                           ),
                           div(class = "condition-box",
                               strong("5- Upper Urinary Tract Infections"), " (Based on WHO AWaRe book)", br(),
                               strong("Global-PPS diagnostic code:"), " Pye", br(),
                               strong("Global-PPS definition:"), " Includes pyelonephritis and catheter-associated upper urinary tract infections."
                           ),
                           div(class = "condition-box",
                               strong("6- Skin/Soft Tissue Infections"), " (Based on WHO AWaRe book)", br(),
                               strong("Global-PPS diagnostic code:"), " SST", br(),
                               strong("Global-PPS definition:"), " Includes cellulitis, wound infections (including surgical site infections), deep soft tissue not involving bone (e.g., infected pressure ulcers, diabetic ulcers), and abscesses."
                           ),
                           div(class = "condition-box",
                               strong("7- Bone and Joint Infections"), " (Based on WHO AWaRe book)", br(),
                               strong("Global-PPS diagnostic code:"), " BJ", br(),
                               strong("Global-PPS definition:"), " Includes septic arthritis (including prosthetic joint infections) and osteomyelitis."
                           ),
                           div(class = "condition-box",
                               strong("8- Surgical Prophylaxis"), " (Based on WHO AWaRe book)", br(),
                               strong("Global-PPS diagnostic code:"), " Proph (including all surgical prophylaxis codes)", br(),
                               strong("Global-PPS indication:"), " SP1, SP2, SP3", br(),
                               strong("Global-PPS definition:"), " Antibiotics given before, during, or after surgical procedures."
                           )
                       ),
                       
                       div(class = "collapsible-header",
                           h4("Frequently Asked Questions", 
                              tags$i(class = "fa fa-chevron-down toggle-icon", style = "float: right;"))
                       ),
                       div(class = "collapsible-content show",
                           
                           # FAQ 1
                           div(class = "collapsible-header", style = "margin-bottom: 5px; background: linear-gradient(135deg, #e8e8e8 0%, #d0d0d0 100%); color: #2c3e50;",
                               h4(style = "font-size: 16px; margin: 0;", "What are AWaRe Quality Indicators (QIs)?", 
                                  tags$i(class = "fa fa-chevron-down toggle-icon", style = "float: right;"))
                           ),
                           div(class = "collapsible-content", style = "margin-bottom: 15px;",
                               p("AWaRe QIs are a set of evidence-based, quantifiable measures developed to assess whether antibiotic prescribing in health care (in both hospital and primary care settings) complies with the guidance provided by the WHO under its AWaRe Antibiotic Book. The QIs were created following a rigorous process (a scoping review plus two rounds of consensus via the Delphi and RAND/UCLA methods) that evaluated both the clinical appropriateness and feasibility of each indicator globally."),
                               p("Each QI reflects the proportion of patients with a defined infection who receive an antibiotic regimen consistent with AWaRe guidance (e.g., recommended agent, route, and duration). Together, these indicators provide a standardised, globally applicable framework for monitoring and benchmarking antibiotic prescribing quality. They help antimicrobial stewardship programmes identify inappropriate use, track changes over time, and guide targeted improvement efforts."),
                               p("The AWaRe QIs used in this dashboard correspond to hospital-care indicators from the WHO-developed QI set."),
                               p("More details are available in the AWaRe QI development paper: ",
                                 tags$a("https://www.medrxiv.org/content/10.1101/2025.10.24.25338539v1", 
                                        href = "https://www.medrxiv.org/content/10.1101/2025.10.24.25338539v1",
                                        target = "_blank",
                                        style = "color: #3498db; text-decoration: underline; font-weight: 600;"))
                           ),
                           
                           # FAQ 2
                           div(class = "collapsible-header", style = "margin-bottom: 5px; background: linear-gradient(135deg, #e8e8e8 0%, #d0d0d0 100%); color: #2c3e50;",
                               h4(style = "font-size: 16px; margin: 0;", "What is the Global Point Prevalence Survey (Global-PPS)?", 
                                  tags$i(class = "fa fa-chevron-down toggle-icon", style = "float: right;"))
                           ),
                           div(class = "collapsible-content", style = "margin-bottom: 15px;",
                               p("The Global-PPS is an international, standardised surveillance programme used by hospitals worldwide to measure antimicrobial prescribing and healthcare-associated infections on a single survey day. It collects a comprehensive set of variables—including patient demographics, clinical diagnoses, infection type, indication for antimicrobial use, antibiotic choice and AWaRe category, route, dose, duration, and adherence to guidelines—all using a uniform methodology."),
                               p("This structured and harmonised approach allows facilities to generate reliable, comparable antimicrobial use data across wards, hospitals, and countries. Because the Global-PPS dataset contains all variables needed to apply the AWaRe Quality Indicator definitions accurately, it provides the ideal input for the automated analyses performed by the AWaRe QI dashboard."),
                               p("For more information about the Global-PPS methodology and participation, please visit: ",
                                 tags$a("https://www.global-pps.com/", 
                                        href = "https://www.global-pps.com/",
                                        target = "_blank",
                                        style = "color: #3498db; text-decoration: underline; font-weight: 600;"))
                           ),
                           
                           # FAQ 3
                           div(class = "collapsible-header", style = "margin-bottom: 5px; background: linear-gradient(135deg, #e8e8e8 0%, #d0d0d0 100%); color: #2c3e50;",
                               h4(style = "font-size: 16px; margin: 0;", "What is the purpose of the AWaRe QI Dashboard, and what supporting documents are available?", 
                                  tags$i(class = "fa fa-chevron-down toggle-icon", style = "float: right;"))
                           ),
                           div(class = "collapsible-content", style = "margin-bottom: 15px;",
                               p("The AWaRe QI Dashboard was developed to automatically apply the definitions of the AWaRe QIs and calculate their proportions by linking facility data to the WHO AWaRe Antibiotic Book recommendations for inpatient care. It uses existing Global-PPS exports to streamline this process."),
                               p("The main goals of the dashboard are to:"),
                               tags$ul(
                                 tags$li("Accelerate and automate the calculation of AWaRe QIs"),
                                 tags$li("Provide a practical, user-friendly tool for visualising antibiotic prescribing patterns"),
                                 tags$li("Deliver high-quality, diverse outputs that support antimicrobial stewardship (AMS)"),
                                 tags$li("Facilitate meaningful interpretation of results through supporting materials, examples, and guidance so that outputs can be appropriately understood in local contexts")
                               ),
                               p("A set of supporting documents accompanies the dashboard to guide users through operation, interpretation, and application of results:"),
                               tags$ul(
                                 tags$li(
                                 
                                   tags$a("User Manual:", 
                                          href = "https://github.com/CNPI-ADILA/AWaRe_QI_inpatient/blob/main/docs/01%20User%20Manual%20for%20AWaRe%20QI%20Inpatient%20Dashboard%20(V.1.0).pdf",
                                          target = "_blank",
                                          style = "color: #3498db; text-decoration: underline; font-weight: 600;")
                                 ),
                                 tags$li(
                                
                                   tags$a("Interpretation Guide:", 
                                          href = "https://github.com/CNPI-ADILA/AWaRe_QI_inpatient/blob/main/docs/02%20Graph%20Interpretations%20for%20AWaRe%20QI%20Inpatient%20Dashboard%20(V.1.0).pdf",
                                          target = "_blank",
                                          style = "color: #3498db; text-decoration: underline; font-weight: 600;")
                                 ),
                                 tags$li(
                                  
                                   tags$a("Antimicrobial stewardship Guide:", 
                                          href = "https://github.com/CNPI-ADILA/AWaRe_QI_inpatient/blob/main/docs/03%20Antimicrobial%20Stewarship%20Interpretations%20for%20AWaRe%20QI%20Inpatient%20Dashboard%20(V.1.0).pdf",
                                          target = "_blank",
                                          style = "color: #3498db; text-decoration: underline; font-weight: 600;")
                                 )
                               )
                           ),
                           
                           # FAQ 4
                           div(class = "collapsible-header", style = "margin-bottom: 5px; background: linear-gradient(135deg, #e8e8e8 0%, #d0d0d0 100%); color: #2c3e50;",
                               h4(style = "font-size: 16px; margin: 0;", "What if my facility has a small number of eligible cases for calculating Quality Indicators?", 
                                  tags$i(class = "fa fa-chevron-down toggle-icon", style = "float: right;"))
                           ),
                           div(class = "collapsible-content", style = "margin-bottom: 15px;",
                               p("If your facility has only a small number of eligible cases (<10 cases), the QI–specific outputs will not be displayed, as the sample size may be too small to generate meaningful or reliable indicators. However, the general summary outputs will still be available and remain useful. These summaries provide an overview of antibiotic prescribing patterns, infection prevalence, AWaRe category distribution, and potential areas for antimicrobial stewardship focus, even when QIs cannot be calculated.")
                           ),
                           
                           # FAQ 5
                           div(class = "collapsible-header", style = "margin-bottom: 5px; background: linear-gradient(135deg, #e8e8e8 0%, #d0d0d0 100%); color: #2c3e50;",
                               h4(style = "font-size: 16px; margin: 0;", "What if your local or national guidelines differ from the WHO AWaRe Antibiotic Book?", 
                                  tags$i(class = "fa fa-chevron-down toggle-icon", style = "float: right;"))
                           ),
                           div(class = "collapsible-content", style = "margin-bottom: 15px;",
                               p("If your local or national guidelines are not mostly or fully aligned with the recommendations in the WHO AWaRe antibiotic book, then using the QI-specific outputs from the dashboard is not advisable, as they may not accurately reflect the appropriateness of prescribing in your context."),
                               p("However, the general summary outputs remain useful, as they still provide an overview of antibiotic prescribing patterns, infection prevalence, AWaRe category distribution, and potential areas for stewardship focus, even when guideline recommendations differ."),
                               p("If your facility has the technical capacity, you may adapt the underlying dashboard code to incorporate your own local guideline recommendations. All code used in the dashboard is openly accessible here:", 
                                 tags$a("https://github.com/CNPI-ADILA/AWaRe_QI_inpatient/tree/main", 
                                        href = "https://github.com/CNPI-ADILA/AWaRe_QI_inpatient/tree/main",
                                        target = "_blank",
                                        style = "color: #3498db; text-decoration: underline; font-weight: 600;"))
                               
                               
                           ),
                           
                           # FAQ 6
                           div(class = "collapsible-header", style = "margin-bottom: 5px; background: linear-gradient(135deg, #e8e8e8 0%, #d0d0d0 100%); color: #2c3e50;",
                               h4(style = "font-size: 16px; margin: 0;", "What if you do not use Global-PPS to collect data from your facilities?", 
                                  tags$i(class = "fa fa-chevron-down toggle-icon", style = "float: right;"))
                           ),
                           div(class = "collapsible-content", style = "margin-bottom: 15px;",
                               p("If your facilities use other antimicrobial surveillance methodologies (such as the WHO PPS or national data collection tools), it is still possible to use the AWaRe QI dashboard. You may be able to restructure your dataset to align with the Global-PPS data structure. Doing so allows the dashboard to correctly identify the required variables and generate valid outputs."),
                               p("To support this process, you can use the conversion sheet provided below, which offers guidance on how to transform your dataset into a Global-PPS–compatible format:", 
                               tags$a("04 PPS Data Input Guide for AWaRe QI Inpatient Dashboard (V.1.0)", 
                                 href = "https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fraw.githubusercontent.com%2FCNPI-ADILA%2FAWaRe_QI_inpatient%2Frefs%2Fheads%2Fmain%2Fdocs%2F04%2520PPS%2520Data%2520Input%2520Guide%2520for%2520AWaRe%2520QI%2520Inpatient%2520Dashboard%2520(V.1.0).xlsx&wdOrigin=BROWSELINK",
                                      target = "_blank",
                                        style = "color: #3498db; text-decoration: underline; font-weight: 600;"))
                               )
                       )
                )
              )
      ),
      tabItem(tabName = "eligibility",
              conditionalPanel(
                condition = "output.dataUploaded == false",
                fluidRow(
                  column(8, offset = 2,
                         box(width = 12, title = "Upload Required", status = "primary", solidHeader = TRUE,
                             div(class = "error-box",
                                 h4("No Data Uploaded"),
                                 p("Please upload your data files to view the patient eligibility check.")
                             )
                         )
                  )
                )
              ), 
              conditionalPanel(
                condition = "output.dataUploaded == true",
                
                fluidRow(
                  column(10, offset = 1,
                         fluidRow(
                           column(3, uiOutput("bone_eligibility")),
                           column(3, uiOutput("meningitis_eligibility")),
                           column(3, uiOutput("intraabdominal_eligibility")),
                           column(3, uiOutput("pneumonia_eligibility"))
                         )
                  )
                ),
                fluidRow(
                  column(10, offset = 1,
                         fluidRow(
                           column(3, uiOutput("prophylaxis_eligibility")),
                           column(3, uiOutput("urinary_eligibility")),
                           column(3, uiOutput("sepsis_eligibility")),
                           column(3, uiOutput("skin_eligibility"))
                         )
                  )
                ),
                fluidRow(
                  column(10, offset = 1,
                         box(width = 12, 
                             title = "Patient Eligibility Check", 
                             status = "primary", 
                             solidHeader = TRUE,
                             tags$div(style = "font-size: 16px;",
                                      strong("Note:"), 
                                      tags$ul(
                                        tags$li(strong("Eligible patients are adults on empirical antibiotics for predefined community-acquired infections or for surgical prophylaxis.")),
                                        tags$li(strong("Fewer than 10 patients cannot be accessed")),
                                        tags$li(strong("If you do not have a lot of eligible conditions – go back to general summary, or overall diagnoses table for more insights on available conditions"))
                                      )
                             )
                         )
                  )
                )
              )
      ),
      tabItem(tabName = "general_summary",
              conditionalPanel(
                condition = "output.dataUploaded == true",
                fluidRow(
                  box(width = 12, title = "General Summary", status = "primary", solidHeader = TRUE,
                      div(class = "info-box",
                          h4("Welcome to the General Summary Section"),
                          p("This section contains comprehensive analysis of your Global-PPS data. Please select from the submenu items to view specific analyses:"),
                          tags$ul(
                            tags$li(strong("Department Analysis"), " - Overview of admissions and treatments by department"),
                            tags$li(strong("Patient Prescription Summary"), " - Combined patient and prescription summaries by ward"),
                            tags$li(strong("Diagnostic Analysis"), " - Antibiotic prescriptions by diagnostic group"),
                            tags$li(strong("Department Heatmap"), " - Patient prescriptions by diagnosis and department"),
                            tags$li(strong("Age Patterns"), " - Treatment and indication patterns across age groups"),
                            tags$li(strong("Prophylaxis Analysis"), " - Age-specific patterns in prophylaxis indications")
                          )
                      )
                  )
                )
              ),
              conditionalPanel(
                condition = "output.dataUploaded == false",
                fluidRow(
                  box(width = 12, title = "Upload Required", status = "primary", solidHeader = TRUE,
                      p("Please upload your data files to access the general summary analyses.")
                  )
                )
              )
      ),
      
      tabItem(tabName = "department",
              conditionalPanel(
                condition = "output.dataUploaded == true",
                generalDepartmentUI("general_summary")
              ),
              conditionalPanel(
                condition = "output.dataUploaded == false",
                fluidRow(
                  box(width = 12, title = "Upload Required", status = "primary", solidHeader = TRUE,
                      p("Please upload your data files to view department analysis.")
                  )
                )
              )
      ),
      
      tabItem(tabName = "diagnosis_antibiotic",
              conditionalPanel(
                condition = "output.dataUploaded == true",
                generalDiagnosisAntibioticUI("general_summary")
              ),
              conditionalPanel(
                condition = "output.dataUploaded == false",
                fluidRow(
                  box(width = 12, title = "Upload Required", status = "primary", solidHeader = TRUE,
                      p("Please upload your data files to view overall diagnosis and antibiotic use analysis.")
                  )
                )
              )
      ),
      
      tabItem(tabName = "patient_summary",
              conditionalPanel(
                condition = "output.dataUploaded == true",
                generalPatientSummaryUI("general_summary")
              ),
              conditionalPanel(
                condition = "output.dataUploaded == false",
                fluidRow(
                  box(width = 12, title = "Upload Required", status = "primary", solidHeader = TRUE,
                      p("Please upload your data files to view patient and prescription summary.")
                  )
                )
              )
      ),
      
      tabItem(tabName = "diagnostic",
              conditionalPanel(
                condition = "output.dataUploaded == true",
                generalDiagnosticUI("general_summary")
              ),
              conditionalPanel(
                condition = "output.dataUploaded == false",
                fluidRow(
                  box(width = 12, title = "Upload Required", status = "primary", solidHeader = TRUE,
                      p("Please upload your data files to view diagnostic analysis.")
                  )
                )
              )
      ),
      
      tabItem(tabName = "dept_heatmap",
              conditionalPanel(
                condition = "output.dataUploaded == true",
                generalDeptHeatmapUI("general_summary")
              ),
              conditionalPanel(
                condition = "output.dataUploaded == false",
                fluidRow(
                  box(width = 12, title = "Upload Required", status = "primary", solidHeader = TRUE,
                      p("Please upload your data files to view department heatmap.")
                  )
                )
              )
      ),
      
      tabItem(tabName = "age_patterns",
              conditionalPanel(
                condition = "output.dataUploaded == true",
                generalAgePatternsUI("general_summary")
              ),
              conditionalPanel(
                condition = "output.dataUploaded == false",
                fluidRow(
                  box(width = 12, title = "Upload Required", status = "primary", solidHeader = TRUE,
                      p("Please upload your data files to view age patterns.")
                  )
                )
              )
      ),
      
      tabItem(tabName = "prophylaxis",
              conditionalPanel(
                condition = "output.dataUploaded == true",
                generalProphylaxisUI("general_summary")
              ),
              conditionalPanel(
                condition = "output.dataUploaded == false",
                fluidRow(
                  box(width = 12, title = "Upload Required", status = "primary", solidHeader = TRUE,
                      p("Please upload your data files to view prophylaxis analysis.")
                  )
                )
              )
      ),
      
      tabItem(tabName = "sepsis_overview",
              sepsisOverviewUI("sepsis_module")
      ),
      
      tabItem(tabName = "sepsis_patient_summary",
              sepsisPatientSummaryUI("sepsis_module")
      ),
      
      tabItem(tabName = "sepsis_qi1",
              sepsisQI1UI("sepsis_module")
      ),
      
      tabItem(tabName = "sepsis_qi2", 
              sepsisQI2UI("sepsis_module")
      ),
      
      tabItem(tabName = "meningitis_overview",
              meningitisOverviewUI("meningitis_module")
      ),
      
      tabItem(tabName = "meningitis_summary",
              meningitisPatientSummaryUI("meningitis_module")
      ),
      
      tabItem(tabName = "meningitis_qi1",
              meningitisQI1UI("meningitis_module")
      ),
      
      tabItem(tabName = "meningitis_qi2",
              meningitisQI2UI("meningitis_module")
      ),
      
      tabItem(tabName = "pn_overview",
              pneumoniaOverviewUI("pneumonia")
      ),
      
      tabItem(tabName = "pn_patient_summary", 
              pneumoniaPatientSummaryUI("pneumonia")
      ),
      
      tabItem(tabName = "pn_qi_guidelines",
              pneumoniaQIGuidelinesUI("pneumonia")
      ),
      
      tabItem(tabName = "pn_watch_analysis",
              pneumoniaWatchAnalysisUI("pneumonia")
      ),
      
      tabItem(tabName = "pn_choice_analysis",
              pneumoniaChoiceAnalysisUI("pneumonia")
      ),
      
      tabItem(tabName = "pn_dosage_analysis",
              pneumoniaDosageAnalysisUI("pneumonia")
      ),
      
      tabItem(tabName = "intra_abdominal_overview",
              iaisOverviewUI("iais_module")
      ),
      
      tabItem(tabName = "intra_abdominal_eligibility",
              iaisEligibilityUI("iais_module")
      ),
      
      tabItem(tabName = "intra_abdominal_summary",
              iaisPatientSummaryUI("iais_module")
      ),
      
      tabItem(tabName = "intra_abdominal_guidelines",
              iaisQIGuidelinesUI("iais_module")
      ),
      
      tabItem(tabName = "intra_abdominal_iv",
              iaisIVAnalysisUI("iais_module")
      ),
      
      tabItem(tabName = "intra_abdominal_watch",
              iaisWatchAnalysisUI("iais_module")
      ),
      
      tabItem(tabName = "intra_abdominal_choice",
              iaisChoiceAnalysisUI("iais_module")
      ),
      
      tabItem(tabName = "intra_abdominal_dosage",
              iaisDosageAnalysisUI("iais_module")
      ),
      
      tabItem(tabName = "uti_overview",
              utiOverviewUI("uti_module")
      ),
      
      tabItem(tabName = "uti_patient_summary",
              utiPatientSummaryUI("uti_module")
      ),
      
      tabItem(tabName = "uti_qi_guidelines",
              utiQIGuidelinesUI("uti_module")
      ),
      
      tabItem(tabName = "uti_choice_analysis",
              utiChoiceAnalysisUI("uti_module")
      ),
      
      tabItem(tabName = "uti_dosage_analysis",
              utiDosageAnalysisUI("uti_module")
      ),
      
      tabItem(tabName = "uti_watch_analysis",
              utiWatchAnalysisUI("uti_module")
      ),
      
      tabItem(tabName = "uti_iv_analysis",
              utiIVAnalysisUI("uti_module")
      ),
      
      tabItem(tabName = "ssti_overview",
              sstiOverviewUI("ssti_module")
      ),
      
      tabItem(tabName = "ssti_patient_summary",
              sstiPatientSummaryUI("ssti_module")
      ),
      
      tabItem(tabName = "ssti_qi_guidelines",
              sstiQIGuidelinesUI("ssti_module")
      ),
      
      tabItem(tabName = "ssti_choice_analysis",
              sstiChoiceAnalysisUI("ssti_module")
      ),
      
      tabItem(tabName = "ssti_dosage_analysis",
              sstiDosageAnalysisUI("ssti_module")
      ),
      
      tabItem(tabName = "bj_overview",
              bjiOverviewUI("bji_module")
      ),
      
      tabItem(tabName = "bj_patient_summary",
              bjiPatientSummaryUI("bji_module")
      ),
      
      tabItem(tabName = "bj_access_watch_analysis",
              bjiAccessWatchAnalysisUI("bji_module")
      ),
      
      tabItem(tabName = "bj_choice_analysis",
              bjiChoiceAnalysisUI("bji_module")
      ),
      
      tabItem(tabName = "bj_dosage_analysis",
              bjiDosageAnalysisUI("bji_module")
      ),
      
      tabItem(tabName = "sp_overview",
              spOverviewUI("sp_module")
      ),
      
      tabItem(tabName = "sp_patient_summary",
              spPatientSummaryUI("sp_module")
      ),
      
      tabItem(tabName = "sp_qi_guidelines",
              spQIGuidelinesUI("sp_module")
      ),
      
      tabItem(tabName = "sp_choice_analysis",
              spChoiceAnalysisUI("sp_module")
      ),
      
      tabItem(tabName = "sp_dosage_analysis",
              spDosageAnalysisUI("sp_module")
      ),
      
      tabItem(
        tabName = "download_rawdata",
        
        conditionalPanel(
          condition = "output.dataUploaded == false",
          fluidRow(
            column(
              8, offset = 2,
              box(
                width = 12,
                title = "Upload Required",
                status = "primary",
                solidHeader = TRUE,
                div(
                  class = "error-box",
                  h4("No Data Uploaded"),
                  p("Please upload your data files to download raw data.")
                )
              )
            )
          )
        ),
        
        conditionalPanel(
          condition = "output.dataUploaded == true",
          fluidRow(
            column(10, offset = 1,
                   box(
                     title = "Download Patient Data",
                     status = "primary",
                     solidHeader = TRUE,
                     width = 12,
                     h4("Complete Dataset with QI-Eligibility Indicator"),
                     div(style = "text-align: center; margin: 30px 0;",
                         downloadButton(
                           "download_combined",
                           "Download Complete Dataset with QI-Eligibility",
                           class = "btn-success btn-lg",
                           style = "margin-top: 10px; margin-bottom: 20px;"
                         )
                     )
                   )
            )
          )
        )
      )
      
      
    ),
    
    div(class = "footer",
        div(class = "footer-content",
            div(class = "footer-background"),
            
            div(class = "footer-logos-section",
                h5("Our Partners & Supporters", 
                   style = "text-align: center; color: #2c3e50; margin-bottom: 20px; font-weight: 600;"),
                div(class = "footer-logos",
                    div(class = "logo-item",
                        tags$a(href = "https://cnpi-amr.org/research/adila/", target = "_blank", class = "logo-link",
                               img(src = "img/ADILA Logo.png", 
                                   class = "footer-logo", alt = "ADILA Logo"),
                               div(class = "logo-label", "ADILA")
                        )
                    ),
                    div(class = "logo-item",
                        tags$a(href = "https://antibioticpolicy.org/", target = "_blank", class = "logo-link",
                               img(src = "img/APG_logo_primary.jpg", 
                                   class = "footer-logo", alt = "APG Logo"),
                               div(class = "logo-label", "APG")
                        )
                    ),
                    div(class = "logo-item",
                        tags$a(href = "https://cnpi.org.uk/", target = "_blank", class = "logo-link",
                               img(src = "img/CNPI Logo_Horz_RGB.jpg", 
                                   class = "footer-logo", alt = "CNPI Logo"),
                               div(class = "logo-label", "CNPI")
                        )
                    ),
                    div(class = "logo-item city-st-georges",
                        tags$a(href = "https://www.citystgeorges.ac.uk/", target = "_blank", class = "logo-link",
                               img(src = "img/city_logo.png",
                                   class = "footer-logo city-logo", alt = "City St Georges Logo"),
                               div(class = "logo-label", "City St Georges")
                        )
                    ),
                    div(class = "logo-item",
                        tags$a(href = "https://www.flemingfund.org/", target = "_blank", class = "logo-link",
                               img(src = "img/Fleming Fund Logo.png", 
                                   class = "footer-logo", alt = "Fleming Fund Logo"),
                               div(class = "logo-label", "Fleming Fund")
                        )
                    ),
                    div(class = "logo-item",
                        tags$a(href = "https://wellcome.org/", target = "_blank", class = "logo-link",
                               img(src = "img/Wellcome trust logo.png", 
                                   class = "footer-logo", alt = "Wellcome Trust Logo"),
                               div(class = "logo-label", "Wellcome Trust")
                        )
                    ),
                    div(class = "logo-item",
                        tags$a(href = "https://www.global-pps.com/", target = "_blank", class = "logo-link",
                               img(src = "img/logo Global PPS DEF.png", 
                                   class = "footer-logo", alt = "Global PPS Logo"),
                               div(class = "logo-label", "Global PPS")
                        )
                    )
                )
            ),
            
            div(class = "privacy-disclaimer",
                p(HTML("<b>Data Privacy Disclaimer:</b> <i>All data processing occurs locally in your browser session - no patient data or uploaded files are stored on our servers. Once you close the browser or refresh the page, all uploaded data is permanently deleted. We do not collect, store, or transmit any sensitive information.</i>"),
                  style = "text-align: center; color: #6c757d; margin: 10px 0 10px 0; font-size: 14px; font-weight: 500; max-width: 900px; margin-left: auto; margin-right: auto; padding: 0 20px;")
            ),
            
            div(class = "footer-developed-by",
                tags$p(style = "text-align: center; margin: 10px 0 0 0; font-size: 14px; font-weight: 500;",
                       tags$a(href = "https://antibioticpolicy.org/about/", 
                              target = "_blank",
                              style = "color: #6c757d; cursor: pointer; position: relative; z-index: 100;",
                              "Developed by the CNPI AMR Team")
                ),
                tags$p("Version 1.0",
                       style = "text-align: center; color: #6c757d; margin: 10px 0 0 0; font-size: 14px; font-weight: 500;")
            )
        )
    )
  )
)

server <- function(input, output, session) {
  
  observeEvent(input$navigate_to_eligibility, ignoreInit = TRUE, {
    updateTabItems(session, "sidebar", selected = "eligibility")
    session$sendCustomMessage("openMenu", "eligibility")
  })
  
  observeEvent(input$navigate_to_overview, ignoreInit = TRUE, {
    updateTabItems(session, "sidebar", selected = "overview")
    session$sendCustomMessage("openMenu", "overview")
  })
  
  # Constants
  diagnostic_labels <- c(
    SEPSIS = "Undifferentiated Sepsis",
    CNS    = "Meningitis",
    Pneu   = "Respiratory Tract Infection",
    IA     = "Intra-abdominal Infection",
    Pye    = "Upper Urinary Tract Infection",
    SST    = "Skin/Soft Tissue Infection",
    BJ     = "Bone/Joint Infection",
    Proph  = "Surgical Prophylaxis"
  )
  
  AWaRe_abx <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
  surgical_indications <- c("SP1", "SP2", "SP3")
  
  # Reactive values for menu visibility
  menu_visibility <- reactiveValues(
    sepsis = FALSE,
    meningitis = FALSE,
    pneumonia = FALSE,
    iais = FALSE,
    uti = FALSE,
    ssti = FALSE,
    bji = FALSE,
    sp = FALSE
  )
  
  # Helper function to hide all menus
  hide_all_menus <- function() {
    menu_visibility$sepsis <- FALSE
    menu_visibility$meningitis <- FALSE
    menu_visibility$pneumonia <- FALSE
    menu_visibility$iais <- FALSE
    menu_visibility$uti <- FALSE
    menu_visibility$ssti <- FALSE
    menu_visibility$bji <- FALSE
    menu_visibility$sp <- FALSE
  }
  
  # Output reactive expressions for menu visibility
  output$showSepsisMenu <- reactive({ menu_visibility$sepsis })
  output$showMeningitisMenu <- reactive({ menu_visibility$meningitis })
  output$showPneumoniaMenu <- reactive({ menu_visibility$pneumonia })
  output$showIaisMenu <- reactive({ menu_visibility$iais })
  output$showUtiMenu <- reactive({ menu_visibility$uti })
  output$showSstiMenu <- reactive({ menu_visibility$ssti })
  output$showBjiMenu <- reactive({ menu_visibility$bji })
  output$showSpMenu <- reactive({ menu_visibility$sp })
  
  outputOptions(output, 'showSepsisMenu', suspendWhenHidden = FALSE)
  outputOptions(output, 'showMeningitisMenu', suspendWhenHidden = FALSE)
  outputOptions(output, 'showPneumoniaMenu', suspendWhenHidden = FALSE)
  outputOptions(output, 'showIaisMenu', suspendWhenHidden = FALSE)
  outputOptions(output, 'showUtiMenu', suspendWhenHidden = FALSE)
  outputOptions(output, 'showSstiMenu', suspendWhenHidden = FALSE)
  outputOptions(output, 'showBjiMenu', suspendWhenHidden = FALSE)
  outputOptions(output, 'showSpMenu', suspendWhenHidden = FALSE)
  
  # Track data upload status
  output$dataUploaded <- reactive({
    return(!is.null(input$dataFile))
  })
  outputOptions(output, 'dataUploaded', suspendWhenHidden = FALSE)
  
  # Load and prepare data
  data_reactive <- reactive({
    req(input$dataFile)
    
    tryCatch({
      file_path <- input$dataFile$datapath
      
      data_info <- tryCatch({
        read_excel(file_path, sheet = "Survey", col_types = c("guess", "date", "guess", "date"))
      }, error = function(e) { 
        data.frame()
      })
      
      data_deps <- read_excel(file_path, sheet = "Department forms")
      data_patients_all <- read_excel(file_path, sheet = "Patient forms")
      
      lookup_url <- "https://raw.githubusercontent.com/CNPI-ADILA/AWaRe_QI_inpatient/main/data/QIs-Lookup.csv"
      data_lookup <- read_csv(lookup_url, show_col_types = FALSE)
      
      # Store the complete patient data for download
      data_patients_complete <- data_patients_all
      
      # Create subset for analysis
      data_patients <- data_patients_all %>%
        select(any_of(c("Department name", "Department type", "Survey Number", "Activity",
                        "Age years", "Weight", "ATC5", "Single Unit Dose", 
                        "Unit", "N Doses/day", "Route", "AWaRe", "Diagnosis code", 
                        "Indication", "Treatment")))
      
      # Standardization logic
      data_patients <- data_patients %>%
        mutate(
          `Diagnosis code` = ifelse(
            Indication %in% c("SP1", "SP2", "SP3"),
            "Proph",
            `Diagnosis code`
          )
        )
      
      data_patients <- data_patients %>%
        mutate(
          AWaRe = ifelse(
            toupper(AWaRe) == "NOT_RECOMMENDED",
            "NOT RECOMMENDED",
            AWaRe
          )
        )
      
      data_patients[data_patients==""]<-NA
      
      showNotification(paste("Data loaded successfully!", nrow(data_patients_all), "antimicrobial records found. Lookup data loaded from GitHub."), 
                       type = "message", duration = 5)
      
      list(
        data_info = data_info,
        data_deps = data_deps, 
        data_patients = data_patients,
        data_patients_all = data_patients_all,
        data_lookup = data_lookup
      )
      
    }, error = function(e) {
      showNotification(paste("Error loading files:", e$message), type = "error", duration = 10)
      return(NULL)
    })
  })
  
  get_eligibility_data <- reactive({
    data <- data_reactive()
    req(data)
    
    data_patients <- data$data_patients
    
    # Calculate eligible counts
    eligible_counts <- data_patients %>%
      filter(`Diagnosis code` %in% names(diagnostic_labels)) %>%
      mutate(
        Route = toupper(Route),
        AWaRe_compatible = case_when(
          `Diagnosis code` == "Proph" & Indication %in% surgical_indications & `Age years` >= 18 & Treatment == "EMPIRICAL" ~ TRUE,
          `Diagnosis code` != "Proph" & Indication == "CAI" & `Age years` >= 18 & Treatment == "EMPIRICAL" ~ TRUE,
          TRUE ~ FALSE
        )
      ) %>%
      filter(AWaRe_compatible) %>%
      filter(AWaRe %in% AWaRe_abx) %>%
      distinct(`Diagnosis code`, `Survey Number`) %>%
      count(`Diagnosis code`, name = "n_eligible")
    
    # Calculate total counts for each diagnosis (simplified - works for all including Proph)
    total_counts <- data_patients %>%
      filter(AWaRe %in% AWaRe_abx, `Diagnosis code` %in% names(diagnostic_labels)) %>%
      distinct(`Diagnosis code`, `Survey Number`) %>%
      count(`Diagnosis code`, name = "n_total")
    
    full_diagnostics <- tibble(`Diagnosis code` = names(diagnostic_labels))
    
    eligible_summary <- full_diagnostics %>%
      left_join(eligible_counts, by = "Diagnosis code") %>%
      left_join(total_counts, by = "Diagnosis code") %>%
      mutate(
        `N of Eligible Patients` = replace_na(n_eligible, 0),
        `Total Patients` = replace_na(n_total, 0),
        Condition = diagnostic_labels[`Diagnosis code`],
        `Analysis suitability` = case_when(
          `N of Eligible Patients` > 10 ~ "Sufficient",
          `N of Eligible Patients` == 0 ~ "No Data", 
          TRUE ~ "Limited"
        ),
        box_color = case_when(
          `N of Eligible Patients` > 10 ~ "green",
          TRUE ~ "red"
        )
      ) %>%
      select(-n_eligible, -n_total)
    
    return(eligible_summary)
  })
  
  # Individual custom valueBox outputs for each condition
  output$sepsis_eligibility <- renderUI({
    eligibility_data <- get_eligibility_data()
    sepsis_data <- eligibility_data %>% filter(`Diagnosis code` == "SEPSIS")
    
    box_class <- case_when(
      sepsis_data$`N of Eligible Patients` > 10 ~ "custom-value-box",
      TRUE ~ "custom-value-box red"
    )
    
    status_text <- case_when(
      sepsis_data$`N of Eligible Patients` >= 10 ~ "✅ Sufficient",
      sepsis_data$`N of Eligible Patients` == 0 ~ "⚠️ No Data",
      TRUE ~ "⚠️ Limited"
    )
    
    div(class = box_class,
        onclick = "Shiny.setInputValue('sepsis_box_clicked', Math.random());",
        div(class = "custom-value-number", formatC(sepsis_data$`N of Eligible Patients`, format = "d", big.mark = ",")),
        div(class = "custom-value-title", "Undifferentiated Sepsis"),
        div(style = "font-size: 14px; margin: 5px 0; font-weight: 500;", 
            paste0("out of ", formatC(sepsis_data$`Total Patients`, format = "d", big.mark = ","), " patients")),
        div(class = "custom-value-status", status_text),
        div(class = "custom-value-icon", icon("bacteria"))
    )
  })
  
  output$meningitis_eligibility <- renderUI({
    eligibility_data <- get_eligibility_data()
    meningitis_data <- eligibility_data %>% filter(`Diagnosis code` == "CNS")
    
    box_class <- case_when(
      meningitis_data$`N of Eligible Patients` > 10 ~ "custom-value-box",
      TRUE ~ "custom-value-box red"
    )
    
    status_text <- case_when(
      meningitis_data$`N of Eligible Patients` >= 10 ~ "✅ Sufficient",
      meningitis_data$`N of Eligible Patients` == 0 ~ "⚠️ No Data",
      TRUE ~ "⚠️ Limited"
    )
    
    div(class = box_class,
        onclick = "Shiny.setInputValue('meningitis_box_clicked', Math.random());",
        div(class = "custom-value-number", formatC(meningitis_data$`N of Eligible Patients`, format = "d", big.mark = ",")),
        div(class = "custom-value-title", "Meningitis"),
        div(style = "font-size: 14px; margin: 5px 0; font-weight: 500;", 
            paste0("out of ", formatC(meningitis_data$`Total Patients`, format = "d", big.mark = ","), " patients")),
        div(class = "custom-value-status", status_text),
        div(class = "custom-value-icon", icon("brain"))
    )
  })
  
  output$pneumonia_eligibility <- renderUI({
    eligibility_data <- get_eligibility_data()
    pneumonia_data <- eligibility_data %>% filter(`Diagnosis code` == "Pneu")
    
    box_class <- case_when(
      pneumonia_data$`N of Eligible Patients` > 10 ~ "custom-value-box",
      TRUE ~ "custom-value-box red"
    )
    
    status_text <- case_when(
      pneumonia_data$`N of Eligible Patients` >= 10 ~ "✅ Sufficient",
      pneumonia_data$`N of Eligible Patients` == 0 ~ "⚠️ No Data",
      TRUE ~ "⚠️ Limited"
    )
    
    div(class = box_class,
        onclick = "Shiny.setInputValue('pneumonia_box_clicked', Math.random());",
        div(class = "custom-value-number", formatC(pneumonia_data$`N of Eligible Patients`, format = "d", big.mark = ",")),
        div(class = "custom-value-title", "Pneumonia"),
        div(style = "font-size: 14px; margin: 5px 0; font-weight: 500;", 
            paste0("out of ", formatC(pneumonia_data$`Total Patients`, format = "d", big.mark = ","), " patients")),
        div(class = "custom-value-status", status_text),
        div(class = "custom-value-icon", icon("lungs"))
    )
  })
  
  output$intraabdominal_eligibility <- renderUI({
    eligibility_data <- get_eligibility_data()
    ia_data <- eligibility_data %>% filter(`Diagnosis code` == "IA")
    
    box_class <- case_when(
      ia_data$`N of Eligible Patients` > 10 ~ "custom-value-box",
      TRUE ~ "custom-value-box red"
    )
    
    status_text <- case_when(
      ia_data$`N of Eligible Patients` >= 10 ~ "✅ Sufficient",
      ia_data$`N of Eligible Patients` == 0 ~ "⚠️ No Data",
      TRUE ~ "⚠️ Limited"
    )
    
    div(class = box_class,
        onclick = "Shiny.setInputValue('iais_box_clicked', Math.random());",
        div(class = "custom-value-number", formatC(ia_data$`N of Eligible Patients`, format = "d", big.mark = ",")),
        div(class = "custom-value-title", "Intra-abdominal Infections"),
        div(style = "font-size: 14px; margin: 5px 0; font-weight: 500;", 
            paste0("out of ", formatC(ia_data$`Total Patients`, format = "d", big.mark = ","), " patients")),
        div(class = "custom-value-status", status_text),
        div(class = "custom-value-icon", icon("pills"))
    )
  })
  
  output$urinary_eligibility <- renderUI({
    eligibility_data <- get_eligibility_data()
    urinary_data <- eligibility_data %>% filter(`Diagnosis code` == "Pye")
    
    box_class <- case_when(
      urinary_data$`N of Eligible Patients` > 10 ~ "custom-value-box",
      TRUE ~ "custom-value-box red"
    )
    
    status_text <- case_when(
      urinary_data$`N of Eligible Patients` >= 10 ~ "✅ Sufficient",
      urinary_data$`N of Eligible Patients` == 0 ~ "⚠️ No Data",
      TRUE ~ "⚠️ Limited"
    )
    
    div(class = box_class,
        onclick = "Shiny.setInputValue('uti_box_clicked', Math.random());",
        div(class = "custom-value-number", formatC(urinary_data$`N of Eligible Patients`, format = "d", big.mark = ",")),
        div(class = "custom-value-title", "Upper Urinary Tract Infections"),
        div(style = "font-size: 14px; margin: 5px 0; font-weight: 500;", 
            paste0("out of ", formatC(urinary_data$`Total Patients`, format = "d", big.mark = ","), " patients")),
        div(class = "custom-value-status", status_text),
        div(class = "custom-value-icon", icon("droplet"))
    )
  })
  
  output$skin_eligibility <- renderUI({
    eligibility_data <- get_eligibility_data()
    skin_data <- eligibility_data %>% filter(`Diagnosis code` == "SST")
    
    box_class <- case_when(
      skin_data$`N of Eligible Patients` > 10 ~ "custom-value-box",
      TRUE ~ "custom-value-box red"
    )
    
    status_text <- case_when(
      skin_data$`N of Eligible Patients` >= 10 ~ "✅ Sufficient",
      skin_data$`N of Eligible Patients` == 0 ~ "⚠️ No Data",
      TRUE ~ "⚠️ Limited"
    )
    
    div(class = box_class,
        onclick = "Shiny.setInputValue('ssti_box_clicked', Math.random());",
        div(class = "custom-value-number", formatC(skin_data$`N of Eligible Patients`, format = "d", big.mark = ",")),
        div(class = "custom-value-title", "Skin/Soft Tissue Infections"),
        div(style = "font-size: 14px; margin: 5px 0; font-weight: 500;", 
            paste0("out of ", formatC(skin_data$`Total Patients`, format = "d", big.mark = ","), " patients")),
        div(class = "custom-value-status", status_text),
        div(class = "custom-value-icon", icon("bandage"))
    )
  })
  
  output$bone_eligibility <- renderUI({
    eligibility_data <- get_eligibility_data()
    bone_data <- eligibility_data %>% filter(`Diagnosis code` == "BJ")
    
    box_class <- case_when(
      bone_data$`N of Eligible Patients` > 10 ~ "custom-value-box",
      TRUE ~ "custom-value-box red"
    )
    
    status_text <- case_when(
      bone_data$`N of Eligible Patients` >= 10 ~ "✅ Sufficient",
      bone_data$`N of Eligible Patients` == 0 ~ "⚠️ No Data",
      TRUE ~ "⚠️ Limited"
    )
    
    div(class = box_class,
        onclick = "Shiny.setInputValue('bji_box_clicked', Math.random());",
        div(class = "custom-value-number", formatC(bone_data$`N of Eligible Patients`, format = "d", big.mark = ",")),
        div(class = "custom-value-title", "Bone and Joint Infections"),
        div(style = "font-size: 14px; margin: 5px 0; font-weight: 500;", 
            paste0("out of ", formatC(bone_data$`Total Patients`, format = "d", big.mark = ","), " patients")),
        div(class = "custom-value-status", status_text),
        div(class = "custom-value-icon", icon("bone"))
    )
  })
  
  output$prophylaxis_eligibility <- renderUI({
    eligibility_data <- get_eligibility_data()
    proph_data <- eligibility_data %>% filter(`Diagnosis code` == "Proph")
    
    box_class <- case_when(
      proph_data$`N of Eligible Patients` > 10 ~ "custom-value-box",
      TRUE ~ "custom-value-box red"
    )
    
    status_text <- case_when(
      proph_data$`N of Eligible Patients` >= 10 ~ "✅ Sufficient",
      proph_data$`N of Eligible Patients` == 0 ~ "⚠️ No Data",
      TRUE ~ "⚠️ Limited"
    )
    
    div(class = box_class,
        onclick = "Shiny.setInputValue('sp_box_clicked', Math.random());",
        div(class = "custom-value-number", formatC(proph_data$`N of Eligible Patients`, format = "d", big.mark = ",")),
        div(class = "custom-value-title", "Surgical Prophylaxis"),
        div(style = "font-size: 14px; margin: 5px 0; font-weight: 500;", 
            paste0("out of ", formatC(proph_data$`Total Patients`, format = "d", big.mark = ","), " patients")),
        div(class = "custom-value-status", status_text),
        div(class = "custom-value-icon", icon("syringe"))
    )
  })
  
  
  # Observers for box clicks
  observeEvent(input$sepsis_box_clicked, {
    eligibility_data <- get_eligibility_data()
    sepsis_count <- eligibility_data %>% filter(`Diagnosis code` == "SEPSIS") %>% pull(`N of Eligible Patients`)
    
    if (sepsis_count >= 10) {
      hide_all_menus()
      menu_visibility$sepsis <- TRUE
      updateTabItems(session, "sidebar", selected = "sepsis_overview")
      session$sendCustomMessage("openMenu", "sepsis_overview")
      showNotification("Navigating to Sepsis Analysis Overview. Other condition menus are hidden.", type = "message", duration = 3)
    } else {
      showNotification("Insufficient data for Sepsis analysis. Need >=10 eligible patients.", type = "warning", duration = 3)
    }
  })
  
  observeEvent(input$meningitis_box_clicked, {
    eligibility_data <- get_eligibility_data()
    meningitis_count <- eligibility_data %>% filter(`Diagnosis code` == "CNS") %>% pull(`N of Eligible Patients`)
    
    if (meningitis_count >= 10) {
      hide_all_menus()
      menu_visibility$meningitis <- TRUE
      updateTabItems(session, "sidebar", selected = "meningitis_overview")
      session$sendCustomMessage("openMenu", "meningitis_overview")
      showNotification("Navigating to Meningitis Analysis Overview. Other condition menus are hidden.", type = "message", duration = 3)
    } else {
      showNotification("Insufficient data for Meningitis analysis. Need >=10 eligible patients.", type = "warning", duration = 3)
    }
  })
  
  observeEvent(input$pneumonia_box_clicked, {
    eligibility_data <- get_eligibility_data()
    pneumonia_count <- eligibility_data %>% filter(`Diagnosis code` == "Pneu") %>% pull(`N of Eligible Patients`)
    
    if (pneumonia_count >= 10) {
      hide_all_menus()
      menu_visibility$pneumonia <- TRUE
      updateTabItems(session, "sidebar", selected = "pn_overview")
      session$sendCustomMessage("openMenu", "pn_overview")
      showNotification("Navigating to Pneumonia Analysis Overview. Other condition menus are hidden.", type = "message", duration = 3)
    } else {
      showNotification("Insufficient data for Pneumonia analysis. Need >=10 eligible patients.", type = "warning", duration = 3)
    }
  })
  
  observeEvent(input$iais_box_clicked, {
    eligibility_data <- get_eligibility_data()
    iais_count <- eligibility_data %>% filter(`Diagnosis code` == "IA") %>% pull(`N of Eligible Patients`)
    
    if (iais_count >= 10) {
      hide_all_menus()
      menu_visibility$iais <- TRUE
      updateTabItems(session, "sidebar", selected = "intra_abdominal_overview")
      session$sendCustomMessage("openMenu", "intra_abdominal_overview")
      showNotification("Navigating to Intra-abdominal Infections Analysis Overview. Other condition menus are hidden.", type = "message", duration = 3)
    } else {
      showNotification("Insufficient data for Intra-abdominal Infections analysis. Need >=10 eligible patients.", type = "warning", duration = 3)
    }
  })
  
  observeEvent(input$uti_box_clicked, {
    eligibility_data <- get_eligibility_data()
    uti_count <- eligibility_data %>% filter(`Diagnosis code` == "Pye") %>% pull(`N of Eligible Patients`)
    if (uti_count >= 10) {
      hide_all_menus()
      menu_visibility$uti <- TRUE
      updateTabItems(session, "sidebar", selected = "uti_overview")
      session$sendCustomMessage("openMenu", "uti_overview")
      showNotification("Navigating to Upper UTI Analysis Overview. Other condition menus are hidden.", type = "message", duration = 3)
    } else {
      showNotification("Insufficient data for Upper UTI analysis. Need >=10 eligible patients.", type = "warning", duration = 3)
    }
  })
  
  observeEvent(input$ssti_box_clicked, {
    eligibility_data <- get_eligibility_data()
    ssti_count <- eligibility_data %>% filter(`Diagnosis code` == "SST") %>% pull(`N of Eligible Patients`)
    
    if (ssti_count >= 10) {
      hide_all_menus()
      menu_visibility$ssti <- TRUE
      updateTabItems(session, "sidebar", selected = "ssti_overview")
      session$sendCustomMessage("openMenu", "ssti_overview")
      showNotification("Navigating to SSTI Analysis Overview. Other condition menus are hidden.", type = "message", duration = 3)
    } else {
      showNotification("Insufficient data for SSTI analysis. Need >=10 eligible patients.", type = "warning", duration = 3)
    }
  })
  
  observeEvent(input$bji_box_clicked, {
    eligibility_data <- get_eligibility_data()
    bji_count <- eligibility_data %>% filter(`Diagnosis code` == "BJ") %>% pull(`N of Eligible Patients`)
    
    if (bji_count >=10) {
      hide_all_menus()
      menu_visibility$bji <- TRUE
      updateTabItems(session, "sidebar", selected = "bj_overview")
      session$sendCustomMessage("openMenu", "bj_overview")
      showNotification("Navigating to Bone & Joint Infections Analysis Overview. Other condition menus are hidden.", type = "message", duration = 3)
    } else {
      showNotification("Insufficient data for Bone & Joint Infections analysis. Need >=10 eligible patients.", type = "warning", duration = 3)
    }
  })
  
  observeEvent(input$sp_box_clicked, {
    eligibility_data <- get_eligibility_data()
    sp_count <- eligibility_data %>% filter(`Diagnosis code` == "Proph") %>% pull(`N of Eligible Patients`)
    
    if (sp_count >= 10) {
      hide_all_menus()
      menu_visibility$sp <- TRUE
      updateTabItems(session, "sidebar", selected = "sp_overview")
      session$sendCustomMessage("openMenu", "sp_overview")
      showNotification("Navigating to Surgical Prophylaxis Analysis Overview. Other condition menus are hidden.", type = "message", duration = 3)
    } else {
      showNotification("Insufficient data for Surgical Prophylaxis analysis. Need >=10 eligible patients.", type = "warning", duration = 3)
    }
  })
  
  # Call the module servers
  generalSummaryServer("general_summary", data_reactive)
  
  # Condition-specific modules
  sepsisAnalysisServer("sepsis_module", data_reactive)
  meningitisAnalysisServer("meningitis_module", data_reactive)
  pneumoniaAnalysisServer("pneumonia", data_reactive)
  iaisAnalysisServer("iais_module", data_reactive)
  utiAnalysisServer("uti_module", data_reactive)
  sstiAnalysisServer("ssti_module", data_reactive)
  bjiAnalysisServer("bji_module", data_reactive)
  spAnalysisServer("sp_module", data_reactive)
  
  # Download handler
  output$download_combined <- downloadHandler(
    filename = function() {
      paste0("Complete_Patient_Data_with_QI_Eligibility_", format(Sys.Date(), "%Y%m%d"), ".xlsx")
    },
    content = function(file) {
      data <- data_reactive()
      req(data)
      
      data_patients_all <- data$data_patients_all
      
      data_with_eligibility <- data_patients_all %>%
        mutate(
          AWaRe_compatible = case_when(
            startsWith(`Diagnosis code`, "Proph") &
              Indication %in% surgical_indications &
              `Age years` >= 18 &
              Treatment == "EMPIRICAL" ~ TRUE,
            !startsWith(`Diagnosis code`, "Proph") &
              `Diagnosis code` %in% names(diagnostic_labels) &
              Indication == "CAI" &
              `Age years` >= 18 &
              Treatment == "EMPIRICAL" ~ TRUE,
            TRUE ~ FALSE
          ),
          `QI-Eligible` = case_when(
            AWaRe_compatible ~ "YES",
            TRUE ~ "NO"
          )
        ) %>%
        select(-AWaRe_compatible)
      
      wb <- openxlsx::createWorkbook()
      openxlsx::addWorksheet(wb, "Patient Data")
      
      openxlsx::writeData(wb, "Patient Data", data_with_eligibility)
      
      qi_col_index <- which(names(data_with_eligibility) == "QI-Eligible")
      
      yes_rows <- which(data_with_eligibility$`QI-Eligible` == "YES") + 1
      
      yellow_style <- openxlsx::createStyle(fgFill = "#FFFF00", fontColour = "#000000", textDecoration = "bold")
      header_style <- openxlsx::createStyle(fgFill = "#4472C4", fontColour = "#FFFFFF", textDecoration = "bold", 
                                            border = "TopBottomLeftRight", borderColour = "#000000")
      
      openxlsx::addStyle(wb, "Patient Data", header_style, rows = 1, cols = 1:ncol(data_with_eligibility), 
                         gridExpand = TRUE)
      
      if(length(yes_rows) > 0) {
        openxlsx::addStyle(wb, "Patient Data", yellow_style, rows = yes_rows, cols = qi_col_index, 
                           gridExpand = TRUE)
      }
      
      openxlsx::setColWidths(wb, "Patient Data", cols = 1:ncol(data_with_eligibility), widths = "auto")
      
      openxlsx::saveWorkbook(wb, file, overwrite = TRUE)
      
      eligible_count <- sum(data_with_eligibility$`QI-Eligible` == "YES")
      total_count <- nrow(data_with_eligibility)
      
      showNotification(
        paste0("Complete dataset with QI-eligibility downloaded successfully! ", 
               eligible_count, " of ", total_count, " records are QI-eligible (highlighted in yellow)."), 
        type = "message", 
        duration = 5
      )
    }
  )
  
  # Template download handler
  output$download_template <- downloadHandler(
    filename = function() {
      "Global-PPS Template-Dummy Dataset.xlsx"
    },
    content = function(file) {
      download.file("https://github.com/CNPI-ADILA/AWaRe_QI_inpatient/raw/main/data/Global-PPS%20Template-Dummy%20Dataset.xlsx", 
                    file, mode = "wb")
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
