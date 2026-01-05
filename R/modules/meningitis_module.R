# Meningitis Analysis Shiny Module - Complete Implementation with Navigation
# This module contains all the meningitis-specific analysis functionality split into separate tabs

# Overview Tab UI
meningitisOverviewUI <- function(id) {
  ns <- NS(id)
  
  tagList(
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
               box(width = 12, title = "🎯 AWaRe Quality Indicators for Meningitis", status = "info", solidHeader = TRUE,
                   h5("Within the gPPS data structure, the following antibiotic use quality indicators have been identified:"),
                   p("1) ","Proportion of patients presenting with bacterial meningitis given the appropriate IV antibiotics according to the WHO AWaRe book."),
                   p("2) ","Proportion of patients presenting with bacterial meningitis prescribed the total daily dose of IV empiric antibiotics recommended in the WHO AWaRe Antibiotic Book.")
               )
        )
      ),
      
      # MOVED: Patient-Level and Prescription-Level Insights - now appear after AWaRe Quality Indicators
      fluidRow(
        box(width = 6, title = "👥 Patient-Level Insights", status = "info", solidHeader = TRUE, collapsed = TRUE, collapsible = TRUE,
            DTOutput(ns("patient_summary_table"))
        ),
        box(width = 6, title = "📑 Prescription-Level Insights", status = "success", solidHeader = TRUE, collapsed = TRUE, collapsible = TRUE,
            DTOutput(ns("prescription_summary_table"))
        )
      )
    )
  )
}

# Eligibility Check Tab UI
meningitisEligibilityUI <- function(id) {
  ns <- NS(id)
  
  tagList(
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
               box(width = 12, title = "🔍 Initial Eligible Cases Check", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                   htmlOutput(ns("eligibility_feedback"))
               )
        )
      )
    )
  )
}

# Patient Summary Tab UI
meningitisPatientSummaryUI <- function(id) {
  ns <- NS(id)
  
  tagList(
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
                   p("Eligible patients for WHO AWaRe Quality Indicator (QI) assessment are defined as adult inpatients (≥18 years) who received empirical antibiotics for CA-Meningitis.")
               )
        )
      )
    )
  )
}

# QI 1 Tab UI - Complete Version with White Backgrounds
meningitisQI1UI <- function(id) {
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
                 p("Please upload your data files to view QI 1 analysis.")
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
                 title = "📌 Antibiotic Choice Alignment with AWaRe book Recommendations for Meningitis", 
                 status = "primary", 
                 solidHeader = TRUE,
                 p("Proportion of patients presenting with bacterial meningitis given the appropriate IV antibiotics according to the WHO AWaRe book.")
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
                 "▸ ", strong("First choice:"), " Cefotaxime (2 g q6h IV) ", em("OR"), " Ceftriaxone (2 g q12h IV)", br(),
                 "▸ ", strong("Second choice:"), " Amoxicillin (2 g q4h IV) ", em("OR"), " Ampicillin (2 g q4h IV) ", em("OR"), " Benzylpenicillin (4 million IU [2.4 g] q4h IV) ", em("OR"), " Chloramphenicol (1 g q6h IV)", br(), br()
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
                   " Antibiotic Choice Alignment with AWaRe book Recommendations for Meningitis"
                 ), 
                 status = "primary", 
                 solidHeader = TRUE,
                 tabsetPanel(
                   id = ns("qi1_viz_tabs"),
                   type = "tabs",
                   
                   # Tab 1: Choice Alignment
                   tabPanel(
                     tagList(icon("check-square"), " Choice Alignment"),
                     div(
                       style = "background-color: white; padding: 15px;",
                       br(),
                       p("Visual summary of antibiotic choice Alignment for meningitis across hospital departments (WHO AWaRe book)."),
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
                           plotlyOutput(ns("choice_appropriateness_plot"), height = "450px", width = "100%"),
                           type = 4
                         )
                       ),
                       br(),
                       div(
                         class = "note-box",
                         style = "background-color: white; padding: 10px; border-radius: 5px; border-left: 4px solid #3498db;",
                         strong("💡 Note:"), 
                         " The partially recommended category refers to cases in which patients were administered a WHO AWaRe-recommended antibiotic in combination with one or more additional antibiotics, rather than as monotherapy as specified in the guideline."
                       )
                     )
                   ),
                   
                   # Tab 2: AWaRe Classification
                   tabPanel(
                     tagList(icon("layer-group"), " AWaRe Classification"),
                     div(
                       style = "background-color: white; padding: 15px;",
                       br(),
                       p("This visual summarises the proportion of antibiotic alignment for meningitis across hospital departments by WHO AWaRe Classification (Access, Watch, Reserve)"),
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
                           plotlyOutput(ns("aware_classification_plot"), height = "450px", width = "100%"),
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
                       p("This visual summarises the proportion of antibiotic alignment for meningitis across hospital departments by line of treatment (First choice, Second choice)"),
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
                           plotlyOutput(ns("treatment_line_plot"), height = "450px", width = "100%"),
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
                 title = "📝 Summary of Antibiotic Choice Alignment with AWaRe book Recommendations for Meningitis", 
                 status = "info", 
                 solidHeader = TRUE, 
                 collapsible = TRUE, 
                 collapsed = TRUE,
                 htmlOutput(ns("choice_appropriateness_summary"))
               )
        )
      )
    )
  )
}

# QI 2 Tab UI
meningitisQI2UI <- function(id) {
  ns <- NS(id)
  
  tagList(
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
    
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
                   p("Please upload your data files to view QI 2 analysis.")
               )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📌 Antibiotic Dosage Alignment with AWaRe book Recommendations for Meningitis", status = "primary", solidHeader = TRUE,
                   p("Proportion of patients presenting with bacterial meningitis prescribed the total daily dose of IV empiric antibiotics recommended in the WHO AWaRe Antibiotic Book.")
               )
        )
      ),
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🔍 WHO AWaRe book Recommendation:", status = "primary", solidHeader = TRUE,
                   "▸ ",strong("First choice:"), " Cefotaxime (2 g q6h IV) ", em("OR"), " Ceftriaxone (2 g q12h IV)", br(),
                   "▸ ",strong("Second choice:"), " Amoxicillin (2 g q4h IV) ", em("OR"), " Ampicillin (2 g q4h IV) ", em("OR"), " Benzylpenicillin (4 million IU [2.4 g] q4h IV) ", em("OR"), " Chloramphenicol (1 g q6h IV)", br(), br()
                   
               )
        )
      ),
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📈 Antibiotic Dosage Alignment with AWaRe book Recommendations for meningitis",
                   status = "primary", solidHeader = TRUE,
                   p("Visual summary of antibiotic Dosage alignment for meningitis across hospital departments (WHO AWaRe book)."),
                   div(style = "
                     display: flex; 
                     justify-content: center; 
                     align-items: center; 
                     max-width: 100%; 
                     overflow: hidden;
                   ",
                       withSpinner(
                         plotlyOutput(ns("dosage_appropriateness_plot"), height = "450px", width = "100%"),
                         type = 4
                       )
               )
        )
       )
      ),
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📝 Summary of Antibiotic Dosage Alignment with AWaRe book Recommendations for Meningitis", status = "info", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
                   htmlOutput(ns("dosage_appropriateness_summary"))
               )
        )
      )
    )
  )
}

# Module Server - Handles all meningitis tabs
meningitisAnalysisServer <- function(id, data_reactive) {
  moduleServer(id, function(input, output, session) {
    
    # Constants
    AWaRe_abx <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
    
    # Helper function to check if data is available
    check_data <- function() {
      data <- data_reactive()
      return(!is.null(data) && !is.null(data$data_patients))
    }
    
    # Output to control conditional panels
    output$dataUploaded <- reactive({
      check_data()
    })
    outputOptions(output, "dataUploaded", suspendWhenHidden = FALSE)
    
    # Eligibility feedback (for Eligibility tab)
    output$eligibility_feedback <- renderUI({
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
        
        # Filter eligible meningitis patients
        data_men <- data_patients %>%
          filter(`Diagnosis code` == "CNS") %>%
          mutate(
            Route = toupper(as.character(Route)),
            AWaRe_compatible = (`Age years` >= 18 & 
                                  Indication == "CAI" & 
                                  Treatment == "EMPIRICAL" & 
                                  AWaRe %in% AWaRe_abx)
          ) 
        
        # Count eligible unique meningitis cases
        eligible_men_n <- data_men %>%
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
        status_message <- if(eligible_men_n == 0) {
          "<div style='background-color:#fff3cd; border: 1px solid #ffeeba; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>🚫 No data available:</strong> There were no eligible cases for evaluation during this survey period. Please verify data availability.
          </div>"
        } else if(eligible_men_n < 10) {
          "<div style='background-color:#ffe0e0; border: 1px solid #ffb3b3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>⚠️ Caution:</strong> Few eligible cases detected. Interpret results with caution.
          </div>"
        } else {
          "<div style='background-color:#e0ffe0; border: 1px solid #b3ffb3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>✅ Good to go!</strong> Sufficient eligible cases available to proceed with full evaluation.
          </div>"
        }
        
        # Build HTML feedback using paste0
        html_feedback <- HTML(paste0(
          "<div style='background-color: #f0f8ff; border: 1px solid #add8e6; padding: 15px; border-radius: 5px; font-family: sans-serif;'>",
          "<p style='margin-bottom: 10px;'>",
          "This script applies <strong>WHO AWaRe Quality Indicators</strong> to adult inpatients with ",
          "empirical antibiotics for community-acquired bacterial meningitis.",
          "</p>",
          "<ul>",
          "<li><strong>Diagnostic code:</strong> CNS (Central Nervous System Infections)</li>",
          "<li><strong>Total eligible cases:</strong> ", eligible_men_n, "</li>",
          "</ul>",
          status_message,
          "</div>"
        ))
        
        return(html_feedback)
        
      }, error = function(e) {
        return(HTML(paste0("<div style='background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 15px; border-radius: 5px;'><p><strong>❌ Error loading eligibility information:</strong></p><p>", as.character(e$message), "</p></div>")))
      })
    })
    
    # Overview eligibility feedback (separate output for overview tab)
    output$overview_eligibility_feedback <- renderUI({
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
        
        # Filter eligible meningitis patients
        data_men <- data_patients %>%
          filter(`Diagnosis code` == "CNS") %>%
          mutate(
            Route = toupper(as.character(Route)),
            AWaRe_compatible = (`Age years` >= 18 & 
                                  Indication == "CAI" & 
                                  Treatment == "EMPIRICAL" & 
                                  AWaRe %in% AWaRe_abx)
          ) 
        
        # Count eligible unique meningitis cases
        eligible_men_n <- data_men %>%
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
        status_message <- if(eligible_men_n == 0) {
          "<div style='background-color:#fff3cd; border: 1px solid #ffeeba; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>🚫 No data available:</strong> There were no eligible cases for evaluation during this survey period. Please verify data availability.
          </div>"
        } else if(eligible_men_n < 10) {
          "<div style='background-color:#ffe0e0; border: 1px solid #ffb3b3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>⚠️ Caution:</strong> Few eligible cases detected. Interpret results with caution.
          </div>"
        } else {
          "<div style='background-color:#e0ffe0; border: 1px solid #b3ffb3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>✅ Good to go!</strong> Sufficient eligible cases available to proceed with full evaluation.
          </div>"
        }
        
        # Build HTML feedback using paste0
        html_feedback <- HTML(paste0(
          "<div style='background-color: #f0f8ff; border: 1px solid #add8e6; padding: 15px; border-radius: 5px; font-family: sans-serif;'>",
          "<p style='margin-bottom: 10px;'>",
          "This script applies <strong>WHO AWaRe Quality Indicators</strong> to adult inpatients with ",
          "empirical antibiotics for community-acquired bacterial meningitis.",
          "</p>",
          "<ul>",
          "<li><strong>Diagnostic code:</strong> CNS (Central Nervous System Infections)</li>",
          "<li><strong>Total eligible cases:</strong> ", eligible_men_n, "</li>",
          "</ul>",
          status_message,
          "</div>"
        ))
        
        return(html_feedback)
        
      }, error = function(e) {
        return(HTML(paste0("<div style='background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 15px; border-radius: 5px;'><p><strong>❌ Error loading eligibility information:</strong></p><p>", as.character(e$message), "</p></div>")))
      })
    })
    
    # Summary insights
    output$summary_insights_cards <- renderUI({
      if (!check_data()) {
        return(HTML("<p>No data available for insights</p>"))
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      total_patients <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "CNS") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      eligible_patients <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx, Treatment == "EMPIRICAL", `Diagnosis code` == "CNS") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      total_prescriptions <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "CNS") %>%
        nrow()
      
      eligible_prescriptions <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx, Treatment == "EMPIRICAL", `Diagnosis code` == "CNS") %>%
        nrow()
      
      patient_percentage <- if(total_patients > 0) round((eligible_patients / total_patients) * 100, 1) else 0
      prescription_percentage <- if(total_prescriptions > 0) round((eligible_prescriptions / total_prescriptions) * 100, 1) else 0
      
      patient_color <- if(patient_percentage >= 10) "#d4edda" else if(patient_percentage >= 5) "#fff3cd" else "#f8d7da"
      prescription_color <- if(prescription_percentage >= 10) "#d4edda" else if(prescription_percentage >= 5) "#fff3cd" else "#f8d7da"
      
      insight_cards <- 
        HTML(paste0(
          "<div style='display: flex; gap: 20px; flex-wrap: wrap;'>",
          
          # Card 1: Patients
          "<div style='flex: 1; min-width: 300px; background-color: ", patient_color, 
          "; border-left: 6px solid #28a745; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>",
          "<h4 style='margin-top: 0; color: #155724;'>👥 Proportion of Eligible Patients</h4>",
          "<div style='font-size: 2.5em; font-weight: bold; color: #155724; margin: 10px 0;'>", patient_percentage, "%</div>",
          "<p style='margin-bottom: 0; color: #155724;'>",
          "<strong>", eligible_patients, "</strong> out of <strong>", total_patients, 
          "</strong> patients on antibiotics for meningitis were QI-eligible patients.",
          "</p>",
          "</div>",
          
          # Card 2: Prescriptions
          "<div style='flex: 1; min-width: 300px; background-color: ", prescription_color, 
          "; border-left: 6px solid #17a2b8; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>",
          "<h4 style='margin-top: 0; color: #0c5460;'>📑 Proportion of Eligible Prescriptions</h4>",
          "<div style='font-size: 2.5em; font-weight: bold; color: #0c5460; margin: 10px 0;'>", prescription_percentage, "%</div>",
          "<p style='margin-bottom: 0; color: #0c5460;'>",
          "<strong>", eligible_prescriptions, "</strong> out of <strong>", total_prescriptions, 
          "</strong> antibiotic prescriptions for meningitis were given to QI-eligible patients.",
          "</p>",
          "</div>",
          
          "</div>"
        ))
      
      return(insight_cards)
      
      
    })
    
    # Summary tables
    output$patient_summary_table <- DT::renderDT({
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
          "Adult patients (≥18 years) with empirical antibiotic treatment for CAI",
          "All patients with meningitis diagnosis on any antibiotics",
          "Eligible patients: Adult patients (≥18 years) with CA-Meningitis treated empirically"
        ),
        Count = c(
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Diagnosis code` == "CNS", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "CNS", AWaRe %in% AWaRe_abx) %>%
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
    
    output$prescription_summary_table <- DT::renderDT({
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
          "Empirical antibiotic prescriptions for adult patients (≥18 years) with CAI",
          "All antibiotic prescriptions for patients diagnosed with meningitis",
          "Eligible antibiotic prescriptions: empirically prescribed for adult patients with CA-Meningitis"
        ),
        Count = c(
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Diagnosis code` == "CNS", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "CNS", AWaRe %in% AWaRe_abx) %>% nrow()
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
    
    # QI1 Analysis - Updated to match R markdown exactly
    qi1_data <- reactive({
      if (!check_data()) {
        return(data.frame())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      # Prepare the data (Select Meningitis data only) - exactly matching R markdown
      data_men <- data_patients %>%
        filter(`Diagnosis code` == "CNS") %>%
        mutate(
          Route = toupper(as.character(Route)),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      # Lookup ABX names for Meningitis QI - exactly matching R markdown
      lookup_names <- data_lookup %>%
        filter(Code == "H_MEN_APPROP_ABX") %>%
        select(starts_with("ABX-ATC")) %>%
        unlist(use.names = FALSE) %>%
        na.omit()
      
      if(length(lookup_names) == 0) {
        return(data.frame())
      }
      
      # Extract lookup info for H_MEN_APPROP_ABX - exactly matching R markdown
      lookup_men <- data_lookup %>%
        filter(Code == "H_MEN_APPROP_ABX")
      
      # Create long format from lookup - exactly matching R markdown
      lookup_long <- tibble(
        Drug = unlist(lookup_men %>% select(starts_with("ABX-ATC")), use.names = FALSE),
        Choice = unlist(lookup_men %>% select(starts_with("ABX-CHOICE")), use.names = FALSE)
      ) %>%
        filter(!is.na(Drug))  # Remove empty rows
      
      # Merge choice info with patient-level data - exactly matching R markdown
      data_men <- data_men %>%
        left_join(lookup_long, by = c("ATC5" = "Drug")) %>%
        mutate(
          Drug_Match = ATC5 %in% lookup_names
        )
      
      # Create patient summary - exactly matching R markdown
      patient_summary <- data_men %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          All_ABX = list(unique(ATC5)),
          Match_1 = any(ATC5 == lookup_names[1], na.rm = TRUE),
          Match_2 = if(length(lookup_names) >= 2) any(ATC5 == lookup_names[2], na.rm = TRUE) else FALSE,
          Match_3 = if(length(lookup_names) >= 3) any(ATC5 == lookup_names[3], na.rm = TRUE) else FALSE,
          Match_4 = if(length(lookup_names) >= 4) any(ATC5 == lookup_names[4], na.rm = TRUE) else FALSE,
          Match_5 = if(length(lookup_names) >= 5) any(ATC5 == lookup_names[5], na.rm = TRUE) else FALSE,
          Match_6 = if(length(lookup_names) >= 6) any(ATC5 == lookup_names[6], na.rm = TRUE) else FALSE,
          Match_1_P = any(ATC5 == lookup_names[1] & Route == "P", na.rm = TRUE),
          Match_2_P = if(length(lookup_names) >= 2) any(ATC5 == lookup_names[2] & Route == "P", na.rm = TRUE) else FALSE,
          Match_3_P = if(length(lookup_names) >= 3) any(ATC5 == lookup_names[3] & Route == "P", na.rm = TRUE) else FALSE,
          Match_4_P = if(length(lookup_names) >= 4) any(ATC5 == lookup_names[4] & Route == "P", na.rm = TRUE) else FALSE,
          Match_5_P = if(length(lookup_names) >= 5) any(ATC5 == lookup_names[5] & Route == "P", na.rm = TRUE) else FALSE,
          Match_6_P = if(length(lookup_names) >= 6) any(ATC5 == lookup_names[6] & Route == "P", na.rm = TRUE) else FALSE,
          N_ABX = n_distinct(ATC5),
          Any_IV = any(Route == "P"),
          .groups = "drop"
        ) %>%
        rowwise() %>%
        mutate(
          Num_Recommended_P = sum(c_across(starts_with("Match_") & ends_with("_P")), na.rm = TRUE),
          Appropriate = Num_Recommended_P == 1 & N_ABX == 1,
          Partial_Appropriate = Num_Recommended_P >= 1 & N_ABX > 1,
          No_Appropriate = Any_IV & !Appropriate & !Partial_Appropriate,
          No_Appropriate_others = !Appropriate & !Partial_Appropriate & !No_Appropriate
        ) %>%
        ungroup()
      
      # Get not eligible patients with department info
      not_eligible_patients <- data_men %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary table with Department name
      eligible_long <- patient_summary %>%
        select(`Survey Number`, `Department name`, Appropriate, Partial_Appropriate, No_Appropriate, No_Appropriate_others) %>%
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
        `Department name` = unique(patient_summary$`Department name`),
        Indicator = c("Appropriate", "Partial_Appropriate", "No_Appropriate", "No_Appropriate_others", "Not_Eligible")
      )
      
      # Left join and replace NAs with 0
      eligible_long <- all_combos %>%
        left_join(eligible_long, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      # Add not eligible
      ineligible_summary <- not_eligible_patients %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      # Combine
      qi_long <- bind_rows(eligible_long, ineligible_summary)
      
      # Calculate total per department
      dept_totals <- qi_long %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      # Final summary table with proportions
      qi_summary_men <- qi_long %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Appropriate" ~ "Received recommended IV antibiotics",
            Indicator == "Partial_Appropriate" ~ "Partially received recommended IV antibiotics",
            Indicator == "No_Appropriate" ~ "Received IV antibiotics not among recommended options",
            Indicator == "No_Appropriate_others" ~ "Received other non-IV antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe meningitis QIs",
            TRUE ~ Indicator
          ),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        select(`Department name`, Indicator, Patients, Total, Proportion)
      
      # Add Hospital-Wide Total row
      hospital_data <- qi_summary_men %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        select(`Department name`, Indicator, Patients)
      
      # Combine with original data
      qi_summary_men <- bind_rows(qi_summary_men, hospital_data)
      
      # Recalculate totals and proportions
      qi_summary_men <- qi_summary_men %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        ungroup()
      
      # Format "Hospital-Wide" label
      qi_summary_men <- qi_summary_men %>%
        mutate(`Department name` = ifelse(`Department name` == "Hospital-Wide", "Hospital-Wide", `Department name`))
      
      return(qi_summary_men)
    })
    
    # Choice appropriateness plot - Meningitis (Updated to match third code vertical format)
    output$choice_appropriateness_plot <- renderPlotly({
      qi_summary_men <- qi1_data()
      req(qi_summary_men, nrow(qi_summary_men) > 0)
      
      # Legend labels & colors (preserved from original)
      indicator_labels <- c(
        "Appropriate"            = "Received recommended IV antibiotics",
        "Partial_Appropriate"    = "Partially received recommended IV antibiotics",
        "No_Appropriate"         = "Received IV antibiotics not among recommended options",
        "No_Appropriate_others"  = "Received other non-IV antibiotics",
        "Not_Eligible"           = "Not eligible for AWaRe meningitis QIs"
      )
      drug_choice_colors <- c(
        "Received recommended IV antibiotics"                   = "#1F77B4",
        "Partially received recommended IV antibiotics"         = "#4FA9DC",
        "Received IV antibiotics not among recommended options" = "#EF476F",
        "Received other non-IV antibiotics"                     = "#D3D3D3",
        "Not eligible for AWaRe meningitis QIs"                 = "#A9A9A9"
      )
      
      # Ensure all categories per department (preserved logic)
      all_categories <- names(drug_choice_colors)
      complete_summary <- expand_grid(
        `Department name` = unique(qi_summary_men$`Department name`),
        Indicator = all_categories
      ) %>%
        left_join(qi_summary_men, by = c("Department name", "Indicator")) %>%
        mutate(
          Patients   = replace_na(Patients, 0),
          Total      = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, Patients / Total),
          PlotLabel  = ifelse(`Department name` == "Hospital-Wide",
                              "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          Indicator  = factor(Indicator, levels = all_categories),
          IsHospitalWide = (`Department name` == "Hospital-Wide")
        )
      
      # Hospital-Wide first (preserved logic)
      dept_levels <- sort(setdiff(unique(complete_summary$`Department name`), "Hospital-Wide"))
      ordered_labels <- c("<b style='color:#0072B2;'>Hospital-Wide</b>", dept_levels)
      complete_summary$PlotLabel <- factor(complete_summary$PlotLabel, levels = ordered_labels)
      
      # Create ggplot (matching third code style - vertical format)
      p <- ggplot(
        complete_summary,
        aes(
          x = PlotLabel, y = Proportion, fill = Indicator,
          text = paste0(
            "Department: ", `Department name`, "<br>",
            "Category: ", as.character(Indicator), "<br>",
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
          data = complete_summary %>% distinct(PlotLabel, Total),
          aes(x = PlotLabel, y = 1.02, label = paste0("n=", Total)),
          inherit.aes = FALSE, size = 3, color = "gray30", hjust = 0.5
        ) +
        scale_fill_manual(values = drug_choice_colors, drop = FALSE) +
        scale_y_continuous(limits = c(0, 1.08), expand = c(0, 0),
                           labels = scales::percent_format(accuracy = 1)) +
        scale_x_discrete(expand = c(0.01, 0.01)) +
        labs(
          title = NULL,
          subtitle = NULL,
          x = "Department",
          y = "Proportion of Patients",
          fill = "Treatment Appropriateness"
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
      
      # Convert to plotly with third code style layout (no subtitle)
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Antibiotic Choice Alignment Summary for Meningitis</b><br>"
            ),
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
      
      # Remove duplicate legend entries (preserved from original)
      legend_names <- vapply(plt$x$data, function(tr) tr$name %||% "", character(1))
      dup_idx <- which(duplicated(legend_names) | grepl("^n=", legend_names))
      if (length(dup_idx)) {
        plt <- plotly::style(plt, showlegend = FALSE, traces = dup_idx)
      }
      
      plt
    })
    
    # AWaRe Classification Analysis
    aware_data <- reactive({
      if (!check_data()) {
        return(data.frame())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      data_men <- data_patients %>%
        filter(`Diagnosis code` == "CNS") %>%
        mutate(
          Route = toupper(as.character(Route)),
          Route = ifelse(is.na(Route), "", Route),
          ATC5 = as.character(ATC5),
          AWaRe_compatible = ifelse(
            !is.na(`Age years`) & `Age years` >= 18 & 
              !is.na(Indication) & Indication == "CAI" & 
              !is.na(Treatment) & Treatment == "EMPIRICAL" & 
              !is.na(AWaRe) & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      lookup_names <- data_lookup %>%
        filter(Code == "H_MEN_APPROP_ABX") %>%
        select(starts_with("ABX-ATC")) %>%
        unlist(use.names = FALSE) %>%
        na.omit()
      
      if(length(lookup_names) == 0) {
        return(data.frame())
      }
      
      # Extract lookup info for H_MEN_APPROP_ABX
      lookup_men <- data_lookup %>%
        filter(Code == "H_MEN_APPROP_ABX")
      
      # Create long format from lookup
      lookup_long <- tibble(
        Drug = unlist(lookup_men %>% select(starts_with("ABX-ATC")), use.names = FALSE),
        Choice = unlist(lookup_men %>% select(starts_with("ABX-CHOICE")), use.names = FALSE)
      ) %>%
        filter(!is.na(Drug))
      
      # Merge choice info with patient-level data
      data_men <- data_men %>%
        left_join(lookup_long, by = c("ATC5" = "Drug"))
      
      # Add Department info to patient summary
      patient_summary_AWARE <- data_men %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`, AWaRe) %>%
        summarise(
          Match_1_P = any(ATC5 == lookup_names[1] & Route == "P", na.rm = TRUE),
          Match_2_P = if(length(lookup_names) >= 2) any(ATC5 == lookup_names[2] & Route == "P", na.rm = TRUE) else FALSE,
          Match_3_P = if(length(lookup_names) >= 3) any(ATC5 == lookup_names[3] & Route == "P", na.rm = TRUE) else FALSE,
          Match_4_P = if(length(lookup_names) >= 4) any(ATC5 == lookup_names[4] & Route == "P", na.rm = TRUE) else FALSE,
          Match_5_P = if(length(lookup_names) >= 5) any(ATC5 == lookup_names[5] & Route == "P", na.rm = TRUE) else FALSE,
          Match_6_P = if(length(lookup_names) >= 6) any(ATC5 == lookup_names[6] & Route == "P", na.rm = TRUE) else FALSE,
          .groups = "drop"
        ) %>%
        mutate(
          Appropriate_IV = (Match_1_P | Match_2_P | Match_3_P | Match_4_P | Match_5_P | Match_6_P)
        )
      
      # Create summary table with Department name
      AWaRe_long <- patient_summary_AWARE %>%
        select(`Survey Number`, `Department name`, AWaRe, Appropriate_IV) %>%
        pivot_longer(
          cols = -c(`Survey Number`, `Department name`, AWaRe),
          names_to = "Indicator",
          values_to = "Value"
        ) %>%
        filter(Value) %>%
        group_by(`Department name`, AWaRe, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Add Hospital-Wide Total row 
      AWaRe_hospital_data <- AWaRe_long %>%
        group_by(AWaRe) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        select(`Department name`, AWaRe, Patients)
      
      # Combine with original data
      AWaRe_long <- bind_rows(AWaRe_long, AWaRe_hospital_data)
      
      # Set the stacking order
      aware_levels_stack <- c("WATCH", "ACCESS")
      
      # Ensure all AWaRe levels are present per department
      all_combos3 <- expand_grid(
        `Department name` = unique(AWaRe_long$`Department name`),
        AWaRe = aware_levels_stack
      )
      
      AWaRe_long <- all_combos3 %>%
        left_join(AWaRe_long, by = c("Department name", "AWaRe")) %>%
        mutate(
          Patients = replace_na(Patients, 0)
        )
      
      # Recalculate totals and proportions
      AWaRe_long <- AWaRe_long %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = ifelse(Total == 0, 0, Patients / Total)
        ) %>%
        ungroup()
      
      return(AWaRe_long)
    })
    
    # AWaRe classification plot (fixed counts) 
    output$aware_classification_plot <- renderPlotly({
      AWaRe_long <- aware_data()
      req(AWaRe_long, nrow(AWaRe_long) > 0)
      
      # Filter out departments with no data
      AWaRe_long <- AWaRe_long %>% dplyr::filter(Total > 0)
      if (nrow(AWaRe_long) == 0) {
        return(plotly_empty() %>%
                 layout(title = list(text = "No data available for AWaRe classification analysis",
                                     font = list(size = 12))))
      }
      
      # MODIFIED: Updated stacking and legend order
      aware_levels_stack <- c("UNCLASSIFIED", "NOT RECOMMENDED", "RESERVE", "WATCH", "ACCESS")
      aware_levels_legend <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
      AWaRe_long$AWaRe <- factor(AWaRe_long$AWaRe, levels = aware_levels_stack)
      
      # FIX: calculate integer counts that always sum to Total per department 
      AWaRe_long <- AWaRe_long %>%
        group_by(`Department name`) %>%
        group_modify(~ {
          df <- .x
          dt <- max(df$Total, na.rm = TRUE)        # department total
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
      
      AWaRe_long <- AWaRe_long %>%
        dplyr::mutate(
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
      
      # Create ordered labels
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(unique(AWaRe_long$PlotLabel[AWaRe_long$PlotLabel != "<b style='color:#0072B2;'>Hospital-Wide</b>"]))
      )
      AWaRe_long$PlotLabel <- factor(AWaRe_long$PlotLabel, levels = ordered_labels)
      
      # n= labels: use dept_total (not sum of Total across rows)
      label_data <- AWaRe_long %>%
        distinct(`Department name`, PlotLabel, dept_total)
      
      # Dynamic buffer
      max_digits <- max(nchar(as.character(label_data$dept_total)), na.rm = TRUE)
      x_buffer <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max <- min(1 + x_buffer, 1.5)
      label_x <- 1 + x_buffer * 0.48
      
      # Create ggplot
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
          breaks = aware_levels_legend,  # MODIFIED: Now includes all 5 categories in correct order
          values = c(
            "ACCESS" = "#1b9e77", 
            "WATCH" = "#ff7f00", 
            "RESERVE" = "#e41a1c",
            "NOT RECOMMENDED" = "#8c510a",
            "UNCLASSIFIED" = "gray70"
          ),
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
            override.aes = list(fill = c("#1b9e77", "#ff7f00", "#e41a1c", "#8c510a", "gray70"))
          )
        ) +
        scale_y_discrete(limits = rev(levels(AWaRe_long$PlotLabel)))
      
      # Convert to plotly with adaptive right margin
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Use of Recommended IV Antibiotic by AWaRe Classification</b><br>"
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
            title = list(text = "<b>AWaRe Classification</b>", font = list(size = 10)),
            traceorder = "normal"  # ADDED: Force plotly to respect order
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
      
      # ADDED: Force reorder legend traces in plotly
      legend_order_map <- setNames(seq_along(aware_levels_legend), aware_levels_legend)
      plt$x$data <- plt$x$data[order(sapply(plt$x$data, function(trace) {
        legend_order_map[trace$name]
      }))]
      
      plt
    })
    
    # Treatment Line Analysis
    treatment_line_data <- reactive({
      if (!check_data()) {
        return(data.frame())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      # Extract lookup info for H_MEN_APPROP_ABX
      lookup_men <- data_lookup %>%
        filter(Code == "H_MEN_APPROP_ABX")
      
      # Create long format from lookup
      lookup_long <- tibble(
        Drug = unlist(lookup_men %>% select(starts_with("ABX-ATC")), use.names = FALSE),
        Choice = unlist(lookup_men %>% select(starts_with("ABX-CHOICE")), use.names = FALSE)
      ) %>%
        filter(!is.na(Drug))
      
      data_men <- data_patients %>%
        filter(`Diagnosis code` == "CNS") %>%
        mutate(
          Route = toupper(as.character(Route)),
          Route = ifelse(is.na(Route), "", Route),
          ATC5 = as.character(ATC5),
          AWaRe_compatible = ifelse(
            !is.na(`Age years`) & `Age years` >= 18 & 
              !is.na(Indication) & Indication == "CAI" & 
              !is.na(Treatment) & Treatment == "EMPIRICAL" & 
              !is.na(AWaRe) & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        ) %>%
        left_join(lookup_long, by = c("ATC5" = "Drug"))
      
      # Build the choice summary table
      choice_summary <- data_men %>%
        filter(AWaRe_compatible == TRUE, Route == "P", !is.na(Choice)) %>%
        group_by(`Department name`, Choice) %>%
        summarise(Prescriptions = n(), .groups = "drop") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Prescriptions),
          Proportion = Prescriptions / Total
        ) %>%
        ungroup()
      
      # Add Hospital-Wide as a summary row
      hospital_summary <- data_men %>%
        filter(AWaRe_compatible == TRUE, Route == "P", !is.na(Choice)) %>%
        group_by(Choice) %>%
        summarise(Prescriptions = n(), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Prescriptions),
          Proportion = Prescriptions / Total
        ) %>%
        ungroup()
      
      # Combine
      choice_summary <- bind_rows(choice_summary, hospital_summary)
      
      # Ensure all combinations (dept x Choice) are present
      choice_levels_stack <- c("Second choice", "First choice")
      
      all_combos <- expand_grid(
        `Department name` = unique(choice_summary$`Department name`),
        Choice = choice_levels_stack
      )
      
      choice_summary <- all_combos %>%
        left_join(choice_summary, by = c("Department name", "Choice")) %>%
        mutate(
          Prescriptions = replace_na(Prescriptions, 0),
          Total = replace_na(Total, 0),
          Proportion = replace_na(Proportion, 0)
        )
      
      return(choice_summary)
    })
    
    # Treatment line plot
    output$treatment_line_plot <- renderPlotly({
      choice_summary <- treatment_line_data()
      req(choice_summary, nrow(choice_summary) > 0)
      
      # Filter out departments with no data
      choice_summary <- choice_summary %>%
        group_by(`Department name`) %>%
        mutate(dept_total = sum(Prescriptions, na.rm = TRUE)) %>%
        ungroup() %>%
        filter(dept_total > 0)
      
      if(nrow(choice_summary) == 0) {
        return(plotly_empty() %>%
                 layout(title = list(text = "No data available for treatment line analysis",
                                     font = list(size = 12))))
      }
      
      # MODIFIED: Updated stacking and legend order to show First choice, Second choice
      treatment_levels_stack <- c("Second choice", "First choice")
      treatment_levels_legend <- c("First choice", "Second choice")
      choice_summary$Choice <- factor(choice_summary$Choice, levels = treatment_levels_stack)
      
      choice_summary <- choice_summary %>%
        dplyr::mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide", 
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          IsHospitalWide = (`Department name` == "Hospital-Wide"),
          ProportionPct = Proportion * 100,
          # Create custom hover text (use dept_total for counts)
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Treatment Choice:</b> ", as.character(Choice), "<br>",
            "<b>Count:</b> ", round(Proportion * dept_total), "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      # Create ordered labels
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(unique(choice_summary$PlotLabel[choice_summary$PlotLabel != "<b style='color:#0072B2;'>Hospital-Wide</b>"]))
      )
      choice_summary$PlotLabel <- factor(choice_summary$PlotLabel, levels = ordered_labels)
      
      # Create label_data from the dept_total (explicit sum) so n= is correct
      label_data <- choice_summary %>%
        group_by(`Department name`, PlotLabel) %>%
        summarise(Total = sum(Prescriptions, na.rm = TRUE), .groups = "drop") %>%
        mutate(
          PlotLabel = factor(PlotLabel, levels = levels(choice_summary$PlotLabel))
        )
      
      # Compute a small dynamic buffer so long 'n=' values don't get clipped/overlap
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      # Use a slightly conservative multiplier to ensure space for commas etc.
      x_buffer <- max(0.06, 0.03 + 0.035 * max_digits)   # e.g. ~0.1 for 2-digit numbers
      xlim_max <- min(1 + x_buffer, 1.5)
      label_x <- 1 + x_buffer * 0.48   # place the labels near the right edge of the buffer
      
      # Create ggplot
      p <- ggplot(choice_summary, aes(y = PlotLabel, x = ProportionPct, fill = Choice, text = hover_text)) +
        geom_bar(stat = "identity", position = "fill", width = 0.85) +
        geom_text(
          aes(label = ifelse(Proportion > 0.05, paste0(round(ProportionPct, 0), "%"), "")),
          position = position_fill(vjust = 0.5),
          size = 3, color = "black"
        ) +
        # Draw n= labels using the computed label_x and nicely formatted totals with commas
        geom_text(
          data = label_data,
          aes(y = PlotLabel, label = paste0("n=", formatC(Total, format = "d", big.mark = ","))),
          x = label_x,
          inherit.aes = FALSE, size = 3, color = "gray30", vjust = 0.5, hjust = 0
        ) +
        scale_fill_manual(
          breaks = treatment_levels_legend,  # MODIFIED: Controls legend order
          values = c("First choice" = "#8E44AD", "Second choice" = "#00BCD4"),
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
          plot.margin  = margin(6, 18, 6, 8)    # keep some extra right margin in ggplot
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
      
      # Convert to plotly
      # Increase the right-hand margin proportional to x_buffer so labels will not be clipped in plotly
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Use of Recommended IV Antibiotic by Line of Treatment</b><br>"
            ),
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
      
      # ADDED: Force reorder legend traces in plotly
      legend_order_map <- setNames(seq_along(treatment_levels_legend), treatment_levels_legend)
      plt$x$data <- plt$x$data[order(sapply(plt$x$data, function(trace) {
        legend_order_map[trace$name]
      }))]
      
      plt
    })
    
    # Choice appropriateness summary
    output$choice_appropriateness_summary <- renderUI({
      qi_summary_men <- qi1_data()
      
      if(is.null(qi_summary_men)) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing IV antibiotic choice appropriateness for community-acquired meningitis.
      </div>"
        ))
      }
      
      # Filter for relevant indicators and exclude Hospital-Wide
      relevant_data <- qi_summary_men %>%
        filter(`Department name` != "Hospital-Wide",
               Indicator %in% c(
                 "Received recommended IV antibiotics",
                 "Partially received recommended IV antibiotics",
                 "Received IV antibiotics not among recommended options"
               ))
      
      # Calculate total eligible patients who received any IV antibiotics
      total_iv <- relevant_data %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      if(is.na(total_iv) || total_iv == 0) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing IV antibiotic choice appropriateness for community-acquired meningitis. <br><br>
     <em>  This may indicate that no patients met the inclusion criteria, or no patients received IV antibiotics during the reporting period. </em>
      </div>"
        ))
      }
      
      # All three categories for choice analysis
      all_categories <- c(
        "Received recommended IV antibiotics",
        "Partially received recommended IV antibiotics", 
        "Received IV antibiotics not among recommended options"
      )
      
      # Get all unique departments and indicators
      dept_list <- unique(qi_summary_men$`Department name`)
      category_list <- all_categories
      
      # Complete grid with zero-filled missing combos
      complete_summary <- expand_grid(
        `Department name` = dept_list,
        Indicator = category_list
      ) %>%
        left_join(qi_summary_men, by = c("Department name", "Indicator")) %>%
        filter(Indicator %in% all_categories) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, round(100 * Patients / Total, 1))
        )
      
      # Icon function for choice analysis
      get_icon <- function(label) {
        label_lower <- tolower(trimws(label))
        if (label_lower == "received recommended iv antibiotics") {
          return("<span style='color:#28a745;'>✅</span>")
        } else if (label_lower == "partially received recommended iv antibiotics") {
          return("<span style='color:#e6b800;'>⚠️</span>")
        } else if (label_lower == "received iv antibiotics not among recommended options") {
          return("<span style='color:#d00;'>❌</span>")
        } else {
          return("🛈")
        }
      }
      
      # Description function for choice analysis
      get_description <- function(label) {
        label_lower <- tolower(label)
        if (label_lower == "received recommended iv antibiotics") {
          return("Received recommended IV antibiotics")
        } else if (label_lower == "partially received recommended iv antibiotics") {
          return("Partially received recommended IV antibiotics")
        } else if (label_lower == "received iv antibiotics not among recommended options") {
          return("Received IV antibiotics not among recommended options")
        } else {
          return(paste("Received:", label))
        }
      }
      
      # Generate HTML summary blocks
      formatted_blocks <- complete_summary %>%
        group_by(`Department name`) %>%
        summarise(
          block = {
            dept <- first(`Department name`)
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            total_patients <- max(Total, na.rm = TRUE)
            
            list_items <- sapply(all_categories, function(label) {
              row_data <- complete_summary %>%
                filter(`Department name` == dept, Indicator == label)
              if(nrow(row_data) == 0) {
                count <- 0
                prop <- 0
              } else {
                count <- row_data$Patients[1]
                prop <- row_data$Proportion[1]
              }
              icon <- get_icon(label)
              description <- get_description(label)
              
              paste0(
                "<li>", icon, " <strong>", description, "</strong> (as per WHO AWaRe book): ",
                "<strong>", scales::percent(prop / 100, accuracy = 0.1), "</strong> ",
                "(", count, " out of ", total_patients, ")</li>"
              )
            })
            
            paste0(
              "<div style='background-color: ", bg, "; border-left: 5px solid ", color, "; padding: 14px; margin-bottom: 20px;'>",
              "<strong>🏥 ", dept, "</strong> <span style='color: #888;'>(n = ", total_patients, " patients)</span><br><br>",
              "<ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>",
              paste(list_items, collapse = ""),
              "</ul>",
              "</div>"
            )
          },
          .groups = "drop"
        ) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>%
        select(-order)
      
      # Calculate total eligible for all analyses (for intro text)
      total_eligible_all <- qi_summary_men %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(!Indicator %in% c("Not eligible for AWaRe meningitis QIs")) %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      if(is.null(total_eligible_all)) total_eligible_all <- 0
      
      # Intro text matching format
      intro_text <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💊 <strong>Denominator:</strong> Number of eligible meningitis patients who received any IV antibiotics for meningitis (<strong>", total_iv, "</strong> out of ", total_eligible_all, ")",
        "</div><br><br>",
        "<strong>Summary:</strong><br><br>"
      )
      
      # Render full HTML output
      final_summary_html <- HTML(paste0(intro_text, paste(formatted_blocks$block, collapse = "\n")))
      return(final_summary_html)
    })
    
    
    # QI2 Dosage appropriateness - Updated to match R markdown logic
    qi2_data <- reactive({
      if (!check_data()) {
        return(data.frame())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      # Filter Meningitis Patients and Add AWaRe Eligibility (exactly matching R markdown)
      data_men2 <- data_patients %>%
        filter(`Diagnosis code` == "CNS") %>%
        mutate(
          Route = toupper(as.character(Route)),
          ATC5 = trimws(toupper(as.character(ATC5))),
          AWaRe_compatible = ifelse(
            !is.na(`Age years`) & `Age years` >= 18 & 
              !is.na(Indication) & Indication == "CAI" & 
              !is.na(Treatment) & Treatment == "EMPIRICAL" & 
              !is.na(AWaRe) & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      # Lookup Drug & Dose Info for H_MEN_APPROP_ABX (exactly matching R markdown)
      lookup2 <- data_lookup %>% filter(Code == "H_MEN_APPROP_ABX")
      
      if(nrow(lookup2) == 0) {
        return(data.frame())
      }
      
      lookup_names2 <- unlist(lookup2[1, c("ABX-ATC-1", "ABX-ATC-2", "ABX-ATC-3", "ABX-ATC-4", "ABX-ATC-5", "ABX-ATC-6")], use.names = FALSE)
      lookup_names2 <- toupper(trimws(lookup_names2[!is.na(lookup_names2)]))
      
      if(length(lookup_names2) == 0) {
        return(data.frame())
      }
      
      # Compute Total Daily Dose with MU → IU conversion (exactly matching R markdown)
      data_men2 <- data_men2 %>%
        mutate(
          # Normalize unit label and apply appropriate factor
          Unit_Factor = case_when(
            Unit == "mg" ~ 1,
            Unit == "g" ~ 1000,
            Unit == "IU" ~ 1,
            Unit == "MU" ~ 1e6,  # Convert MU (Million Units) to IU factor
            TRUE ~ NA_real_
          ),
          # Final total dose: always multiply single dose × freq × factor (includes MU)
          Total_Daily_Dose = as.numeric(`Single Unit Dose`) * as.numeric(`N Doses/day`) * Unit_Factor
        )
      
      # Match Drug + Dose + Route (exactly matching R markdown logic)
      convert_unit <- function(unit) {
        case_when(
          unit == "mg" ~ 1,
          unit == "g" ~ 1000,
          unit == "IU" ~ 1,
          unit == "MU" ~ 1e6,
          TRUE ~ NA_real_
        )
      }
      
      # Helper to get expected dose
      get_expected_dose <- function(i) {
        dose <- as.numeric(lookup2[[paste0("ABX-DOSE-", i)]][1])
        freq <- as.numeric(lookup2[[paste0("ABX-DAY-DOSE-", i)]][1])
        unit <- lookup2[[paste0("ABX-UNIT-", i)]][1]
        dose * freq * convert_unit(unit)
      }
      
      # Extract basic info
      drug_names <- sapply(1:6, function(i) toupper(trimws(lookup2[[paste0("ABX-ATC-", i)]][1])))
      routes <- sapply(1:6, function(i) toupper(trimws(lookup2[[paste0("ABX-ROUTE-", i)]][1])))
      expected_doses <- sapply(1:6, get_expected_dose)
      
      # Special logic for Drug 5 (main + alt dose)
      expected_5_main <- expected_doses[5]
      expected_5_alt <- as.numeric(lookup2[["ABX-DOSE-5a"]][1]) *
        as.numeric(lookup2[["ABX-DAY-DOSE-5"]][1]) *
        convert_unit(lookup2[["ABX-UNIT-5a"]][1])
      
      # Perform matching in one go
      data_men2 <- data_men2 %>%
        mutate(
          Match_Drug_Dose_1 = ATC5 == drug_names[1] & Route == "P" &
            abs(Total_Daily_Dose - expected_doses[1]) < 1,
          
          Match_Drug_Dose_2 = ATC5 == drug_names[2] & Route == "P" &
            abs(Total_Daily_Dose - expected_doses[2]) < 1,
          
          Match_Drug_Dose_3 = ATC5 == drug_names[3] & Route == "P" &
            abs(Total_Daily_Dose - expected_doses[3]) < 1,
          
          Match_Drug_Dose_4 = ATC5 == drug_names[4] & Route == "P" &
            abs(Total_Daily_Dose - expected_doses[4]) < 1,
          
          Match_Drug_Dose_5 = ATC5 == drug_names[5] & Route == "P" &
            (
              abs(Total_Daily_Dose - expected_5_main) < 1 |
                abs(Total_Daily_Dose - expected_5_alt) < 1
            ),
          
          Match_Drug_Dose_6 = ATC5 == drug_names[6] & Route == "P" &
            abs(Total_Daily_Dose - expected_doses[6]) < 1
        )
      
      # Summarize at Patient Level (exactly matching R markdown)
      patient_summary2 <- data_men2 %>%
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
            (Match_1_P & Dose_1_OK) |
            (Match_2_P & Dose_2_OK) |
            (Match_3_P & Dose_3_OK) |
            (Match_4_P & Dose_4_OK) |
            (Match_5_P & Dose_5_OK) |
            (Match_6_P & Dose_6_OK),
          
          Dose_Result = case_when(
            Any_Correct_Dose ~ "Received recommended IV antibiotic with recommended dosage",
            Any_Match & !Any_Correct_Dose ~ "Received recommended IV antibiotic without recommended dosage",
            Any_IV & !Any_Match ~ "Received IV antibiotics not among recommended options",
            TRUE ~ NA_character_
          )
        ) %>%
        filter(!is.na(Dose_Result))
      
      if(nrow(patient_summary2) == 0) {
        return(data.frame())
      }
      
      # Summarize by department (exactly matching R markdown)
      iv_dose_counts <- patient_summary2 %>%
        count(`Department name`, Dose_Result, name = "Patients")
      
      # Complete combinations: all depts × all results
      all_combos2 <- expand_grid(
        `Department name` = unique(patient_summary2$`Department name`),
        Dose_Result = c("Received recommended IV antibiotic with recommended dosage", 
                        "Received recommended IV antibiotic without recommended dosage", 
                        "Received IV antibiotics not among recommended options")
      )
      
      # Merge and fill missing
      iv_dose_summary2 <- all_combos2 %>%
        left_join(iv_dose_counts, by = c("Department name", "Dose_Result")) %>%
        mutate(Patients = replace_na(Patients, 0)) %>%
        group_by(`Department name`) %>%
        mutate(Total = sum(Patients), Proportion = round(100 * Patients / Total, 1)) %>%
        ungroup()
      
      # Hospital-Wide row
      hospital_row2 <- iv_dose_summary2 %>%
        group_by(Dose_Result) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(Total = sum(Patients), Proportion = round(100 * Patients / Total, 1)) %>%
        ungroup()
      
      # Final summary table
      final_summary2 <- bind_rows(iv_dose_summary2, hospital_row2) %>%
        arrange(`Department name`, Dose_Result)
      
      return(final_summary2)
    })
    
    # Dosage appropriateness plot (Updated to match horizontal format from fourth code)
    output$dosage_appropriateness_plot <- renderPlotly({
      final_summary2 <- qi2_data()
      req(final_summary2, nrow(final_summary2) > 0)
      
      # Colors matching R markdown (keeping original logic)
      drug_dosage_colors <- c(
        "Received recommended IV antibiotic with recommended dosage" = "#084594",
        "Received recommended IV antibiotic without recommended dosage" = "#FC9272",
        "Received IV antibiotics not among recommended options" = "#D3D3D3"
      )
      
      all_categories2 <- names(drug_dosage_colors)
      
      # Complete summary with all combinations
      complete_summary <- tidyr::expand_grid(
        `Department name` = unique(final_summary2$`Department name`),
        Dose_Result = all_categories2
      ) %>%
        dplyr::left_join(final_summary2, by = c("Department name", "Dose_Result")) %>%
        dplyr::mutate(
          Patients = tidyr::replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, round(100 * Patients / Total, 1)),
          Dose_Result = factor(Dose_Result, levels = all_categories2),
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          IsHospitalWide = (`Department name` == "Hospital-Wide"),
          Proportion_Decimal = Proportion / 100,
          # Create custom hover text matching R markdown style
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
      
      # Dynamic buffer (matching fourth code)
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # Create ggplot matching fourth code style but with original logic
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
        scale_fill_manual(values = drug_dosage_colors, drop = FALSE) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
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
        guides(fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")) +
        scale_y_discrete(limits = rev(levels(complete_summary$PlotLabel)))
      
      # Convert to plotly (matching fourth code layout)
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Summary of Choice & Dosage Appropriateness for Meningitis Cases</b><br>"
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
            title = list(text = "<b>Treatment Appropriateness</b>", font = list(size = 10))
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
    
    # Dosage appropriateness summary
    output$dosage_appropriateness_summary <- renderUI({
      final_summary2 <- qi2_data()
      
      if(is.null(final_summary2)) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for evaluating the appropriateness of IV antibiotic dosage for community-acquired meningitis.
      </div>"
        ))
      }
      
      # Exclude Hospital-Wide and filter for dose-related categories only
      final_summary2_filtered <- final_summary2 %>%
        filter(`Department name` != "Hospital-Wide")
      
      # Define the relevant dose categories (excluding "not recommended" category)
      dose_categories <- c(
        "Received recommended IV antibiotic with recommended dosage",
        "Received recommended IV antibiotic without recommended dosage"
      )
      
      # Calculate total eligible patients who received recommended IV antibiotics
      total_approp_iv_given <- final_summary2_filtered %>%
        filter(Dose_Result %in% dose_categories) %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      if (total_approp_iv_given == 0 || is.na(total_approp_iv_given)) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for evaluating the appropriateness of IV antibiotic dosage for community-acquired meningitis. <br><br>
     <em>This may indicate that no patients met the inclusion criteria, or no patients received recommended IV antibiotics during the reporting period.</em>
      </div>"
        ))
      }
      
      # Get all unique departments and dose result categories
      dept_list <- unique(final_summary2$`Department name`)
      
      # Complete grid with zero-filled missing combos (only dose categories)
      complete_summary <- expand_grid(
        `Department name` = dept_list,
        Dose_Result = dose_categories
      ) %>%
        left_join(final_summary2, by = c("Department name", "Dose_Result")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, Patients / Total)
        ) %>%
        filter(Total > 0)  # Remove departments with no eligible patients
      
      # If no data remains after filtering
      if (nrow(complete_summary) == 0) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for evaluating the appropriateness of IV antibiotic dosage for community-acquired meningitis. <br><br>
     <em>This may indicate that no patients met the inclusion criteria, or no patients received recommended IV antibiotics during the reporting period.</em>
      </div>"
        ))
      }
      
      # Calculate total eligible for all analyses (from QI1 data for context)
      total_eligible_all <- qi1_data() %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(!Indicator %in% c("Not eligible for AWaRe meningitis QIs")) %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      if(is.null(total_eligible_all)) total_eligible_all <- 0
      
      # Generate HTML summary blocks
      formatted_blocks2 <- complete_summary %>%
        group_by(`Department name`) %>%
        summarise(
          block = {
            dept <- first(`Department name`)
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            total_patients <- first(Total)
            
            # Get values for each category
            correct_dose_count <- Patients[Dose_Result == "Received recommended IV antibiotic with recommended dosage"]
            correct_dose_prop <- Proportion[Dose_Result == "Received recommended IV antibiotic with recommended dosage"]
            
            incorrect_dose_count <- Patients[Dose_Result == "Received recommended IV antibiotic without recommended dosage"]
            incorrect_dose_prop <- Proportion[Dose_Result == "Received recommended IV antibiotic without recommended dosage"]
            
            # Handle NA values
            if(length(correct_dose_count) == 0) correct_dose_count <- 0
            if(length(correct_dose_prop) == 0) correct_dose_prop <- 0
            if(length(incorrect_dose_count) == 0) incorrect_dose_count <- 0
            if(length(incorrect_dose_prop) == 0) incorrect_dose_prop <- 0
            
            paste0(
              "<div style='background-color: ", bg, "; border-left: 5px solid ", color, "; padding: 14px; margin-bottom: 20px;'>",
              "<strong>🏥 ", dept, "</strong> <span style='color: #888;'>(n = ", total_patients, " patients)</span><br><br>",
              "<ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>",
              "<li>✅ <strong>Received recommended IV antibiotic with recommended dosage</strong> (as per WHO AWaRe book): ",
              "<strong>", scales::percent(correct_dose_prop, accuracy = 0.1), "</strong> ",
              "(", correct_dose_count, " out of ", total_patients, ")</li>",
              "<li>❌ <strong>Received recommended IV antibiotic without recommended dosage</strong> (as per WHO AWaRe book): ",
              "<strong>", scales::percent(incorrect_dose_prop, accuracy = 0.1), "</strong> ",
              "(", incorrect_dose_count, " out of ", total_patients, ")</li>",
              "</ul>",
              "</div>"
            )
          },
          .groups = "drop"
        ) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>%
        select(-order)
      
      # Intro text matching R markdown format
      intro_text2 <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💊 <strong>Denominator:</strong> Number of eligible meningitis patients who received any recommended (<em>or partially recommended</em>) IV antibiotic choice based on WHO AWaRe book (<strong>", total_approp_iv_given, "</strong> out of ", total_eligible_all, ").",
        "</div><br><br>",
        "<strong>Summary:</strong><br><br>"
      )
      
      # Render full HTML output
      final_summary_html2 <- HTML(paste0(intro_text2, paste(formatted_blocks2$block, collapse = "\n")))
      return(final_summary_html2)
    })
  })
}