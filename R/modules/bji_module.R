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

bjiOverviewUI <- function(id) {
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
      fluidRow(
        column(10, offset = 1,
               box(
                 width = 12, title = "🎯 AWaRe Quality Indicators for Bone and joint infection",
                 status = "info", solidHeader = TRUE,
                 #div(class = "info-box",
                 h5("Within the gPPS data structure, the following antibiotic use quality indicators have been identified:"),
                 p("1) "," Proportion of patients presenting with bone and joint infections given IV antibiotics by AWaRe category (Access or Watch)."),
                 p("2) ","Proportion of patients presenting with bone and joint infections given the appropriate IV antibiotic according to the WHO AWaRe book."),
                 p("3) ","Proportion of patients presenting with Bone and Joint Infection prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book.")
                 #)
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

bjiEligibilityUI <- function(id) {
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

bjiPatientSummaryUI <- function(id) {
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
               box(width = 12, title = "🧾 Eligiblilty Criteria",
                   status = "primary", solidHeader = TRUE, 
                   p("Eligible patients for WHO AWaRe QI assessment are defined as adult inpatients (≥18 years) who received empirical antibiotics for community acquired bone and joint infections.")
               )
        )
      )
    )
  )
}

bjiQIGuidelinesUI <- function(id) {
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
                strong("This script evaluates Three indicators:"), br(), br(),
                strong("1. H_OAI_ACCESS_ABX:"), " Proportion of patients presenting with Bone and Joint Infection given IV AWaRe book Access antibiotics.", br(), br(),
                strong("2. H_OAI_WATCH_ABX:"), " Proportion of patients presenting with Bone and Joint Infection given IV AWaRe book Watch antibiotics.", br(), br(),
                strong("3. H_OAI_APPROP_DOSAGE:"), " Proportion of patients presenting with Bone and Joint Infection prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book."
            ),
            div(class = "note-box",
                strong("🔍 WHO AWaRe book Recommendation:"), br(), br(),
                tags$ul(
                  tags$li(strong("Option 1:"), " Cloxacillin (2 g q6h IV)"),
                  tags$li(strong("Option 2:"), " Amoxicillin + clavulanic acid (1 g + 200 mg q8h IV)"),
                  tags$li(strong("Option 3:"), " Cefazolin (2 g q8h IV)"),
                  tags$li(strong("Option 4:"), " Cefotaxime (2 g q8h IV)"),
                  tags$li(strong("Option 5:"), " Ceftriaxone (2 g q24h IV)"),
                  tags$li(strong("Option 6:"), " Clindamycin (600 mg q8h IV/ORAL)")
                )
            ),
            div(class = "warning-box",
                strong("🩺 WHO AWaRe Notes:"), br(),
                tags$ul(
                  tags$li("The intravenous route is preferred at least in the first week of treatment"),
                  tags$li("Step down to oral treatment is based on improvement"),
                  tags$li("If cloxacillin is unavailable, any other IV antistaphylococcal penicillin could be used"),
                  tags$li("A higher dose (e.g. 12 g/day) could be considered given the concerns with bone penetration"),
                  tags$li("Ceftriaxone or cefotaxime are the preferred options if invasive non-typhoidal Salmonella or Enterobacterales infection is suspected"),
                  tags$li("Acceptable option for community-acquired-MRSA if MRSA is susceptible or where MRSA remains susceptible to clindamycin; otherwise consider vancomycin")
                )
            )
        )
      )
    )
  )
}

bjiAccessWatchAnalysisUI <- function(id) {
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
            p("Please upload your data files to view access/watch antibiotic analysis.")
        )
      )
    ),
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📌 IV antibiotic use by AWaRe category (Access or Watch)",
            status = "primary", solidHeader = TRUE, 
            
            "Proportion of patients with bone and joint infections given IV antibiotics by AWaRe category (Access or Watch)"
          )
        )
      ),
      #fluidRow(
      #  column(10, offset = 1,
      #         box(width = 12, title = "🔍 WHO AWaRe book Recommendation:", status = "primary", solidHeader = TRUE,
      #             "▸ ",strong("Option 1:"), "Cloxacillin (2 g q6h IV)", br(),
      #             "▸ ",strong("Option 2:"), "Amoxicillin + clavulanic acid (1 g + 200 mg q8h IV)", br(),
      #             "▸ ",strong("Option 3:"), "Cefazolin (2 g q8h IV)", br(),
      #             "▸ ",strong("Option 4:"), "Cefotaxime (2 g q8h IV)", br(),
      #             "▸ ",strong("Option 5:"), "Ceftriaxone (2 g q24h IV)", br(),
      #             "▸ ",strong("Option 6:"), "Clindamycin (600 mg q8h IV/ORAL)", br(),
      #             
      
      #        )
      #)
      #),
      
      
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📈 Antibiotic Prescription by AWaRe Classification",
            status = "primary", solidHeader = TRUE,
            p("This visual summarises the proportion of antibiotic prescription for Bone and Joint Infection across hospital departments by WHO AWaRe Classification (Access, Watch, Reserve)"),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("aware_plot_bar"), height = "450px", width = "100%"),
                  type = 4
                ))
          )
        )
      ),
      
      # Access Watch Summary Box at the bottom
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📊 Summary of Access/Watch Antibiotic Use", status = "success", solidHeader = TRUE,collapsible = TRUE,collapsed = TRUE,
                   htmlOutput(ns("access_watch_summary"))
               )
        )
      )
    )
  )
}



# BJI Choice Analysis Tab UI - Complete Version with White Backgrounds
bjiChoiceAnalysisUI <- function(id) {
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
                 title = "📌 Antibiotic Choice Alignment with AWaRe book Recommendations for Bone and Joint Infection",
                 status = "primary", 
                 solidHeader = TRUE,
                 p("Proportion of patients presenting with bone and joint infections given the appropriate IV antibiotic according to the WHO AWaRe book.")
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
                 tags$ul(
                   strong("First choice:"),
                   tags$li(strong("Cloxacillin"), "(2 g q6h IV)"),br(),
                   strong("Second Choice:"),
                   tags$li(strong("Amoxicillin + clavulanic acid"), "(1 g + 200 mg q8h IV)"),
                   tags$li(strong("Cefazolin"), "(2 g q8h IV)"),
                   tags$li(strong("Cefotaxime"), "(2 g q8h IV)"),
                   tags$li(strong("Ceftriaxone"), "(2 g q24h IV)"),
                   tags$li(strong("Clindamycin"), "(600 mg q8h IV/ORAL)")
                 )
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
                   " Antibiotic Choice Alignment with AWaRe book Recommendations for Bone and Joint Infection"
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
                       p("This visual summarises the proportion of antibiotic alignment for Bone and Joint Infection across hospital departments based on WHO AWaRe book"),
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
                           plotlyOutput(ns("choice_plot"), height = "450px", width = "100%"),
                           type = 4
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
                       p("This visual summarises the proportion of antibiotic alignment for Bone and Joint Infection across hospital departments by WHO AWaRe Classification (Access, Watch, Reserve)"),
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
                       p("This visual summarises the proportion of antibiotic alignment for Bone and Joint Infection across hospital departments by line of treatment (First choice, Second choice)"),
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
                           plotlyOutput(ns("choice_line_plot"), height = "450px", width = "100%"),
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
                 title = "📝 Summary of Antibiotic Choice Alignment with AWaRe book Recommendations for Bone and Joint Infection",
                 status = "success", 
                 solidHeader = TRUE, 
                 collapsible = TRUE, 
                 collapsed = TRUE,
                 htmlOutput(ns("choice_summary"))
               )
        )
      )
    )
  )
}


bjiDosageAnalysisUI <- function(id) {
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
        column(
          10, offset = 1,
          box(
            width = 12, title = "📌 Antibiotic Dosage Alignment with AWaRe book Recommendations for Bone and Joint Infection",
            status = "primary", solidHeader = TRUE, 
            
            "Proportion of patients presenting with Bone and Joint Infection prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book."
            
          )
        )
      ),
      fluidRow(
        column(10, offset = 1,
               box(
                 width = 12, 
                 title = "🔍 WHO AWaRe book Recommendation:", 
                 status = "primary", 
                 solidHeader = TRUE,
                 tags$ul(
                   strong("First choice:"),
                   tags$li(strong("Cloxacillin"), "(2 g q6h IV)"),br(),
                   strong("Second Choice:"),
                   tags$li(strong("Amoxicillin + clavulanic acid"), "(1 g + 200 mg q8h IV)"),
                   tags$li(strong("Cefazolin"), "(2 g q8h IV)"),
                   tags$li(strong("Cefotaxime"), "(2 g q8h IV)"),
                   tags$li(strong("Ceftriaxone"), "(2 g q24h IV)"),
                   tags$li(strong("Clindamycin"), "(600 mg q8h IV/ORAL)")
                 )
               )
        )
      ),
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📌 Antibiotic  Dosage Alignment with AWaRe book Recommendations for Bone and Joint Infection",
            status = "primary", solidHeader = TRUE,
            p("Visual summary of antibiotic  dosage alignment for Bone and Joint Infection across departments (WHO AWaRe book)."),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("dosage_plot"), height = "450px", width = "100%"),
                  type = 4
                ))
          )
        )
      ),
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📝 Antibiotic Dosage Alignment with AWaRe book Recommendations for Bone and Joint Infection",
            status = "success", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
            htmlOutput(ns("dosage_summary"))
          )
        )
      )
    )
  )
}
# =====================================================================
# SERVER (MODULE)
# =====================================================================

bjiAnalysisServer <- function(id, data_reactive) {
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
    
    # ---------- Eligibility feedback (logic mirrors the base code) ----------
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
        
        # Updated data filtering logic exactly as base code
        data_BJ <- data_patients %>%
          filter(`Diagnosis code` == "BJ") %>%
          mutate(
            AWaRe = case_when(
              toupper(AWaRe) %in% c("NOT_RECOMMENDED", "NOT RECOMMENDED") ~ "NOT RECOMMENDED",
              TRUE ~ AWaRe
            ),
            Route = toupper(as.character(Route)),
            AWaRe_compatible = (`Age years` >= 18 & 
                                  Indication == "CAI" & 
                                  Treatment == "EMPIRICAL" & 
                                  AWaRe %in% AWaRe_abx)
          )
        
        eligible_BJ_n <- data_BJ %>%
          filter(AWaRe_compatible) %>%
          distinct(`Survey Number`) %>%
          nrow()
        
        survey_start <- if (!is.null(data_info$`Survey start date`)) format(as.Date(data_info$`Survey start date`), "%d %b %Y") else "Not available"
        survey_end   <- if (!is.null(data_info$`Survey end date`))   format(as.Date(data_info$`Survey end date`), "%d %b %Y") else "Not available"
        
        status_html <-
          if (eligible_BJ_n == 0) {
            "<div style='background:#fff3cd;border:1px solid #ffeeba;padding:10px;border-radius:3px;margin-top:10px;'><b>🚫 No eligible cases found:</b> There were no eligible cases during this survey period.</div>"
          } else if (eligible_BJ_n < 10) {
            "<div style='background:#ffe0e0;border:1px solid #ffb3b3;padding:10px;border-radius:3px;margin-top:10px;'><b>⚠️ Caution:</b> Few eligible cases detected. Interpret results with caution.</div>"
          } else {
            "<div style='background:#e0ffe0;border:1px solid #b3ffb3;padding:10px;border-radius:3px;margin-top:10px;'><b>✅ Good to go!</b> Sufficient eligible cases available.</div>"
          }
        
        HTML(paste0(
          "<div style='background:#f0f8ff;border:1px solid #add8e6;padding:15px;border-radius:5px;'>",
          "<p>This module applies <b>WHO AWaRe Quality Indicators</b> to adult inpatients with empirical antibiotics for community acquired bone and joint infections.</p>",
          "<ul><li><b>Diagnostic code:</b> BJ</li><li><b>Total eligible cases:</b> ", eligible_BJ_n, "</li></ul>",
          status_html, "</div>"
        ))
      }, error = function(e) {
        HTML(paste0("<div style='background:#f8d7da;border:1px solid #f5c6cb;padding:15px;border-radius:5px;'>",
                    "<b>❌ Error:</b> ", htmlEscape(e$message), "</div>"))
      })
    }
    output$eligibility_feedback <- renderUI({ generate_eligibility_feedback() })
    output$overview_eligibility_feedback <- renderUI({ generate_eligibility_feedback() })
    
    # ---------- Summary cards (exact same logic as base code) ----------
    output$summary_insights_cards <- renderUI({
      if (!check_data()) return(HTML("<p>No data available for insights</p>"))
      data <- data_reactive()
      data_patients <- data$data_patients %>%
        mutate(AWaRe = case_when(
          toupper(AWaRe) %in% c("NOT_RECOMMENDED", "NOT RECOMMENDED") ~ "NOT RECOMMENDED",
          TRUE ~ AWaRe
        ))
      
      total_patients <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "BJ") %>%
        distinct(`Survey Number`) %>% nrow()
      
      eligible_patients <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx,
               Treatment == "EMPIRICAL", `Diagnosis code` == "BJ") %>%
        distinct(`Survey Number`) %>% nrow()
      
      total_prescriptions <- data_patients %>% filter(AWaRe %in% AWaRe_abx , `Diagnosis code` == "BJ") %>% nrow()
      
      eligible_prescriptions <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx,
               Treatment == "EMPIRICAL", `Diagnosis code` == "BJ") %>% nrow()
      
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
        "</b> patients on antibiotics for bone and joint infections were QI-eligible patients</div>",
        "</div>",
        
        # Card 2: Prescriptions
        "<div style='flex:1;min-width:300px;background:", rx_bg, 
        ";border-left:6px solid #17a2b8;padding:18px;border-radius:8px;'>",
        "<h4 style='margin:0 0 6px;color:#0c5460;'>📑 Proportion of Eligible Prescriptions:</h4>",
        "<div style='font-size:2.2em;font-weight:700;color:#0c5460;'>", rx_pct, "%</div>",
        "<div style='color:#0c5460;'><b>", eligible_prescriptions, "</b> out of <b>", total_prescriptions, 
        "</b> antibiotic prescriptions for bone and joint infections were given to QI-eligible patients</div>",
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
          "Number of all patients with a diagnosis of Bone and joint infections on any antibiotics",
          "**Number of eligible patients:** Adult patients (≥18 years) with a diagnosis of Bone and joint infections who were treated empirically with antibiotics"
        ),
        Count = c(
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Diagnosis code` == "BJ", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "BJ", AWaRe %in% AWaRe_abx) %>%
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
          "Number of all antibiotic prescriptions for patients diagnosed with Bone and joint infections",
          "**Number of eligible antibiotic prescriptions:** antibiotics empirically prescribed for adult patients (≥18 years) with Bone and joint infections"
        ),
        Count = c(
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Diagnosis code` == "BJ", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "BJ", AWaRe %in% AWaRe_abx) %>% nrow()
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
    
    
    # ---------- ACCESS/WATCH DATA (exact base code logic) ----------
    access_watch_data_reactive <- reactive({
      if (!check_data()) return(NULL)
      data <- data_reactive()
      data_patients <- data$data_patients %>%
        mutate(
          Route = toupper(Route),
          AWaRe = case_when(
            toupper(AWaRe) %in% c("NOT_RECOMMENDED", "NOT RECOMMENDED") ~ "NOT RECOMMENDED",
            TRUE ~ AWaRe
          )
        )
      
      # CRITICAL FIX: Filter for BJ WITHOUT any AWaRe filtering first
      # This ensures we count ALL BJ patients (24), not just those with valid AWaRe
      data_BJ <- data_patients %>%
        filter(`Diagnosis code` == "BJ") %>%  # ONLY filter by diagnosis code
        mutate(
          Eligible = (`Age years` >= 18 & 
                        Indication == "CAI" & 
                        Treatment == "EMPIRICAL" & 
                        AWaRe %in% AWaRe_abx)
        )
      
      data_BJ_eligible <- data_BJ %>% filter(Eligible)
      
      # Exact base code patient-level aggregation
      summary_iv_aware <- data_BJ_eligible %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          IV_ACCESS = any(Route == "P" & AWaRe == "ACCESS"),
          IV_WATCH  = any(Route == "P" & AWaRe == "WATCH"),
          IV_OTHER  = any(Route == "P" & !(AWaRe %in% c("ACCESS", "WATCH"))),
          ANY_IV    = any(Route == "P"),
          .groups = "drop"
        ) %>% mutate(Not_IV = !ANY_IV)
      
      summary_iv_dept <- summary_iv_aware %>%
        group_by(`Department name`) %>%
        summarise(
          Eligible = n(),
          N_IV_ACCESS = sum(IV_ACCESS),
          N_IV_WATCH  = sum(IV_WATCH),
          N_IV_OTHER  = sum(IV_OTHER),
          N_Not_IV    = sum(Not_IV),
          Prop_ACCESS = round(100*N_IV_ACCESS/Eligible, 1),
          Prop_WATCH  = round(100*N_IV_WATCH/Eligible, 1),
          Prop_OTHER  = round(100*N_IV_OTHER/Eligible, 1),
          Prop_Not_IV = round(100*N_Not_IV/Eligible, 1),
          .groups = "drop"
        )
      
      summary_iv_total <- summary_iv_aware %>%
        summarise(
          `Department name` = "Hospital-Wide",
          Eligible = n(),
          N_IV_ACCESS = sum(IV_ACCESS),
          N_IV_WATCH  = sum(IV_WATCH),
          N_IV_OTHER  = sum(IV_OTHER),
          N_Not_IV    = sum(Not_IV),
          Prop_ACCESS = round(100*N_IV_ACCESS/Eligible, 1),
          Prop_WATCH  = round(100*N_IV_WATCH/Eligible, 1),
          Prop_OTHER  = round(100*N_IV_OTHER/Eligible, 1),
          Prop_Not_IV = round(100*N_Not_IV/Eligible, 1)
        )
      
      list(
        data_BJ = data_BJ,  # This now contains ALL 24 BJ patients
        data_BJ_eligible = data_BJ_eligible,
        summary_iv_final = bind_rows(summary_iv_total, summary_iv_dept)
      )
    })
    
    # ---------- ACCESS/WATCH summary HTML with numbered circles ----------
    output$access_watch_summary <- renderUI({
      aw <- access_watch_data_reactive()
      if (is.null(aw)) return(HTML("<p>No data</p>"))
      
      data_BJ_eligible <- aw$data_BJ_eligible
      summary_iv_final <- aw$summary_iv_final
      
      # CRITICAL FIX: Count ALL BJ patients from raw data (before AWaRe filtering)
      if (!check_data()) return(HTML("<p>No data</p>"))
      
      data <- data_reactive()
      data_patients_raw <- data$data_patients
      
      # Count ALL patients with BJ diagnosis code (no AWaRe filter)
      total_BJ <- data_patients_raw %>%
        filter(`Diagnosis code` == "BJ") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      # Count eligible patients (with all criteria including valid AWaRe)
      eligible_BJ <- data_BJ_eligible %>% 
        distinct(`Survey Number`) %>% 
        nrow()
      
      if (eligible_BJ == 0 || is.na(eligible_BJ)) {
        return(HTML("<div style='background:#fff3cd;border-left:5px solid #ffc107;padding:14px;'>⚠️ <b>No summary</b> — no eligible patients.</div>"))
      }
      
      # Updated intro text to match R Markdown exactly
      intro <- glue("<div style='background:#f8f9fa;border-left:5px solid #17a2b8;padding:14px;margin:10px 0;'>
                💊 <b>Denominator:</b> Number of eligible patients with any bone and joint infections (<b>{eligible_BJ}</b> out of {total_BJ})</div>
                <b>Summary:</b><br><br>")
      
      blocks <- summary_iv_final %>%
        mutate(block = pmap_chr(
          list(`Department name`, Prop_ACCESS, N_IV_ACCESS, Prop_WATCH, N_IV_WATCH,
               Prop_OTHER, N_IV_OTHER, Prop_Not_IV, N_Not_IV, Eligible),
          function(dept, pA, nA, pW, nW, pO, nO, pN, nN, nTot) {
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            
            # Define colors for each numbered circle
            access_color <- "#28a745"    # Green
            watch_color <- "#fd7e14"     # Orange  
            other_color <- "#dc3545"     # Red
            no_iv_color <- "#6c757d"     # Gray
            
            glue(
              "<div style='background:{bg};border-left:5px solid {color};padding:14px;margin-bottom:16px;'>
           <b>🏥 {dept}</b> <span style='color:#888;'>(n = {nTot} patients)</span><br><br>
           <div style='margin-left:0;line-height:2.2;'>
             <div style='display:flex;align-items:center;margin-bottom:8px;'>
               <span style='display:inline-block;width:24px;height:24px;background:{access_color};color:white;border-radius:50%;text-align:center;line-height:24px;font-size:14px;font-weight:bold;margin-right:12px;'>1</span>
               <span><b>Received IV ACCESS antibiotic: {scales::percent(pA/100, 0.1)}</b> ({nA} out of {nTot})</span>
             </div>
             <div style='display:flex;align-items:center;margin-bottom:8px;'>
               <span style='display:inline-block;width:24px;height:24px;background:{watch_color};color:white;border-radius:50%;text-align:center;line-height:24px;font-size:14px;font-weight:bold;margin-right:12px;'>2</span>
               <span><b>Received IV WATCH antibiotic: {scales::percent(pW/100, 0.1)}</b> ({nW} out of {nTot})</span>
             </div>
             <div style='display:flex;align-items:center;margin-bottom:8px;'>
               <span style='display:inline-block;width:24px;height:24px;background:{other_color};color:white;border-radius:50%;text-align:center;line-height:24px;font-size:14px;font-weight:bold;margin-right:12px;'>3</span>
               <span><b>Received IV OTHER AWaRe antibiotic: {scales::percent(pO/100, 0.1)}</b> ({nO} out of {nTot})</span>
             </div>
             <div style='display:flex;align-items:center;margin-bottom:8px;'>
               <span style='display:inline-block;width:24px;height:24px;background:{no_iv_color};color:white;border-radius:50%;text-align:center;line-height:24px;font-size:14px;font-weight:bold;margin-right:12px;'>4</span>
               <span><b>Did NOT receive any IV antibiotic: {scales::percent(pN/100, 0.1)}</b> ({nN} out of {nTot})</span>
             </div>
           </div></div>"
            )
          }
        )) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>% 
        pull(block)
      
      HTML(paste0(intro, paste(blocks, collapse = "")))
    })
    
    # ---------- ACCESS/WATCH PLOT (stacked bar chart like second code) ----------
    output$aware_plot_bar <- renderPlotly({
      aw <- access_watch_data_reactive()
      if (is.null(aw)) {
        return(
          plotly_empty() %>% layout(title = list(text = "No data available"))
        )
      }
      
      summary_iv_final <- aw$summary_iv_final
      route_levels <- c("IV ACCESS","IV WATCH","IV OTHER","No IV")
      
      # Prepare data similar to original logic but for stacked bars
      plot_df <- summary_iv_final %>%
        select(`Department name`, Eligible,
               `IV ACCESS` = N_IV_ACCESS,
               `IV WATCH`  = N_IV_WATCH,
               `IV OTHER`  = N_IV_OTHER,
               `No IV`     = N_Not_IV) %>%
        pivot_longer(cols = c(`IV ACCESS`,`IV WATCH`,`IV OTHER`,`No IV`),
                     names_to = "Route", values_to = "Count") %>%
        group_by(`Department name`) %>%
        mutate(Total = sum(Count),
               Proportion = ifelse(Total > 0, Count/Total, 0)) %>%
        ungroup() %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", 
                             `Department name`),
          Route = factor(Route, levels = route_levels)
        )
      
      # Order departments (Hospital-Wide first, matching second code style)
      label_order <- c("<b style='color:#0072B2;'>Hospital-Wide</b>",
                       sort(setdiff(unique(plot_df$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>")))
      plot_df$PlotLabel <- factor(plot_df$PlotLabel, levels = label_order)
      
      # Color palette (matching original pie colors)
      palette <- c(
        "IV ACCESS" = "#1B9E77",
        "IV WATCH" = "#3399ff", 
        "IV OTHER" = "#A52A2A",
        "No IV" = "#999999"
      )
      
      # Create ggplot (matching second code style)
      p <- ggplot(
        plot_df,
        aes(
          x = PlotLabel, y = Proportion, fill = Route,
          text = paste0(
            "Department: ", `Department name`, "<br>",
            "Category: ", Route, "<br>",
            "Count: ", Count, "<br>",
            "Total: ", Total, "<br>",
            "Proportion: ", scales::percent(Proportion, accuracy = 0.1)
          )
        )
      ) +
        geom_bar(stat = "identity", position = "fill", width = 0.7) +
        geom_text(
          aes(label = ifelse(Proportion > 0.08, 
                             paste0(round(Proportion * 100), "%"), "")),
          position = position_fill(vjust = 0.5),
          size = 2.6, color = "white", fontface = "bold"
        ) +
        geom_text(
          data = plot_df %>% distinct(PlotLabel, Total),
          aes(x = PlotLabel, y = 1.02, label = paste0("n=", Total)),
          inherit.aes = FALSE, size = 3, color = "gray30", hjust = 0.5
        ) +
        scale_fill_manual(
          values = palette,
          labels = c("IV ACCESS" = "IV ACCESS", 
                     "IV WATCH" = "IV WATCH",
                     "IV OTHER" = "IV OTHER",
                     "No IV" = "No IV"),
          drop = FALSE  # Ensure all levels appear in legend
        ) +
        scale_y_continuous(limits = c(0, 1.08), expand = c(0, 0),
                           labels = scales::percent_format(accuracy = 1)) +
        scale_x_discrete(expand = c(0.01, 0.01)) +
        labs(
          title = NULL,
          subtitle = NULL,
          x = "Department",
          y = "Proportion of Patients", 
          fill = "AWaRe Group"
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
        guides(fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"))
      
      # Convert to plotly (matching second code style layout)
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>IV Antibiotic use by AWaRe Category (Bone and Joint Infection)</b><br>"
            ),
            x = 0.5, xanchor = "center",
            y = 0.97, yanchor = "top",   # lower a bit to avoid clipping
            font = list(size = 12)
          ),
          height = 450,
          width  = 680,
          margin = list(l = 30, r = 30, t = 60, b = 180),  # extra top margin for subtitle
          legend = list(
            orientation = "h",
            x = 0.5, xanchor = "center", 
            y = -0.70, yanchor = "top",
            font = list(size = 9),
            title = list(text = "<b>AWaRe Group</b>", font = list(size = 9))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          xaxis = list(
            automargin = TRUE,
            tickangle = 45,
            categoryorder = "array",
            categoryarray = label_order,
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
      
      # Remove duplicate legend entries (matching second code)
      legend_names <- vapply(plt$x$data, function(tr) tr$name %||% "", character(1))
      dup_idx <- which(duplicated(legend_names) | grepl("^n=", legend_names))
      if (length(dup_idx)) {
        plt <- plotly::style(plt, showlegend = FALSE, traces = dup_idx)
      }
      
      plt
    })
    
    
    
    # =======================
    # CHOICE DATA REACTIVE - EXACT R MARKDOWN
    # =======================
    choice_data_reactive <- reactive({
      if (!check_data()) return(NULL)
      data <- data_reactive()
      data_patients <- data$data_patients %>%
        mutate(
          Route = toupper(Route),
          AWaRe = case_when(
            toupper(AWaRe) %in% c("NOT_RECOMMENDED", "NOT RECOMMENDED") ~ "NOT RECOMMENDED",
            TRUE ~ AWaRe
          )
        )
      data_lookup <- data$data_lookup
      
      # EXACT R markdown: filter BJ and create AWaRe_compatible
      data_BJ_choice <- data_patients %>%
        filter(`Diagnosis code` == "BJ") %>%
        mutate(
          Route = toupper(Route),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      lookup_names <- data_lookup %>%
        filter(Code == "H_OAI_APPROP_DOSAGE") %>%
        select(starts_with("ABX-ATC")) %>%
        unlist(use.names = FALSE)
      
      data_BJ_choice <- data_BJ_choice %>%
        mutate(Drug_Match = ATC5 %in% lookup_names)
      
      lookup_long <- tibble(
        Drug = unlist(data_lookup %>% filter(Code == "H_OAI_APPROP_DOSAGE") %>% 
                        select(starts_with("ABX-ATC")), use.names = FALSE),
        Choice = unlist(data_lookup %>% filter(Code == "H_OAI_APPROP_DOSAGE") %>% 
                          select(starts_with("ABX-CHOICE")), use.names = FALSE)
      ) %>%
        filter(!is.na(Drug)) %>%
        distinct()
      
      data_BJ_choice <- data_BJ_choice %>%
        left_join(lookup_long, by = c("ATC5" = "Drug"))
      
      # EXACT R markdown: filter AWaRe_compatible for patient summary
      patient_summary_BJ <- data_BJ_choice %>%
        filter(AWaRe_compatible) %>%  # This gives 23 patients
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          All_ABX = list(unique(ATC5)),
          Match_1_P = any(ATC5 == lookup_names[1] & Route == "P"),
          Match_2_P = any(ATC5 == lookup_names[2] & Route == "P"),
          Match_3_P = any(ATC5 == lookup_names[3] & Route == "P"),
          Match_4_P = any(ATC5 == lookup_names[4] & Route == "P"),
          Match_5_P = any(ATC5 == lookup_names[5] & Route == "P"),
          Match_6_P = any(ATC5 == lookup_names[6] & Route == "P"),
          Any_IV = any(Route == "P"),
          Any_Oral = any(Route == "O"),
          N_ABX = n_distinct(ATC5),
          .groups = "drop"
        ) %>%
        rowwise() %>%
        mutate(
          Num_Recommended_P = sum(c_across(Match_1_P:Match_6_P)),
          Appropriate = (Num_Recommended_P == 1 & N_ABX == 1),
          Partial_Appropriate = (Num_Recommended_P >= 1 & N_ABX > 1),
          No_Appropriate = (Any_IV & !Appropriate & !Partial_Appropriate),
          Oral_antibiotics = (Any_Oral & !Appropriate & !Partial_Appropriate & !No_Appropriate),
          No_Appropriate_others = (!Appropriate & !Partial_Appropriate & !No_Appropriate & !Oral_antibiotics)
        ) %>%
        ungroup()
      
      list(
        data_BJ_choice = data_BJ_choice,
        patient_summary_BJ = patient_summary_BJ
      )
    })
    
    # =======================
    # CHOICE PLOT - EXACT R MARKDOWN
    # =======================
    output$choice_plot <- renderPlotly({
      ch <- choice_data_reactive()
      if (is.null(ch)) return(plotly_empty())
      
      patient_summary_BJ <- ch$patient_summary_BJ
      data_BJ_choice <- ch$data_BJ_choice
      
      # EXACT R markdown: Get not eligible patients (where ALL rows are ineligible)
      not_eligible_patients_BJ <- data_BJ_choice %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # EXACT R markdown: Reshape eligible indicators to long format
      eligible_long_BJ <- patient_summary_BJ %>%
        select(`Survey Number`, `Department name`, Appropriate, Partial_Appropriate, 
               No_Appropriate, Oral_antibiotics, No_Appropriate_others) %>%
        pivot_longer(
          cols = -c(`Survey Number`, `Department name`),
          names_to = "Indicator",
          values_to = "Value"
        ) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # EXACT R markdown: Create "Not Eligible" summary
      ineligible_summary_BJ <- not_eligible_patients_BJ %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      # EXACT R markdown: Combine all indicator data
      combined_BJ <- bind_rows(eligible_long_BJ, ineligible_summary_BJ)
      
      # EXACT R markdown: Expand all department-indicator combinations
      all_combos_BJ <- expand_grid(
        `Department name` = unique(combined_BJ$`Department name`),
        Indicator = c("Appropriate", "Partial_Appropriate", "No_Appropriate", 
                      "Oral_antibiotics", "No_Appropriate_others", "Not_Eligible")
      )
      
      # EXACT R markdown: Ensure all categories appear with 0 if missing
      qi_long_BJ <- all_combos_BJ %>%
        left_join(combined_BJ, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      # EXACT R markdown: Department totals
      dept_totals_BJ <- qi_long_BJ %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      # EXACT R markdown: Calculate proportions and clean labels
      qi_summary_BJ <- qi_long_BJ %>%
        left_join(dept_totals_BJ, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Appropriate" ~ "Received recommended IV antibiotics",
            Indicator == "Partial_Appropriate" ~ "Partially received recommended IV antibiotics",
            Indicator == "No_Appropriate" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Oral_antibiotics" ~ "Received oral antibiotics",
            Indicator == "No_Appropriate_others" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe BJI QIs",
            TRUE ~ Indicator
          ),
          Proportion = round(Patients / Total, 4)
        )
      
      # EXACT R markdown: Add Hospital-Wide totals
      hospital_data_BJ <- qi_summary_BJ %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      # EXACT R markdown: Combine with department-level data
      qi_summary_BJ <- bind_rows(qi_summary_BJ, hospital_data_BJ)
      
      # EXACT R markdown: Recalculate total and proportion for Hospital-Wide
      qi_summary_BJ <- qi_summary_BJ %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = round(Patients / Total, 4)
        ) %>%
        ungroup()
      
      # Indicator levels
      indicator_levels <- c(
        "Received recommended IV antibiotics",
        "Partially received recommended IV antibiotics",
        "Received IV antibiotics not among recommended options",
        "Received oral antibiotics",
        "Received other non-IV/oral antibiotics",
        "Not eligible for AWaRe BJI QIs"
      )
      
      qi_summary_BJ <- qi_summary_BJ %>%
        mutate(
          Indicator = factor(Indicator, levels = indicator_levels),
          PlotLabel = ifelse(
            `Department name` == "Hospital-Wide",
            "<b style='color:#0072B2;'>Hospital-Wide</b>",
            `Department name`
          )
        )
      
      label_order <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(setdiff(unique(qi_summary_BJ$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>"))
      )
      qi_summary_BJ$PlotLabel <- factor(qi_summary_BJ$PlotLabel, levels = label_order)
      
      palette <- c(
        "Received recommended IV antibiotics" = "#1F77B4",
        "Partially received recommended IV antibiotics" = "#4FA9DC",
        "Received IV antibiotics not among recommended options" = "#EF476F",
        "Received oral antibiotics" = "#F9D99E",
        "Received other non-IV/oral antibiotics" = "#D3D3D3",
        "Not eligible for AWaRe BJI QIs" = "#A9A9A9"
      )
      
      p <- ggplot(
        qi_summary_BJ,
        aes(
          x = PlotLabel, y = Proportion, fill = Indicator,
          text = paste0(
            "Department: ", `Department name`, "<br>",
            "Category: ", Indicator, "<br>",
            "Patients: ", Patients, "<br>",
            "Total: ", Total
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
          data = qi_summary_BJ %>% distinct(PlotLabel, Total),
          aes(x = PlotLabel, y = 1.02, label = paste0("n=", Total)),
          inherit.aes = FALSE, size = 3, color = "gray30", hjust = 0.5
        ) +
        scale_fill_manual(values = palette, drop = FALSE) +
        scale_y_continuous(limits = c(0, 1.08), expand = c(0, 0),
                           labels = scales::percent_format(accuracy = 1)) +
        scale_x_discrete(expand = c(0.01, 0.01)) +
        labs(
          x = "Department",
          y = "Proportion of Patients",
          fill = "Treatment Appropriateness"
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
        guides(fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"))
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>Antibiotic Choice Alignment Summary for Bone and Joint Infection</b>",
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
            title = list(text = "<b>Treatment Classification</b>", font = list(size = 9))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          xaxis = list(
            automargin = TRUE,
            tickangle = 45,
            categoryorder = "array",
            categoryarray = label_order
          ),
          yaxis = list(automargin = TRUE)
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
    
    
    # ---- choice_aware_plot (fixed counts, same style as aware_classification_plot) ----
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
      
      data_BJ_choice <- ch$data_BJ_choice
      
      # --- Summarise data ---
      patient_summary_AWARE <- data_BJ_choice %>%
        filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>%
        group_by(`Survey Number`, `Department name`, AWaRe) %>%
        summarise(
          N_total   = n(),
          N_match   = sum(Drug_Match),
          N_p       = sum(Route == "P"),
          N_p_match = sum(Route == "P" & Drug_Match),
          .groups   = "drop"
        ) %>%
        mutate(Appropriate_IV = (N_p_match > 0))
      
      # --- Long format ---
      AWaRe_long <- patient_summary_AWARE %>%
        select(`Survey Number`, `Department name`, AWaRe, Appropriate_IV) %>%
        pivot_longer(-c(`Survey Number`,`Department name`,AWaRe),
                     names_to = "Indicator", values_to = "Value") %>%
        filter(Value) %>%
        group_by(`Department name`, AWaRe, Indicator) %>%
        summarise(Patients = n(), .groups = "drop") %>%
        group_by(`Department name`) %>%
        mutate(Total = sum(Patients), Proportion = ifelse(Total > 0, Patients/Total, 0)) %>%
        ungroup()
      
      # --- Hospital-wide row ---
      hospital <- AWaRe_long %>%
        group_by(AWaRe) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      AWaRe_long <- bind_rows(AWaRe_long, hospital) %>%
        group_by(`Department name`) %>%
        mutate(
          Total       = sum(Patients),
          Proportion  = ifelse(Total > 0, Patients/Total, 0)
        ) %>%
        ungroup()
      
      # Filter out departments with no data
      AWaRe_long <- AWaRe_long %>% dplyr::filter(Total > 0)
      if (nrow(AWaRe_long) == 0) {
        return(plotly_empty() %>%
                 layout(title = list(text = "No data available for AWaRe classification analysis",
                                     font = list(size = 12))))
      }
      
      # --- Factor levels ---
      aware_levels_stack  <- c("WATCH","ACCESS")
      aware_levels_legend <- c("ACCESS","WATCH")
      AWaRe_long$AWaRe <- factor(AWaRe_long$AWaRe, levels = aware_levels_stack)
      
      # --- ENSURE all AWaRe categories present for legend (add dummy rows if needed) ---
      existing_aware <- unique(AWaRe_long$AWaRe)
      missing_aware <- setdiff(aware_levels_legend, as.character(existing_aware))
      
      if (length(missing_aware) > 0) {
        dummy_rows <- expand_grid(
          `Department name` = unique(AWaRe_long$`Department name`)[1],
          AWaRe = factor(missing_aware, levels = aware_levels_stack),
          Patients = 0,
          Total = max(AWaRe_long$Total, na.rm = TRUE),
          Proportion = 0,
          Count = 0L,
          dept_total = max(AWaRe_long$Total, na.rm = TRUE)
        )
        AWaRe_long <- bind_rows(AWaRe_long, dummy_rows)
      }
      
      # --- FIX: integer counts per department ---
      AWaRe_long <- AWaRe_long %>%
        group_by(`Department name`) %>%
        group_modify(~ {
          df <- .x
          dt <- max(df$Total, na.rm = TRUE)
          raw <- df$Proportion * dt
          base <- floor(raw)
          remainder <- dt - sum(base)
          if (remainder > 0) {
            frac_order <- order(-(raw - base))
            base[frac_order[seq_len(remainder)]] <- base[frac_order[seq_len(remainder)]] + 1L
          }
          df$Count <- as.integer(base)
          df$dept_total <- dt
          df
        }) %>%
        ungroup()
      
      # --- Labels and hover text ---
      AWaRe_long <- AWaRe_long %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          IsHospitalWide = (`Department name` == "Hospital-Wide"),
          ProportionPct = Proportion * 100,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>AWaRe Classification:</b> ", as.character(AWaRe), "<br>",
            "<b>Count:</b> ", Count, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      # --- Ordered labels ---
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(unique(AWaRe_long$PlotLabel[AWaRe_long$PlotLabel != "<b style='color:#0072B2;'>Hospital-Wide</b>"]))
      )
      AWaRe_long$PlotLabel <- factor(AWaRe_long$PlotLabel, levels = ordered_labels)
      
      # --- n= labels ---
      label_data <- AWaRe_long %>%
        distinct(`Department name`, PlotLabel, dept_total)
      
      # --- Dynamic buffer ---
      max_digits <- max(nchar(as.character(label_data$dept_total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # --- ggplot ---
      p <- ggplot(AWaRe_long, aes(y = PlotLabel, x = ProportionPct, fill = AWaRe, text = hover_text)) +
        geom_bar(stat = "identity", position = "fill", width = 0.85) +
        geom_text(
          aes(label = ifelse(Proportion > 0.05, paste0(round(ProportionPct, 0), "%"), "")),
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
          breaks = aware_levels_legend,
          values = c("ACCESS"="#1b9e77","WATCH"="#ff7f00"), 
          drop = FALSE
        ) +
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
        guides(
          fill = guide_legend(
            nrow = 1, 
            byrow = TRUE, 
            title.position = "top",
            override.aes = list(fill = c("#1b9e77", "#ff7f00"))
          )
        ) +
        scale_y_discrete(limits = rev(levels(AWaRe_long$PlotLabel)))
      
      # --- Convert to plotly ---
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Use of Recommended IV Antibiotics by AWaRe Classification</b><br>"
            ),
            x = 0.5, xanchor = "center",
            y = 0.98, yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width  = 730,
          margin = list(l = 30, r = r_margin, t = 60, b = 170),
          legend = list(
            orientation = "h", x = 0.5, xanchor = "center",
            y = -0.40, yanchor = "top",
            font = list(size = 10),
            title = list(text = "<b>AWaRe Classification</b>", font = list(size = 10)),
            traceorder = "normal"
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
      
      # Force reorder legend traces in plotly
      legend_order_map <- setNames(seq_along(aware_levels_legend), aware_levels_legend)
      plt$x$data <- plt$x$data[order(sapply(plt$x$data, function(trace) {
        legend_order_map[trace$name]
      }))]
      
      plt
    })
    
    
    # ---------- By Line of Treatment (fixed counts, with legend ordering) ----------
    output$choice_line_plot <- renderPlotly({
      ch <- choice_data_reactive()
      if (is.null(ch)) return(plotly_empty())
      data_BJ_choice <- ch$data_BJ_choice
      
      choice_levels_stack  <- c("Second choice","First choice")
      choice_levels_legend <- c("First choice","Second choice")
      
      combos <- expand_grid(
        `Department name` = unique(data_BJ_choice$`Department name`),
        Choice = choice_levels_stack
      )
      
      # --- Department-level summary ---
      choice_summary <- data_BJ_choice %>%
        filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL",
               AWaRe %in% AWaRe_abx, Route == "P", !is.na(Choice)) %>%
        group_by(`Department name`, Choice) %>%
        summarise(Prescriptions = n(), .groups = "drop") %>%
        right_join(combos, by = c("Department name","Choice")) %>%
        mutate(Prescriptions = replace_na(Prescriptions, 0)) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Prescriptions),
          Proportion = ifelse(Total > 0, Prescriptions/Total, 0)
        ) %>%
        ungroup()
      
      # --- Hospital-wide summary ---
      hospital <- data_BJ_choice %>%
        filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL",
               AWaRe %in% AWaRe_abx, Route == "P", !is.na(Choice)) %>%
        group_by(Choice) %>%
        summarise(Prescriptions = n(), .groups = "drop") %>%
        right_join(tibble(Choice = choice_levels_stack), by = "Choice") %>%
        mutate(Prescriptions = replace_na(Prescriptions, 0),
               `Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Prescriptions),
          Proportion = ifelse(Total > 0, Prescriptions/Total, 0)
        ) %>%
        ungroup()
      
      choice_summary <- bind_rows(choice_summary, hospital)
      
      # Filter out departments with no data
      choice_summary <- choice_summary %>%
        group_by(`Department name`) %>%
        mutate(dept_total_check = sum(Prescriptions, na.rm = TRUE)) %>%
        ungroup() %>%
        filter(dept_total_check > 0) %>%
        select(-dept_total_check)
      
      if(nrow(choice_summary) == 0) {
        return(plotly_empty() %>%
                 layout(title = list(text = "No data available for treatment line analysis",
                                     font = list(size = 12))))
      }
      
      # --- FIX: integer counts that always sum to Total ---
      choice_summary <- choice_summary %>%
        group_by(`Department name`) %>%
        group_modify(~ {
          df <- .x
          dt <- max(df$Total, na.rm = TRUE)
          raw <- df$Proportion * dt
          base <- floor(raw)
          remainder <- dt - sum(base)
          if (remainder > 0) {
            frac_order <- order(-(raw - base))
            base[frac_order[seq_len(remainder)]] <- base[frac_order[seq_len(remainder)]] + 1L
          }
          df$Count <- as.integer(base)
          df$dept_total <- dt
          df
        }) %>%
        ungroup()
      
      # --- Labels & hover text ---
      choice_summary <- choice_summary %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          IsHospitalWide = (`Department name` == "Hospital-Wide"),
          Choice = factor(Choice, levels = choice_levels_stack),
          ProportionPct = Proportion * 100,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Treatment Choice:</b> ", as.character(Choice), "<br>",
            "<b>Count:</b> ", Count, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      # --- Ordered labels ---
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(unique(choice_summary$PlotLabel[choice_summary$PlotLabel != "<b style='color:#0072B2;'>Hospital-Wide</b>"]))
      )
      choice_summary$PlotLabel <- factor(choice_summary$PlotLabel, levels = ordered_labels)
      
      # Create label_data from dept_total
      label_data <- choice_summary %>%
        group_by(`Department name`, PlotLabel) %>%
        summarise(Total = sum(Prescriptions, na.rm = TRUE), .groups = "drop") %>%
        mutate(
          PlotLabel = factor(PlotLabel, levels = levels(choice_summary$PlotLabel))
        )
      
      # --- Dynamic buffer ---
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # --- ggplot ---
      p <- ggplot(choice_summary, aes(y = PlotLabel, x = ProportionPct, fill = Choice, text = hover_text)) +
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
          breaks = choice_levels_legend,  # MODIFIED: Controls legend order
          values = c("First choice"="#8E44AD","Second choice"="#00BCD4"),
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
            override.aes = list(fill = c("#8E44AD", "#00BCD4"))  # ADDED: Force legend colors in order
          )
        ) +
        scale_y_discrete(limits = rev(levels(choice_summary$PlotLabel)))
      
      # --- Convert to plotly ---
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Use of Recommended IV Antibiotics by Line of Treatment</b><br>"
            ),
            x = 0.5, xanchor = "center",
            y = 0.98, yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width  = 730,
          margin = list(l = 30, r = r_margin, t = 60, b = 170),
          legend = list(
            orientation = "h", x = 0.5, xanchor = "center",
            y = -0.40, yanchor = "top",
            font = list(size = 10),
            title = list(text = "<b>Treatment Choice</b>", font = list(size = 10)),
            traceorder = "normal"  # ADDED: Force plotly to respect order
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
      
      # ADDED: Force reorder legend traces in plotly
      legend_order_map <- setNames(seq_along(choice_levels_legend), choice_levels_legend)
      plt$x$data <- plt$x$data[order(sapply(plt$x$data, function(trace) {
        legend_order_map[trace$name]
      }))]
      
      plt
    })
    
    # ---------- Choice summary (correct denominator with zero categories) ----------
    output$choice_summary <- renderUI({
      choice_data <- choice_data_reactive()
      if (is.null(choice_data)) {
        return(HTML("<p>No data available for BJI choice summary</p>"))
      }
      
      patient_summary_BJ <- choice_data$patient_summary_BJ
      
      # Get the original eligible patient count (before filtering by IV use)
      if (!check_data()) return(HTML("<p>No data</p>"))
      
      data <- data_reactive()
      data_patients <- data$data_patients %>%
        mutate(
          Route = toupper(Route),
          AWaRe = case_when(
            toupper(AWaRe) %in% c("NOT_RECOMMENDED", "NOT RECOMMENDED") ~ "NOT RECOMMENDED",
            TRUE ~ AWaRe
          )
        )
      
      # Total eligible patients (before any IV filtering) - this is the true denominator
      total_eligible <- data_patients %>%
        filter(`Diagnosis code` == "BJ",
               `Age years` >= 18, 
               Indication == "CAI", 
               Treatment == "EMPIRICAL", 
               AWaRe %in% AWaRe_abx) %>%
        distinct(`Survey Number`) %>% 
        nrow()
      
      # Count eligible patients who received IV antibiotics (any IV route)
      total_iv <- data_patients %>%
        filter(`Diagnosis code` == "BJ",
               `Age years` >= 18, 
               Indication == "CAI", 
               Treatment == "EMPIRICAL", 
               AWaRe %in% AWaRe_abx,
               toupper(Route) == "P") %>%  # Only IV patients
        distinct(`Survey Number`) %>% 
        nrow()
      
      if (total_eligible == 0) {
        summary_html <- HTML(
          paste0(
            "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>",
            "<strong>Warning:</strong> No eligible BJI patients found for choice appropriateness analysis.<br><br>",
            "<em>This suggests no patients met the inclusion criteria for this analysis.</em>",
            "</div>"
          )
        )
        return(summary_html)
      }
      
      intro_text <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "<strong>Denominator:</strong> Number of eligible patients who received any IV antibiotics for Bone and Joint Infection (<strong>", total_iv, "</strong> out of ", total_eligible, ").",
        "</div><br><br>",
        "<strong>Summary:</strong><br><br>"
      )
      
      # Get all departments (including those with zero cases)
      all_departments <- unique(c(patient_summary_BJ$`Department name`, "Hospital-Wide"))
      
      # Create complete grid of all departments × all categories
      all_categories <- c("Appropriate", "Partial_Appropriate", "No_Appropriate")
      
      complete_grid <- expand_grid(
        `Department name` = all_departments[all_departments != "Hospital-Wide"],
        Category = all_categories
      )
      
      # Count by department and category (including zeros)
      complete_summary <- patient_summary_BJ %>%
        select(`Department name`, Appropriate, Partial_Appropriate, No_Appropriate) %>%
        pivot_longer(-`Department name`, names_to = "Category", values_to = "Value") %>%
        filter(Value) %>%
        group_by(`Department name`, Category) %>%
        summarise(Count = n(), .groups = "drop") %>%
        right_join(complete_grid, by = c("Department name", "Category")) %>%
        mutate(Count = replace_na(Count, 0)) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Count),
          Proportion = ifelse(Total > 0, Count / Total, 0)
        ) %>%
        ungroup() %>%
        filter(Total > 0)  # Only show departments that have patients
      
      # Hospital-wide summary
      hospital_summary <- complete_summary %>%
        group_by(Category) %>%
        summarise(Count = sum(Count), .groups = "drop") %>%
        mutate(
          `Department name` = "Hospital-Wide",
          Total = sum(Count),
          Proportion = ifelse(Total > 0, Count / Total, 0)
        )
      
      final_summary <- bind_rows(hospital_summary, complete_summary) %>%
        mutate(
          Category = case_when(
            Category == "Appropriate" ~ "Received recommended IV antibiotics",
            Category == "Partial_Appropriate" ~ "Partially received recommended IV antibiotics", 
            Category == "No_Appropriate" ~ "Received IV antibiotics not among recommended options"
          )
        )
      
      # Format blocks (including zero categories)
      formatted_blocks <- final_summary %>%
        group_by(`Department name`) %>%
        summarise(
          block = {
            dept <- first(`Department name`)
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            total_dept <- first(Total)
            
            # Create all three categories, even if some are zero
            categories_data <- data.frame(
              Category = c("Received recommended IV antibiotics", 
                           "Partially received recommended IV antibiotics", 
                           "Received IV antibiotics not among recommended options"),
              Count = c(
                ifelse(any(Category == "Received recommended IV antibiotics"), 
                       Count[Category == "Received recommended IV antibiotics"], 0),
                ifelse(any(Category == "Partially received recommended IV antibiotics"), 
                       Count[Category == "Partially received recommended IV antibiotics"], 0),
                ifelse(any(Category == "Received IV antibiotics not among recommended options"), 
                       Count[Category == "Received IV antibiotics not among recommended options"], 0)
              ),
              stringsAsFactors = FALSE
            ) %>%
              mutate(
                Proportion = ifelse(total_dept > 0, Count / total_dept, 0),
                Emoji = c("✅", "⚠️", "❌")
              )
            
            categories_text <- paste(
              paste0(
                "<li>", categories_data$Emoji, " <strong>", categories_data$Category, 
                "</strong> (as per WHO AWaRe book): <strong>",
                scales::percent(categories_data$Proportion, accuracy = 0.1),
                "</strong> (", categories_data$Count, " out of ", total_dept, ")</li>"
              ),
              collapse = ""
            )
            
            paste0(
              "<div style='background-color: ", bg, "; border-left: 5px solid ", color, "; padding: 14px; margin-bottom: 20px;'>",
              "<strong>", dept, "</strong> ",
              "<span style='color: #888;'>(n = ", total_dept, " patients)</span><br><br>",
              "<ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>",
              categories_text,
              "</ul>",
              "</div>"
            )
          },
          .groups = "drop"
        ) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>%
        select(-order)
      
      summary_html <- HTML(paste0(intro_text, paste(formatted_blocks$block, collapse = "\n")))
      return(summary_html)
    })
    
    
    # =======================
    # DOSAGE LOGIC (exact base code)
    # =======================
    dosage_data_reactive <- reactive({
      if (!check_data()) return(NULL)
      data <- data_reactive()
      data_patients <- data$data_patients %>%
        mutate(
          Route = toupper(Route),
          ATC5 = trimws(toupper(ATC5)),
          AWaRe = case_when(
            toupper(AWaRe) %in% c("NOT_RECOMMENDED", "NOT RECOMMENDED") ~ "NOT RECOMMENDED",
            TRUE ~ AWaRe
          )
        )
      data_lookup <- data$data_lookup
      
      data_BJ2 <- data_patients %>%
        filter(`Diagnosis code` == "BJ") %>%
        mutate(AWaRe_compatible = (`Age years` >= 18 & Indication == "CAI" &
                                     Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx))
      
      lookup2 <- data_lookup %>% filter(Code == "H_OAI_APPROP_DOSAGE")
      lookup_names2 <- unlist(lookup2[1, c("ABX-ATC-1","ABX-ATC-2","ABX-ATC-3",
                                           "ABX-ATC-4","ABX-ATC-5","ABX-ATC-6")], use.names = FALSE)
      lookup_names2 <- toupper(trimws(lookup_names2))
      
      data_BJ2 <- data_BJ2 %>%
        mutate(
          Unit_Factor = case_when(Unit == "mg" ~ 1, Unit == "g" ~ 1000, TRUE ~ NA_real_),
          Total_Daily_Dose = as.numeric(`Single Unit Dose`) * as.numeric(`N Doses/day`) * Unit_Factor
        )
      
      for (i in 1:6) {
        name_col <- paste0("ABX-ATC-", i)
        dose_col <- paste0("ABX-DOSE-", i)
        freq_col <- paste0("ABX-DAY-DOSE-", i)
        unit_col <- paste0("ABX-UNIT-", i)
        dose_match_col <- paste0("Match_Drug_Dose_", i)
        
        expected_dose  <- as.numeric(lookup2[[dose_col]]) * as.numeric(lookup2[[freq_col]])
        unit_factor    <- case_when(lookup2[[unit_col]] == "mg" ~ 1,
                                    lookup2[[unit_col]] == "g"  ~ 1000,
                                    TRUE ~ NA_real_)
        expected_total <- expected_dose * unit_factor
        drug_lookup    <- toupper(trimws(lookup2[[name_col]]))
        
        data_BJ2[[dose_match_col]] <- ifelse(
          data_BJ2$ATC5 == drug_lookup &
            abs(data_BJ2$Total_Daily_Dose - expected_total) < 1,
          TRUE, FALSE
        )
      }
      
      patient_summary2 <- data_BJ2 %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          Match_1_P = any(ATC5 == lookup_names2[1] & Route == "P"),
          Match_2_P = any(ATC5 == lookup_names2[2] & Route == "P"),
          Match_3_P = any(ATC5 == lookup_names2[3] & Route == "P"),
          Match_4_P = any(ATC5 == lookup_names2[4] & Route == "P"),
          Match_5_P = any(ATC5 == lookup_names2[5] & Route == "P"),
          Match_6_P = any(ATC5 == lookup_names2[6] & Route == "P"),
          Dose_1_OK = any(Match_Drug_Dose_1),
          Dose_2_OK = any(Match_Drug_Dose_2),
          Dose_3_OK = any(Match_Drug_Dose_3),
          Dose_4_OK = any(Match_Drug_Dose_4),
          Dose_5_OK = any(Match_Drug_Dose_5),
          Dose_6_OK = any(Match_Drug_Dose_6),
          Any_IV = any(Route == "P"),
          .groups = "drop"
        ) %>%
        mutate(
          Any_Match = Match_1_P | Match_2_P | Match_3_P | Match_4_P | Match_5_P | Match_6_P,
          Any_Correct_Dose =
            (Match_1_P & Dose_1_OK) | (Match_2_P & Dose_2_OK) | (Match_3_P & Dose_3_OK) |
            (Match_4_P & Dose_4_OK) | (Match_5_P & Dose_5_OK) | (Match_6_P & Dose_6_OK),
          Dose_Result = case_when(
            Any_Correct_Dose ~ "Received recommended IV antibiotic with recommended dosage",
            Any_Match & !Any_Correct_Dose ~ "Received recommended IV antibiotic without recommended dosage",
            Any_IV & !Any_Match ~ "Received IV antibiotics not among recommended options",
            TRUE ~ NA_character_
          )
        ) %>% filter(!is.na(Dose_Result))
      
      iv_dose_counts <- patient_summary2 %>%
        count(`Department name`, Dose_Result, name = "Patients")
      
      all_combos2 <- expand_grid(
        `Department name` = unique(patient_summary2$`Department name`),
        Dose_Result = c("Received recommended IV antibiotic with recommended dosage",
                        "Received recommended IV antibiotic without recommended dosage",
                        "Received IV antibiotics not among recommended options")
      )
      
      iv_dose_summary2 <- all_combos2 %>%
        left_join(iv_dose_counts, by = c("Department name","Dose_Result")) %>%
        mutate(Patients = replace_na(Patients, 0)) %>%
        group_by(`Department name`) %>%
        mutate(Total = sum(Patients), Proportion = ifelse(Total>0, 100*Patients/Total, 0)) %>%
        ungroup()
      
      hospital_row2 <- iv_dose_summary2 %>%
        group_by(Dose_Result) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(Total = sum(Patients), Proportion = ifelse(Total>0, 100*Patients/Total, 0)) %>%
        ungroup()
      
      final_summary2 <- bind_rows(iv_dose_summary2, hospital_row2) %>%
        arrange(`Department name`, Dose_Result)
      
      list(final_summary2 = final_summary2, patient_summary2 = patient_summary2)
    })
    
    # ---------- DOSAGE plot (horizontal stacked; with title + subtitle, no overlap) ----------
    output$dosage_plot <- renderPlotly({
      dd <- dosage_data_reactive()
      if (is.null(dd)) return(plotly_empty())
      final_summary2 <- dd$final_summary2
      
      final_summary2$Dose_Result <- factor(
        final_summary2$Dose_Result,
        levels = c(
          "Received recommended IV antibiotic with recommended dosage",
          "Received recommended IV antibiotic without recommended dosage",
          "Received IV antibiotics not among recommended options"
        )
      )
      
      # --- FIX: integer counts per department ---
      final_summary2 <- final_summary2 %>%
        group_by(`Department name`) %>%
        group_modify(~ {
          df <- .x
          dt <- max(df$Total, na.rm = TRUE)
          raw <- df$Proportion
          base <- floor(raw)
          remainder <- dt - sum(base)
          if (remainder > 0) {
            frac_order <- order(-(raw - base))
            base[frac_order[seq_len(remainder)]] <- base[frac_order[seq_len(remainder)]] + 1L
          }
          df$Count <- as.integer(base)
          df$dept_total <- dt
          df
        }) %>%
        ungroup()
      
      # --- Labels and hover text ---
      final_summary2 <- final_summary2 %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          ProportionPct = Proportion,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Treatment:</b> ", as.character(Dose_Result), "<br>",
            "<b>Count:</b> ", Count, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      # --- Ordered labels ---
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(unique(final_summary2$PlotLabel[final_summary2$PlotLabel != "<b style='color:#0072B2;'>Hospital-Wide</b>"]))
      )
      final_summary2$PlotLabel <- factor(final_summary2$PlotLabel, levels = ordered_labels)
      
      # --- n= labels ---
      label_data <- final_summary2 %>%
        distinct(`Department name`, PlotLabel, Total) %>%
        mutate(dept_total = Total)
      
      # --- Dynamic buffer ---
      max_digits <- max(nchar(as.character(label_data$dept_total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # --- ggplot ---
      p <- ggplot(final_summary2, aes(y = PlotLabel, x = ProportionPct, fill = Dose_Result, text = hover_text)) +
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
            "Received recommended IV antibiotic with recommended dosage" = "#084594",
            "Received recommended IV antibiotic without recommended dosage" = "#FC9272",
            "Received IV antibiotics not among recommended options" = "#D3D3D3"
          )
        ) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
          title = NULL,
          subtitle = NULL,
          x = "Proportion of Patients",
          y = "Department",
          fill = "Treatment Appropriateness"
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
          fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")
        ) +
        scale_y_discrete(limits = rev(levels(final_summary2$PlotLabel)))
      
      # --- Convert to plotly ---
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Antibiotic Prescriptions by Diagnosis</b><br>"
            ),
            x = 0.5,
            xanchor = "center",
            y = 0.98,
            yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width  = 730,
          margin = list(l = 30, r = r_margin, t = 60, b = 170),
          legend = list(
            orientation = "h",
            x = 0.5, xanchor = "center",
            y = -0.40, yanchor = "top",
            font = list(size = 10),
            title = list(text = "<b>Treatment Classification</b>", font = list(size = 10))
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
    
    
    
    # ---------- DOSAGE summary (corrected denominator as R markdown) ----------
    output$dosage_summary <- renderUI({
      dosage_data <- dosage_data_reactive()
      if (length(dosage_data) == 0) {
        return(HTML("<p>No data available for BJI dosage summary</p>"))
      }
      
      final_summary2 <- dosage_data$final_summary2
      patient_summary2 <- dosage_data$patient_summary2
      
      # Get the original eligible patient count (total eligible patients)
      if (!check_data()) return(HTML("<p>No data</p>"))
      
      data <- data_reactive()
      data_patients <- data$data_patients %>%
        mutate(
          Route = toupper(Route),
          AWaRe = case_when(
            toupper(AWaRe) %in% c("NOT_RECOMMENDED", "NOT RECOMMENDED") ~ "NOT RECOMMENDED",
            TRUE ~ AWaRe
          )
        )
      
      # Total eligible patients (before any filtering) - this is the true total
      total_eligible <- data_patients %>%
        filter(`Diagnosis code` == "BJ",
               `Age years` >= 18, 
               Indication == "CAI", 
               Treatment == "EMPIRICAL", 
               AWaRe %in% AWaRe_abx) %>%
        distinct(`Survey Number`) %>% 
        nrow()
      
      # Filter out Hospital-Wide for department-level counts
      final_summary2_BJ_filtered <- final_summary2 %>%
        filter(`Department name` != "Hospital-Wide")
      
      # Total patients who received any recommended (or partially recommended) IV antibiotic choice
      # This includes both categories: "with recommended dosage" AND "without recommended dosage"
      total_recommended_iv <- final_summary2_BJ_filtered %>%
        filter(Dose_Result %in% c(
          "Received recommended IV antibiotic with recommended dosage",
          "Received recommended IV antibiotic without recommended dosage"
        )) %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      if (is.na(total_recommended_iv) || total_recommended_iv == 0) {
        final_summary_html2 <- HTML(
          paste0(
            "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>",
            "⚠️ <strong>No summary available</strong> — there are currently no BJI patients who received a recommended IV antibiotic with dosage data available.<br><br>",
            "<em>This may indicate that no patients received antibiotics with recommended dosing, or none met inclusion criteria.</em>",
            "</div>"
          )
        )
        return(final_summary_html2)
      } else {
        
        intro_text2 <- paste0(
          "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
          "💊 <strong>Denominator:</strong> Number of eligible BJI patients who received any recommended (<em>or partially recommended</em>) IV antibiotic choice based on WHO AWaRe book (<strong>",
          total_recommended_iv, "</strong> out of <strong>", total_eligible, "</strong>).",
          "</div><br><br>",
          "<strong>Summary:</strong><br><br>"
        )
        
        # Get all possible combinations for only the two categories that matter for dosage analysis
        dept_list <- unique(final_summary2$`Department name`)
        dose_categories <- c(
          "Received recommended IV antibiotic with recommended dosage",
          "Received recommended IV antibiotic without recommended dosage"
        )
        
        # Filter to only include patients who received recommended antibiotics
        complete_summary <- expand_grid(
          `Department name` = dept_list,
          Dose_Result = dose_categories
        ) %>%
          left_join(final_summary2, by = c("Department name", "Dose_Result")) %>%
          mutate(Patients = replace_na(Patients, 0)) %>%
          group_by(`Department name`) %>%
          mutate(Total = sum(Patients)) %>%
          ungroup() %>%
          filter(Total > 0)  # Only departments with patients who received recommended antibiotics
        
        # Create summary data with two categories (dosage analysis only)
        summary_data_dosage <- complete_summary %>%
          select(`Department name`, Dose_Result, Patients, Total) %>%
          pivot_wider(
            names_from = Dose_Result,
            values_from = Patients,
            values_fill = 0
          ) %>%
          mutate(
            Prop_Recommended_Dosage = `Received recommended IV antibiotic with recommended dosage` / Total,
            Prop_Without_Recommended_Dosage = `Received recommended IV antibiotic without recommended dosage` / Total,
            # Replace NaN with 0 for departments with no patients
            Prop_Recommended_Dosage = ifelse(is.nan(Prop_Recommended_Dosage), 0, Prop_Recommended_Dosage),
            Prop_Without_Recommended_Dosage = ifelse(is.nan(Prop_Without_Recommended_Dosage), 0, Prop_Without_Recommended_Dosage)
          )
        
        # Format department blocks with two categories (matching R markdown)
        formatted_blocks2 <- summary_data_dosage %>%
          mutate(block = pmap_chr(
            list(
              `Department name`,
              Prop_Recommended_Dosage, `Received recommended IV antibiotic with recommended dosage`,
              Prop_Without_Recommended_Dosage, `Received recommended IV antibiotic without recommended dosage`,
              Total
            ),
            function(dept, prop_rec, n_rec, prop_without, n_without, total_n) {
              color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
              bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
              
              paste0(
                "<div style='background-color: ", bg, "; border-left: 5px solid ", color, "; padding: 14px; margin-bottom: 20px;'>",
                "<strong>🏥 ", dept, "</strong> <span style='color: #888;'>(n = ", total_n, " patients)</span><br><br>",
                "<ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>",
                "<li>✅ <strong>Received recommended IV antibiotic with recommended dosage</strong> (as per WHO AWaRe book): ",
                "<strong>", scales::percent(prop_rec, accuracy = 0.1), "</strong> ",
                "(", n_rec, " out of ", total_n, ")",
                "</li>",
                "<li>❌ <strong>Received recommended IV antibiotic without recommended dosage</strong> (as per WHO AWaRe book): ",
                "<strong>", scales::percent(prop_without, accuracy = 0.1), "</strong> ",
                "(", n_without, " out of ", total_n, ")",
                "</li>",
                "</ul>",
                "</div>"
              )
            }
          )) %>%
          mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
          arrange(order, `Department name`) %>%
          select(-order)
        
        # Combine HTML
        final_summary_html2 <- HTML(paste0(intro_text2, paste(formatted_blocks2$block, collapse = "\n")))
        return(final_summary_html2)
      }
    })
    
  })
}