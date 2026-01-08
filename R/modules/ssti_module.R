# SSTI Analysis Shiny Module - Complete Implementation Aligned with R Markdown
# This module contains all the SSTI-specific analysis functionality split into separate tabs

# Overview Tab UI
sstiOverviewUI <- function(id) {
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
        column(10, offset = 1,
               box(width = 12, title = "🔍 Initial Eligible Cases Check", status = "primary", solidHeader = TRUE,
                   htmlOutput(ns("overview_eligibility_feedback"))
               )
        )
      ),
      
      # MOVED: Key Insights - now appears after Initial Eligible Cases Check
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📊 Key Insights", status = "warning", solidHeader = TRUE,
                   htmlOutput(ns("summary_insights_cards"))
               )
        )
      ),
      
      # WHO AWaRe QIs sections
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🎯 AWaRe Quality Indicators for skin/soft tissue infections", status = "info", solidHeader = TRUE,
                   h5("Within the gPPS data structure, the following antibiotic use quality indicators have been identified:"),
                   p("1) "," Proportion of patients presenting with skin/soft tissue infections given the appropriate IV antibiotic according to the WHO AWaRe book."),
                   p("2) "," Proportion of patients presenting with skin/soft tissue infections prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book.")
                   
               )
        )
      ),
      
      # MOVED: Patient-Level and Prescription-Level Insights - now appear after AWaRe Quality Indicators
      fluidRow(
        box(width = 6, title = "👥 Patient-Level Insights", status = "info", solidHeader = TRUE, collapsed = TRUE, collapsible = TRUE,
            DT::dataTableOutput(ns("patient_level_table"))
        ),
        box(width = 6, title = "📑 Prescription-Level Insights", status = "success", solidHeader = TRUE, collapsed = TRUE, collapsible = TRUE,
            DT::dataTableOutput(ns("prescription_level_table"))
        )
      )
    )
  )
}

# Eligibility Check Tab UI
sstiEligibilityUI <- function(id) {
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
                       p("Please upload your data files to check eligible cases.")
                   )
               )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🔍 Initial Eligible Cases Check", status = "primary", solidHeader = TRUE,
                   p("This section assesses whether there are enough eligible cases to support meaningful analysis."),
                   htmlOutput(ns("eligibility_feedback"))
               )
        )
      )
    )
  )
}

# Patient Summary Tab UI
sstiPatientSummaryUI <- function(id) {
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
                   p("Please upload your data files to view patient summary.")
               )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🧾 Eligibility Criteria", status = "primary", solidHeader = TRUE,
                   p("Eligible patients for WHO AWaRe Quality Indicator (QI) assessment are defined as adult inpatients (≥18 years) who received empirical antibiotics for community-acquired skin/soft tissue infections.")
               )
        )
      )
    )
  )
}

# QI Guidelines Tab UI
sstiQIGuidelinesUI <- function(id) {
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
                   p("Please upload your data files to view QI guidelines.")
               )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📘 WHO AWaRe-QIs Overview", status = "primary", solidHeader = TRUE,
                   div(class = "condition-box",
                       strong("This script evaluates TWO indicators:"), br(), br(),
                       strong("1. H_SSTI_APPROP_ABX:"), " Proportion of patients presenting with skin/soft tissue infections given the appropriate IV antibiotic according to the WHO AWaRe book.", br(),
                       strong("2. H_SSTI_APPROP_DOSAGE:"), " Proportion of patients presenting with skin/soft tissue infections prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book."
                   ),
                   
                   div(class = "note-box",
                       strong("🔍 WHO AWaRe book Recommendation:"), br(), br(),
                       tags$ul(
                         tags$li("(", strong("Piperacillin + tazobactam"), " (4 g + 500 mg q6h IV) COMBINED WITH ", strong("Clindamycin"), " (900 mg q8h IV)) with or without ", strong("Vancomycin"), " (15–20 mg/kg q12h IV)"),
                         tags$li("(", strong("Ceftriaxone"), " (2 g q24h IV) COMBINED WITH ", strong("Metronidazole"), " (500 mg q8h IV)) with or without ", strong("Vancomycin"), " (15–20 mg/kg q12h IV)"),
                         tags$li(strong("Amoxicillin + clavulanic acid"), " (1 g + 200 mg q8h IV or 875 mg + 125 mg q8h ORAL)"),
                         tags$li(strong("Cefalexin"), " (500 mg q8h ORAL)"),
                         tags$li(strong("Cloxacillin"), " (2 g q6h IV or 500 mg q6h ORAL)")
                       )
                   ),
                   
                   div(class = "warning-box",
                       strong("🩺 WHO AWaRe Notes:"), br(),
                       tags$ul(
                         tags$li("The intravenous route is preferred at least in the first week of treatment"),
                         tags$li("Step down to oral treatment is based on improvement"),
                         tags$li("If cloxacillin is unavailable, any other IV antistaphylococcal penicillin could be used."),
                         tags$li("For oral administration, dicloxacillin and flucloxacillin are preferred options within the class as they have better oral bioavailability"),
                         tags$li("Please refer to the WHO AWaRe Antibiotic Book for detailed case-specific recommendations and considerations for different SSIs")
                       )
                   )
               )
        )
      )
    )
  )
}


# Choice Appropriateness Tab UI - Complete Version with White Backgrounds
sstiChoiceAnalysisUI <- function(id) {
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
                 title = "📌 Indicator Antibiotic Choice Alignment with AWaRe book Recommendations for skin/soft tissue infections", 
                 status = "primary", 
                 solidHeader = TRUE,
                 p("Proportion of patients presenting with skin/soft tissue infections given the appropriate IV antibiotic according to the WHO AWaRe book.")
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
                   tags$li("(", strong("Piperacillin + tazobactam"), " (4 g + 500 mg q6h IV) COMBINED WITH ", strong("Clindamycin"), " (900 mg q8h IV)) with or without ", strong("Vancomycin"), " (15–20 mg/kg q12h IV)"),
                   tags$li("(", strong("Ceftriaxone"), " (2 g q24h IV) COMBINED WITH ", strong("Metronidazole"), " (500 mg q8h IV)) with or without ", strong("Vancomycin"), " (15–20 mg/kg q12h IV)"),
                   tags$li(strong("Amoxicillin + clavulanic acid"), " (1 g + 200 mg q8h IV or 875 mg + 125 mg q8h ORAL)"),
                   tags$li(strong("Cefalexin"), " (500 mg q8h ORAL)"),
                   tags$li(strong("Cloxacillin"), " (2 g q6h IV or 500 mg q6h ORAL)")
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
                   " Antibiotic Choice Alignment with AWaRe book Recommendations for skin/soft tissue infections"
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
                       p("This visual summarises the proportion of antibiotic alignment for skin/soft tissue infections across hospital departments based on WHO AWaRe book"),
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
                       p("This visual summarises the proportion of antibiotic alignment for skin/soft tissue infections across hospital departments by WHO AWaRe Classification (Access, Watch, Reserve)"),
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
                           plotlyOutput(ns("aware_plot"), height = "450px", width = "100%"),
                           type = 4
                         )
                       ),
                       br(),
                       div(
                         class = "note-box",
                         style = "background-color: white; padding: 10px; border-radius: 5px; border-left: 4px solid #3498db;",
                         strong("💡 Note:"), 
                         " Each patient is counted once per AWaRe category if they received at least one recommended IV antibiotic from that category. Patients treated with recommended antibiotic combinations from multiple categories are included in each, so category totals can exceed the number of unique patients."
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
                 title = "📝 Summary of Antibiotic Choice Alignment with AWaRe book Recommendations for skin/soft tissue infections", 
                 status = "success", 
                 solidHeader = TRUE, 
                 collapsible = TRUE, 
                 collapsed = TRUE,
                 p("This section summarises the proportion of antibiotic choice alignment for skin/soft tissue infections across hospital departments based on the WHO AWaRe book."),
                 htmlOutput(ns("choice_appropriateness_summary"))
               )
        )
      )
    )
  )
}

# Dosage Appropriateness Tab UI
sstiDosageAnalysisUI <- function(id) {
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
                   p("Please upload your data files to view dosage appropriateness analysis.")
               )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📌 Antibiotic Dosage Alignment with AWaRe book Recommendations for skin/soft tissue infections", status = "primary", solidHeader = TRUE,
                   
                   " Proportion of patients presenting with skin/soft tissue infections prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book."
                   
               )
        )
      ),
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🔍 WHO AWaRe book Recommendation:", status = "primary", solidHeader = TRUE,
                   tags$ul(
                     tags$li("(", strong("Piperacillin + tazobactam"), " (4 g + 500 mg q6h IV) COMBINED WITH ", strong("Clindamycin"), " (900 mg q8h IV)) with or without ", strong("Vancomycin"), " (15–20 mg/kg q12h IV)"),
                     tags$li("(", strong("Ceftriaxone"), " (2 g q24h IV) COMBINED WITH ", strong("Metronidazole"), " (500 mg q8h IV)) with or without ", strong("Vancomycin"), " (15–20 mg/kg q12h IV)"),
                     tags$li(strong("Amoxicillin + clavulanic acid"), " (1 g + 200 mg q8h IV or 875 mg + 125 mg q8h ORAL)"),
                     tags$li(strong("Cefalexin"), " (500 mg q8h ORAL)"),
                     tags$li(strong("Cloxacillin"), " (2 g q6h IV or 500 mg q6h ORAL)")
                   )
               )  
        )
      ),
      
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📈 Antibiotic Dosage Alignment with AWaRe book Recommendations for skin/soft tissue infections",
            status = "primary", solidHeader = TRUE,
            p("This visual summarises dosage alignment for skin/soft tissue infections across hospital departments based on WHO AWaRe book"),
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
      
      column(10, offset = 1,
             div(class = "info-box",
                 strong("💡 Note:"),
                 tags$ul(
                   tags$li("Received recommended IV antibiotics with recommended dosage indicates that the full recommended treatment regimen (whether monotherapy or dual or triple therapy) was given, with all dosages aligned with WHO AWaRe book guidance."),
                   tags$li("Received at least one recommended IV antibiotic with some have recommended dosage refers to cases where only part of the recommended dual or triple therapy was given, and only some antibiotic were at the recommended dosage."),
                   tags$li("Received at least one recommended IV antibiotic with none have recommended dosage includes cases who received either the full recommended regimen with no recommended dosages, or only part of it (e.g., one agent from a dual therapy) with none of the dosages aligned with WHO AWaRe book guidance.")
                 )
             )
      ),
      
      
      # NEW SECTION - Summary Table
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📝 Summary of Antibiotic Dosage Alignment with AWaRe book Recommendations for skin/soft tissue infections", status = "success", solidHeader = TRUE,collapsible = TRUE ,collapsed = TRUE,
                   p("This section evaluates the alignment of IV antibiotic drug dosage for patients with skin/soft tissue infections, in line with the WHO AWaRe book."),
                   htmlOutput(ns("dosage_appropriateness_summary"))
               )
        )
      )
    )
  )
}


# Module Server - Handles all SSTI tabs
sstiAnalysisServer <- function(id, data_reactive) {
  moduleServer(id, function(input, output, session) {
    
    # Constants
    AWaRe_abx <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
    
    # Helper function to check if data is available
    check_data <- function() {
      data <- data_reactive()
      return(!is.null(data) && !is.null(data$data_patients) && !is.null(data$data_lookup))
    }
    
    # Output to control conditional panels
    output$dataUploaded <- reactive({
      check_data()
    })
    outputOptions(output, "dataUploaded", suspendWhenHidden = FALSE)
    
    # Eligibility feedback functions
    generate_eligibility_feedback <- function() {
      tryCatch({
        if (!check_data()) {
          return(HTML("<div style='background-color: #fff3cd; border: 1px solid #ffeeba; padding: 15px; border-radius: 5px;'><p><strong>⚠️ No data available</strong></p><p>Please upload your data files to check eligible cases.</p></div>"))
        }
        
        data <- data_reactive()
        data_patients <- data$data_patients
        data_info <- data$data_info
        
        # Check if required columns exist
        required_cols <- c("Diagnosis code", "Age years", "Indication", "Treatment", "AWaRe", "Route", "Survey Number")
        missing_cols <- setdiff(required_cols, names(data_patients))
        if(length(missing_cols) > 0) {
          return(HTML(paste0("<div style='background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 15px; border-radius: 5px;'><p><strong>❌ Missing required columns:</strong> ", paste(missing_cols, collapse = ", "), "</p></div>")))
        }
        
        # Filter eligible SSTI patients
        data_ssti <- data_patients %>%
          filter(`Diagnosis code` == "SST") %>%
          mutate(
            Route = toupper(as.character(Route)),
            AWaRe_compatible = (`Age years` >= 18 & 
                                  Indication == "CAI" & 
                                  Treatment == "EMPIRICAL" & 
                                  AWaRe %in% AWaRe_abx)
          ) 
        
        # Count eligible unique SSTI cases
        eligible_ssti_n <- data_ssti %>%
          filter(AWaRe_compatible) %>%
          distinct(`Survey Number`) %>%
          nrow()
        
        # Format survey dates safely
        survey_start <- if(!is.null(data_info$`Survey start date`)) {
          format(as.Date(data_info$`Survey start date`), "%d %b %Y")
        } else {
          "Not available"
        }
        
        survey_end <- if(!is.null(data_info$`Survey end date`)) {
          format(as.Date(data_info$`Survey end date`), "%d %b %Y")
        } else {
          "Not available"
        }
        
        # Build status message
        status_message <- if(eligible_ssti_n == 0) {
          "<div style='background-color:#fff3cd; border: 1px solid #ffeeba; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>🚫 No data available:</strong> There were no eligible cases for evaluation during this survey period. Please verify data availability.
          </div>"
        } else if(eligible_ssti_n < 10) {
          "<div style='background-color:#ffe0e0; border: 1px solid #ffb3b3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>⚠️ Caution:</strong> Few eligible cases detected. Interpret results with caution.
          </div>"
        } else {
          "<div style='background-color:#e0ffe0; border: 1px solid #b3ffb3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>✅ Good to go!</strong> Sufficient eligible cases available to proceed with full evaluation.
          </div>"
        }
        
        # Build HTML feedback
        html_feedback <- HTML(paste0(
          "<div style='background-color: #f0f8ff; border: 1px solid #add8e6; padding: 15px; border-radius: 5px; font-family: sans-serif;'>",
          "<p style='margin-bottom: 10px;'>",
          "This script applies <strong>WHO AWaRe Quality Indicators</strong> to adult inpatients with ",
          "empirical antibiotics for community-acquired skin & soft tissue infections (SSTI).",
          "</p>",
          "<ul>",
          "<li><strong>Diagnostic code:</strong> SST</li>",
          "<li><strong>Total eligible cases:</strong> ", eligible_ssti_n, "</li>",
          "</ul>",
          status_message,
          "</div>"
        ))
        
        return(html_feedback)
        
      }, error = function(e) {
        return(HTML(paste0("<div style='background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 15px; border-radius: 5px;'><p><strong>❌ Error loading eligibility information:</strong></p><p>", as.character(e$message), "</p></div>")))
      })
    }
    
    # Eligibility feedback outputs
    output$eligibility_feedback <- renderUI({
      generate_eligibility_feedback()
    })
    
    output$overview_eligibility_feedback <- renderUI({
      generate_eligibility_feedback()
    })
    
    # Summary Insights Cards
    output$summary_insights_cards <- renderUI({
      if (!check_data()) {
        return(HTML("<p>No data available for insights</p>"))
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      total_patients <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx , `Diagnosis code` == "SST") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      eligible_patients <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx, Treatment == "EMPIRICAL", `Diagnosis code` == "SST") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      total_prescriptions <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx , `Diagnosis code` == "SST") %>%
        nrow()
      
      eligible_prescriptions <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx, Treatment == "EMPIRICAL", `Diagnosis code` == "SST") %>%
        nrow()
      
      patient_percentage <- if(total_patients > 0) round((eligible_patients / total_patients) * 100, 1) else 0
      prescription_percentage <- if(total_prescriptions > 0) round((eligible_prescriptions / total_prescriptions) * 100, 1) else 0
      
      patient_color <- if(patient_percentage >= 10) "#d4edda" else if(patient_percentage >= 5) "#fff3cd" else "#f8d7da"
      prescription_color <- if(prescription_percentage >= 10) "#d4edda" else if(prescription_percentage >= 5) "#fff3cd" else "#f8d7da"
      
      insight_cards <- HTML(paste0(
        "<div style='display: flex; gap: 20px; flex-wrap: wrap;'>",
        
        # Card 1: Patients
        "<div style='flex: 1; min-width: 300px; background-color: ", patient_color, 
        "; border-left: 6px solid #28a745; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>",
        "<h4 style='margin-top: 0; color: #155724;'>👥 Proportion of Eligible Patients</h4>",
        "<div style='font-size: 2.5em; font-weight: bold; color: #155724; margin: 10px 0;'>", patient_percentage, "%</div>",
        "<p style='margin-bottom: 0; color: #155724;'>",
        "<strong>", eligible_patients, "</strong> out of <strong>", total_patients, 
        "</strong> patients on antibiotics for skin/soft tissue infections were QI-eligible patients.",
        "</p>",
        "</div>",
        
        # Card 2: Prescriptions
        "<div style='flex: 1; min-width: 300px; background-color: ", prescription_color, 
        "; border-left: 6px solid #17a2b8; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>",
        "<h4 style='margin-top: 0; color: #0c5460;'>📑 Proportion of Eligible Prescriptions</h4>",
        "<div style='font-size: 2.5em; font-weight: bold; color: #0c5460; margin: 10px 0;'>", prescription_percentage, "%</div>",
        "<p style='margin-bottom: 0; color: #0c5460;'>",
        "<strong>", eligible_prescriptions, "</strong> out of <strong>", total_prescriptions, 
        "</strong> antibiotic prescriptions for skin/soft tissue infections  were given to QI-eligible patients.",
        "</p>",
        "</div>",
        
        "</div>"
      ))
      
      return(insight_cards)
      
    })
    
    # Patient Level Table
    output$patient_level_table <- DT::renderDataTable({
      if (!check_data()) {
        return(DT::datatable(data.frame(Message = "No data available"), options = list(dom = 't'), rownames = FALSE))
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      total_patients <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx) %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      patient_summary <- data.frame(
        Category = c(
          "Number of adult patients (≥18 years) who received empirical antibiotic treatment for CAI",
          "Number of all patients with a diagnosis of skin/soft tissue infections on any antibiotics",
          "Number of eligible patients: Adult patients (≥18 years) with a diagnosis of skin/soft tissue infections who were treated empirically with antibiotics"
        ),
        Count = c(
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Diagnosis code` == "SST", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "SST", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow()
        )
      ) %>%
        mutate(
          Percent = sprintf("%.1f%%", 100 * Count / total_patients)
        )
      
      DT::datatable(
        patient_summary,
        colnames = c("Patient Category", "Number of Patients", "Proportion of All Patients"),
        options = list(pageLength = 10, dom = 't'),
        rownames = FALSE
      )
    })
    
    # Prescription Level Table
    output$prescription_level_table <- DT::renderDataTable({
      if (!check_data()) {
        return(DT::datatable(data.frame(Message = "No data available"), options = list(dom = 't'), rownames = FALSE))
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      total_prescriptions <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx) %>%
        nrow()
      
      prescription_summary <- data.frame(
        Category = c(
          "Number of empirical antibiotic prescriptions administered to adult patients (≥18 years) for CAI",
          "Number of all antibiotic prescriptions for patients diagnosed with skin/soft tissue infections",
          "Number of eligible antibiotic prescriptions: antibiotics empirically prescribed for adult patients (≥18 years) with skin/soft tissue infections"
        ),
        Count = c(
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Diagnosis code` == "SST", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "SST", AWaRe %in% AWaRe_abx) %>% nrow()
        )
      ) %>%
        mutate(
          Percent = sprintf("%.1f%%", 100 * Count / total_prescriptions)
        )
      
      DT::datatable(
        prescription_summary,
        colnames = c("Prescription Category", "Number of Prescriptions", "Proportion of All Prescriptions"),
        options = list(pageLength = 10, dom = 't'),
        rownames = FALSE
      )
    })
    
    # Choice Analysis Data Processing
    choice_data_reactive <- reactive({
      if (!check_data()) {
        return(list())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      # Filter and process SSTI data
      data_SST <- data_patients %>%
        filter(`Diagnosis code` == "SST") %>%
        mutate(
          Route = toupper(Route),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      # Lookup ABX names for SST QI
      lookup_names <- data_lookup %>%
        filter(Code == "H_SSTI_APPROP_ABX") %>%
        select(starts_with("ABX-ATC")) %>%
        unlist(use.names = FALSE)
      
      # Flag matched prescriptions
      data_SST <- data_SST %>%
        mutate(
          Drug_Match = ATC5 %in% lookup_names
        )
      
      # Patient Summary for SSTI
      patient_summary_SST <- data_SST %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>% 
        summarise(
          Abx_names = list(unique(ATC5[Route == "P"])),
          
          # Route-specific match flags
          Match_1_P = any(ATC5 == lookup_names[1] & Route == "P"),
          Match_2_P = any(ATC5 == lookup_names[2] & Route == "P"),
          Match_3_P = any(ATC5 == lookup_names[3] & Route == "P"),
          Match_4_P = any(ATC5 == lookup_names[4] & Route == "P"),
          Match_5_P = any(ATC5 == lookup_names[5] & Route == "P"),
          Match_6_P = any(ATC5 == lookup_names[6] & Route == "P"),
          Match_7_P = any(ATC5 == lookup_names[7] & Route == "P"),
          Match_8_P = any(ATC5 == lookup_names[8] & Route == "P"),
          
          Any_Oral = any(Route == "O"),
          Any_IV = any(Route == "P"),
          N_ABX = n_distinct(ATC5),
          
          .groups = "drop"
        ) %>%
        rowwise() %>%
        mutate(
          Num_recommended_given = sum(c_across(c(Match_1_P:Match_8_P, -Match_7_P))),
          All_IV_names_flat = paste0(unlist(Abx_names), collapse = ","),
          
          # Full match = correct pair given and no extra IV abx
          Received_full_recommended_IV = (
            (
              # Monotherapy cases
              (Match_6_P & Num_recommended_given == 1 & N_ABX == 1) |
                (Match_8_P & Num_recommended_given == 1 & N_ABX == 1)
            ) |
              (
                # Dual therapy cases
                ((Match_1_P & Match_2_P) |
                   (Match_3_P & Match_4_P)) &
                  Num_recommended_given == 2 & N_ABX == 2
              ) |
              (
                # triple antibiotic therapy cases
                ((Match_1_P & Match_2_P & Match_5_P) |
                   (Match_3_P & Match_4_P & Match_5_P)) &
                  Num_recommended_given == 3 & N_ABX == 3
              )
          ),
          
          # No match at all with recommended options
          Received_no_recommended_IV = Any_IV & Num_recommended_given == 0,
          
          # Partial = recommended abx used, but not in full combo or with extra abx
          Received_partial_recommended_IV = Any_IV & !Received_full_recommended_IV & !Received_no_recommended_IV,
          
          # flag patients who only got oral or non-matching routes
          Received_oral_only = Any_Oral & !Any_IV,
          Other_non_IV_or_oral = !Received_full_recommended_IV & !Received_partial_recommended_IV & 
            !Received_no_recommended_IV & !Received_oral_only
        ) %>%
        ungroup()
      
      list(
        data_SST = data_SST,
        patient_summary_SST = patient_summary_SST,
        lookup_names = lookup_names
      )
    })
    
    # Choice Plot - SSTI (Vertical stacking like third code format)
    output$choice_plot <- renderPlotly({
      choice_data <- choice_data_reactive()
      if (length(choice_data) == 0) {
        return(plotly_empty())
      }
      
      patient_summary_SST <- choice_data$patient_summary_SST
      data_SST <- choice_data$data_SST
      
      # Get not eligible patients with department info
      not_eligible_patients_SST <- data_SST %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary table with Department name
      eligible_long_SST <- patient_summary_SST %>%
        select(`Survey Number`, `Department name`, Received_full_recommended_IV, Received_partial_recommended_IV, 
               Received_no_recommended_IV, Received_oral_only, Other_non_IV_or_oral) %>%
        pivot_longer(
          cols = -c(`Survey Number`, `Department name`),
          names_to = "Indicator",
          values_to = "Value"
        ) %>%
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Get all possible combinations of departments and indicators
      all_combos <- expand_grid(
        `Department name` = unique(patient_summary_SST$`Department name`),
        Indicator = c("Received_full_recommended_IV", "Received_partial_recommended_IV", 
                      "Received_no_recommended_IV", "Received_oral_only", "Other_non_IV_or_oral", "Not_Eligible")
      )
      
      # Left join and replace NAs with 0
      eligible_long_SST <- all_combos %>%
        left_join(eligible_long_SST, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      # Add not eligible
      ineligible_summary_SST <- not_eligible_patients_SST %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      # Combine
      qi_long_SST <- bind_rows(eligible_long_SST, ineligible_summary_SST)
      
      # Calculate total per department
      dept_totals <- qi_long_SST %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      # Final summary table with proportions
      qi_summary_SST <- qi_long_SST %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Received_oral_only" ~ "Received oral antibiotics",
            Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe SSTI QIs",
            TRUE ~ Indicator
          ),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        select(`Department name`, Indicator, Patients, Total, Proportion)
      
      # Add Hospital-Wide Total row
      hospital_data <- qi_summary_SST %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        select(`Department name`, Indicator, Patients)
      
      # Combine with original data
      qi_summary_SST <- bind_rows(qi_summary_SST, hospital_data)
      
      # Recalculate totals and proportions
      qi_summary_SST <- qi_summary_SST %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Prepare data for plotting (vertical format like third code)
      qi_summary_SST <- qi_summary_SST %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>",
                             `Department name`),
          Indicator = factor(Indicator, levels = c(
            "Received recommended IV antibiotics",
            "Partially received recommended IV antibiotics",
            "Received IV antibiotics not among recommended options",
            "Received oral antibiotics",
            "Received other non-IV/oral antibiotics",
            "Not eligible for AWaRe SSTI QIs"
          ))
        )
      
      # X-axis department order (Hospital-Wide first)
      label_order <- c("<b style='color:#0072B2;'>Hospital-Wide</b>",
                       sort(setdiff(unique(qi_summary_SST$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>")))
      qi_summary_SST$PlotLabel <- factor(qi_summary_SST$PlotLabel, levels = label_order)
      
      # Color codes matching R markdown
      palette <- c(
        "Received recommended IV antibiotics"      = "#1F77B4",
        "Partially received recommended IV antibiotics" = "#4FA9DC",
        "Received IV antibiotics not among recommended options"    = "#EF476F",
        "Received oral antibiotics"                     = "#F9D99E",
        "Received other non-IV/oral antibiotics"        = "#D3D3D3",
        "Not eligible for AWaRe SSTI QIs"             = "#A9A9A9"
      )
      
      # Create ggplot (vertical stacked like third code)
      p <- ggplot(
        qi_summary_SST,
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
          data = qi_summary_SST %>% distinct(PlotLabel, Total),
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
        guides(fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"))
      
      # Convert to plotly with layout matching third code
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>Antibiotic Choice Alignment Summary for skin/soft tissue infections</b>",
            x = 0.5, xanchor = "center",
            y = 0.97, yanchor = "top",
            font = list(size = 12)
          ),
          height = 450,
          width  = 680,
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
      
      # Remove duplicate legend entries
      legend_names <- vapply(plt$x$data, function(tr) tr$name %||% "", character(1))
      dup_idx <- which(duplicated(legend_names) | grepl("^n=", legend_names))
      if (length(dup_idx)) {
        plt <- plotly::style(plt, showlegend = FALSE, traces = dup_idx)
      }
      
      plt
    })
    
    # AWaRe Classification Plot (Modified to match dosage plot style)
    output$aware_plot <- renderPlotly({
      choice_data <- choice_data_reactive()
      if (length(choice_data) == 0) {
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
      
      data_SST <- choice_data$data_SST
      
      # Classify antibiotics into AWaRe groups - matching R markdown exactly
      data_SST_AWaRe <- data_SST %>%
        mutate(
          AWaRe2 = case_when(
            ATC5 %in% c("J01FF01", "J01XD01", "J01CR02", "J01CF02") ~ "ACCESS", 
            ATC5 %in% c("J01CR05", "J01DD04", "J01XA01") ~ "WATCH", 
            TRUE ~ NA_character_
          )
        )
      
      # Identify primary and secondary antibiotics
      data_SST_AWaRe <- data_SST_AWaRe %>%
        filter(AWaRe_compatible, Route == "P", !is.na(AWaRe2))
      
      # Filter only valid cases
      aware_expanded <- data_SST_AWaRe %>%
        select(`Survey Number`, `Department name`, AWaRe2) %>%
        distinct()
      
      # Create Summary Table by Department (with 0s for missing combos)
      all_categories <- c("ACCESS", "WATCH")
      
      aware_counts <- aware_expanded %>%
        group_by(`Department name`, AWaRe2) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos <- expand_grid(
        `Department name` = unique(aware_expanded$`Department name`),
        AWaRe2 = all_categories
      )
      
      AWaRe_long <- all_combos %>%
        left_join(aware_counts, by = c("Department name", "AWaRe2")) %>%
        mutate(Patients = replace_na(Patients, 0)) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Add Hospital-Wide Summary Row
      hospital_row <- AWaRe_long %>%
        group_by(AWaRe2) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Combine and Sort Final Output
      AWaRe_long <- bind_rows(AWaRe_long, hospital_row) %>%
        arrange(`Department name`, AWaRe2)
      
      # Filter out departments with no data
      AWaRe_long <- AWaRe_long %>% dplyr::filter(Total > 0)
      if (nrow(AWaRe_long) == 0) {
        return(plotly_empty() %>%
                 layout(title = list(text = "No data available for AWaRe classification analysis",
                                     font = list(size = 12))))
      }
      
      # Define AWaRe categories for stacking and legend
      aware_levels_stack <- c("WATCH", "ACCESS")
      aware_levels_legend <- c("ACCESS", "WATCH")
      
      AWaRe_long$AWaRe2 <- factor(AWaRe_long$AWaRe2, levels = aware_levels_stack)
      
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
            "<b>AWaRe Classification:</b> ", as.character(AWaRe2), "<br>",
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
      
      # --- Dynamic buffer (matching dosage code) ---
      max_digits <- max(nchar(as.character(label_data$dept_total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # --- ggplot (horizontal like dosage code) ---
      p <- ggplot(AWaRe_long, aes(y = PlotLabel, x = ProportionPct, fill = AWaRe2, text = hover_text)) +
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
          values = c("ACCESS" = "#1b9e77", "WATCH" = "#ff7f00"),
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
      
      # --- Convert to plotly (matching dosage code layout) ---
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>Use of Recommended IV Antibiotics by AWaRe Classification for skin/soft tissue infections</b>",
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
    
    # Choice Appropriateness Summary
    output$choice_appropriateness_summary <- renderUI({
      choice_data <- choice_data_reactive()
      if(length(choice_data) == 0) {
        return(HTML("<p>No data available for choice appropriateness summary</p>"))
      }
      
      patient_summary_SST <- choice_data$patient_summary_SST
      data_SST <- choice_data$data_SST
      
      # Check if we have any data
      if(nrow(patient_summary_SST) == 0) {
        return(HTML(
          '<div style="background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;">
          ⚠️ <strong>No summary available</strong> — there are currently no eligible patients with valid IV antibiotic data for <strong>skin/soft tissue infections</strong>.<br><br>
          <em>This may indicate that no patients received IV antibiotics, or none met the inclusion criteria during the reporting period.</em>
          </div>'
        ))
      }
      
      # Get not eligible patients with department info
      not_eligible_patients_SST <- data_SST %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary table with Department name
      eligible_long_SST <- patient_summary_SST %>%
        select(`Survey Number`, `Department name`, Received_full_recommended_IV, Received_partial_recommended_IV, 
               Received_no_recommended_IV, Received_oral_only, Other_non_IV_or_oral) %>%
        pivot_longer(
          cols = -c(`Survey Number`, `Department name`),
          names_to = "Indicator",
          values_to = "Value"
        ) %>%
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Get all possible combinations of departments and indicators
      all_combos <- expand_grid(
        `Department name` = unique(patient_summary_SST$`Department name`),
        Indicator = c("Received_full_recommended_IV", "Received_partial_recommended_IV", "Received_no_recommended_IV", "Received_oral_only", "Other_non_IV_or_oral", "Not_Eligible")
      )
      
      # Left join and replace NAs with 0
      eligible_long_SST <- all_combos %>%
        left_join(eligible_long_SST, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      # Add not eligible
      ineligible_summary_SST <- not_eligible_patients_SST %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      # Combine
      qi_long_SST <- bind_rows(eligible_long_SST, ineligible_summary_SST)
      
      # Calculate total per department
      dept_totals <- qi_long_SST %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      # Final summary table with proportions
      qi_summary_SST <- qi_long_SST %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Received_oral_only" ~ "Received oral antibiotics",
            Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe SSTI QIs",
            TRUE ~ Indicator
          ),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        select(`Department name`, Indicator, Patients, Total, Proportion)
      
      # Add Hospital-Wide Total row
      hospital_data <- qi_summary_SST %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        select(`Department name`, Indicator, Patients)
      
      # Combine with original data
      qi_summary_SST <- bind_rows(qi_summary_SST, hospital_data)
      
      # Recalculate totals and proportions
      qi_summary_SST <- qi_summary_SST %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Calculate summary statistics
      # Total eligible patients (exclude 'Not eligible' group)
      total_eligible <- qi_summary_SST %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(Indicator != "Not eligible for AWaRe SSTI QIs") %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Total receiving any IV antibiotic (via eligible categories)
      total_iv <- qi_summary_SST %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(Indicator %in% c(
          "Received recommended IV antibiotics",
          "Partially received recommended IV antibiotics",
          "Received IV antibiotics not among recommended options"
        )) %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # === If no eligible patients with valid IV data ===
      if (total_iv == 0) {
        final_summary_html <- HTML(
          '<div style="background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;">
          ⚠️ <strong>No summary available</strong> — there are currently no eligible patients with valid IV antibiotic data for <strong>skin/soft tissue infections</strong>.<br><br>
          <em>This may indicate that no patients received IV antibiotics, or none met the inclusion criteria during the reporting period.</em>
          </div>'
        )
        return(final_summary_html)
      } else {
        
        # Now filter and process only after checking that data exists
        qi_summary_cleaned <- qi_summary_SST %>%
          filter(Indicator %in% c(
            "Received recommended IV antibiotics",
            "Partially received recommended IV antibiotics",
            "Received IV antibiotics not among recommended options"
          )) %>%
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
        
        # Intro styled card
        intro_text <- paste0(
          '<div style="background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;">
          💊 <strong>Denominator:</strong> Number of eligible skin/soft tissue infections patients who received any IV antibiotic 
          (<strong>', total_iv, '</strong> out of <strong>', total_eligible, '</strong>)
          </div><br><br>
          <strong>Summary:</strong><br><br>'
        )
        
        # Format department-wise HTML blocks
        formatted_blocks <- qi_summary_cleaned %>%
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
                
                paste0(
                  '<div style="background-color: ', bg, '; border-left: 5px solid ', color, '; padding: 14px; margin-bottom: 20px;">
                  <strong>🏥 ', dept, '</strong> <span style="color: #888;">(n = ', total_n, ' patients)</span><br><br>
                  <ul style="margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;">
                    <li>✅ <strong>Received recommended IV antibiotics</strong> (as per WHO AWaRe book): 
                      <strong>', scales::percent(prop_rec, accuracy = 0.1), '</strong> 
                      (', n_rec, ' out of ', total_n, ')
                    </li>
                    <li>⚠️ <strong>Partially received recommended IV antibiotics</strong> (as per WHO AWaRe book): 
                      <strong>', scales::percent(prop_part, accuracy = 0.1), '</strong> 
                      (', n_part, ' out of ', total_n, ')
                    </li>
                    <li>❌ <strong>Received IV antibiotics not among recommended options</strong> (as per WHO AWaRe book): 
                      <strong>', scales::percent(prop_not, accuracy = 0.1), '</strong> 
                      (', n_not, ' out of ', total_n, ')
                    </li>
                  </ul>
                  </div>'
                )
              }
            )
          ) %>%
          mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
          arrange(order, `Department name`) %>%
          select(-order)
        
        # Render final HTML
        final_summary_html <- HTML(paste0(intro_text, paste(formatted_blocks$block, collapse = "\n")))
        return(final_summary_html)
      }
    })
    
    # Dosage Analysis Data Processing
    dosage_data_reactive <- reactive({
      if (!check_data()) {
        return(list())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      # Filter and standardise patient data - matching R markdown exactly
      data_SST2 <- data_patients %>%
        filter(`Diagnosis code` == "SST") %>%
        mutate(
          Route = toupper(Route),
          ATC5 = trimws(toupper(ATC5)),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          ),
          Weight = as.numeric(Weight)
        )
      
      # Lookup dose info
      lookup2 <- data_lookup %>%
        filter(Code == "H_SSTI_APPROP_DOSAGE")
      
      lookup_names2 <- unlist(lookup2[1, paste0("ABX-ATC-", 1:8)], use.names = FALSE)
      lookup_names2 <- toupper(trimws(lookup_names2))
      
      # Preprocess dose columns to handle "15-20" ranges
      for (i in 1:8) {
        dose_col <- paste0("ABX-DOSE-", i)
        
        lookup2[[dose_col]] <- sapply(lookup2[[dose_col]], function(x) {
          x <- as.character(trimws(x))
          if (grepl("^[0-9]+\\s*-\\s*[0-9]+$", x)) {
            nums <- as.numeric(unlist(strsplit(gsub(" ", "", x), "-")))
            mean(nums)
          } else {
            suppressWarnings(as.numeric(x))
          }
        })
      }
      
      # Compute Total Daily Dose for each row in patient data
      data_SST2 <- data_SST2 %>%
        mutate(
          Unit_Factor = case_when(
            Unit == "mg" ~ 1,
            Unit == "g" ~ 1000,
            TRUE ~ NA_real_
          ),
          Total_Daily_Dose = as.numeric(`Single Unit Dose`) * as.numeric(`N Doses/day`) * Unit_Factor
        )
      
      # Match Drug + Dose + Route
      for (i in 1:8) {
        name_col <- paste0("ABX-ATC-", i)
        dose_col <- paste0("ABX-DOSE-", i)
        freq_col <- paste0("ABX-DAY-DOSE-", i)
        unit_col <- paste0("ABX-UNIT-", i)
        route_col <- paste0("ABX-ROUTE-", i)
        
        dose_match_col <- paste0("Match_Drug_Dose_", i)
        
        # Lookup standardized values
        drug_lookup <- toupper(trimws(lookup2[[name_col]]))
        unit_value <- lookup2[[unit_col]]
        dose <- lookup2[[dose_col]]
        freq <- as.numeric(lookup2[[freq_col]])
        
        # Convert units to mg
        if (unit_value == "mg") {
          unit_factor <- 1
        } else if (unit_value == "g") {
          unit_factor <- 1000
        } else if (unit_value == "mg/kg") {
          unit_factor <- 1
        } else {
          unit_factor <- NA_real_
        }
        
        # Calculate expected dose
        expected_dose <- if (!is.na(unit_value) && unit_value == "mg/kg") {
          dose * freq * data_SST2$Weight * unit_factor
        } else {
          dose * freq * unit_factor
        }
        
        # Match by name and dose - Using ±25.7% tolerance around the median (17.5 mg/kg)
        data_SST2[[dose_match_col]] <- ifelse(
          data_SST2$ATC5 == drug_lookup &
            (
              if (!is.na(unit_value) && unit_value == "mg/kg") {
                abs(data_SST2$Total_Daily_Dose - expected_dose) / expected_dose <= 0.257
              } else {
                abs(data_SST2$Total_Daily_Dose - expected_dose) < 1
              }
            ),
          TRUE, FALSE
        )
      }
      
      # Summarise at Patient Level - matching R markdown logic exactly
      patient_summary <- data_SST2 %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          Match_1_P = any(ATC5 == lookup_names2[1] & Route == "P"),
          Match_2_P = any(ATC5 == lookup_names2[2] & Route == "P"),
          Match_3_P = any(ATC5 == lookup_names2[3] & Route == "P"),
          Match_4_P = any(ATC5 == lookup_names2[4] & Route == "P"),
          Match_5_P = any(ATC5 == lookup_names2[5] & Route == "P"),
          Match_6_P = any(ATC5 == lookup_names2[6] & Route == "P"),
          Match_7_P = any(ATC5 == lookup_names2[7] & Route == "P"),
          Match_8_P = any(ATC5 == lookup_names2[8] & Route == "P"),
          
          Dose_1 = any(Match_Drug_Dose_1),
          Dose_2 = any(Match_Drug_Dose_2),
          Dose_3 = any(Match_Drug_Dose_3),
          Dose_4 = any(Match_Drug_Dose_4),
          Dose_5 = any(Match_Drug_Dose_5),
          Dose_6 = any(Match_Drug_Dose_6),
          Dose_7 = any(Match_Drug_Dose_7),
          Dose_8 = any(Match_Drug_Dose_8),
          
          Any_IV = any(Route == "P"),
          
          .groups = "drop"
        ) %>%
        mutate(
          # Define presence of any recommended IV antibiotic
          Any_Recommended_IV_Given = Match_1_P | Match_2_P | Match_3_P | Match_4_P | Match_5_P | Match_6_P | Match_8_P,
          
          # Define if any correct dosage among recommended ones
          Any_Recommended_Dose_Correct = (Match_1_P & Dose_1) |
            (Match_2_P & Dose_2) |
            (Match_3_P & Dose_3) |
            (Match_4_P & Dose_4) |
            (Match_5_P & Dose_5) |
            (Match_6_P & Dose_6) |
            (Match_8_P & Dose_8),
          
          # Define if all recommended IV antibiotics given had correct doses
          All_Matched_And_Dosed = ((Match_1_P & Dose_1) & (Match_2_P & Dose_2) & (!Match_5_P)) |
            ((Match_3_P & Dose_3) & (Match_4_P & Dose_4) & (!Match_5_P)) |
            ((Match_1_P & Dose_1) & (Match_2_P & Dose_2) & (Match_5_P & Dose_5)) |
            ((Match_3_P & Dose_3) & (Match_4_P & Dose_4) & (Match_5_P & Dose_5)) |
            (Match_6_P & Dose_6) |
            (Match_8_P & Dose_8),
          
          Dose_Result = case_when(
            # Fully correct recommended IVs and all at correct dosage
            All_Matched_And_Dosed ~ "Received recommended IV antibiotics with recommended dosage",
            
            # At least one recommended IV with correct dosage
            Any_Recommended_IV_Given & Any_Recommended_Dose_Correct & !All_Matched_And_Dosed ~
              "Received at least one recommended IV antibiotic with only some have recommended dosage",
            
            # Received recommended IV(s) but none were at correct dose
            Any_Recommended_IV_Given & !Any_Recommended_Dose_Correct ~
              "Received at least one recommended IV antibiotic with none have recommended dosage",
            
            # Received IV but none were from recommended list
            Any_IV & !Any_Recommended_IV_Given ~
              "Received IV antibiotics not among recommended options",
            
            TRUE ~ NA_character_
          )
        ) %>%
        filter(!is.na(Dose_Result))
      
      list(
        patient_summary = patient_summary
      )
    })
    
    # Dosage Plot (Horizontal stacking with complete legend)
    output$dosage_plot <- renderPlotly({
      dosage_data <- dosage_data_reactive()
      if (length(dosage_data) == 0) {
        return(plotly_empty())
      }
      
      patient_summary <- dosage_data$patient_summary
      
      # Define all Dose_Result categories FIRST (for legend and completeness)
      all_categories <- c(
        "Received recommended IV antibiotics with recommended dosage",
        "Received at least one recommended IV antibiotic with only some have recommended dosage",
        "Received at least one recommended IV antibiotic with none have recommended dosage",
        "Received IV antibiotics not among recommended options"
      )
      
      # Colors matching R markdown
      dosage_colors <- c(
        "Received recommended IV antibiotics with recommended dosage" = "#084594",
        "Received at least one recommended IV antibiotic with only some have recommended dosage" = "#6BAED6",
        "Received at least one recommended IV antibiotic with none have recommended dosage" = "#FC9272",
        "Received IV antibiotics not among recommended options" = "#D3D3D3"
      )
      
      # Create Summary Table by Department (with 0s for missing combos)
      iv_dose_counts <- patient_summary %>%
        group_by(`Department name`, Dose_Result) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos2 <- expand_grid(
        `Department name` = unique(patient_summary$`Department name`),
        Dose_Result = all_categories  # Use predefined categories
      )
      
      iv_dose_summary <- all_combos2 %>%
        left_join(iv_dose_counts, by = c("Department name", "Dose_Result")) %>%
        mutate(Patients = replace_na(Patients, 0)) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        ungroup()
      
      # Add Hospital-Wide Summary Row
      hospital_row <- iv_dose_summary %>%
        group_by(Dose_Result) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        ungroup()
      
      # Combine and Sort Final Output
      final_summary2 <- bind_rows(iv_dose_summary, hospital_row) %>%
        arrange(`Department name`, Dose_Result)
      
      # Ensure factor levels include ALL categories
      final_summary2$Dose_Result <- factor(final_summary2$Dose_Result, levels = all_categories)
      
      # --- FIX: integer counts per department ---
      final_summary2 <- final_summary2 %>%
        group_by(`Department name`) %>%
        group_modify(~ {
          df <- .x
          dt <- max(df$Total, na.rm = TRUE)
          raw <- df$Proportion / 100 * dt
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
        filter(Total > 0) %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          ProportionPct = Proportion,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Treatment Classification:</b> ", as.character(Dose_Result), "<br>",
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
        distinct(`Department name`, PlotLabel, dept_total)
      
      # --- Dynamic buffer (matching fourth code) ---
      max_digits <- max(nchar(as.character(label_data$dept_total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # --- ggplot (horizontal like fourth code) ---
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
          values = dosage_colors,
          drop = FALSE  # Keep all legend items even if not in data
        ) +
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
        scale_y_discrete(limits = rev(levels(final_summary2$PlotLabel)))
      
      # --- Convert to plotly (matching fourth code layout) ---
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>Antibiotic Choice & Dosage Alignment with AWaRe book Recommendations for skin/soft tissue infections</b>",
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
            title = list(text = "<b>Treatment Classification</b>", font = list(size = 10)),
            traceorder = "normal"  # Ensure consistent legend order
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
    
    # Dosage Summary Table
    output$dosage_appropriateness_summary <- renderUI({
      dosage_data <- dosage_data_reactive()
      if(length(dosage_data) == 0) {
        return(HTML("<p>No data available for dosage appropriateness summary</p>"))
      }
      
      patient_summary <- dosage_data$patient_summary
      
      # Check if we have any data
      if(nrow(patient_summary) == 0) {
        return(HTML(
          '<div style="background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;">
          ⚠️ <strong>No summary available</strong> — there are currently no eligible patients with valid IV antibiotic data for <strong>SSTI dosage assessment</strong>.<br><br>
          <em>This may indicate that no patients received antibiotics with recommended dosing, or none met inclusion criteria.</em>
          </div>'
        ))
      }
      
      # Create Summary Table by Department (with 0s for missing combos)
      all_categories <- unique(patient_summary$Dose_Result)
      
      iv_dose_counts <- patient_summary %>%
        group_by(`Department name`, Dose_Result) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos2 <- expand_grid(
        `Department name` = unique(patient_summary$`Department name`),
        Dose_Result = all_categories
      )
      
      iv_dose_summary <- all_combos2 %>%
        left_join(iv_dose_counts, by = c("Department name", "Dose_Result")) %>%
        mutate(Patients = replace_na(Patients, 0)) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        ungroup()
      
      # Add Hospital-Wide Summary Row
      hospital_row <- iv_dose_summary %>%
        group_by(Dose_Result) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        ungroup()
      
      # Combine and Sort Final Output
      final_summary2 <- bind_rows(iv_dose_summary, hospital_row) %>%
        arrange(`Department name`, Dose_Result)
      
      # Exclude Hospital-Wide for total count and filter relevant categories
      final_summary2_SST_filtered <- final_summary2 %>%
        filter(`Department name` != "Hospital-Wide",
               Dose_Result != "Received IV antibiotics not among recommended options")
      
      # Calculate total eligible patients
      total_approp_iv_given <- final_summary2_SST_filtered %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Check if there are any eligible patients to show
      if (total_approp_iv_given == 0) {
        final_summary_html2 <- HTML(
          '<div style="background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;">
          ⚠️ <strong>No summary available</strong> — there are currently no eligible patients with valid IV antibiotic data for <strong>SSTI dosage assessment</strong>.<br><br>
          <em>This may indicate that no patients received antibiotics with recommended dosing, or none met inclusion criteria.</em>
          </div>'
        )
        return(final_summary_html2)
      } else {
        
        # Intro text card
        intro_text2 <- paste0(
          '<div style="background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;">
          💊 <strong>Denominator:</strong> Number of eligible skin/soft tissue infections patients who received recommended (<em>or partially recommended</em>) IV antibiotic choice based on WHO AWaRe book (<strong>', total_approp_iv_given, '</strong>)
          </div><br><br>
          <strong>Summary:</strong><br><br>'
        )
        
        # Define relevant categories
        all_categories2 <- c(
          "Received recommended IV antibiotics with recommended dosage",
          "Received at least one recommended IV antibiotic with only some have recommended dosage",
          "Received at least one recommended IV antibiotic with none have recommended dosage"
        )
        
        dept_list <- unique(final_summary2$`Department name`)
        category_list <- all_categories2
        
        # Build complete grid with zeros for missing
        complete_summary <- expand_grid(
          `Department name` = dept_list,
          Dose_Result = category_list
        ) %>%
          left_join(final_summary2, by = c("Department name", "Dose_Result")) %>%
          filter(Dose_Result %in% all_categories2) %>%
          mutate(
            Patients = replace_na(Patients, 0),
            Total = ave(Patients, `Department name`, FUN = sum),
            Proportion = ifelse(Total == 0, 0, round(100 * Patients / Total, 1))
          )
        
        # Icon function
        get_icon <- function(label) {
          label_clean <- tolower(trimws(label))
          if (label_clean == "received recommended iv antibiotics with recommended dosage") {
            return('<span style="color:#28a745;">✅</span>')
          } else if (label_clean == "received at least one recommended iv antibiotic with only some have recommended dosage") {
            return('<span style="color:#e6b800;">⚠️</span>')
          } else if (label_clean == "received at least one recommended iv antibiotic with none have recommended dosage") {
            return('<span style="color:#d00;">❌</span>')
          } else {
            return("🛈")
          }
        }
        
        # Description function
        get_description <- function(label) {
          label_clean <- tolower(trimws(label))
          if (label_clean == "received recommended iv antibiotics with recommended dosage") {
            return("Received recommended IV antibiotics with recommended dosage")
          } else if (label_clean == "received at least one recommended iv antibiotic with only some have recommended dosage") {
            return("Received at least one recommended IV antibiotic with only some have recommended dosage")
          } else if (label_clean == "received at least one recommended iv antibiotic with none have recommended dosage") {
            return("Received at least one recommended IV antibiotic with none have recommended dosage")
          } else {
            return(paste("Received:", label))
          }
        }
        
        # Generate HTML summary blocks
        formatted_blocks2 <- complete_summary %>%
          group_by(`Department name`) %>%
          summarise(
            block = {
              dept <- first(`Department name`)
              color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
              bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
              total_patients <- max(Total, na.rm = TRUE)
              
              list_items <- map_chr(all_categories2, function(label) {
                row_data <- complete_summary %>%
                  filter(`Department name` == dept, Dose_Result == label)
                count <- if(nrow(row_data) > 0) row_data$Patients[1] else 0
                prop <- if(nrow(row_data) > 0) row_data$Proportion[1] else 0
                icon <- get_icon(label)
                description <- get_description(label)
                
                paste0(
                  '<li>', icon, ' <strong>', description, '</strong> (as per WHO AWaRe book): 
                  <strong>', scales::percent(prop / 100, accuracy = 0.1), '</strong> 
                  (', count, ' out of ', total_patients, ')</li>'
                )
              })
              
              paste0(
                '<div style="background-color: ', bg, '; border-left: 5px solid ', color, '; padding: 14px; margin-bottom: 20px;">
                <strong>🏥 ', dept, '</strong> <span style="color: #888;">(n = ', total_patients, ' patients)</span><br><br>
                <ul style="margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;">
                ', paste(list_items, collapse = ''), '
                </ul>
                </div>'
              )
            },
            .groups = "drop"
          ) %>%
          mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
          arrange(order, `Department name`) %>%
          select(-order)
        
        # Final render
        final_summary_html2 <- HTML(paste0(intro_text2, paste(formatted_blocks2$block, collapse = "\n")))
        return(final_summary_html2)
      }
    })
    
  })
}