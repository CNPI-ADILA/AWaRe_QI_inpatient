# ---- Encoding / Locale (avoid "????") --------------------------------
options(encoding = "UTF-8")
try({ Sys.setlocale("LC_ALL", "en_US.UTF-8") }, silent = TRUE)

# ---- Packages ---------------------------------------------------------
suppressPackageStartupMessages({
  library(shiny)
  library(shinydashboard)
  library(shinycssloaders)
  library(htmltools)
  library(DT)
  library(dplyr)
  library(tidyr)
  library(purrr)
  library(glue)
  library(scales)
  library(forcats)
  library(ggplot2)
  library(ggtext)
  library(plotly)
})

# =====================================================================
# UI FUNCTIONS
# =====================================================================

pneumoniaOverviewUI <- function(id) {
  ns <- NS(id)
  tagList(
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Back to Conditions"),  # two-line label
                 class = "btn btn-primary fixed-button",
                 style = "
            background-color: #3498db; 
            border-color: #3498db; 
            color: white; 
            font-size: 12px !important;   /* smaller font */
            font-weight: 500; 
            border-radius: 6px; 
            padding: 3px 8px !important;  /* smaller box */
            min-width: auto; 
            width: auto;
            line-height: 1.2;             /* tighter spacing for 2 lines */
          ",
                 onclick = "
            Shiny.setInputValue('navigate_to_eligibility', Math.random(), {priority: 'event'});
            window.scrollTo({top: 0, behavior: 'smooth'});
          ")
             )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
                   div(class = "error-box",
                       h4("⚠️ No Data Uploaded"),
                       p("Please upload your patient data file to begin the WHO AWaRe QIs analysis."),
                       p("Go to the 'Data Upload' tab to upload your Excel file.")
                   )
               )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      # Initial Eligible Cases Check
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "🔍 Initial Eligible Cases Check",
            status = "primary", solidHeader = TRUE,
            htmlOutput(ns("overview_eligibility_feedback"))
          )
        )
      ),
      
      # MOVED: Key Insights - now appears after Initial Eligible Cases Check
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📊 Key Insights",
                   status = "warning", solidHeader = TRUE,
                   htmlOutput(ns("summary_insights_cards"))
               )
        )
      ),
      
      # AWaRe Quality Indicators
      fluidRow(
        column(10, offset = 1,
               box(
                 width = 12, title = "🎯 AWaRe Quality Indicators for Pneumonia",
                 status = "info", solidHeader = TRUE,
                 h5("Within the gPPS data structure, the following antibiotic use quality indicators have been identified:"),
                 p("1) ","Proportion of patients presenting with community acquired pneumonia given IV/oral antibiotics by AWaRe category (Access or Watch)."),
                 p("2) ","Proportion of patients presenting with any community acquired pneumonia given the appropriate IV antibiotics according to the WHO AWaRe Antibiotic Book."),
                 p("3) ","Proportion of patients presenting with any community acquired pneumonia given the prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book.")
               )
        )
      ),
      
      # MOVED: Patient-Level and Prescription-Level Insights - now appear after AWaRe Quality Indicators
      fluidRow(
        box(width = 6, title = "👥 Patient-Level Insights",
            status = "info", solidHeader = TRUE, collapsed = TRUE, collapsible = TRUE,
            withSpinner(DTOutput(ns("patient_level_table")), type = 4)
        ),
        box(width = 6, title = "📑 Prescription-Level Insights",
            status = "success", solidHeader = TRUE, collapsed = TRUE, collapsible = TRUE,
            withSpinner(DTOutput(ns("prescription_level_table")), type = 4)
        )
      )
    )
  )
}

pneumoniaEligibilityUI <- function(id) {
  ns <- NS(id)
  tagList(
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            div(class = "error-box",
                h4("⚠️ No Data Uploaded"),
                p("Please upload your data files to check eligible cases.")
            )
        )
      )
    ),
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        box(width = 12, title = "🔍 Initial Eligible Cases Check", status = "primary",
            solidHeader = TRUE, collapsible = TRUE,
            p("This section assesses whether there are enough eligible cases to support meaningful analysis."),
            htmlOutput(ns("eligibility_feedback"))
        )
      )
    )
  )
}

pneumoniaPatientSummaryUI <- function(id) {
  ns <- NS(id)
  tagList(
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Back to Conditions"),  # two-line label
                 class = "btn btn-primary fixed-button",
                 style = "
            background-color: #3498db; 
            border-color: #3498db; 
            color: white; 
            font-size: 12px !important;   /* smaller font */
            font-weight: 500; 
            border-radius: 6px; 
            padding: 3px 8px !important;  /* smaller box */
            min-width: auto; 
            width: auto;
            line-height: 1.2;             /* tighter spacing for 2 lines */
          ",
                 onclick = "
            Shiny.setInputValue('navigate_to_eligibility', Math.random(), {priority: 'event'});
            window.scrollTo({top: 0, behavior: 'smooth'});
          ")
             )
      )
    ),
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view patient summary.")
        )
      )
    ),
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🧾 Eligibility Criteria",
                   status = "primary", solidHeader = TRUE,
                   p("Eligible patients for WHO AWaRe QI assessment are defined as adult inpatients (≥18 years) who received empirical antibiotics for Pneumonia.")
               )
        )
      )
    )
  )
}

pneumoniaQIGuidelinesUI <- function(id) {
  ns <- NS(id)
  tagList(
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Back to Conditions"),  # two-line label
                 class = "btn btn-primary fixed-button",
                 style = "
            background-color: #3498db; 
            border-color: #3498db; 
            color: white; 
            font-size: 12px !important;   /* smaller font */
            font-weight: 500; 
            border-radius: 6px; 
            padding: 3px 8px !important;  /* smaller box */
            min-width: auto; 
            width: auto;
            line-height: 1.2;             /* tighter spacing for 2 lines */
          ",
                 onclick = "
            Shiny.setInputValue('navigate_to_eligibility', Math.random(), {priority: 'event'});
            window.scrollTo({top: 0, behavior: 'smooth'});
          ")
             )
      )
    ),
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view QI guidelines.")
        )
      )
    ),
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        box(width = 12, title = "📘 WHO AWaRe-QIs Overview", status = "primary",
            solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
            div(class = "condition-box",
                strong("This script evaluates Two indicators:"), br(), br(),
                strong("1. H_RESP_WATCH_ABX:"), " Proportion of patients presenting with any community-acquired pneumonia given the appropriate IV antibiotics according to the WHO AWaRe Antibiotic Book.", br(), br(),
                strong("2. H_RESP_APPROP_ABX:"), " Proportion of patients presenting with any community acquired pneumonia given the appropriate IV antibiotics according to the WHO AWaRe Antibiotic Book."
            ),
            div(class = "note-box",
                strong("🔍 WHO AWaRe book Recommendations for Severe Pneumonia:"), br(), br(),
                tags$ul(
                  tags$li(strong("Option 1:"), " Amoxicillin + clavulanic acid (IV)"),
                  tags$li(strong("Option 2:"), " Cefotaxime (IV)"), 
                  tags$li(strong("Option 3:"), " Ceftriaxone + Azithromycin (IV)"),
                  tags$li(strong("Option 4:"), " Ceftriaxone (IV)")
                ),
                br(),
                strong("🔍 WHO AWaRe book Recommendations for Mild/Moderate Pneumonia:"), br(), br(),
                tags$ul(
                  tags$li(strong("Option 5:"), " Amoxicillin (Oral)"),
                  tags$li(strong("Option 6:"), " Phenoxymethylpenicillin (Oral)"),
                  tags$li(strong("Option 7:"), " Amoxicillin + clavulanic acid (Oral)"),
                  tags$li(strong("Option 8:"), " Doxycycline (Oral)")
                )
            ),
            div(class = "warning-box",
                strong("📘 WHO AWaRe Notes:"), br(),
                tags$ul(
                  tags$li("Watch antibiotics are ", strong("not recommended"), " for most cases of mild to moderate Pneumonia"),
                  tags$li("They may be considered only when clinical severity is high (e.g., CURB-65 score ≥2), or pathogen coverage necessitates escalation"),
                  tags$li("Azithromycin is added to ceftriaxone when atypical organisms are suspected"),
                  tags$li("Doxycycline is particularly useful for atypical pneumonia")
                )
            )
        )
      )
    )
  )
}

pneumoniaWatchAnalysisUI <- function(id) {
  ns <- NS(id)
  tagList(
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Back to Conditions"),  # two-line label
                 class = "btn btn-primary fixed-button",
                 style = "
            background-color: #3498db; 
            border-color: #3498db; 
            color: white; 
            font-size: 12px !important;   /* smaller font */
            font-weight: 500; 
            border-radius: 6px; 
            padding: 3px 8px !important;  /* smaller box */
            min-width: auto; 
            width: auto;
            line-height: 1.2;             /* tighter spacing for 2 lines */
          ",
                 onclick = "
            Shiny.setInputValue('navigate_to_eligibility', Math.random(), {priority: 'event'});
            window.scrollTo({top: 0, behavior: 'smooth'});
          ")
             )
      )
    ),
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view watch antibiotic analysis.")
        )
      )
    ),
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📌 IV/Oral Watch Antibiotic Use",
            status = "primary", solidHeader = TRUE,
            " Proportion of patients presenting with community acquired pneumonia given IV/oral antibiotics by AWaRe category (Access or Watch)"
            
          )
        )
      ),
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📈 Antibiotic Prescription by AWaRe Classification",
            status = "primary", solidHeader = TRUE,
            p("This visual summarises the proportion of antibiotic prescription for Pneumonia across hospital departments by WHO AWaRe Classification (Access, Watch, Reserve)"),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("aware_classification_plot"), height = "450px", width = "100%"),
                  type = 4
                ))
          )
        )
      ),
      column(10, offset = 1,
             div(class = "note-box",
                 strong("💡 Note:"), "This count in this visual represents the number of unique patients who were prescribed at least one antibiotic within a specific WHO AWaRe category (Access, Watch, or Reserve) during their encounter. A patient is counted once for each distinct AWaRe category they received an antibiotic from."
             )
      ),
      
      
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📈 Antibiotic Prescription by Route of Administration",
            status = "primary", solidHeader = TRUE,
            p("This visual summarises the proportion of Pneumonia Patients on Watch Antibiotics across hospital departments by Route of Administration"),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("route_administration_plot"), height = "450px", width = "100%"),
                  type = 4
                ))
          )
        )
      ),
      # Watch Summary Box at the bottom
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📊 Summary of Antibiotic Prescription by AWaRe Classification", status = "success", solidHeader = TRUE,collapsible = TRUE,collapsed =TRUE, 
                   htmlOutput(ns("watch_summary")),
                   div(class = "note-box",
                       strong("💡 Note:"), "The proportions are based on the number of unique Pneumonia patients per department for each specific combination of WHO AWaRe antibiotic category and route of administration. A patient contributes to the count for each distinct AWaRe category and route combination they received. Receiving the same combination multiple times does not increase the count for that combination for that patient."
                   )
               )
        )
      )
    )
  )
}



# Pneumonia Choice Analysis Tab UI - Complete Version with White Backgrounds
pneumoniaChoiceAnalysisUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Custom CSS to ensure white backgrounds throughout
    tags$head(
      tags$style(HTML("
        .box {
          background-color: white !important;
        }
        .box-body {
          background-color: white !important;
        }
        .tab-content {
          background-color: white !important;
        }
        .nav-tabs-custom {
          background-color: white !important;
        }
        .tab-pane {
          background-color: white !important;
        }
      "))
    ),
    
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Back to Conditions"),
                 class = "btn btn-primary fixed-button",
                 style = "
                   background-color: #3498db; 
                   border-color: #3498db; 
                   color: white; 
                   font-size: 12px !important;
                   font-weight: 500; 
                   border-radius: 6px; 
                   padding: 3px 8px !important;
                   min-width: auto; 
                   width: auto;
                   line-height: 1.2;
                 ",
                 onclick = "
                   Shiny.setInputValue('navigate_to_eligibility', Math.random(), {priority: 'event'});
                   window.scrollTo({top: 0, behavior: 'smooth'});
                 ")
             )
      )
    ),
    
    # Upload Required Message
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        column(10, offset = 1,
               box(
                 width = 12, 
                 title = "📤 Upload Required", 
                 status = "warning", 
                 solidHeader = TRUE,
                 p("Please upload your data files to view choice appropriateness analysis.")
               )
        )
      )
    ),
    
    # Main Content (when data is uploaded)
    conditionalPanel(
      condition = "output.dataUploaded == true",
      
      # Introduction Box
      fluidRow(
        column(10, offset = 1,
               box(
                 width = 12, 
                 title = "📌 Antibiotic Choice Alignment with AWaRe book Recommendations for Pneumonia", 
                 status = "primary", 
                 solidHeader = TRUE, 
                 p("Proportion of patients presenting with any community acquired pneumonia given the appropriate IV antibiotics according to the WHO AWaRe Antibiotic Book.")
               )
        )
      ),
      
      # WHO AWaRe book Recommendations Box
      fluidRow(
        column(10, offset = 1,
               box(
                 width = 12, 
                 title = "🔍 WHO AWaRe book Recommendation:", 
                 status = "primary", 
                 solidHeader = TRUE,
                 "▸ ", "Please refer to the WHO AWaRe Antibiotic Book for detailed antibiotic choice & dosage recommendations and considerations"
               )
        )
      ),
      
      # Visual Analytics with Tabbed Interface
      fluidRow(
        column(10, offset = 1,
               box(
                 width = 12, 
                 title = tagList(
                   icon("chart-bar"), 
                   "Antibiotic Choice Alignment with AWaRe book Recommendations for Pneumonia"
                 ), 
                 status = "primary", 
                 solidHeader = TRUE,
                 tabsetPanel(
                   id = ns("choice_viz_tabs"),
                   type = "tabs",
                   
                   # Tab 1: Choice Alignment
                   tabPanel(
                     tagList(icon("check-square"), " Choice Alignment"),
                     div(
                       style = "background-color: white; padding: 15px;",
                       br(),
                       h5(strong("IV antibiotics for Pneumonia")),
                       p("This section assesses whether adult inpatients with Pneumonia were prescribed the appropriate empirical IV antibiotics based on the WHO AWaRe Antibiotic Book."),
                       div(
                         style = "
                           display: flex; 
                           justify-content: center; 
                           align-items: center; 
                           max-width: 100%; 
                           overflow: hidden;
                           background-color: white;
                         ",
                         withSpinner(
                           plotlyOutput(ns("choice_severe_plot"), height = "450px", width = "100%"),
                           type = 4
                         )
                       ),
                       br(),
                       h5(strong("Oral antibiotics for Pneumonia")),
                       p("Visual summary of oral antibiotic choice alignment  Pneumonia across departments."),
                       div(
                         style = "
                           display: flex; 
                           justify-content: center; 
                           align-items: center; 
                           max-width: 100%; 
                           overflow: hidden;
                           background-color: white;
                         ",
                         withSpinner(
                           plotlyOutput(ns("choice_mild_plot"), height = "450px", width = "100%"),
                           type = 4
                         )
                       ),
                       br(),
                       div(
                         class = "info-box",
                         style = "background-color: white; padding: 10px; border-radius: 5px; border-left: 4px solid #3498db;",
                         strong("💡 Note:"),
                         tags$ul(
                           tags$li("The partially recommended category refers to cases where patients received only part of the recommended antibiotic regimen. This includes cases where recommended antibiotics were combined with others outside the intended combination."),
                           tags$li("As gPPS data do not Pneumoniature clinical severity in Pneumonia, antibiotic route was used as a proxy: oral prescriptions were classified as treatment for mild/moderate Pneumonia, and IV prescriptions as treatment for severe Pneumonia. This assumption aligns with WHO AWaRe book recommendations, which advise oral antibiotics for mild/moderate cases and parenteral antibiotics for severe cases.")
                         )
                       )
                     )
                   ),
                   
                   # Tab 2: AWaRe Classification
                   tabPanel(
                     tagList(icon("layer-group"), " AWaRe Classification"),
                     div(
                       style = "background-color: white; padding: 15px;",
                       br(),
                       p("This visual summarises the proportion of IV/ORAL antibiotic choice alignment for Pneumonia across hospital departments by WHO AWaRe Classification (Access, Watch, Reserve)."),
                       div(
                         style = "
                           display: flex; 
                           justify-content: center; 
                           align-items: center; 
                           max-width: 100%; 
                           overflow: hidden;
                           background-color: white;
                         ",
                         withSpinner(
                           plotlyOutput(ns("choice_aware_plot"), height = "450px", width = "100%"),
                           type = 4
                         )
                       )
                     )
                   ),
                   
                   # Tab 3: Treatment Line
                   tabPanel(
                     tagList(icon("stethoscope"), " Treatment Line"),
                     div(
                       style = "background-color: white; padding: 15px;",
                       br(),
                       h5(strong("IV Antibiotic Choice Alignment by Line of Treatment")),
                       p("This visual summarises the proportion of IV antibiotic alignment for Pneumonia across hospital departments by line of treatment (First choice, Second choice)"),
                       div(
                         style = "
                           display: flex; 
                           justify-content: center; 
                           align-items: center; 
                           max-width: 100%; 
                           overflow: hidden;
                           background-color: white;
                         ",
                         withSpinner(
                           plotlyOutput(ns("choice_line_iv_plot"), height = "450px", width = "100%"),
                           type = 4
                         )
                       ),
                       br(),
                       h5(strong("ORAL Antibiotic Choice Alignment by Line of Treatment")),
                       p("This visual summarises the proportion of ORAL antibiotic alignment for Pneumonia across hospital departments by line of treatment (First choice, Second choice)"),
                       div(
                         style = "
                           display: flex; 
                           justify-content: center; 
                           align-items: center; 
                           max-width: 100%; 
                           overflow: hidden;
                           background-color: white;
                         ",
                         withSpinner(
                           plotlyOutput(ns("choice_line_oral_plot"), height = "450px", width = "100%"),
                           type = 4
                         )
                       )
                     )
                   )
                 )
               )
        )
      ),
      
      # Summary Box
      fluidRow(
        column(10, offset = 1,
               box(
                 width = 12, 
                 title = "📝 Summary of Antibiotic Choice Alignment with AWaRe book Recommendations for Pneumonia",
                 status = "success", 
                 solidHeader = TRUE, 
                 collapsible = TRUE, 
                 collapsed = TRUE,
                 h4("IV antibiotics for Pneumonia"),
                 htmlOutput(ns("choice_severe_summary")),
                 br(),
                 h4("Oral antibiotics for Pneumonia"), 
                 htmlOutput(ns("choice_mild_summary"))
               )
        )
      )
    )
  )
}


pneumoniaDosageAnalysisUI <- function(id) {
  ns <- NS(id)
  tagList(
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Back to Conditions"),  # two-line label
                 class = "btn btn-primary fixed-button",
                 style = "
            background-color: #3498db; 
            border-color: #3498db; 
            color: white; 
            font-size: 12px !important;   /* smaller font */
            font-weight: 500; 
            border-radius: 6px; 
            padding: 3px 8px !important;  /* smaller box */
            min-width: auto; 
            width: auto;
            line-height: 1.2;             /* tighter spacing for 2 lines */
          ",
                 onclick = "
            Shiny.setInputValue('navigate_to_eligibility', Math.random(), {priority: 'event'});
            window.scrollTo({top: 0, behavior: 'smooth'});
          ")
             )
      )
    ),
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view dosage appropriateness analysis.")
        )
      )
    ),
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📌 Antibiotic Dosage Alignment with AWaRe book Recommendations for Pneumonia", status = "primary", solidHeader = TRUE, 
                   
                   "Proportion of patients presenting with any community acquired pneumonia given the prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book.",br(),
                   
               )
        )
      ),
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🔍 WHO AWaRe book Recommendation:", status = "primary", solidHeader = TRUE,
                   "▸ ","Please refer to the WHO AWaRe Antibiotic Book for detailed antibiotic choice & dosage recommendations and considerations",br()
               )
        )
      ),
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📌 IV Antibiotic Dosage Alignment with AWaRe book Recommendations for Pneumonia",
            status = "primary", solidHeader = TRUE, 
            p("Visual summary of IV antibiotic choice & dosage alignment for Pneumonia across departments."),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("dosage_severe_plot"), height = "450px", width = "100%"),
                  type = 4
                ))
          )
        )
      ),
      
      column(10, offset = 1,
             div(class = "info-box",
                 strong("💡 Note:"),
                 tags$ul(
                   tags$li("Received recommended IV antibiotics with recommended dosage indicates that the full recommended treatment regimen (whether monotherapy or dual therapy) was given, with all dosages aligned with WHO AWaRe book guidance."),
                   tags$li("Received at least one recommended IV antibiotic with one has recommended dosage refers to cases where only part of the recommended dual therapy was given, and only one antibiotic was at the recommended dosage."),
                   tags$li("Received at least one recommended IV antibiotic with none have recommended dosage includes cases who received either the full recommended regimen with no recommended dosages, or only part of it (e.g., one agent from a dual therapy) with none of the dosages aligned with WHO AWaRe book guidance.")
                   
                 )
             )
      ),
      
      
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📌 Oral Antibiotic Choice & Dosage Alignment with AWaRe book Recommendations for Pneumonia",
            status = "primary", solidHeader = TRUE, 
            p("Visual summary of oral antibiotic choice & dosage appropriateness for across departments."),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("dosage_mild_plot"), height = "450px", width = "100%"),
                  type = 4
                ))
          )
        )
      ),
      
      column(10, offset = 1,
             div(class = "info-box",
                 strong("💡 Note:"),
                 tags$ul(
                   tags$li("Cases where oral clarithromycin was given alongside a recommended IV antibiotic (Cefotaxime, Ceftriaxone, or Amoxicillin–Clavulanic acid) were considered appropriate IV treatment. Because clarithromycin is part of the recommended combination for severe Pneumonia (CURB-65 ≥2), these cases were excluded from the oral antibiotic appropriateness assessment."),
                   tags$li("The combined total of patients in the oral and IV antibiotic choice/dosage appropriateness assessment summaries may exceed the overall number of patients, as some were prescribed both oral and IV treatments — so they are included in both summaries.")
                 )
             )
      ),
      
      
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📝 Summary of Antibiotic Dosage Alignment for Pneumonia",
            status = "success", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
            h4("IV antibiotics for Pneumonia"),
            htmlOutput(ns("dosage_severe_summary")),
            br(),
            h4("Oral antibiotics for Pneumonia"),
            htmlOutput(ns("dosage_mild_summary"))
          )
        )
      )
    )
  )
}

# =====================================================================
# SERVER (MODULE)
# =====================================================================

pneumoniaAnalysisServer <- function(id, data_reactive) {
  moduleServer(id, function(input, output, session) {
    
    # Constants
    AWaRe_abx <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
    
    # ---------- Helper: data presence ----------
    check_data <- function() {
      data <- data_reactive()
      !is.null(data) && !is.null(data$data_patients)
    }
    
    output$dataUploaded <- reactive({ check_data() })
    outputOptions(output, "dataUploaded", suspendWhenHidden = FALSE)
    
    # ---------- Eligibility feedback (matching R markdown logic) ----------
    generate_eligibility_feedback <- function() {
      tryCatch({
        if (!check_data()) {
          return(HTML("<div style='background-color:#fff3cd;border:1px solid #ffeeba;padding:15px;border-radius:5px;'><b>⚠️ No data available</b><br>Please upload your data files to check eligible cases.</div>"))
        }
        data <- data_reactive()
        data_patients <- data$data_patients
        data_info <- data$data_info
        
        required_cols <- c("Diagnosis code", "Age years", "Indication", "Treatment", "AWaRe", "Route", "Survey Number")
        missing_cols <- setdiff(required_cols, names(data_patients))
        if (length(missing_cols) > 0) {
          return(HTML(paste0("<div style='background:#f8d7da;border:1px solid #f5c6cb;padding:15px;border-radius:5px;'><b>❌ Missing required columns:</b> ", paste(missing_cols, collapse = ", "), "</div>")))
        }
        
        # Updated data filtering logic matching R markdown
        data_pneu <- data_patients %>%
          filter(`Diagnosis code` == "Pneu") %>%
          mutate(
            Route = toupper(as.character(Route)),
            AWaRe_compatible = (`Age years` >= 18 & 
                                  Indication == "CAI" & 
                                  Treatment == "EMPIRICAL" & 
                                  AWaRe %in% AWaRe_abx)
          )
        
        eligible_pneu_n <- data_pneu %>%
          filter(AWaRe_compatible) %>%
          distinct(`Survey Number`) %>%
          nrow()
        
        survey_start <- if (!is.null(data_info$`Survey start date`)) format(as.Date(data_info$`Survey start date`), "%d %b %Y") else "Not available"
        survey_end   <- if (!is.null(data_info$`Survey end date`))   format(as.Date(data_info$`Survey end date`), "%d %b %Y") else "Not available"
        
        status_html <-
          if (eligible_pneu_n == 0) {
            "<div style='background:#fff3cd;border:1px solid #ffeeba;padding:10px;border-radius:3px;margin-top:10px;'><b>🚫 No eligible cases found:</b> There were no eligible cases during this survey period.</div>"
          } else if (eligible_pneu_n < 10) {
            "<div style='background:#ffe0e0;border:1px solid #ffb3b3;padding:10px;border-radius:3px;margin-top:10px;'><b>⚠️ Caution:</b> Few eligible cases detected. Interpret results with caution.</div>"
          } else {
            "<div style='background:#e0ffe0;border:1px solid #b3ffb3;padding:10px;border-radius:3px;margin-top:10px;'><b>✅ Good to go!</b> Sufficient eligible cases available.</div>"
          }
        
        HTML(paste0(
          "<div style='background:#f0f8ff;border:1px solid #add8e6;padding:15px;border-radius:5px;'>",
          "<p>This module applies <b>WHO AWaRe Quality Indicators</b> to adult inpatients with empirical antibiotics for community-acquired pneumonia (Pneumonia).</p>",
          "<ul><li><b>Diagnostic code:</b> Pneu</li><li><b>Total eligible cases:</b> ", eligible_pneu_n, "</li></ul>",
          status_html, "</div>"
        ))
      }, error = function(e) {
        HTML(paste0("<div style='background:#f8d7da;border:1px solid #f5c6cb;padding:15px;border-radius:5px;'>",
                    "<b>❌ Error:</b> ", htmlEsPneumoniae(e$message), "</div>"))
      })
    }
    output$eligibility_feedback <- renderUI({ generate_eligibility_feedback() })
    output$overview_eligibility_feedback <- renderUI({ generate_eligibility_feedback() })
    
    # ---------- Summary cards (matching R markdown logic) ----------
    output$summary_insights_cards <- renderUI({
      if (!check_data()) return(HTML("<p>No data available for insights</p>"))
      data <- data_reactive()
      data_patients <- data$data_patients
      
      total_patients <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "Pneu") %>%
        distinct(`Survey Number`) %>% nrow()
      
      eligible_patients <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx,
               Treatment == "EMPIRICAL", `Diagnosis code` == "Pneu") %>%
        distinct(`Survey Number`) %>% nrow()
      
      total_prescriptions <- data_patients %>% filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "Pneu") %>% nrow()
      
      eligible_prescriptions <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx,
               Treatment == "EMPIRICAL", `Diagnosis code` == "Pneu") %>% nrow()
      
      patient_pct <- if (total_patients > 0) round(100*eligible_patients/total_patients,1) else 0
      rx_pct <- if (total_prescriptions > 0) round(100*eligible_prescriptions/total_prescriptions,1) else 0
      
      pc_bg <- if (patient_pct >= 10) "#d4edda" else if (patient_pct >= 5) "#fff3cd" else "#f8d7da"
      rx_bg <- if (rx_pct >= 10) "#d4edda" else if (rx_pct >= 5) "#fff3cd" else "#f8d7da"
      
      HTML(paste0(
        "<div style='display:flex;gap:20px;flex-wrap:wrap'>",
        
        # Card 1: Patients
        "<div style='flex:1;min-width:300px;background:", pc_bg, 
        ";border-left:6px solid #28a745;padding:18px;border-radius:8px;'>",
        "<h4 style='margin:0 0 6px;color:#155724;'>👥 Proportion of Eligible Patients:</h4>",
        "<div style='font-size:2.2em;font-weight:700;color:#155724;'>", patient_pct, "%</div>",
        "<div style='color:#155724;'><b>", eligible_patients, "</b> out of <b>", total_patients, 
        "</b> patients on antibiotics for pneumonia were QI-eligible patients</div>",
        "</div>",
        
        # Card 2: Prescriptions
        "<div style='flex:1;min-width:300px;background:", rx_bg, 
        ";border-left:6px solid #17a2b8;padding:18px;border-radius:8px;'>",
        "<h4 style='margin:0 0 6px;color:#0c5460;'>📑 Proportion of Eligible Prescriptions:</h4>",
        "<div style='font-size:2.2em;font-weight:700;color:#0c5460;'>", rx_pct, "%</div>",
        "<div style='color:#0c5460;'><b>", eligible_prescriptions, "</b> out of <b>", total_prescriptions, 
        "</b> antibiotic prescriptions for pneumonia were given to QI-eligible patients</div>",
        "</div>",
        
        "</div>"
      ))
      
    })
    
    # ---------- Patient-level table (exact base code logic) ----------
    output$patient_level_table <- renderDT({
      if (!check_data()) {
        return(DT::datatable(data.frame(Message = "No data available"), options = list(dom = 't'), rownames = FALSE))
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # Fix AWaRe column - convert NOT_RECOMMENDED to NOT RECOMMENDED 
      data_patients <- data_patients %>%
        mutate(
          AWaRe = ifelse(
            toupper(AWaRe) == "NOT_RECOMMENDED",
            "NOT RECOMMENDED",
            AWaRe
          )
        )
      
      total_patients <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx) %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      patient_summary <- data.frame(
        Category = c(
          "Number of adult patients (≥18 years) who received empirical antibiotic treatment for CAI",
          "Number of all patients with a diagnosis of pneumonia on any antibiotics",
          "Number of eligible patients: Adult patients (≥18 years) with a diagnosis of Pneumonia who were treated empirically with antibiotics"
        ),
        Count = c(
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Diagnosis code` == "Pneu", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "Pneu", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow()
        )
      ) %>%
        mutate(
          Percent = sprintf("%.1f%%", 100 * Count / total_patients)
        )
      
      DT::datatable(patient_summary,
                    colnames = c("Patient Category", "Number of Patients", "Proportion of All Patients"),
                    options = list(pageLength = 5, dom = 't', searching = FALSE, paging = FALSE),
                    rownames = FALSE)
    })
    
    
    
    
    # ---------- Prescription-level table (exact base code logic) ----------
    output$prescription_level_table <- renderDT({
      if (!check_data()) {
        return(DT::datatable(data.frame(Message = "No data available"), options = list(dom = 't'), rownames = FALSE))
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # Fix AWaRe column - convert NOT_RECOMMENDED to NOT RECOMMENDED 
      data_patients <- data_patients %>%
        mutate(
          AWaRe = ifelse(
            toupper(AWaRe) == "NOT_RECOMMENDED",
            "NOT RECOMMENDED",
            AWaRe
          )
        )
      
      total_prescriptions <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx) %>%
        nrow()
      
      prescription_summary <- data.frame(
        Category = c(
          "Number of empirical antibiotic prescriptions administered to adult patients (≥18 years) for CAI",
          "Number of all antibiotic prescriptions for patients diagnosed with pneumonia",
          "Number of eligible antibiotic prescriptions: antibiotics empirically prescribed for adult patients (≥18 years) with Pneumonia"
        ),
        Count = c(
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Diagnosis code` == "Pneu", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "Pneu", AWaRe %in% AWaRe_abx) %>% nrow()
        )
      ) %>%
        mutate(
          Percent = sprintf("%.1f%%", 100 * Count / total_prescriptions)
        )
      
      DT::datatable(prescription_summary,
                    colnames = c("Prescription Category", "Number of Prescriptions", "Proportion of All Prescriptions"),
                    options = list(pageLength = 5, dom = 't', searching = FALSE, paging = FALSE),
                    rownames = FALSE)
    })
    
    # =======================
    # WATCH DATA REACTIVE - CORRECTED
    # =======================
    watch_data_reactive <- reactive({
      if (!check_data()) return(NULL)
      data <- data_reactive()
      data_patients <- data$data_patients %>%
        mutate(Route = toupper(Route))
      
      # EXACT R markdown filtering logic
      data_pneu <- data_patients %>%
        filter(`Diagnosis code` == "Pneu") %>%
        mutate(
          Route = toupper(Route),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      data_pneu_eligible <- data_pneu %>%
        filter(AWaRe_compatible == TRUE)
      
      # EXACT R markdown patient-level aggregation
      summary_watch <- data_pneu_eligible %>%
        mutate(
          # Flag each prescription
          Is_WATCH = (AWaRe == "WATCH"),
          Is_Route_IV_ORAL = (Route %in% c("P", "O")),
          Is_Route_OTHER = (!Route %in% c("P", "O"))
        ) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          # Patient received WATCH via IV/Oral if ANY of their WATCH prescriptions were P or O
          WATCH_IV_ORAL = any(Is_WATCH & Is_Route_IV_ORAL),
          
          # Patient received WATCH via Other route (temporary)
          WATCH_OTHER_temp = any(Is_WATCH & Is_Route_OTHER),
          
          # Patient received only NON-WATCH antibiotics
          NON_WATCH = all(!Is_WATCH),
          .groups = "drop"
        ) %>%
        mutate(
          # CRITICAL: WATCH_OTHER is only TRUE if patient got WATCH via other routes
          # AND did NOT receive WATCH via IV/Oral routes
          WATCH_OTHER = WATCH_OTHER_temp & !WATCH_IV_ORAL
        ) %>%
        select(-WATCH_OTHER_temp)
      
      # Department summary (exact R markdown)
      summary_watch_dept <- summary_watch %>%
        group_by(`Department name`) %>%
        summarise(
          Eligible = n(),
          N_WATCH_IV_ORAL = sum(WATCH_IV_ORAL),
          N_WATCH_OTHER = sum(WATCH_OTHER),
          N_NON_WATCH = sum(NON_WATCH),
          Prop_WATCH_IV_ORAL = round(100 * N_WATCH_IV_ORAL / Eligible, 1),
          Prop_WATCH_OTHER = round(100 * N_WATCH_OTHER / Eligible, 1),
          Prop_NON_WATCH = round(100 * N_NON_WATCH / Eligible, 1),
          .groups = "drop"
        )
      
      # Hospital-wide summary (exact R markdown)
      summary_watch_total <- summary_watch %>%
        summarise(
          `Department name` = "Hospital-Wide",
          Eligible = n(),
          N_WATCH_IV_ORAL = sum(WATCH_IV_ORAL),
          N_WATCH_OTHER = sum(WATCH_OTHER),
          N_NON_WATCH = sum(NON_WATCH),
          Prop_WATCH_IV_ORAL = round(100 * N_WATCH_IV_ORAL / Eligible, 1),
          Prop_WATCH_OTHER = round(100 * N_WATCH_OTHER / Eligible, 1),
          Prop_NON_WATCH = round(100 * N_NON_WATCH / Eligible, 1)
        )
      
      list(
        data_pneu = data_pneu,
        data_pneu_eligible = data_pneu_eligible,
        summary_watch_final = bind_rows(summary_watch_total, summary_watch_dept)
      )
    })
    
    # =======================
    # WATCH SUMMARY OUTPUT - CORRECTED
    # =======================
    output$watch_summary <- renderUI({
      wd <- watch_data_reactive()
      if (is.null(wd)) return(HTML("<p>No data</p>"))
      data_pneu <- wd$data_pneu
      data_pneu_eligible <- wd$data_pneu_eligible
      summary_watch_final <- wd$summary_watch_final
      
      total_Pneumonia <- data_pneu %>% distinct(`Survey Number`) %>% nrow()
      eligible_Pneumonia <- data_pneu_eligible %>% distinct(`Survey Number`) %>% nrow()
      
      if (eligible_Pneumonia == 0 || is.na(eligible_Pneumonia)) {
        return(HTML("<div style='background:#fff3cd;border-left:5px solid #ffc107;padding:14px;'>⚠️ <b>No summary</b> — no eligible patients.</div>"))
      }
      
      intro <- glue("<div style='background:#f8f9fa;border-left:5px solid #17a2b8;padding:14px;margin:10px 0;'>
                💊 <b>Denominator:</b> Number of eligible Pneumonia patients who received any antibiotics (<b>{eligible_Pneumonia}</b> out of {total_Pneumonia})
                </div><br><br>
                <b>Summary:</b><br><br>")
      
      blocks <- summary_watch_final %>%
        mutate(block = pmap_chr(
          list(`Department name`, Prop_WATCH_IV_ORAL, N_WATCH_IV_ORAL, 
               Prop_WATCH_OTHER, N_WATCH_OTHER, Prop_NON_WATCH, N_NON_WATCH, Eligible),
          function(dept, ivoral_p, ivoral_n, other_p, other_n, nonwatch_p, nonwatch_n, total_n) {
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            
            glue("<div style='background-color:{bg};border-left:5px solid {color};padding:14px;margin-bottom:20px;'>
             <b>🏥 {dept}</b> <span style='color:#888;'>(n = {total_n} patients)</span><br><br>
             <ul style='margin-left:1.2em;line-height:1.8;padding-left:0;list-style-type:none;'>
               <li><span style='display:inline-block;background-color:#007bff;color:white;border-radius:50%;width:22px;height:22px;text-align:center;line-height:22px;font-size:12px;margin-right:8px;'>1</span>
                   <b>Received a WATCH antibiotic via IV or Oral route</b>: <b>{scales::percent(ivoral_p/100, 0.1)}</b> ({ivoral_n} out of {total_n})</li>
               <li><span style='display:inline-block;background-color:#17a2b8;color:white;border-radius:50%;width:22px;height:22px;text-align:center;line-height:22px;font-size:12px;margin-right:8px;'>2</span>
                   <b>Received a WATCH antibiotic via other route</b>: <b>{scales::percent(other_p/100, 0.1)}</b> ({other_n} out of {total_n})</li>
               <li><span style='display:inline-block;background-color:#ffc107;color:black;border-radius:50%;width:22px;height:22px;text-align:center;line-height:22px;font-size:12px;margin-right:8px;'>3</span>
                   <b>Received a NON-WATCH antibiotic</b>: <b>{scales::percent(nonwatch_p/100, 0.1)}</b> ({nonwatch_n} out of {total_n})</li>
             </ul></div>")
          }
        )) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>% pull(block)
      
      HTML(paste0(intro, paste(blocks, collapse = "")))
    })
    
    # AWaRe plot (converted to plotly) - PNEUMONIA DATA WITH IAI STYLING
    output$aware_classification_plot <- renderPlotly({
      wd <- watch_data_reactive()
      if (is.null(wd)) {
        return(
          plotly::plotly_empty(type = "scatter", mode = "markers") %>%
            plotly::layout(
              title = list(text = "No data available"),
              xaxis = list(visible = FALSE),
              yaxis = list(visible = FALSE),
              showlegend = FALSE
            )
        )
      }
      
      data_pneu_eligible <- wd$data_pneu_eligible
      
      # EXACT PNEUMONIA LOGIC: Summarise AWaRe category by department
      aware_summary <- data_pneu_eligible %>%
        group_by(`Department name`, Survey_ID = `Survey Number`, AWaRe) %>%
        summarise(Prescriptions = n(), .groups = "drop") %>%
        group_by(`Department name`, AWaRe) %>%
        summarise(Patients = n(), .groups = "drop")  # This counts unique patients per AWaRe
      
      # Add totals and proportions per department
      aware_dept_totals <- aware_summary %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      aware_summary <- aware_summary %>%
        left_join(aware_dept_totals, by = "Department name") %>%
        mutate(Proportion = round(Patients / Total, 3))
      
      # Create hospital-level summary - EXACT PNEUMONIA LABEL
      hospital_row <- aware_summary %>%
        group_by(AWaRe) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital")
      
      # Combine summaries
      aware_summary_combined <- bind_rows(aware_summary, hospital_row)
      
      # Recalculate totals and proportions with Hospital
      aware_summary_combined <- aware_summary_combined %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      aware_levels_stack <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
      aware_levels_legend <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
      
      # Ensure all AWaRe levels are represented per department
      all_combos2 <- expand_grid(
        `Department name` = unique(aware_summary_combined$`Department name`),
        AWaRe = aware_levels_stack
      )
      
      aware_summary_all <- all_combos2 %>%
        left_join(aware_summary_combined, by = c("Department name", "AWaRe")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, Patients / Total)
        )
      
      aware_summary_all$AWaRe <- factor(aware_summary_all$AWaRe, levels = aware_levels_stack)
      
      # Labels and hover text (no integer rounding)
      aware_summary_all <- aware_summary_all %>%
        filter(Total > 0) %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          ProportionPct = Proportion * 100,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>AWaRe Category:</b> ", as.character(AWaRe), "<br>",
            "<b>Count:</b> ", Patients, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      # Ordered labels
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(unique(aware_summary_all$PlotLabel[aware_summary_all$PlotLabel != "<b style='color:#0072B2;'>Hospital-Wide</b>"]))
      )
      aware_summary_all$PlotLabel <- factor(aware_summary_all$PlotLabel, levels = ordered_labels)
      
      # n= labels
      label_data <- aware_summary_all %>%
        distinct(`Department name`, PlotLabel, Total)
      
      # Dynamic buffer
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # Colors
      aware_colors <- c(
        "ACCESS" = "#1b9e77",
        "WATCH" = "#ff7f00",
        "RESERVE" = "#e41a1c",
        "NOT RECOMMENDED" = "#8c510a",
        "UNCLASSIFIED" = "gray70"
      )
      
      # ggplot
      p <- ggplot(aware_summary_all, aes(y = PlotLabel, x = ProportionPct, fill = AWaRe, text = hover_text)) +
        geom_bar(stat = "identity", position = "fill", width = 0.85) +
        geom_text(
          aes(label = ifelse(Proportion > 0.05, paste0(round(ProportionPct, 1), "%"), "")),
          position = position_fill(vjust = 0.5),
          size = 3, color = "black"
        ) +
        geom_text(
          data = label_data,
          aes(y = PlotLabel, label = paste0("n=", formatC(Total, format = "d", big.mark = ","))),
          x = label_x,
          inherit.aes = FALSE, size = 3, color = "gray30", vjust = 0.5, hjust = 0
        ) +
        scale_fill_manual(
          breaks = aware_levels_legend,
          values = aware_colors,
          drop = FALSE,
          name = "AWaRe Category"
        ) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
          x = "Proportion of Patients",
          y = "Department"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.y = ggtext::element_markdown(size = 7),
          axis.text.x = element_text(size = 7),
          axis.title  = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text  = element_text(size = 8),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          plot.margin  = margin(6, 18, 6, 8)
        ) +
        guides(fill = guide_legend(nrow = 5, byrow = TRUE, title.position = "top")) +
        scale_y_discrete(limits = rev(levels(aware_summary_all$PlotLabel)))
      
      # Convert to plotly
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Proportion of Pneumonia Patients on Antibiotics by AWaRe</b><br>"
            ),
            x = 0.5, xanchor = "center",
            y = 0.98, yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width  = 680,
          margin = list(l = 30, r = r_margin, t = 60, b = 220),
          legend = list(
            orientation = "h", x = 0.5, xanchor = "center",
            y = -0.50, yanchor = "top",
            font = list(size = 10),
            title = list(text = "<b>AWaRe Category</b>", font = list(size = 10))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          yaxis = list(automargin = TRUE, categoryorder = "array", categoryarray = rev(ordered_labels)),
          xaxis = list(automargin = TRUE)
        ) %>%
        layout(
          shapes = list(list(
            type = "rect", xref = "paper", yref = "y", x0 = 0, x1 = 1,
            y0 = length(ordered_labels) - 0.5, 
            y1 = length(ordered_labels) + 0.5 - (length(ordered_labels)-1),
            fillcolor = "rgba(240,240,240,0.5)",
            line = list(width = 0),
            layer = "below"
          ))
        )
      
      plt
    })
    
    # ---------- Route Administration Plot (split IV/Oral/Other) ----------
    output$route_administration_plot <- renderPlotly({
      wd <- watch_data_reactive()
      if (is.null(wd)) {
        return(plotly_empty() %>% layout(title = list(text = "No data available")))
      }
      
      data_pneu_eligible <- wd$data_pneu_eligible
      
      # Modified logic to split IV, Oral, and Other
      watch_route_summary <- data_pneu_eligible %>%
        filter(AWaRe == "WATCH") %>%
        mutate(
          Route_Clean = case_when(
            Route == "P" ~ "IV",
            Route == "O" ~ "Oral",
            TRUE ~ "Other"
          )
        ) %>%
        group_by(`Department name`, `Survey Number`, Route_Clean) %>%
        summarise(Prescriptions = n(), .groups = "drop") %>%
        group_by(`Department name`, Route_Clean) %>%
        summarise(Patients = n_distinct(`Survey Number`), .groups = "drop") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = ifelse(Total > 0, Patients / Total, 0)
        )
      
      # Hospital-wide summary
      hospital_watch_summary <- watch_route_summary %>%
        group_by(Route_Clean) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(
          `Department name` = "Hospital-Wide",
          Total = sum(Patients),
          Proportion = ifelse(Total > 0, Patients / Total, 0)
        ) %>%
        select(names(watch_route_summary))
      
      watch_route_final <- bind_rows(watch_route_summary, hospital_watch_summary)
      
      # Complete combinations with three route levels
      route_levels <- c("IV", "Oral", "Other")
      all_combos3 <- expand_grid(
        `Department name` = unique(watch_route_final$`Department name`),
        Route_Clean = route_levels
      )
      
      watch_route_final <- all_combos3 %>%
        left_join(watch_route_final, by = c("Department name", "Route_Clean")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total > 0, Patients / Total, 0)
        )
      
      # Format labels
      watch_route_final <- watch_route_final %>%
        mutate(
          PlotLabel = ifelse(
            `Department name` == "Hospital-Wide",
            "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`
          )
        )
      
      # Order departments (Hospital-Wide first)
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(setdiff(unique(watch_route_final$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>"))
      )
      watch_route_final$PlotLabel <- factor(watch_route_final$PlotLabel, levels = ordered_labels)
      watch_route_final$Route_Clean <- factor(watch_route_final$Route_Clean, levels = route_levels)
      
      # Color palette matching previous codes
      palette <- c(
        "IV" = "#4682B4",
        "Oral" = "#CD5C5C",
        "Other" = "#A9A9A9"
      )
      
      # Create ggplot
      p <- ggplot(
        watch_route_final, 
        aes(
          x = PlotLabel, y = Proportion, fill = Route_Clean,
          text = paste0(
            "Department: ", `Department name`, "<br>",
            "Route: ", Route_Clean, "<br>",
            "Patients: ", Patients, "<br>",
            "Total: ", Total, "<br>",
            "Proportion: ", scales::percent(Proportion, accuracy = 0.1)
          )
        )
      ) +
        geom_bar(stat = "identity", position = "fill", width = 0.7) +
        geom_text(
          aes(label = ifelse(Proportion > 0.05, 
                             paste0(round(Proportion * 100), "%"), "")),
          position = position_fill(vjust = 0.5),
          size = 2.6, color = "white", fontface = "bold"
        ) +
        geom_text(
          data = watch_route_final %>% distinct(PlotLabel, Total),
          aes(x = PlotLabel, y = 1.02, label = paste0("n=", Total)),
          inherit.aes = FALSE, size = 3, color = "gray30", hjust = 0.5
        ) +
        scale_fill_manual(
          values = palette,
          labels = c("IV" = "IV", "Oral" = "Oral", "Other" = "Other"),
          drop = FALSE
        ) +
        scale_y_continuous(limits = c(0, 1.08), expand = c(0, 0),
                           labels = scales::percent_format(accuracy = 1)) +
        scale_x_discrete(expand = c(0.01, 0.01)) +
        labs(
          title = NULL,
          subtitle = NULL,
          x = "Department",
          y = "Proportion of Patients",
          fill = "Route"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.x = ggtext::element_markdown(size = 7, angle = 45, hjust = 1),
          axis.text.y = element_text(size = 7),
          axis.title = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text = element_text(size = 8),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          plot.margin = margin(6, 8, 6, 8)
        ) +
        guides(fill = guide_legend(nrow = 1, byrow = TRUE, title.position = "top"))
      
      # Convert to plotly
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Route of Administration for WATCH Antibiotics (Pneumonia Patients)</b><br>"
            ),
            x = 0.5, xanchor = "center",
            y = 0.97, yanchor = "top",
            font = list(size = 12)
          ),
          height = 450,
          width = 680,
          margin = list(l = 30, r = 30, t = 60, b = 180),
          legend = list(
            orientation = "h",
            x = 0.5, xanchor = "center",
            y = -0.70, yanchor = "top",
            font = list(size = 9),
            title = list(text = "<b>Route</b>", font = list(size = 9))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          xaxis = list(
            automargin = TRUE,
            tickangle = 45,
            categoryorder = "array",
            categoryarray = ordered_labels,
            title = list(
              text = "<b>Department</b>",
              standoff = 20
            )
          ),
          yaxis = list(
            automargin = TRUE,
            title = list(
              text = "<b>Proportion of Patients</b>",
              standoff = 20
            )
          )
        ) %>%
        layout(
          shapes = list(list(
            type = "rect",
            xref = "x",
            yref = "paper",
            x0 = 0.5, x1 = 1.5,
            y0 = 0, y1 = 1,
            fillcolor = "rgba(240,240,240,0.5)",
            line = list(width = 0),
            layer = "below"
          ))
        )
      
      # Remove duplicate legend entries
      legend_names <- vapply(plt$x$data, function(tr) tr$name %||% "", character(1))
      dup_idx <- which(duplicated(legend_names) | grepl("^n=", legend_names))
      if (length(dup_idx)) {
        plt <- plotly::style(plt, showlegend = FALSE, traces = dup_idx)
      }
      
      plt
    })
    
    # =======================
    # CHOICE DATA REACTIVE - MATCHING R MARKDOWN EXACTLY
    # =======================
    choice_data_reactive <- reactive({
      if (!check_data()) return(NULL)
      data <- data_reactive()
      data_patients <- data$data_patients %>%
        mutate(Route = toupper(Route))
      data_lookup <- data$data_lookup
      
      # EXACT R markdown preparation
      data_Pneu_choice <- data_patients %>%
        filter(`Diagnosis code` == "Pneu") %>%
        mutate(
          Route = toupper(Route),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      # Get lookup names
      lookup_names <- data_lookup %>%
        filter(Code == "H_RESP_APPROP_ABX") %>%
        select(starts_with("ABX-ATC")) %>%
        unlist(use.names = FALSE)
      
      data_Pneu_choice <- data_Pneu_choice %>%
        mutate(Drug_Match = ATC5 %in% lookup_names)
      
      lookup_Pneu_choice <- data_lookup %>%
        filter(Code == "H_RESP_APPROP_ABX")
      
      lookup_long <- tibble(
        Drug = unlist(lookup_Pneu_choice %>% select(starts_with("ABX-ATC")), use.names = FALSE),
        Choice = unlist(lookup_Pneu_choice %>% select(starts_with("ABX-CHOICE")), use.names = FALSE)
      ) %>%
        filter(!is.na(Drug)) %>%
        distinct()
      
      data_Pneu_choice <- data_Pneu_choice %>%
        left_join(lookup_long, by = c("ATC5" = "Drug"))
      
      # EXACT R markdown Patient Summary
      patient_summary_Pneu <- data_Pneu_choice %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          Abx_names = list(unique(ATC5)),
          
          Match_1_P   = any(ATC5 == lookup_names[1] & Route == "P"),
          Match_2_P   = any(ATC5 == lookup_names[2] & Route == "P"),
          Match_3_P   = any(ATC5 == lookup_names[3] & Route == "P"),
          Match_3_O   = any(ATC5 == lookup_names[3] & Route == "O"),
          Match_4_P   = any(ATC5 == lookup_names[4] & Route == "P"),
          Match_5_O   = any(ATC5 == lookup_names[5] & Route == "O"),
          Match_6_O   = any(ATC5 == lookup_names[6] & Route == "O"),
          Match_7_O   = any(ATC5 == lookup_names[7] & Route == "O"),
          Match_8_O   = any(ATC5 == lookup_names[8] & Route == "O"),
          
          Any_Oral    = any(Route == "O"),
          Any_IV      = any(Route == "P"),
          N_ABX       = n_distinct(ATC5),
          .groups = "drop"
        ) %>%
        rowwise() %>%
        mutate(
          Num_recommended_IV_given   = sum(c_across(c(Match_1_P, Match_2_P, Match_3_P, Match_4_P))),
          Num_recommended_ORAL_given = sum(c_across(c(Match_5_O, Match_6_O, Match_7_O, Match_8_O))),
          All_IV_names_flat = paste0(unlist(Abx_names), collapse = ","),
          
          # EXACT R markdown logic
          Received_full_recommended_IV = (
            (
              (Match_1_P & Num_recommended_IV_given == 1 & N_ABX == 1) |
                (Match_2_P & Num_recommended_IV_given == 1 & N_ABX == 1) |
                (Match_4_P & Num_recommended_IV_given == 1 & N_ABX == 1)
            ) |
              (
                ((Match_1_P & Match_3_P) |
                   (Match_2_P & Match_3_P) |
                   (Match_4_P & Match_3_P)) &
                  Num_recommended_IV_given == 2 & N_ABX == 2
              ) |
              (
                ((Match_1_P & Match_3_O) |
                   (Match_2_P & Match_3_O) |
                   (Match_4_P & Match_3_O)) &
                  Num_recommended_IV_given == 1 & N_ABX == 2
              )
          ),
          
          Received_no_recommended_IV = (Any_IV & Num_recommended_IV_given == 0),
          
          Received_partial_recommended_IV = Any_IV &
            Num_recommended_IV_given > 0 &
            !Received_full_recommended_IV,
          
          Received_full_recommended_ORAL = (
            (Match_5_O & Num_recommended_ORAL_given == 1 & N_ABX == 1) |
              (Match_6_O & Num_recommended_ORAL_given == 1 & N_ABX == 1) |
              (Match_7_O & Num_recommended_ORAL_given == 1 & N_ABX == 1) |
              (Match_8_O & Num_recommended_ORAL_given == 1 & N_ABX == 1)
          ),
          
          Received_no_recommended_ORAL = Any_Oral & Num_recommended_ORAL_given == 0 & !Received_full_recommended_IV,
          
          Received_partial_recommended_ORAL = Any_Oral &
            Num_recommended_ORAL_given > 0 &
            !Received_full_recommended_ORAL,
          
          # CRITICAL: These two categories from R markdown
          Received_any_IV = Any_IV &
            !Received_full_recommended_ORAL &
            !Received_partial_recommended_ORAL &
            !Received_no_recommended_ORAL,
          
          Received_any_ORAL = Any_Oral &
            !Received_full_recommended_IV &
            !Received_partial_recommended_IV &
            !Received_no_recommended_IV,
          
          Other_non_IV_or_oral = !Received_full_recommended_IV &
            !Received_full_recommended_ORAL &
            !Received_partial_recommended_IV &
            !Received_partial_recommended_ORAL &
            !Received_no_recommended_IV &
            !Received_no_recommended_ORAL
        ) %>%
        ungroup()
      
      list(
        data_Pneu_choice = data_Pneu_choice,
        patient_summary_Pneu = patient_summary_Pneu
      )
    })
    
    # =======================
    # CHOICE SEVERE PLOT - EXACT R MARKDOWN MATCH
    # =======================
    # =======================
    # CHOICE SEVERE PLOT - WITH CORRECT COLORS
    # =======================
    output$choice_severe_plot <- renderPlotly({
      ch <- choice_data_reactive()
      if (is.null(ch)) return(plotly_empty())
      
      patient_summary_Pneu <- ch$patient_summary_Pneu
      data_Pneu_choice <- ch$data_Pneu_choice
      
      # Get not eligible patients (exact R markdown)
      not_eligible_patients_Pneu <- data_Pneu_choice %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary table - EXACT R markdown with ALL 10 categories
      eligible_long_Pneu <- patient_summary_Pneu %>%
        select(`Survey Number`, `Department name`, 
               Received_full_recommended_IV, Received_full_recommended_ORAL,
               Received_partial_recommended_IV, Received_partial_recommended_ORAL,
               Received_no_recommended_IV, Received_no_recommended_ORAL,
               Received_any_IV, Received_any_ORAL, Other_non_IV_or_oral) %>%
        pivot_longer(
          cols = -c(`Survey Number`, `Department name`),
          names_to = "Indicator",
          values_to = "Value"
        ) %>%
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Complete combinations
      all_combos <- expand_grid(
        `Department name` = unique(patient_summary_Pneu$`Department name`),
        Indicator = c("Received_full_recommended_IV", "Received_full_recommended_ORAL",
                      "Received_partial_recommended_IV", "Received_partial_recommended_ORAL",
                      "Received_no_recommended_IV", "Received_no_recommended_ORAL",
                      "Received_any_IV", "Received_any_ORAL",
                      "Other_non_IV_or_oral", "Not_Eligible")
      )
      
      eligible_long_Pneu <- all_combos %>%
        left_join(eligible_long_Pneu, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      # Add ineligible
      ineligible_summary_Pneu <- not_eligible_patients_Pneu %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      qi_long_Pneu <- bind_rows(eligible_long_Pneu, ineligible_summary_Pneu)
      
      # Calculate totals
      dept_totals <- qi_long_Pneu %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      qi_summary_Pneu <- qi_long_Pneu %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_full_recommended_ORAL" ~ "Received recommended ORAL antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_ORAL" ~ "Partially received recommended ORAL antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Received_no_recommended_ORAL" ~ "Received ORAL antibiotics not among recommended options",
            Indicator == "Received_any_IV" ~ "Received IV antibiotics only",
            Indicator == "Received_any_ORAL" ~ "Received ORAL antibiotics only",
            Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe Pneumonia QIs",
            TRUE ~ Indicator
          ),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        select(`Department name`, Indicator, Patients, Total, Proportion)
      
      # Add Hospital-Wide
      hospital_data <- qi_summary_Pneu %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        select(`Department name`, Indicator, Patients)
      
      qi_summary_Pneu <- bind_rows(qi_summary_Pneu, hospital_data)
      
      # Recalculate totals
      qi_summary_Pneu <- qi_summary_Pneu %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # FILTER FOR IV PLOT
      iv_indicators <- c(
        "Received recommended IV antibiotics",
        "Partially received recommended IV antibiotics",
        "Received IV antibiotics not among recommended options",
        "Received ORAL antibiotics only"
      )
      
      shared_indicators <- c(
        "Received other non-IV/oral antibiotics",
        "Not eligible for AWaRe Pneumonia QIs"
      )
      
      relevant_indicators_iv <- c(iv_indicators, shared_indicators)
      
      qi_summary_Pneu_IV <- qi_summary_Pneu %>%
        filter(Indicator %in% relevant_indicators_iv) %>%
        group_by(`Department name`) %>%
        mutate(Total_IV = sum(Patients[Indicator %in% relevant_indicators_iv])) %>%
        ungroup() %>%
        filter(Total_IV > 0) %>%
        mutate(Proportion = Patients / Total_IV)
      
      # Format labels
      qi_summary_Pneu_IV <- qi_summary_Pneu_IV %>%
        mutate(
          PlotLabel = ifelse(
            `Department name` == "Hospital-Wide",
            "<b style='color:#0072B2;'>Hospital-Wide</b>",
            `Department name`
          )
        )
      
      label_order <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(setdiff(unique(qi_summary_Pneu_IV$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>"))
      )
      qi_summary_Pneu_IV$PlotLabel <- factor(qi_summary_Pneu_IV$PlotLabel, levels = label_order)
      
      indicator_levels <- relevant_indicators_iv
      qi_summary_Pneu_IV$Indicator <- factor(qi_summary_Pneu_IV$Indicator, levels = indicator_levels)
      
      # CORRECTED COLOR PALETTE
      palette <- c(
        "Received recommended IV antibiotics"                   = "#1F77B4",
        "Received recommended ORAL antibiotics"                 = "#1F77B4",
        "Partially received recommended IV antibiotics"         = "#4FA9DC",
        "Partially received recommended ORAL antibiotics"       = "#4FA9DC",
        "Received IV antibiotics not among recommended options" = "#EF476F",
        "Received ORAL antibiotics not among recommended options" = "#EF476F",
        "Received IV antibiotics only"                          = "#F9D99E",
        "Received ORAL antibiotics only"                        = "#F9D99E",
        "Received other non-IV/oral antibiotics"                = "#D3D3D3",
        "Not eligible for AWaRe Pneumonia QIs"                        = "#A9A9A9"
      )
      
      # Create plot
      p <- ggplot(
        qi_summary_Pneu_IV,
        aes(
          x = PlotLabel, y = Proportion, fill = Indicator,
          text = paste0(
            "Department: ", `Department name`, "<br>",
            "Category: ", Indicator, "<br>",
            "Patients: ", Patients, "<br>",
            "Total: ", Total_IV
          )
        )
      ) +
        geom_bar(stat = "identity", position = "fill", width = 0.7) +
        geom_text(
          aes(label = ifelse(Patients > 0, Patients, "")),
          position = position_fill(vjust = 0.5),
          size = 2.6, color = "black"
        ) +
        geom_text(
          data = qi_summary_Pneu_IV %>% distinct(PlotLabel, Total_IV),
          aes(x = PlotLabel, y = 1.02, label = paste0("n=", Total_IV)),
          inherit.aes = FALSE, size = 3, color = "gray30", hjust = 0.5
        ) +
        scale_fill_manual(values = palette, drop = FALSE) +
        scale_y_continuous(limits = c(0, 1.08), expand = c(0, 0),
                           labels = scales::percent_format(accuracy = 1)) +
        scale_x_discrete(expand = c(0.01, 0.01)) +
        labs(
          x = "Department",
          y = "Proportion Patients",
          fill = "Treatment Appropriateness Category"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.x = ggtext::element_markdown(size = 7, angle = 45, hjust = 1),
          axis.text.y = element_text(size = 7),
          axis.title  = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text  = element_text(size = 8),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          plot.margin  = margin(6, 8, 6, 8)
        ) +
        guides(fill = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"))
      
      # Convert to plotly
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>IV Antibiotic Alignment for Pneumonia</b>",
            x = 0.5, xanchor = "center",
            y = 0.97, yanchor = "top",
            font = list(size = 12)
          ),
          height = 450,
          width  = 680,
          margin = list(l = 30, r = 30, t = 60, b = 200),
          legend = list(
            orientation = "h",
            x = 0.5, xanchor = "center",
            y = -0.75, yanchor = "top",
            font = list(size = 9),
            title = list(text = "<b>Treatment Alignment Classifcation</b>", font = list(size = 9))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          shapes = list(list(
            type = "rect",
            xref = "x",
            yref = "paper",
            x0 = 0.5, x1 = 1.5,
            y0 = 0, y1 = 1,
            fillcolor = "rgba(240,240,240,0.5)",
            line = list(width = 0),
            layer = "below"
          ))
        )
      
      plt
    })
    
    # =======================
    # CHOICE MILD PLOT - EXACT R MARKDOWN MATCH
    # =======================
    output$choice_mild_plot <- renderPlotly({
      ch <- choice_data_reactive()
      if (is.null(ch)) return(plotly_empty())
      
      patient_summary_Pneu <- ch$patient_summary_Pneu
      data_Pneu_choice <- ch$data_Pneu_choice
      
      # Get not eligible patients (exact R markdown)
      not_eligible_patients_Pneu <- data_Pneu_choice %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary table - EXACT R markdown with ALL 10 categories
      eligible_long_Pneu <- patient_summary_Pneu %>%
        select(`Survey Number`, `Department name`, 
               Received_full_recommended_IV, Received_full_recommended_ORAL,
               Received_partial_recommended_IV, Received_partial_recommended_ORAL,
               Received_no_recommended_IV, Received_no_recommended_ORAL,
               Received_any_IV, Received_any_ORAL, Other_non_IV_or_oral) %>%
        pivot_longer(
          cols = -c(`Survey Number`, `Department name`),
          names_to = "Indicator",
          values_to = "Value"
        ) %>%
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Complete combinations
      all_combos <- expand_grid(
        `Department name` = unique(patient_summary_Pneu$`Department name`),
        Indicator = c("Received_full_recommended_IV", "Received_full_recommended_ORAL",
                      "Received_partial_recommended_IV", "Received_partial_recommended_ORAL",
                      "Received_no_recommended_IV", "Received_no_recommended_ORAL",
                      "Received_any_IV", "Received_any_ORAL",
                      "Other_non_IV_or_oral", "Not_Eligible")
      )
      
      eligible_long_Pneu <- all_combos %>%
        left_join(eligible_long_Pneu, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      # Add ineligible
      ineligible_summary_Pneu <- not_eligible_patients_Pneu %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      qi_long_Pneu <- bind_rows(eligible_long_Pneu, ineligible_summary_Pneu)
      
      # Calculate totals
      dept_totals <- qi_long_Pneu %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      qi_summary_Pneu <- qi_long_Pneu %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_full_recommended_ORAL" ~ "Received recommended ORAL antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_ORAL" ~ "Partially received recommended ORAL antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Received_no_recommended_ORAL" ~ "Received ORAL antibiotics not among recommended options",
            Indicator == "Received_any_IV" ~ "Received IV antibiotics only",
            Indicator == "Received_any_ORAL" ~ "Received ORAL antibiotics only",
            Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe Pneumonia QIs",
            TRUE ~ Indicator
          ),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        select(`Department name`, Indicator, Patients, Total, Proportion)
      
      # Add Hospital-Wide
      hospital_data <- qi_summary_Pneu %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        select(`Department name`, Indicator, Patients)
      
      qi_summary_Pneu <- bind_rows(qi_summary_Pneu, hospital_data)
      
      # Recalculate totals
      qi_summary_Pneu <- qi_summary_Pneu %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # FILTER FOR ORAL PLOT - matching R markdown
      oral_indicators <- c(
        "Received recommended ORAL antibiotics",
        "Partially received recommended ORAL antibiotics",
        "Received ORAL antibiotics not among recommended options",
        "Received IV antibiotics only"
      )
      
      shared_indicators <- c(
        "Received other non-IV/oral antibiotics",
        "Not eligible for AWaRe Pneumonia QIs"
      )
      
      relevant_indicators_oral <- c(oral_indicators, shared_indicators)
      
      qi_summary_Pneu_ORAL <- qi_summary_Pneu %>%
        filter(Indicator %in% relevant_indicators_oral) %>%
        group_by(`Department name`) %>%
        mutate(Total_ORAL = sum(Patients[Indicator %in% relevant_indicators_oral])) %>%
        ungroup() %>%
        filter(Total_ORAL > 0) %>%
        mutate(Proportion = Patients / Total_ORAL)
      
      # Format labels
      qi_summary_Pneu_ORAL <- qi_summary_Pneu_ORAL %>%
        mutate(
          PlotLabel = ifelse(
            `Department name` == "Hospital-Wide",
            "<b style='color:#0072B2;'>Hospital-Wide</b>",
            `Department name`
          )
        )
      
      label_order <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(setdiff(unique(qi_summary_Pneu_ORAL$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>"))
      )
      qi_summary_Pneu_ORAL$PlotLabel <- factor(qi_summary_Pneu_ORAL$PlotLabel, levels = label_order)
      
      indicator_levels <- relevant_indicators_oral
      qi_summary_Pneu_ORAL$Indicator <- factor(qi_summary_Pneu_ORAL$Indicator, levels = indicator_levels)
      
      # Color palette
      palette <- c(
        "Received recommended IV antibiotics"                   = "#1F77B4",
        "Received recommended ORAL antibiotics"                 = "#1F77B4",
        "Partially received recommended IV antibiotics"         = "#4FA9DC",
        "Partially received recommended ORAL antibiotics"       = "#4FA9DC",
        "Received IV antibiotics not among recommended options" = "#EF476F",
        "Received ORAL antibiotics not among recommended options" = "#EF476F",
        "Received IV antibiotics only"                          = "#F9D99E",
        "Received ORAL antibiotics only"                        = "#F9D99E",
        "Received other non-IV/oral antibiotics"                = "#D3D3D3",
        "Not eligible for AWaRe Pneumonia QIs"                        = "#A9A9A9"
      )
      
      # Create plot
      p <- ggplot(
        qi_summary_Pneu_ORAL,
        aes(
          x = PlotLabel, y = Proportion, fill = Indicator,
          text = paste0(
            "Department: ", `Department name`, "<br>",
            "Category: ", Indicator, "<br>",
            "Patients: ", Patients, "<br>",
            "Total: ", Total_ORAL
          )
        )
      ) +
        geom_bar(stat = "identity", position = "fill", width = 0.7) +
        geom_text(
          aes(label = ifelse(Patients > 0, Patients, "")),
          position = position_fill(vjust = 0.5),
          size = 2.6, color = "black"
        ) +
        geom_text(
          data = qi_summary_Pneu_ORAL %>% distinct(PlotLabel, Total_ORAL),
          aes(x = PlotLabel, y = 1.02, label = paste0("n=", Total_ORAL)),
          inherit.aes = FALSE, size = 3, color = "gray30", hjust = 0.5
        ) +
        scale_fill_manual(values = palette, drop = FALSE) +
        scale_y_continuous(limits = c(0, 1.08), expand = c(0, 0),
                           labels = scales::percent_format(accuracy = 1)) +
        scale_x_discrete(expand = c(0.01, 0.01)) +
        labs(
          x = "Department",
          y = "Proportion Patients",
          fill = "Treatment Appropriateness Category"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.x = ggtext::element_markdown(size = 7, angle = 45, hjust = 1),
          axis.text.y = element_text(size = 7),
          axis.title  = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text  = element_text(size = 8),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          plot.margin  = margin(6, 8, 6, 8)
        ) +
        guides(fill = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"))
      
      # Convert to plotly
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>ORAL Antibiotic Alignment for Pneumonia</b>",
            x = 0.5, xanchor = "center",
            y = 0.97, yanchor = "top",
            font = list(size = 12)
          ),
          height = 450,
          width  = 680,
          margin = list(l = 30, r = 30, t = 60, b = 200),
          legend = list(
            orientation = "h",
            x = 0.5, xanchor = "center",
            y = -0.75, yanchor = "top",
            font = list(size = 9),
            title = list(text = "<b>Treatment Alignment Classification</b>", font = list(size = 9))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          shapes = list(list(
            type = "rect",
            xref = "x",
            yref = "paper",
            x0 = 0.5, x1 = 1.5,
            y0 = 0, y1 = 1,
            fillcolor = "rgba(240,240,240,0.5)",
            line = list(width = 0),
            layer = "below"
          ))
        )
      
      plt
    })
    
    # ---- choice_aware_plot (horizontal bars fourth document style) ----
    output$choice_aware_plot <- renderPlotly({
      ch <- choice_data_reactive()
      if (is.null(ch)) {
        return(
          plotly::plotly_empty(type = "scatter", mode = "markers") %>%
            plotly::layout(
              title = list(text = "No data available"),
              xaxis = list(visible = FALSE),
              yaxis = list(visible = FALSE),
              showlegend = FALSE
            )
        )
      }
      
      data_pneu_choice <- ch$data_Pneu_choice
      
      # Classify antibiotics into AWaRe groups (matching R markdown)
      data_Pneu_AWaRe <- data_pneu_choice %>%
        mutate(
          AWaRe2 = case_when(
            ATC5 %in% c("J01CA04", "J01CE02", "J01CR02", "J01AA02") ~ "ACCESS", 
            ATC5 %in% c("J01DD01", "J01DD04", "J01FA09") ~ "WATCH",
            TRUE ~ NA_character_
          )
        )
      
      # Filter valid cases
      aware_expanded <- data_Pneu_AWaRe %>%
        filter(AWaRe_compatible, Route %in% c("P", "O"), !is.na(AWaRe2)) %>%
        select(`Survey Number`, `Department name`, AWaRe2) %>%
        distinct()
      
      if (nrow(aware_expanded) == 0) {
        return(
          plotly::plotly_empty(type = "scatter", mode = "markers") %>%
            plotly::layout(
              title = list(text = "No data available for AWaRe classification"),
              xaxis = list(visible = FALSE),
              yaxis = list(visible = FALSE),
              showlegend = FALSE
            )
        )
      }
      
      # Summarise by department and AWaRe2
      AWaRe_long <- aware_expanded %>%
        group_by(`Department name`, AWaRe2) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Add Hospital-Wide
      AWaRe_hospital_data <- aware_expanded %>%
        group_by(AWaRe2) %>%
        summarise(Patients = n(), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      AWaRe_long <- bind_rows(AWaRe_long, AWaRe_hospital_data)
      
      # Calculate totals and proportions
      AWaRe_long <- AWaRe_long %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Colors matching R markdown
      aware_colors <- c("ACCESS" = "#1b9e77", "WATCH" = "#ff7f00")
      
      # Define all AWaRe categories (for legend and completeness) - ORDERED
      all_aware_categories <- names(aware_colors)
      
      # Fill in all missing Department × Category combos (0 patients)
      complete_summary <- expand_grid(
        `Department name` = unique(AWaRe_long$`Department name`),
        AWaRe2 = all_aware_categories
      ) %>%
        left_join(AWaRe_long, by = c("Department name", "AWaRe2")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, Patients / Total),
          AWaRe2 = factor(AWaRe2, levels = all_aware_categories)
        )
      
      # Labels and hover text
      complete_summary <- complete_summary %>%
        filter(Total > 0) %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          ProportionPct = Proportion * 100,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>AWaRe Classification:</b> ", as.character(AWaRe2), "<br>",
            "<b>Patients:</b> ", Patients, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      # Ordered labels (Hospital-Wide first)
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(setdiff(unique(complete_summary$PlotLabel),
                     "<b style='color:#0072B2;'>Hospital-Wide</b>"))
      )
      complete_summary$PlotLabel <- factor(complete_summary$PlotLabel, levels = ordered_labels)
      
      # n= labels
      label_data <- complete_summary %>%
        distinct(`Department name`, PlotLabel, Total)
      
      # Dynamic buffer for n= labels (fourth document style)
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # Create plot (horizontal bars - fourth document style)
      p <- ggplot(complete_summary, aes(y = PlotLabel, x = ProportionPct, fill = AWaRe2, text = hover_text)) +
        geom_bar(stat = "identity", position = "fill", width = 0.85) +
        geom_text(
          aes(label = ifelse(Proportion > 0.05, paste0(round(ProportionPct, 0), "%"), "")),
          position = position_fill(vjust = 0.5),
          size = 3, color = "black"
        ) +
        geom_text(
          data = label_data,
          aes(y = PlotLabel, label = ifelse(Total > 0, paste0("n=", formatC(Total, format = "d", big.mark = ",")), "")),
          x = label_x,
          inherit.aes = FALSE, size = 3, color = "gray30", vjust = 0.5, hjust = 0
        ) +
        scale_fill_manual(values = aware_colors, drop = FALSE) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
          x = "Proportion of Patients",
          y = "Department",
          fill = "AWaRe Classification"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.y = ggtext::element_markdown(size = 7),
          axis.text.x = element_text(size = 7),
          axis.title  = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text  = element_text(size = 8),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          plot.margin  = margin(6, 18, 6, 8)
        ) +
        guides(fill = guide_legend(nrow = 1, byrow = TRUE, title.position = "top")) +
        scale_y_discrete(limits = rev(levels(complete_summary$PlotLabel)))
      
      # Convert to plotly (fourth document style)
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Use of Recommended IV/ORAL Antibiotics by AWaRe Classification for Pneumonia</b><br>"
            ),
            x = 0.5, xanchor = "center",
            y = 0.98, yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width  = 680,
          margin = list(l = 30, r = r_margin, t = 70, b = 170),
          legend = list(
            orientation = "h", x = 0.5, xanchor = "center",
            y = -0.40, yanchor = "top",
            font = list(size = 10),
            title = list(text = "<b>AWaRe Classification</b>", font = list(size = 10))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          yaxis = list(automargin = TRUE, categoryorder = "array", categoryarray = rev(ordered_labels)),
          xaxis = list(automargin = TRUE)
        ) %>%
        layout(
          shapes = list(list(
            type = "rect", xref = "paper", yref = "y", x0 = 0, x1 = 1,
            y0 = length(ordered_labels) - 0.5, 
            y1 = length(ordered_labels) + 0.5 - (length(ordered_labels)-1),
            fillcolor = "rgba(240,240,240,0.5)",
            line = list(width = 0),
            layer = "below"
          ))
        )
      
      plt
    })
    
    # ---------- By Line of Treatment Plot (horizontal bars fourth document style) ----------
    output$choice_line_plot <- renderPlotly({
      ch <- choice_data_reactive()
      if (is.null(ch)) {
        return(
          plotly::plotly_empty(type = "scatter", mode = "markers") %>%
            plotly::layout(
              title = list(text = "No data available"),
              xaxis = list(visible = FALSE),
              yaxis = list(visible = FALSE),
              showlegend = FALSE
            )
        )
      }
      data_pneu_choice <- ch$data_Pneu_choice
      
      # Matching R markdown logic for line of treatment
      choice_levels_stack  <- c("Second choice","First choice")
      choice_levels_legend <- c("First choice","Second choice")
      
      # Department-level summary
      choice_summary <- data_pneu_choice %>%
        filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL",
               AWaRe %in% AWaRe_abx, Route %in% c("P", "O"), !is.na(Choice)) %>%
        group_by(`Department name`, Choice) %>%
        summarise(Prescriptions = n(), .groups = "drop")
      
      # Add totals and proportions per department
      choice_dept_totals <- choice_summary %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Prescriptions), .groups = "drop")
      
      choice_summary <- choice_summary %>%
        left_join(choice_dept_totals, by = "Department name") %>%
        mutate(Proportion = round(Prescriptions / Total, 3))
      
      # Add Hospital-Wide totals
      hospital_summary <- choice_summary %>%
        group_by(Choice) %>%
        summarise(Prescriptions = sum(Prescriptions), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      choice_summary <- bind_rows(choice_summary, hospital_summary)
      
      # Recalculate totals and proportions with Hospital-Wide
      choice_summary <- choice_summary %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Prescriptions),
          Proportion = Prescriptions / Total
        ) %>%
        ungroup()
      
      # Ensure all departments × choices exist
      dept_list <- unique(choice_summary$`Department name`)
      
      complete_data <- expand_grid(
        `Department name` = dept_list,
        Choice = choice_levels_stack
      ) %>%
        left_join(choice_summary, by = c("Department name", "Choice")) %>%
        mutate(
          Prescriptions = replace_na(Prescriptions, 0),
          Total = ave(Prescriptions, `Department name`, FUN = sum),
          Proportion = ifelse(Total > 0, Prescriptions / Total, 0)
        )
      
      # Filter out departments with no data
      complete_data <- complete_data %>%
        group_by(`Department name`) %>%
        mutate(dept_total_check = sum(Prescriptions, na.rm = TRUE)) %>%
        ungroup() %>%
        filter(dept_total_check > 0) %>%
        select(-dept_total_check)
      
      if(nrow(complete_data) == 0) {
        return(plotly_empty() %>%
                 layout(title = list(text = "No data available for choice analysis",
                                     font = list(size = 12))))
      }
      
      complete_data$Choice <- factor(complete_data$Choice, levels = choice_levels_stack)
      
      # Labels and hover text
      complete_data <- complete_data %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          IsHospitalWide = (`Department name` == "Hospital-Wide"),
          ProportionPct = Proportion * 100,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Treatment Choice:</b> ", as.character(Choice), "<br>",
            "<b>Count:</b> ", Prescriptions, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      # Ordered labels
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(unique(complete_data$PlotLabel[complete_data$PlotLabel != "<b style='color:#0072B2;'>Hospital-Wide</b>"]))
      )
      complete_data$PlotLabel <- factor(complete_data$PlotLabel, levels = ordered_labels)
      
      # Create label_data from Total
      label_data <- complete_data %>%
        group_by(`Department name`, PlotLabel) %>%
        summarise(Total = sum(Prescriptions, na.rm = TRUE), .groups = "drop") %>%
        mutate(
          PlotLabel = factor(PlotLabel, levels = levels(complete_data$PlotLabel))
        )
      
      # Dynamic buffer
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # ggplot
      p <- ggplot(complete_data, aes(y = PlotLabel, x = ProportionPct, fill = Choice, text = hover_text)) +
        geom_bar(stat = "identity", position = "fill", width = 0.85) +
        geom_text(
          aes(label = ifelse(Proportion > 0.05, paste0(round(ProportionPct, 0), "%"), "")),
          position = position_fill(vjust = 0.5),
          size = 3, color = "black"
        ) +
        geom_text(
          data = label_data,
          aes(y = PlotLabel, label = paste0("n=", formatC(Total, format = "d", big.mark = ","))),
          x = label_x,
          inherit.aes = FALSE, size = 3, color = "gray30", vjust = 0.5, hjust = 0
        ) +
        scale_fill_manual(
          breaks = choice_levels_legend,
          values = c(
            "First choice"  = "#8E44AD",
            "Second choice" = "#00BCD4"
          ),
          drop = FALSE
        ) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
          title = NULL,
          subtitle = NULL,
          x = "Proportion of Patients",
          y = "Department",
          fill = "Treatment Choice"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.y = ggtext::element_markdown(size = 7),
          axis.text.x = element_text(size = 7),
          axis.title  = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text  = element_text(size = 8),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          plot.margin  = margin(6, 18, 6, 8)
        ) +
        guides(
          fill = guide_legend(
            nrow = 1, 
            byrow = TRUE, 
            title.position = "top",
            override.aes = list(fill = c("#8E44AD", "#00BCD4"))
          )
        ) +
        scale_y_discrete(limits = rev(levels(complete_data$PlotLabel)))
      
      # Convert to plotly
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Use of Recommended Antibiotics by Line of Treatment</b><br>"
            ),
            x = 0.5, xanchor = "center",
            y = 0.98, yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width  = 680,
          margin = list(l = 30, r = r_margin, t = 60, b = 170),
          legend = list(
            orientation = "h", x = 0.5, xanchor = "center",
            y = -0.40, yanchor = "top",
            font = list(size = 10),
            title = list(text = "<b>Treatment Choice</b>", font = list(size = 10)),
            traceorder = "normal"
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          yaxis = list(
            automargin = TRUE, 
            categoryorder = "array", 
            categoryarray = rev(ordered_labels)
          ),
          xaxis = list(automargin = TRUE)
        ) %>%
        layout(
          shapes = list(list(
            type = "rect", xref = "paper", yref = "y", x0 = 0, x1 = 1,
            y0 = length(ordered_labels) - 0.5, 
            y1 = length(ordered_labels) + 0.5 - (length(ordered_labels)-1),
            fillcolor = "rgba(240,240,240,0.5)",
            line = list(width = 0),
            layer = "below"
          ))
        )
      
      # Force reorder legend traces in plotly
      legend_order_map <- setNames(seq_along(choice_levels_legend), choice_levels_legend)
      plt$x$data <- plt$x$data[order(sapply(plt$x$data, function(trace) {
        legend_order_map[trace$name]
      }))]
      
      plt
    })
    
    # ---------- Choice Line IV Plot (horizontal bars) ----------
    output$choice_line_iv_plot <- renderPlotly({
      ch <- choice_data_reactive()
      if (is.null(ch)) return(plotly_empty())
      
      data_pneu_choice <- ch$data_Pneu_choice
      
      # Define IV drugs
      iv_drugs <- c(
        "J01DD01",
        "J01DD04",
        "J01CR02"
      ) 
      
      # Filter for IV route and relevant drugs
      choice_summary <- data_pneu_choice %>%
        filter(
          AWaRe_compatible == TRUE,
          Route == "P",
          ATC5 %in% iv_drugs,
          Choice != "Both",
          !is.na(Choice)
        ) %>%
        group_by(`Department name`, Choice) %>%
        summarise(Prescriptions = n(), .groups = "drop") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Prescriptions),
          Proportion = Prescriptions / Total
        ) %>%
        ungroup()
      
      # Hospital-Wide totals
      hospital_summary <- choice_summary %>%
        group_by(Choice) %>%
        summarise(Prescriptions = sum(Prescriptions), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Prescriptions),
          Proportion = Prescriptions / Total
        ) %>%
        ungroup()
      
      # Combine
      choice_summary <- bind_rows(choice_summary, hospital_summary)
      
      # Ensure all departments × choices exist
      choice_levels <- c("Second choice", "First choice")
      dept_list <- unique(choice_summary$`Department name`)
      
      complete_data <- expand_grid(
        `Department name` = dept_list,
        Choice = choice_levels
      ) %>%
        left_join(choice_summary, by = c("Department name", "Choice")) %>%
        mutate(
          Prescriptions = replace_na(Prescriptions, 0),
          Total = ave(Prescriptions, `Department name`, FUN = sum),
          Proportion = ifelse(Total > 0, Prescriptions / Total, 0)
        )
      
      # Filter departments with data
      complete_data <- complete_data %>%
        group_by(`Department name`) %>%
        mutate(dept_total_check = sum(Prescriptions, na.rm = TRUE)) %>%
        ungroup() %>%
        filter(dept_total_check > 0) %>%
        select(-dept_total_check)
      
      if(nrow(complete_data) == 0) {
        return(plotly_empty() %>% layout(title = list(text = "No data available for IV choice analysis")))
      }
      
      complete_data$Choice <- factor(complete_data$Choice, levels = choice_levels)
      
      # Format labels
      complete_data <- complete_data %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          ProportionPct = Proportion * 100,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Treatment Choice:</b> ", as.character(Choice), "<br>",
            "<b>Count:</b> ", Prescriptions, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      # Ordered labels
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(setdiff(unique(complete_data$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>"))
      )
      complete_data$PlotLabel <- factor(complete_data$PlotLabel, levels = ordered_labels)
      
      # Create label_data
      label_data <- complete_data %>%
        group_by(`Department name`, PlotLabel) %>%
        summarise(Total = sum(Prescriptions, na.rm = TRUE), .groups = "drop") %>%
        mutate(PlotLabel = factor(PlotLabel, levels = levels(complete_data$PlotLabel)))
      
      # Dynamic buffer
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # ggplot
      p <- ggplot(complete_data, aes(y = PlotLabel, x = ProportionPct, fill = Choice, text = hover_text)) +
        geom_bar(stat = "identity", position = "fill", width = 0.85) +
        geom_text(
          aes(label = ifelse(Proportion > 0.05, paste0(round(Proportion * 100, 0), "%"), "")),
          position = position_fill(vjust = 0.5),
          size = 3, color = "black"
        ) +
        geom_text(
          data = label_data,
          aes(y = PlotLabel, label = paste0("n=", formatC(Total, format = "d", big.mark = ","))),
          x = label_x,
          inherit.aes = FALSE, size = 3, color = "gray30", vjust = 0.5, hjust = 0
        ) +
        scale_fill_manual(
          breaks = c("First choice", "Second choice"),
          values = c("First choice" = "#8E44AD", "Second choice" = "#00BCD4"),
          drop = FALSE,
          name = "Treatment Choice"
        ) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
          x = "Proportion of Patients",
          y = "Department",
          fill = "Treatment Choice"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.y = ggtext::element_markdown(size = 7),
          axis.text.x = element_text(size = 7),
          axis.title  = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text  = element_text(size = 8),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          plot.margin  = margin(6, 18, 6, 8)
        ) +
        guides(fill = guide_legend(nrow = 1, byrow = TRUE, title.position = "top")) +
        scale_y_discrete(limits = rev(levels(complete_data$PlotLabel)))
      
      # Convert to plotly
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>Use of Recommended IV Antibiotics by Line of Treatment</b>",
            x = 0.5, xanchor = "center",
            y = 0.98, yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width  = 680,
          margin = list(l = 30, r = r_margin, t = 60, b = 170),
          legend = list(
            orientation = "h", x = 0.5, xanchor = "center",
            y = -0.40, yanchor = "top",
            font = list(size = 10),
            title = list(text = "<b>Treatment Choice</b>", font = list(size = 10))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          yaxis = list(automargin = TRUE, categoryorder = "array", categoryarray = rev(ordered_labels)),
          xaxis = list(automargin = TRUE)
        ) %>%
        layout(
          shapes = list(list(
            type = "rect", xref = "paper", yref = "y", x0 = 0, x1 = 1,
            y0 = length(ordered_labels) - 0.5, 
            y1 = length(ordered_labels) + 0.5 - (length(ordered_labels)-1),
            fillcolor = "rgba(240,240,240,0.5)",
            line = list(width = 0),
            layer = "below"
          ))
        )
      
      plt
    })
    
    # ---------- Choice Line ORAL Plot (horizontal bars) ----------
    output$choice_line_oral_plot <- renderPlotly({
      ch <- choice_data_reactive()
      if (is.null(ch)) return(plotly_empty())
      
      data_pneu_choice <- ch$data_Pneu_choice
      
      # Define ORAL drugs
      oral_drugs <- c(
        "J01CA04",
        "J01CE02",
        "J01CR02",
        "J01AA02"
      )
      

      
      
      # Filter for ORAL route and relevant drugs
      choice_summary <- data_pneu_choice %>%
        filter(
          AWaRe_compatible == TRUE,
          Route == "O",
          ATC5 %in% oral_drugs,
          Choice != "Both",
          !is.na(Choice)
        ) %>%
        group_by(`Department name`, Choice) %>%
        summarise(Prescriptions = n(), .groups = "drop") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Prescriptions),
          Proportion = Prescriptions / Total
        ) %>%
        ungroup()
      
      # Hospital-Wide totals
      hospital_summary <- choice_summary %>%
        group_by(Choice) %>%
        summarise(Prescriptions = sum(Prescriptions), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Prescriptions),
          Proportion = Prescriptions / Total
        ) %>%
        ungroup()
      
      # Combine
      choice_summary <- bind_rows(choice_summary, hospital_summary)
      
      # Ensure all departments × choices exist
      choice_levels <- c("Second choice", "First choice")
      dept_list <- unique(choice_summary$`Department name`)
      
      complete_data <- expand_grid(
        `Department name` = dept_list,
        Choice = choice_levels
      ) %>%
        left_join(choice_summary, by = c("Department name", "Choice")) %>%
        mutate(
          Prescriptions = replace_na(Prescriptions, 0),
          Total = ave(Prescriptions, `Department name`, FUN = sum),
          Proportion = ifelse(Total > 0, Prescriptions / Total, 0)
        )
      
      # Filter departments with data
      complete_data <- complete_data %>%
        group_by(`Department name`) %>%
        mutate(dept_total_check = sum(Prescriptions, na.rm = TRUE)) %>%
        ungroup() %>%
        filter(dept_total_check > 0) %>%
        select(-dept_total_check)
      
      if(nrow(complete_data) == 0) {
        return(plotly_empty() %>% layout(title = list(text = "No data available for ORAL choice analysis")))
      }
      
      complete_data$Choice <- factor(complete_data$Choice, levels = choice_levels)
      
      # Format labels
      complete_data <- complete_data %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          ProportionPct = Proportion * 100,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Treatment Choice:</b> ", as.character(Choice), "<br>",
            "<b>Count:</b> ", Prescriptions, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      # Ordered labels
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(setdiff(unique(complete_data$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>"))
      )
      complete_data$PlotLabel <- factor(complete_data$PlotLabel, levels = ordered_labels)
      
      # Create label_data
      label_data <- complete_data %>%
        group_by(`Department name`, PlotLabel) %>%
        summarise(Total = sum(Prescriptions, na.rm = TRUE), .groups = "drop") %>%
        mutate(PlotLabel = factor(PlotLabel, levels = levels(complete_data$PlotLabel)))
      
      # Dynamic buffer
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # ggplot
      p <- ggplot(complete_data, aes(y = PlotLabel, x = ProportionPct, fill = Choice, text = hover_text)) +
        geom_bar(stat = "identity", position = "fill", width = 0.85) +
        geom_text(
          aes(label = ifelse(Proportion > 0.05, paste0(round(Proportion * 100, 0), "%"), "")),
          position = position_fill(vjust = 0.5),
          size = 3, color = "black"
        ) +
        geom_text(
          data = label_data,
          aes(y = PlotLabel, label = paste0("n=", formatC(Total, format = "d", big.mark = ","))),
          x = label_x,
          inherit.aes = FALSE, size = 3, color = "gray30", vjust = 0.5, hjust = 0
        ) +
        scale_fill_manual(
          breaks = c("First choice", "Second choice"),
          values = c("First choice" = "#8E44AD", "Second choice" = "#00BCD4"),
          drop = FALSE,
          name = "Treatment Choice"
        ) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
          x = "Proportion of Patients",
          y = "Department",
          fill = "Treatment Choice"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.y = ggtext::element_markdown(size = 7),
          axis.text.x = element_text(size = 7),
          axis.title  = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text  = element_text(size = 8),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          plot.margin  = margin(6, 18, 6, 8)
        ) +
        guides(fill = guide_legend(nrow = 1, byrow = TRUE, title.position = "top")) +
        scale_y_discrete(limits = rev(levels(complete_data$PlotLabel)))
      
      # Convert to plotly
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>Use of Recommended ORAL Antibiotics by Line of Treatment</b>",
            x = 0.5, xanchor = "center",
            y = 0.98, yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width  = 680,
          margin = list(l = 30, r = r_margin, t = 60, b = 170),
          legend = list(
            orientation = "h", x = 0.5, xanchor = "center",
            y = -0.40, yanchor = "top",
            font = list(size = 10),
            title = list(text = "<b>Treatment Choice</b>", font = list(size = 10))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          yaxis = list(automargin = TRUE, categoryorder = "array", categoryarray = rev(ordered_labels)),
          xaxis = list(automargin = TRUE)
        ) %>%
        layout(
          shapes = list(list(
            type = "rect", xref = "paper", yref = "y", x0 = 0, x1 = 1,
            y0 = length(ordered_labels) - 0.5, 
            y1 = length(ordered_labels) + 0.5 - (length(ordered_labels)-1),
            fillcolor = "rgba(240,240,240,0.5)",
            line = list(width = 0),
            layer = "below"
          ))
        )
      
      plt
    })
    
    
    
    
    
    # ---------- Choice summary - SEVERE Pneumonia (IV) - EXACT R MARKDOWN MATCH ----------
    output$choice_severe_summary <- renderUI({
      choice_data <- choice_data_reactive()
      if (is.null(choice_data)) {
        return(HTML("<p>No data available for Pneumonia IV choice summary</p>"))
      }
      
      patient_summary_Pneu <- choice_data$patient_summary_Pneu
      data_Pneu_choice <- choice_data$data_Pneu_choice
      
      # Get not eligible patients
      not_eligible_patients_Pneu <- data_Pneu_choice %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary for all categories
      eligible_long_Pneu <- patient_summary_Pneu %>%
        select(`Survey Number`, `Department name`, 
               Received_full_recommended_IV, Received_full_recommended_ORAL,
               Received_partial_recommended_IV, Received_partial_recommended_ORAL,
               Received_no_recommended_IV, Received_no_recommended_ORAL,
               Received_any_IV, Received_any_ORAL, Other_non_IV_or_oral) %>%
        pivot_longer(
          cols = -c(`Survey Number`, `Department name`),
          names_to = "Indicator",
          values_to = "Value"
        ) %>%
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos <- expand_grid(
        `Department name` = unique(patient_summary_Pneu$`Department name`),
        Indicator = c("Received_full_recommended_IV", "Received_full_recommended_ORAL",
                      "Received_partial_recommended_IV", "Received_partial_recommended_ORAL",
                      "Received_no_recommended_IV", "Received_no_recommended_ORAL",
                      "Received_any_IV", "Received_any_ORAL",
                      "Other_non_IV_or_oral", "Not_Eligible")
      )
      
      eligible_long_Pneu <- all_combos %>%
        left_join(eligible_long_Pneu, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      ineligible_summary_Pneu <- not_eligible_patients_Pneu %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      qi_long_Pneu <- bind_rows(eligible_long_Pneu, ineligible_summary_Pneu)
      
      dept_totals <- qi_long_Pneu %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      qi_summary_Pneu <- qi_long_Pneu %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_full_recommended_ORAL" ~ "Received recommended ORAL antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_ORAL" ~ "Partially received recommended ORAL antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Received_no_recommended_ORAL" ~ "Received ORAL antibiotics not among recommended options",
            Indicator == "Received_any_IV" ~ "Received IV antibiotics only",
            Indicator == "Received_any_ORAL" ~ "Received ORAL antibiotics only",
            Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe Pneumonia QIs",
            TRUE ~ Indicator
          ),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        select(`Department name`, Indicator, Patients, Total, Proportion)
      
      hospital_data <- qi_summary_Pneu %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        select(`Department name`, Indicator, Patients)
      
      qi_summary_Pneu <- bind_rows(qi_summary_Pneu, hospital_data) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # EXACT R MARKDOWN: Create qi_summary_Pneu_IV
      iv_indicators <- c(
        "Received recommended IV antibiotics",
        "Partially received recommended IV antibiotics",
        "Received IV antibiotics not among recommended options",
        "Received ORAL antibiotics only"
      )
      
      shared_indicators <- c(
        "Received other non-IV/oral antibiotics",
        "Not eligible for AWaRe Pneumonia QIs"
      )
      
      relevant_indicators_iv <- c(iv_indicators, shared_indicators)
      
      qi_summary_Pneu_IV <- qi_summary_Pneu %>%
        filter(Indicator %in% relevant_indicators_iv) %>%
        group_by(`Department name`) %>%
        mutate(Total_IV = sum(Patients[Indicator %in% relevant_indicators_iv])) %>%
        ungroup() %>%
        filter(Total_IV > 0) %>%
        mutate(Proportion = Patients / Total_IV)
      
      # EXACT R MARKDOWN DENOMINATOR CALCULATION
      total_eligible_IV <- qi_summary_Pneu_IV %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(Indicator != "Not eligible for AWaRe Pneumonia QIs") %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Total who received IV antibiotics
      total_iv <- qi_summary_Pneu %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(Indicator %in% c(
          "Received recommended IV antibiotics",
          "Partially received recommended IV antibiotics",
          "Received IV antibiotics not among recommended options"
        )) %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      relevant_data <- qi_summary_Pneu %>%
        filter(Indicator %in% c(
          "Received recommended IV antibiotics",
          "Partially received recommended IV antibiotics",
          "Received IV antibiotics not among recommended options"
        ))
      
      if (nrow(relevant_data) == 0 || total_iv == 0 || is.na(total_iv)) {
        return(HTML(glue(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing IV antibiotic choice appropriateness for Pneumonia.<br><br>
      <em>This may indicate that no patients received IV antibiotics, no patients with Pneumonia, or that none met the inclusion criteria during the reporting period.</em>
      </div>"
        )))
      }
      
      summary_data_Pneu_IV <- relevant_data %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        pivot_wider(
          names_from = Indicator,
          values_from = Patients,
          values_fill = 0
        ) %>%
        mutate(
          Total = `Received recommended IV antibiotics` +
            `Partially received recommended IV antibiotics` +
            `Received IV antibiotics not among recommended options`,
          Prop_Recommended   = `Received recommended IV antibiotics` / Total,
          Prop_Partial       = `Partially received recommended IV antibiotics` / Total,
          Prop_Not_Recommended = `Received IV antibiotics not among recommended options` / Total
        ) %>%
        filter(Total > 0)
      
      if (nrow(summary_data_Pneu_IV) == 0) {
        return(HTML(glue(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing IV antibiotic choice appropriateness for Pneumonia.<br><br>
      <em>This may indicate that no patients received IV antibiotics, no patients with Pneumonia, or that none met the inclusion criteria during the reporting period.</em>
      </div>"
        )))
      }
      
      # Intro block
      intro_text <- glue(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>
    💊 <strong>Denominator:</strong> Number of eligible Pneumonia patients who received any IV antibiotic (<strong>{total_iv}</strong> out of <strong>{total_eligible_IV}</strong>)
    </div><br><br>
    <strong>Summary:</strong><br><br>"
      )
      
      # Format department blocks
      formatted_blocks <- summary_data_Pneu_IV %>%
        mutate(
          block = pmap_chr(
            list(
              `Department name`,
              Prop_Recommended, `Received recommended IV antibiotics`,
              Prop_Partial, `Partially received recommended IV antibiotics`,
              Prop_Not_Recommended, `Received IV antibiotics not among recommended options`,
              Total
            ),
            function(dept, prop_rec, n_rec, prop_part, n_part, prop_not, n_not, total_n) {
              color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
              bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
              
              glue(
                "<div style='background-color: {bg}; border-left: 5px solid {color}; padding: 14px; margin-bottom: 20px;'>

            <strong>🏥 {dept}</strong> <span style='color: #888;'>(n = {total_n} patients)</span><br><br>

            <ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>
              <li>✅ <strong>Received recommended IV antibiotics</strong> (as per WHO AWaRe book): 
                <strong>{scales::percent(prop_rec, accuracy = 0.1)}</strong> 
                ({n_rec} out of {total_n})
              </li>
              <li>⚠️ <strong>Partially received recommended IV antibiotics</strong> (as per WHO AWaRe book): 
                <strong>{scales::percent(prop_part, accuracy = 0.1)}</strong> 
                ({n_part} out of {total_n})
              </li>
              <li>❌ <strong>Received IV antibiotics not among recommended options</strong> (as per WHO AWaRe book): 
                <strong>{scales::percent(prop_not, accuracy = 0.1)}</strong> 
                ({n_not} out of {total_n})
              </li>
            </ul>
            </div>"
              )
            }
          )
        ) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order) %>%
        pull(block)
      
      final_summary_html <- HTML(paste0(intro_text, paste(formatted_blocks, collapse = "\n")))
      final_summary_html
    })
    
    # ---------- Choice summary - MILD/MODERATE Pneumonia (ORAL) - EXACT R MARKDOWN MATCH ----------
    output$choice_mild_summary <- renderUI({
      choice_data <- choice_data_reactive()
      if (is.null(choice_data)) {
        return(HTML("<p>No data available for Pneumonia Oral choice summary</p>"))
      }
      
      patient_summary_Pneu <- choice_data$patient_summary_Pneu
      data_Pneu_choice <- choice_data$data_Pneu_choice
      
      # Get not eligible patients
      not_eligible_patients_Pneu <- data_Pneu_choice %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary for all categories
      eligible_long_Pneu <- patient_summary_Pneu %>%
        select(`Survey Number`, `Department name`, 
               Received_full_recommended_IV, Received_full_recommended_ORAL,
               Received_partial_recommended_IV, Received_partial_recommended_ORAL,
               Received_no_recommended_IV, Received_no_recommended_ORAL,
               Received_any_IV, Received_any_ORAL, Other_non_IV_or_oral) %>%
        pivot_longer(
          cols = -c(`Survey Number`, `Department name`),
          names_to = "Indicator",
          values_to = "Value"
        ) %>%
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos <- expand_grid(
        `Department name` = unique(patient_summary_Pneu$`Department name`),
        Indicator = c("Received_full_recommended_IV", "Received_full_recommended_ORAL",
                      "Received_partial_recommended_IV", "Received_partial_recommended_ORAL",
                      "Received_no_recommended_IV", "Received_no_recommended_ORAL",
                      "Received_any_IV", "Received_any_ORAL",
                      "Other_non_IV_or_oral", "Not_Eligible")
      )
      
      eligible_long_Pneu <- all_combos %>%
        left_join(eligible_long_Pneu, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      ineligible_summary_Pneu <- not_eligible_patients_Pneu %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      qi_long_Pneu <- bind_rows(eligible_long_Pneu, ineligible_summary_Pneu)
      
      dept_totals <- qi_long_Pneu %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      qi_summary_Pneu <- qi_long_Pneu %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_full_recommended_ORAL" ~ "Received recommended ORAL antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_ORAL" ~ "Partially received recommended ORAL antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Received_no_recommended_ORAL" ~ "Received ORAL antibiotics not among recommended options",
            Indicator == "Received_any_IV" ~ "Received IV antibiotics only",
            Indicator == "Received_any_ORAL" ~ "Received ORAL antibiotics only",
            Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe Pneumonia QIs",
            TRUE ~ Indicator
          ),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        select(`Department name`, Indicator, Patients, Total, Proportion)
      
      hospital_data <- qi_summary_Pneu %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        select(`Department name`, Indicator, Patients)
      
      qi_summary_Pneu <- bind_rows(qi_summary_Pneu, hospital_data) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # EXACT R MARKDOWN: Create qi_summary_Pneu_ORAL
      oral_indicators <- c(
        "Received recommended ORAL antibiotics",
        "Partially received recommended ORAL antibiotics",
        "Received ORAL antibiotics not among recommended options",
        "Received IV antibiotics only"
      )
      
      shared_indicators <- c(
        "Received other non-IV/oral antibiotics",
        "Not eligible for AWaRe Pneumonia QIs"
      )
      
      relevant_indicators_oral <- c(oral_indicators, shared_indicators)
      
      qi_summary_Pneu_ORAL <- qi_summary_Pneu %>%
        filter(Indicator %in% relevant_indicators_oral) %>%
        group_by(`Department name`) %>%
        mutate(Total_ORAL = sum(Patients[Indicator %in% relevant_indicators_oral])) %>%
        ungroup() %>%
        filter(Total_ORAL > 0) %>%
        mutate(Proportion = Patients / Total_ORAL)
      
      # EXACT R MARKDOWN DENOMINATOR CALCULATION
      total_eligible_ORAL <- qi_summary_Pneu_ORAL %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(Indicator != "Not eligible for AWaRe Pneumonia QIs") %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Total who received ORAL antibiotics
      total_oral <- qi_summary_Pneu %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(Indicator %in% c(
          "Received recommended ORAL antibiotics",
          "Partially received recommended ORAL antibiotics",
          "Received ORAL antibiotics not among recommended options"
        )) %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      relevant_data <- qi_summary_Pneu %>%
        filter(Indicator %in% c(
          "Received recommended ORAL antibiotics",
          "Partially received recommended ORAL antibiotics",
          "Received ORAL antibiotics not among recommended options"
        ))
      
      if (nrow(relevant_data) == 0 || total_oral == 0 || is.na(total_oral)) {
        return(HTML(glue(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing ORAL antibiotic choice appropriateness for Pneumonia.<br><br>
      <em>This may indicate that no patients received ORAL antibiotics, no patients with Pneumonia, or that none met the inclusion criteria during the reporting period.</em>
      </div>"
        )))
      }
      
      summary_data_Pneu_ORAL <- relevant_data %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        pivot_wider(
          names_from = Indicator,
          values_from = Patients,
          values_fill = 0
        ) %>%
        mutate(
          Total = `Received recommended ORAL antibiotics` +
            `Partially received recommended ORAL antibiotics` +
            `Received ORAL antibiotics not among recommended options`,
          Prop_Recommended   = `Received recommended ORAL antibiotics` / Total,
          Prop_Partial       = `Partially received recommended ORAL antibiotics` / Total,
          Prop_Not_Recommended = `Received ORAL antibiotics not among recommended options` / Total
        ) %>%
        filter(Total > 0)
      
      if (nrow(summary_data_Pneu_ORAL) == 0) {
        return(HTML(glue(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing ORAL antibiotic choice appropriateness for Pneumonia.<br><br>
      <em>This may indicate that no patients received ORAL antibiotics, no patients with Pneumonia, or that none met the inclusion criteria during the reporting period.</em>
      </div>"
        )))
      }
      
      # Intro block
      intro_text <- glue(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>
    💊 <strong>Denominator:</strong> Number of eligible Pneumonia patients who received any ORAL antibiotic (<strong>{total_oral}</strong> out of <strong>{total_eligible_ORAL}</strong>)
    </div><br><br>
    <strong>Summary:</strong><br><br>"
      )
      
      # Format department blocks
      formatted_blocks <- summary_data_Pneu_ORAL %>%
        mutate(
          block = pmap_chr(
            list(
              `Department name`,
              Prop_Recommended, `Received recommended ORAL antibiotics`,
              Prop_Partial, `Partially received recommended ORAL antibiotics`,
              Prop_Not_Recommended, `Received ORAL antibiotics not among recommended options`,
              Total
            ),
            function(dept, prop_rec, n_rec, prop_part, n_part, prop_not, n_not, total_n) {
              color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
              bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
              
              glue(
                "<div style='background-color: {bg}; border-left: 5px solid {color}; padding: 14px; margin-bottom: 20px;'>

            <strong>🏥 {dept}</strong> <span style='color: #888;'>(n = {total_n} patients)</span><br><br>

            <ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>
              <li>✅ <strong>Received recommended ORAL antibiotics</strong> (as per WHO AWaRe book): 
                <strong>{scales::percent(prop_rec, accuracy = 0.1)}</strong> 
                ({n_rec} out of {total_n})
              </li>
              <li>⚠️ <strong>Partially received recommended ORAL antibiotics</strong> (as per WHO AWaRe book): 
                <strong>{scales::percent(prop_part, accuracy = 0.1)}</strong> 
                ({n_part} out of {total_n})
              </li>
              <li>❌ <strong>Received ORAL antibiotics not among recommended options</strong> (as per WHO AWaRe book): 
                <strong>{scales::percent(prop_not, accuracy = 0.1)}</strong> 
                ({n_not} out of {total_n})
              </li>
            </ul>
            </div>"
              )
            }
          )
        ) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order) %>%
        pull(block)
      
      final_summary_html <- HTML(paste0(intro_text, paste(formatted_blocks, collapse = "\n")))
      final_summary_html
    })
    
    
    # =======================
    # DOSAGE DATA REACTIVE - EXACT R MARKDOWN MATCH
    # =======================
    dosage_data_reactive <- reactive({
      if (!check_data()) return(NULL)
      data <- data_reactive()
      data_patients <- data$data_patients %>%
        mutate(
          Route = toupper(Route),
          ATC5 = trimws(toupper(ATC5))
        )
      data_lookup <- data$data_lookup
      
      # Matching R markdown preparation
      data_Pneu2 <- data_patients %>%
        filter(`Diagnosis code` == "Pneu") %>%
        mutate(
          Route = toupper(Route),
          ATC5 = trimws(toupper(ATC5)),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx, 
            TRUE, FALSE
          )
        )
      
      lookup2 <- data_lookup %>% filter(Code == "H_RESP_APPROP_ABX")
      lookup_names2 <- unlist(lookup2[1, c("ABX-ATC-1", "ABX-ATC-2", "ABX-ATC-3", "ABX-ATC-4", 
                                           "ABX-ATC-5", "ABX-ATC-6", "ABX-ATC-7", "ABX-ATC-8")], use.names = FALSE)
      lookup_names2 <- toupper(trimws(lookup_names2))
      
      # Compute Total Daily Dose (matching R markdown)
      data_Pneu2 <- data_Pneu2 %>%
        mutate(
          Unit_Factor = case_when(
            Unit == "mg" ~ 1,
            Unit == "g" ~ 1000,
            Unit == "IU" ~ 1,
            Unit == "MU" ~ 1e6,
            TRUE ~ NA_real_
          ),
          Total_Daily_Dose = as.numeric(`Single Unit Dose`) * as.numeric(`N Doses/day`) * Unit_Factor
        )
      
      # Helper function
      convert_unit <- function(unit) {
        case_when(
          unit == "mg" ~ 1,
          unit == "g" ~ 1000,
          unit == "IU" ~ 1,
          unit == "MU" ~ 1e6,
          TRUE ~ NA_real_
        )
      }
      
      get_expected_dose <- function(i) {
        dose <- as.numeric(lookup2[[paste0("ABX-DOSE-", i)]][1])
        freq <- as.numeric(lookup2[[paste0("ABX-DAY-DOSE-", i)]][1])
        unit <- lookup2[[paste0("ABX-UNIT-", i)]][1]
        dose * freq * convert_unit(unit)
      }
      
      drug_names <- sapply(1:8, function(i) toupper(trimws(lookup2[[paste0("ABX-ATC-", i)]][1])))
      expected_doses <- sapply(1:8, get_expected_dose)
      
      # Special logic for Drug 4 (main + alt dose)
      expected_4_main <- expected_doses[4]
      expected_4_alt <- as.numeric(lookup2[["ABX-DOSE-4"]][1]) *
        as.numeric(lookup2[["ABX-DAY-DOSE-4a"]][1]) *
        convert_unit(lookup2[["ABX-UNIT-4"]][1])
      
      # Special logic for Drug 6 (main + alt dose)
      expected_6_main <- expected_doses[6]
      expected_6_alt <- as.numeric(lookup2[["ABX-DOSE-6a"]][1]) *
        as.numeric(lookup2[["ABX-DAY-DOSE-6"]][1]) *
        convert_unit(lookup2[["ABX-UNIT-6a"]][1])
      
      # Perform matching
      data_Pneu2 <- data_Pneu2 %>%
        mutate(
          Match_Drug_Dose_1 = ATC5 == drug_names[1] & Route == "P" &
            abs(Total_Daily_Dose - expected_doses[1]) < 1,
          
          Match_Drug_Dose_2 = ATC5 == drug_names[2] & Route == "P" &
            abs(Total_Daily_Dose - expected_doses[2]) < 1,
          
          Match_Drug_Dose_3 = ATC5 == drug_names[3] & Route == "P" &
            abs(Total_Daily_Dose - expected_doses[3]) < 1,
          
          Match_Drug_Dose_4 = ATC5 == drug_names[4] & Route == "P" &
            (abs(Total_Daily_Dose - expected_4_main) < 1 | abs(Total_Daily_Dose - expected_4_alt) < 1),
          
          Match_Drug_Dose_5 = ATC5 == drug_names[5] & Route == "O" &
            abs(Total_Daily_Dose - expected_doses[5]) < 1,
          
          Match_Drug_Dose_6 = ATC5 == drug_names[6] & Route == "O" &
            (abs(Total_Daily_Dose - expected_6_main) < 1 | abs(Total_Daily_Dose - expected_6_alt) < 1),
          
          Match_Drug_Dose_7 = ATC5 == drug_names[7] & Route == "O" &
            abs(Total_Daily_Dose - expected_doses[7]) < 1,
          
          Match_Drug_Dose_8 = ATC5 == drug_names[8] & Route == "O" &
            abs(Total_Daily_Dose - expected_doses[8]) < 1
        )
      
      # SPLIT INTO TWO SEPARATE SUMMARIES: IV and ORAL
      
      # ===== IV PATIENT SUMMARY (Severe Pneumonia) =====
      patient_summary2_IV <- data_Pneu2 %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          Match_1_P = any(ATC5 == lookup_names2[1] & Route == "P"),
          Match_2_P = any(ATC5 == lookup_names2[2] & Route == "P"),
          Match_3_P = any(ATC5 == lookup_names2[3] & Route == "P"),
          Match_3_O = any(ATC5 == lookup_names2[3] & Route == "O"),
          Match_4_P = any(ATC5 == lookup_names2[4] & Route == "P"),
          
          Dose_1 = any(Match_Drug_Dose_1),
          Dose_2 = any(Match_Drug_Dose_2),
          Dose_3 = any(Match_Drug_Dose_3),
          Dose_4 = any(Match_Drug_Dose_4),
          
          Any_IV = any(Route == "P"),
          .groups = "drop"
        ) %>%
        mutate(
          Any_Recommended_IV_Given = Match_1_P | Match_2_P | Match_3_P | Match_4_P,
          
          Any_Recommended_Dose_Correct_IV = (Match_1_P & Dose_1) |
            (Match_2_P & Dose_2) |
            (Match_3_P & Dose_3) |
            (Match_4_P & Dose_4),
          
          All_Matched_And_Dosed_IV = (
            ((Match_1_P & Dose_1) & (!Match_3_P)) |
              ((Match_1_P & Dose_1) & ((Match_3_P | Match_3_O) & Dose_3)) |
              ((Match_2_P & Dose_2) & (!Match_3_P)) |
              ((Match_2_P & Dose_2) & ((Match_3_P | Match_3_O) & Dose_3)) |
              ((Match_4_P & Dose_4) & (!Match_3_P)) |
              ((Match_4_P & Dose_4) & ((Match_3_P | Match_3_O) & Dose_3))
          ),
          
          Dose_Result = case_when(
            All_Matched_And_Dosed_IV ~ "Received recommended IV antibiotics with recommended dosage",
            Any_Recommended_IV_Given & Any_Recommended_Dose_Correct_IV & !All_Matched_And_Dosed_IV ~
              "Received at least one recommended IV antibiotic with only one has recommended dosage",
            Any_Recommended_IV_Given & !Any_Recommended_Dose_Correct_IV ~
              "Received at least one recommended IV antibiotic with none have recommended dosage",
            Any_IV & !Any_Recommended_IV_Given ~
              "Received IV antibiotics not among recommended options",
            TRUE ~ NA_character_
          )
        ) %>%
        filter(!is.na(Dose_Result))
      
      # IV Summary
      all_categories_IV <- unique(patient_summary2_IV$Dose_Result)
      
      iv_dose_counts <- patient_summary2_IV %>%
        group_by(`Department name`, Dose_Result) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos2_IV <- expand_grid(
        `Department name` = unique(patient_summary2_IV$`Department name`),
        Dose_Result = all_categories_IV
      )
      
      iv_dose_summary <- all_combos2_IV %>%
        left_join(iv_dose_counts, by = c("Department name", "Dose_Result")) %>%
        mutate(Patients = replace_na(Patients, 0)) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        ungroup()
      
      iv_hospital_row <- iv_dose_summary %>%
        group_by(Dose_Result) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        ungroup()
      
      final_summary2_IV <- bind_rows(iv_dose_summary, iv_hospital_row) %>%
        arrange(`Department name`, Dose_Result)
      
      # ===== ORAL PATIENT SUMMARY (Mild/Moderate Pneumonia) =====
      patient_summary2_Oral <- data_Pneu2 %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          Match_1_P = any(ATC5 == lookup_names2[1] & Route == "P"),
          Match_2_P = any(ATC5 == lookup_names2[2] & Route == "P"),
          Match_3_O = any(ATC5 == lookup_names2[3] & Route == "O"),
          Match_4_P = any(ATC5 == lookup_names2[4] & Route == "P"),
          Match_5_O = any(ATC5 == lookup_names2[5] & Route == "O"),
          Match_6_O = any(ATC5 == lookup_names2[6] & Route == "O"),
          Match_7_O = any(ATC5 == lookup_names2[7] & Route == "O"),
          Match_8_O = any(ATC5 == lookup_names2[8] & Route == "O"),
          
          Dose_3 = any(Match_Drug_Dose_3),
          Dose_5 = any(Match_Drug_Dose_5),
          Dose_6 = any(Match_Drug_Dose_6),
          Dose_7 = any(Match_Drug_Dose_7),
          Dose_8 = any(Match_Drug_Dose_8),
          
          Any_Oral = any(Route == "O"),
          N_ABX = n(),
          .groups = "drop"
        ) %>%
        mutate(
          Any_Recommended_ORAL_Given = Match_5_O | Match_6_O | Match_7_O | Match_8_O,
          
          Any_Recommended_Dose_Correct_ORAL = (Match_5_O & Dose_5) |
            (Match_6_O & Dose_6) |
            (Match_7_O & Dose_7) |
            (Match_8_O & Dose_8),
          
          All_Matched_And_Dosed_ORAL = (Match_5_O & Dose_5) |
            (Match_6_O & Dose_6) |
            (Match_7_O & Dose_7) |
            (Match_8_O & Dose_8),
          
          IV_ORAL_Combined = (
            ((Match_1_P & Match_3_O) |
               (Match_2_P & Match_3_O) |
               (Match_4_P & Match_3_O)) &
              N_ABX == 2
          ),
          
          Dose_Result = case_when(
            All_Matched_And_Dosed_ORAL ~ "Received recommended ORAL antibiotic with recommended dosage",
            Any_Recommended_ORAL_Given & !Any_Recommended_Dose_Correct_ORAL ~
              "Received recommended ORAL antibiotic without recommended dosage",
            Any_Oral & !Any_Recommended_ORAL_Given & !IV_ORAL_Combined ~
              "Received ORAL antibiotics not among recommended options",
            TRUE ~ NA_character_
          )
        ) %>%
        filter(!is.na(Dose_Result))
      
      # ORAL Summary
      all_categories_Oral <- unique(patient_summary2_Oral$Dose_Result)
      
      Oral_dose_counts <- patient_summary2_Oral %>%
        group_by(`Department name`, Dose_Result) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos2_Oral <- expand_grid(
        `Department name` = unique(patient_summary2_Oral$`Department name`),
        Dose_Result = all_categories_Oral
      )
      
      Oral_dose_summary <- all_combos2_Oral %>%
        left_join(Oral_dose_counts, by = c("Department name", "Dose_Result")) %>%
        mutate(Patients = replace_na(Patients, 0)) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        ungroup()
      
      Oral_hospital_row <- Oral_dose_summary %>%
        group_by(Dose_Result) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        ungroup()
      
      final_summary2_Oral <- bind_rows(Oral_dose_summary, Oral_hospital_row) %>%
        arrange(`Department name`, Dose_Result)
      
      list(
        data_Pneu2 = data_Pneu2,
        final_summary2_IV = final_summary2_IV,
        final_summary2_Oral = final_summary2_Oral
      )
    })
    
    # ---------- DOSAGE plot - SEVERE Pneumonia (horizontal stacked) ----------
    output$dosage_severe_plot <- renderPlotly({
      dd <- dosage_data_reactive()
      if (is.null(dd) || is.null(dd$final_summary2_IV)) return(plotly_empty())
      
      final_summary2_IV <- dd$final_summary2_IV
      
      # Colors matching the pattern
      drug_dosage_colors_IV <- c(
        "Received recommended IV antibiotics with recommended dosage" = "#084594",
        "Received at least one recommended IV antibiotic with only one has recommended dosage" = "#6BAED6",
        "Received at least one recommended IV antibiotic with none have recommended dosage" = "#FC9272",
        "Received IV antibiotics not among recommended options" = "#D3D3D3"
      )
      
      all_categories2_IV <- names(drug_dosage_colors_IV)
      
      # Complete summary with all combinations
      complete_summary <- tidyr::expand_grid(
        `Department name` = unique(final_summary2_IV$`Department name`),
        Dose_Result = all_categories2_IV
      ) %>%
        dplyr::left_join(final_summary2_IV, by = c("Department name", "Dose_Result")) %>%
        dplyr::mutate(
          Patients = tidyr::replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, round(100 * Patients / Total, 1)),
          Dose_Result = factor(Dose_Result, levels = all_categories2_IV),
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          IsHospitalWide = (`Department name` == "Hospital-Wide"),
          Proportion_Decimal = Proportion / 100,
          # Create custom hover text
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Category:</b> ", as.character(Dose_Result), "<br>",
            "<b>Patients:</b> ", Patients, "<br>",
            "<b>Proportion:</b> ", round(Proportion, 1), "%"
          )
        )
      
      # Hospital-Wide first (will appear at the TOP in coord_flip)
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(setdiff(unique(complete_summary$PlotLabel),
                     "<b style='color:#0072B2;'>Hospital-Wide</b>"))
      )
      complete_summary$PlotLabel <- factor(complete_summary$PlotLabel, levels = ordered_labels)
      
      label_data <- complete_summary %>%
        distinct(`Department name`, Total) %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          PlotLabel = factor(PlotLabel, levels = levels(complete_summary$PlotLabel))
        )
      
      # --- Dynamic buffer ---
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # Create ggplot
      p <- ggplot(complete_summary, aes(y = PlotLabel, x = Proportion, fill = Dose_Result, text = hover_text)) +
        geom_bar(stat = "identity", position = "fill", width = 0.85) +
        geom_text(
          aes(label = ifelse(Proportion > 5, paste0(round(Proportion, 1), "%"), "")),
          position = position_fill(vjust = 0.5),
          size = 3, color = "black"
        ) +
        geom_text(
          data = label_data,
          aes(y = PlotLabel, label = paste0("n=", formatC(Total, format = "d", big.mark = ","))),
          x = label_x,
          inherit.aes = FALSE, size = 3, color = "gray30", vjust = 0.5, hjust = 0
        ) +
        scale_fill_manual(values = drug_dosage_colors_IV, drop = FALSE) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
          x = "Proportion of Patients",
          y = "Department",
          fill = "Treatment Classification"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.y = ggtext::element_markdown(size = 7),
          axis.text.x = element_text(size = 7),
          axis.title  = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text  = element_text(size = 8),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          plot.margin  = margin(6, 18, 6, 8)
        ) +
        guides(fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")) +
        scale_y_discrete(limits = rev(levels(complete_summary$PlotLabel)))
      
      # --- Convert to plotly ---
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>Antibiotic Choice and Dosage Alignment for IV Route</b>",
            x = 0.5, xanchor = "center",
            y = 0.98, yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width  = 680,
          margin = list(l = 30, r = r_margin, t = 60, b = 170),
          legend = list(
            orientation = "h", x = 0.5, xanchor = "center",
            y = -0.40, yanchor = "top",
            font = list(size = 10),
            title = list(text = "<b>Treatment Classification</b>", font = list(size = 10))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          yaxis = list(automargin = TRUE, categoryorder = "array", categoryarray = rev(ordered_labels)),
          xaxis = list(automargin = TRUE)
        ) %>%
        layout(
          shapes = list(list(
            type = "rect", xref = "paper", yref = "y", x0 = 0, x1 = 1,
            y0 = length(ordered_labels) - 0.5, 
            y1 = length(ordered_labels) + 0.5 - (length(ordered_labels)-1),
            fillcolor = "rgba(240,240,240,0.5)",
            line = list(width = 0),
            layer = "below"
          ))
        )
      
      plt
    })
    
    
    
    # ---------- DOSAGE plot - MILD/MODERATE Pneumonia (horizontal stacked) ----------
    output$dosage_mild_plot <- renderPlotly({
      dd <- dosage_data_reactive()
      if (is.null(dd) || is.null(dd$final_summary2_Oral)) return(plotly_empty())
      
      final_summary2_Oral <- dd$final_summary2_Oral
      
      all_categories2_ORAL <- c(
        "Received recommended ORAL antibiotic with recommended dosage",
        "Received recommended ORAL antibiotic without recommended dosage",
        "Received ORAL antibiotics not among recommended options"
      )
      
      # Ensure all categories exist for each department (even with 0 patients)
      dept_list <- unique(final_summary2_Oral$`Department name`)
      
      complete_oral_data <- expand_grid(
        `Department name` = dept_list,
        Dose_Result = all_categories2_ORAL
      ) %>%
        left_join(final_summary2_Oral, by = c("Department name", "Dose_Result")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, round(100 * Patients / Total, 1))
        )
      
      # Filter departments with at least some patients
      final_summary2_ORAL <- complete_oral_data %>%
        group_by(`Department name`) %>%
        filter(sum(Patients) > 0) %>%
        ungroup() %>%
        mutate(Dose_Result = factor(Dose_Result, levels = all_categories2_ORAL))
      
      if (nrow(final_summary2_ORAL) == 0) {
        return(plotly_empty())
      }
      
      final_summary2_ORAL <- final_summary2_ORAL %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          ProportionPct = Proportion,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Treatment:</b> ", as.character(Dose_Result), "<br>",
            "<b>Patients:</b> ", Patients, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(setdiff(unique(final_summary2_ORAL$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>"))
      )
      final_summary2_ORAL$PlotLabel <- factor(final_summary2_ORAL$PlotLabel, levels = rev(ordered_labels))
      
      label_data <- final_summary2_ORAL %>%
        distinct(`Department name`, PlotLabel, Total) %>%
        mutate(dept_total = Total)
      
      max_digits <- max(nchar(as.character(label_data$dept_total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      p <- ggplot(final_summary2_ORAL, aes(y = PlotLabel, x = ProportionPct, fill = Dose_Result, text = hover_text)) +
        geom_bar(stat = "identity", position = "fill", width = 0.85) +
        geom_text(
          aes(label = ifelse(Proportion > 5, paste0(round(Proportion, 1), "%"), "")),
          position = position_fill(vjust = 0.5),
          size = 3, color = "black"
        ) +
        geom_text(
          data = label_data,
          aes(y = PlotLabel, label = paste0("n=", formatC(dept_total, format = "d", big.mark = ","))),
          x = label_x,
          inherit.aes = FALSE, size = 3, color = "gray30", vjust = 0.5, hjust = 0
        ) +
        scale_fill_manual(
          values = c(
            "Received recommended ORAL antibiotic with recommended dosage" = "#084594",
            "Received recommended ORAL antibiotic without recommended dosage" = "#FC9272",
            "Received ORAL antibiotics not among recommended options" = "#D3D3D3"
          ),
          breaks = all_categories2_ORAL,  # Force all categories in legend
          drop = FALSE  # Don't drop unused levels
        ) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
          x = "Proportional Stacked Bar",
          y = "Department",
          fill = "Treatment Classification"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.y = ggtext::element_markdown(size = 7),
          axis.text.x = element_text(size = 7),
          axis.title  = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text  = element_text(size = 8),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          plot.margin  = margin(6, 18, 6, 8)
        ) +
        guides(fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")) +
        scale_y_discrete(limits = rev(levels(final_summary2_ORAL$PlotLabel)))
      
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>Antibiotic Choice and Dosage Alignment for O Route</b>",
            x = 0.5,
            xanchor = "center",
            y = 0.98,
            yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width  = 680,
          margin = list(l = 30, r = r_margin, t = 60, b = 170),
          legend = list(
            orientation = "h",
            x = 0.5, xanchor = "center",
            y = -0.40, yanchor = "top",
            font = list(size = 10),
            title = list(text = "<b>Treatment Alignment Classification</b>", font = list(size = 10))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          yaxis = list(
            automargin = TRUE,
            categoryorder = "array",
            categoryarray = rev(ordered_labels)
          ),
          xaxis = list(automargin = TRUE)
        ) %>%
        layout(
          shapes = list(list(
            type = "rect",
            xref = "paper",
            yref = "y",
            x0 = 0, x1 = 1,
            y0 = length(ordered_labels) - 0.5, 
            y1 = length(ordered_labels) + 0.5 - (length(ordered_labels)-1),
            fillcolor = "rgba(240,240,240,0.5)",
            line = list(width = 0),
            layer = "below"
          ))
        )
      
      plt
    })
    
    # ---------- DOSAGE summary - SEVERE Pneumonia (IV) - EXACT R MARKDOWN MATCH ----------
    output$dosage_severe_summary <- renderUI({
      dosage_data <- dosage_data_reactive()
      if (is.null(dosage_data) || is.null(dosage_data$final_summary2_IV)) {
        return(HTML("<p>No data available for Pneumonia dosage (IV) summary</p>"))
      }
      
      # Get choice_data to calculate total_eligible_IV
      choice_data <- choice_data_reactive()
      if (is.null(choice_data)) {
        return(HTML("<p>No data available for Pneumonia dosage (IV) summary</p>"))
      }
      
      patient_summary_Pneu <- choice_data$patient_summary_Pneu
      data_Pneu_choice <- choice_data$data_Pneu_choice
      
      # Get not eligible patients
      not_eligible_patients_Pneu <- data_Pneu_choice %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary for all categories (same as choice summary)
      eligible_long_Pneu <- patient_summary_Pneu %>%
        select(`Survey Number`, `Department name`, 
               Received_full_recommended_IV, Received_full_recommended_ORAL,
               Received_partial_recommended_IV, Received_partial_recommended_ORAL,
               Received_no_recommended_IV, Received_no_recommended_ORAL,
               Received_any_IV, Received_any_ORAL, Other_non_IV_or_oral) %>%
        pivot_longer(
          cols = -c(`Survey Number`, `Department name`),
          names_to = "Indicator",
          values_to = "Value"
        ) %>%
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos <- expand_grid(
        `Department name` = unique(patient_summary_Pneu$`Department name`),
        Indicator = c("Received_full_recommended_IV", "Received_full_recommended_ORAL",
                      "Received_partial_recommended_IV", "Received_partial_recommended_ORAL",
                      "Received_no_recommended_IV", "Received_no_recommended_ORAL",
                      "Received_any_IV", "Received_any_ORAL",
                      "Other_non_IV_or_oral", "Not_Eligible")
      )
      
      eligible_long_Pneu <- all_combos %>%
        left_join(eligible_long_Pneu, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      ineligible_summary_Pneu <- not_eligible_patients_Pneu %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      qi_long_Pneu <- bind_rows(eligible_long_Pneu, ineligible_summary_Pneu)
      
      dept_totals <- qi_long_Pneu %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      qi_summary_Pneu <- qi_long_Pneu %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_full_recommended_ORAL" ~ "Received recommended ORAL antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_ORAL" ~ "Partially received recommended ORAL antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Received_no_recommended_ORAL" ~ "Received ORAL antibiotics not among recommended options",
            Indicator == "Received_any_IV" ~ "Received IV antibiotics only",
            Indicator == "Received_any_ORAL" ~ "Received ORAL antibiotics only",
            Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe Pneumonia QIs",
            TRUE ~ Indicator
          )
        )
      
      hospital_data <- qi_summary_Pneu %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      qi_summary_Pneu <- bind_rows(qi_summary_Pneu, hospital_data) %>%
        group_by(`Department name`) %>%
        mutate(Total = sum(Patients)) %>%
        ungroup()
      
      # Create qi_summary_Pneu_IV (same as choice summary)
      iv_indicators <- c(
        "Received recommended IV antibiotics",
        "Partially received recommended IV antibiotics",
        "Received IV antibiotics not among recommended options",
        "Received ORAL antibiotics only"
      )
      
      shared_indicators <- c(
        "Received other non-IV/oral antibiotics",
        "Not eligible for AWaRe Pneumonia QIs"
      )
      
      relevant_indicators_iv <- c(iv_indicators, shared_indicators)
      
      qi_summary_Pneu_IV <- qi_summary_Pneu %>%
        filter(Indicator %in% relevant_indicators_iv) %>%
        group_by(`Department name`) %>%
        mutate(Total_IV = sum(Patients[Indicator %in% relevant_indicators_iv])) %>%
        ungroup() %>%
        filter(Total_IV > 0)
      
      # EXACT R MARKDOWN: Calculate total_eligible_IV
      total_eligible_IV <- qi_summary_Pneu_IV %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(Indicator != "Not eligible for AWaRe Pneumonia QIs") %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Get dosage data
      final_summary2_Pneu_IV <- dosage_data$final_summary2_IV %>%
        filter(`Department name` != "Hospital-Wide",
               !Dose_Result == "Received IV antibiotics not among recommended options")
      
      total_approp_iv_given <- final_summary2_Pneu_IV %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      if (total_approp_iv_given == 0 || is.na(total_approp_iv_given)) {
        return(HTML(glue(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for evaluating the <strong>appropriateness of IV antibiotic dosage</strong> for Pneumonia.<br><br>
      <em>This may indicate that no patients met the inclusion criteria, or that no patients received recommended IV antibiotics during the reporting period.</em>
      </div>"
        )))
      }
      
      intro_text2 <- glue(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>
    💊 <strong>Denominator:</strong> Number of eligible Pneumonia patients who received recommended (<em>or partially recommended</em>) IV antibiotic choice based on WHO AWaRe book (<strong>{total_approp_iv_given}</strong> out of {total_eligible_IV})
    </div><br><br>
    <strong>Summary:</strong><br><br>"
      )
      
      all_categories2 <- c(
        "Received recommended IV antibiotics with recommended dosage",
        "Received at least one recommended IV antibiotic with only one has recommended dosage",
        "Received at least one recommended IV antibiotic with none have recommended dosage"
      )
      
      final_summary2_IV <- dosage_data$final_summary2_IV
      
      dept_list <- unique(final_summary2_IV$`Department name`)
      complete_summary <- expand_grid(
        `Department name` = dept_list,
        Dose_Result = all_categories2
      ) %>%
        left_join(final_summary2_IV, by = c("Department name", "Dose_Result")) %>%
        filter(Dose_Result %in% all_categories2) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, round(100 * Patients / Total, 1))
        )
      
      get_icon <- function(label) {
        label_lower <- tolower(trimws(label))
        if (label_lower == "received recommended iv antibiotics with recommended dosage") {
          return("<span style='color:#28a745;'>✅</span>")
        } else if (label_lower == "received at least one recommended iv antibiotic with only one has recommended dosage") {
          return("<span style='color:#e6b800;'>⚠️</span>")
        } else if (label_lower == "received at least one recommended iv antibiotic with none have recommended dosage") {
          return("<span style='color:#d00;'>❌</span>")
        } else {
          return("🛈")
        }
      }
      
      get_description <- function(label) {
        label_lower <- tolower(label)
        if (label_lower == "received recommended iv antibiotics with recommended dosage") {
          return("Received recommended IV antibiotics with recommended dosage")
        } else if (label_lower == "received at least one recommended iv antibiotic with only one has recommended dosage") {
          return("Received at least one recommended IV antibiotic with only one has recommended dosage")
        } else if (label_lower == "received at least one recommended iv antibiotic with none have recommended dosage") {
          return("Received at least one recommended IV antibiotic with none have recommended dosage")
        } else {
          return(paste("Received:", label))
        }
      }
      
      formatted_blocks2 <- complete_summary %>%
        group_by(`Department name`) %>%
        summarise(
          block = {
            dept <- first(`Department name`)
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            total_patients <- max(Total, na.rm = TRUE)
            
            if (total_patients == 0) {
              return(character(0))
            }
            
            list_items <- purrr::map_chr(all_categories2, function(label) {
              row_data <- complete_summary %>%
                filter(`Department name` == dept, Dose_Result == label)
              count <- row_data$Patients
              prop <- row_data$Proportion
              icon <- get_icon(label)
              description <- get_description(label)
              
              glue(
                "<li>{icon} <strong>{description}</strong> (as per WHO AWaRe book): 
            <strong>{scales::percent(prop / 100, accuracy = 0.1)}</strong> 
            ({count} out of {total_patients})</li>"
              )
            })
            
            glue(
              "<div style='background-color: {bg}; border-left: 5px solid {color}; padding: 14px; margin-bottom: 20px;'>
          <strong>🏥 {dept}</strong> <span style='color: #888;'>(n = {total_patients} patients)</span><br><br>
          <ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>
          {paste(list_items, collapse = '')}
          </ul>
          </div>"
            )
          },
          .groups = "drop"
        ) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>%
        filter(nchar(block) > 0) %>%
        select(-order)
      
      final_summary_html2 <- HTML(paste0(intro_text2, paste(formatted_blocks2$block, collapse = "\n")))
      final_summary_html2
    })
    
    # ---------- DOSAGE summary - MILD/MODERATE Pneumonia (ORAL) - EXACT R MARKDOWN MATCH ----------
    output$dosage_mild_summary <- renderUI({
      dosage_data <- dosage_data_reactive()
      if (is.null(dosage_data) || is.null(dosage_data$final_summary2_Oral)) {
        return(HTML("<p>No data available for Pneumonia dosage (oral) summary </p>"))
      }
      
      # Get choice_data to calculate total_eligible_ORAL
      choice_data <- choice_data_reactive()
      if (is.null(choice_data)) {
        return(HTML("<p>No data available for Pneumonia dosage (oral) summary</p>"))
      }
      
      patient_summary_Pneu <- choice_data$patient_summary_Pneu
      data_Pneu_choice <- choice_data$data_Pneu_choice
      
      # Get not eligible patients
      not_eligible_patients_Pneu <- data_Pneu_choice %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary for all categories (same as choice summary)
      eligible_long_Pneu <- patient_summary_Pneu %>%
        select(`Survey Number`, `Department name`, 
               Received_full_recommended_IV, Received_full_recommended_ORAL,
               Received_partial_recommended_IV, Received_partial_recommended_ORAL,
               Received_no_recommended_IV, Received_no_recommended_ORAL,
               Received_any_IV, Received_any_ORAL, Other_non_IV_or_oral) %>%
        pivot_longer(
          cols = -c(`Survey Number`, `Department name`),
          names_to = "Indicator",
          values_to = "Value"
        ) %>%
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos <- expand_grid(
        `Department name` = unique(patient_summary_Pneu$`Department name`),
        Indicator = c("Received_full_recommended_IV", "Received_full_recommended_ORAL",
                      "Received_partial_recommended_IV", "Received_partial_recommended_ORAL",
                      "Received_no_recommended_IV", "Received_no_recommended_ORAL",
                      "Received_any_IV", "Received_any_ORAL",
                      "Other_non_IV_or_oral", "Not_Eligible")
      )
      
      eligible_long_Pneu <- all_combos %>%
        left_join(eligible_long_Pneu, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      ineligible_summary_Pneu <- not_eligible_patients_Pneu %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      qi_long_Pneu <- bind_rows(eligible_long_Pneu, ineligible_summary_Pneu)
      
      dept_totals <- qi_long_Pneu %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      qi_summary_Pneu <- qi_long_Pneu %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_full_recommended_ORAL" ~ "Received recommended ORAL antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_ORAL" ~ "Partially received recommended ORAL antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Received_no_recommended_ORAL" ~ "Received ORAL antibiotics not among recommended options",
            Indicator == "Received_any_IV" ~ "Received IV antibiotics only",
            Indicator == "Received_any_ORAL" ~ "Received ORAL antibiotics only",
            Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe Pneumonia QIs",
            TRUE ~ Indicator
          )
        )
      
      hospital_data <- qi_summary_Pneu %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      qi_summary_Pneu <- bind_rows(qi_summary_Pneu, hospital_data) %>%
        group_by(`Department name`) %>%
        mutate(Total = sum(Patients)) %>%
        ungroup()
      
      # Create qi_summary_Pneu_ORAL (same as choice summary)
      oral_indicators <- c(
        "Received recommended ORAL antibiotics",
        "Partially received recommended ORAL antibiotics",
        "Received ORAL antibiotics not among recommended options",
        "Received IV antibiotics only"
      )
      
      shared_indicators <- c(
        "Received other non-IV/oral antibiotics",
        "Not eligible for AWaRe Pneumonia QIs"
      )
      
      relevant_indicators_oral <- c(oral_indicators, shared_indicators)
      
      qi_summary_Pneu_ORAL <- qi_summary_Pneu %>%
        filter(Indicator %in% relevant_indicators_oral) %>%
        group_by(`Department name`) %>%
        mutate(Total_ORAL = sum(Patients[Indicator %in% relevant_indicators_oral])) %>%
        ungroup() %>%
        filter(Total_ORAL > 0)
      
      # EXACT R MARKDOWN: Calculate total_eligible_ORAL
      total_eligible_ORAL <- qi_summary_Pneu_ORAL %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(Indicator != "Not eligible for AWaRe Pneumonia QIs") %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Get dosage data
      final_summary2_ORAL <- dosage_data$final_summary2_Oral %>%
        filter(`Department name` != "Hospital-Wide")
      
      dose_categories2 <- c(
        "Received recommended ORAL antibiotic with recommended dosage",
        "Received recommended ORAL antibiotic without recommended dosage"
      )
      
      relevant_dose_data2 <- final_summary2_ORAL %>%
        filter(Dose_Result %in% dose_categories2)
      
      total_approp_oral_given <- relevant_dose_data2 %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      if (nrow(relevant_dose_data2) == 0 || total_approp_oral_given == 0 || is.na(total_approp_oral_given)) {
        return(HTML(glue(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible Pneumonia patients for assessing ORAL antibiotic dosage appropriateness.<br><br>
      <em>This may indicate that no patients met the inclusion criteria, or no patients received recommended ORAL antibiotics during the reporting period.</em>
      </div>"
        )))
      }
      
      intro_text3 <- glue(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>
    💊 <strong>Denominator:</strong> Number of eligible Pneumonia patients who received any recommended ORAL antibiotic choice based on WHO AWaRe book (<strong>{total_approp_oral_given}</strong> out of {total_eligible_ORAL}).
    </div><br><br>
    <strong>Summary:</strong><br><br>"
      )
      
      dept_list2 <- unique(dosage_data$final_summary2_Oral$`Department name`)
      complete_summary2 <- expand_grid(
        `Department name` = dept_list2,
        Dose_Result = dose_categories2
      ) %>%
        left_join(dosage_data$final_summary2_Oral, by = c("Department name", "Dose_Result")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, Patients / Total)
        )
      
      complete_summary2 <- complete_summary2 %>%
        filter(Total > 0)
      
      if (nrow(complete_summary2) == 0) {
        return(HTML(glue(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for evaluating the <strong>appropriateness of ORAL antibiotic dosage</strong> for Pneumonia <br><br>
      <em>This may indicate that no patients met the inclusion criteria, or no patients received recommended ORAL antibiotics during the reporting period.</em>
      </div>"
        )))
      }
      
      formatted_blocks3 <- complete_summary2 %>%
        group_by(`Department name`) %>%
        summarise(
          block = {
            dept <- first(`Department name`)
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            
            glue(
              "<div style='background-color: {bg}; border-left: 5px solid {color}; padding: 14px; margin-bottom: 20px;'>
          <strong>🏥 {dept}</strong> <span style='color: #888;'>(n = {first(Total)} patients)</span><br><br>
          <ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>
            <li>✅ <strong>Received recommended ORAL antibiotic with recommended dosage</strong> (as per WHO AWaRe book): <strong>{scales::percent(Proportion[Dose_Result == 'Received recommended ORAL antibiotic with recommended dosage'], accuracy = 0.1)}</strong> ({Patients[Dose_Result == 'Received recommended ORAL antibiotic with recommended dosage']} out of {first(Total)})</li>
            <li>❌ <strong>Received recommended ORAL antibiotic without recommended dosage</strong> (as per WHO AWaRe book): <strong>{scales::percent(Proportion[Dose_Result == 'Received recommended ORAL antibiotic without recommended dosage'], accuracy = 0.1)}</strong> ({Patients[Dose_Result == 'Received recommended ORAL antibiotic without recommended dosage']} out of {first(Total)})</li>
          </ul>
          </div>"
            )
          },
          .groups = "drop"
        )
      
      formatted_blocks3 <- formatted_blocks3 %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>%
        select(-order)
      
      final_summary_html3 <- HTML(paste0(intro_text3, paste(formatted_blocks3$block, collapse = "\n")))
      final_summary_html3
    })
    
  })
}