# Sepsis Analysis Shiny Module - Complete Implementation
# This module contains all the sepsis-specific analysis functionality split into separate tabs

# Overview Tab UI
sepsisOverviewUI <- function(id) {
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
               box(width = 12, title = "🎯 AWaRe Quality Indicators for Sepsis", status = "info", solidHeader = TRUE,
                   
                   h5("Within the gPPS data structure, the following antibiotic use quality indicators have been identified:"),
                   p("1) ","Proportion of patients presenting with clinical sepsis of unknown origin given the appropriate IV antibiotics according to the WHO AWaRe book."),
                   p("2) ","Proportion of patients presenting with clinical sepsis of unknown origin prescribed the total daily dose of IV empiric antibiotics recommended in the WHO AWaRe book.")
                   
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
sepsisEligibilityUI <- function(id) {
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
                   htmlOutput(ns("eligibility_feedback"))
               )
        )
      )
    )
  )
}

# Patient Summary Tab UI
sepsisPatientSummaryUI <- function(id) {
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
                   p("Eligible patients for WHO AWaRe Quality Indicator (QI) assessment are defined as adult inpatients (≥18 years) who received empirical antibiotics for CA-SEPSIS.")
               )
        )
      )
    )
  )
}

# QI 1 Tab UI
sepsisQI1UI <- function(id) {
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
                   p("Please upload your data files to view QI 1 analysis.")
               )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📌 Antibiotic Choice Alignment with AWaRe book Recommendations for Sepsis", status = "primary", solidHeader = TRUE,#collapsible = TRUE,collapsed = TRUE,
                   p(" Proportion of patients presenting with clinical sepsis of unknown origin given the appropriate IV antibiotics according to the WHO AWaRe book."),
                   
               )
        )
      ),
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🔍 WHO AWaRe book Recommendation:", status = "primary", solidHeader = TRUE,
                   "▸ ",strong("Primary IV antibiotics:"), " Cefotaxime (2 g q8h) ", em("OR"), " Ceftriaxone (2 g q24h)", br(),
                   "▸ ",strong("Secondary IV antibiotics:"), " Amikacin (15 mg/kg q24h) ", em("OR"), " Gentamicin (5 mg/kg q24h)", br(),
                   em(strong("The recommended regimen"), ": A combination of one primary + one secondary antibiotic")
                   
               )
        )
      ),
      
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📈 Antibiotic Choice Alignment with AWaRe book Recommendations for Sepsis",
            status = "primary", solidHeader = TRUE, 
            p("This visual summarises the proportion of treatment alignment for sepsis across hospital departments based on WHO AWaRe book"),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("choice_appropriateness_plot"), height = "450px", width = "100%"),
                  type = 4
                ))
          )
        )
      ),
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📝 Summary of Antibiotic Choice Alignment with AWaRe book Recommendations for Sepsis", status = "info", solidHeader = TRUE,collapsible = TRUE,collapsed = TRUE,
                   htmlOutput(ns("choice_appropriateness_summary"))
               )
        )
      )
    )
  )
}

# QI 2 Tab UI
sepsisQI2UI <- function(id) {
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
                   p("Please upload your data files to view QI 2 analysis.")
               )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📌 Antibiotic Dosage Alignment with AWaRe book Recommendations for Sepsis", status = "primary", solidHeader = TRUE,
                   p(" Proportion of patients presenting with clinical sepsis of unknown origin prescribed the total daily dose of IV empiric antibiotics recommended in the WHO AWaRe Antibiotic Book.")
               )
        )
      ),
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🔍 WHO AWaRe book Recommendation:", status = "primary", solidHeader = TRUE,
                   "▸ ",strong("Primary IV antibiotics:"), " Cefotaxime (2 g q8h) ", em("OR"), " Ceftriaxone (2 g q24h)", br(),
                   "▸ ",strong("Secondary IV antibiotics:"), " Amikacin (15 mg/kg q24h) ", em("OR"), " Gentamicin (5 mg/kg q24h)", br(),
                   em(strong("The recommended regimen"), ": A combination of one primary + one secondary antibiotic")
                   
               )
        )
      ),
      
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📈 Antibiotic Dosage Alignment with AWaRe book Recommendations for Sepsis",
            status = "primary", solidHeader = TRUE,
            p("This visual summarises Dosage Alignment for sepsis across hospital departments based on WHO AWaRe book"),
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
                ))
          )
        )
      ),
      
      column(10, offset = 1,
             div(class = "info-box",
                 strong("💡 Note:"),
                 tags$ul(
                   tags$li("The partially recommended category refers to cases where patients received only part of the recommended antibiotic regimen. This could mean just one of the two recommended antibiotics was given, or the recommended antibiotics were combined with others not part of the regimen."),
                   tags$li("Secondary antibiotics (Amikacin or Gentamicin) are recommended to be used in combination with primary agents (Cefotaxime or Ceftriaxone) to achieve bactericidal synergy, broaden the spectrum of treatment activity, prevent the emergence of resistance, and induce a lasting inhibition of bacterial growth.")
                 )
             )
      ),
      
      column(10, offset = 1,
             div(class = "info-box",
                 strong("💡 Note:"),
                 tags$ul(
                   tags$li("Received recommended IV antibiotics with recommended dosage indicates that the full recommended treatment regimen was given, with both dosages aligned with WHO AWaRe book guidance."),
                   tags$li("Received at least one recommended IV antibiotic with one has recommended dosage refers to cases where only part of the recommended dual therapy was given, and only one antibiotic was at the recommended dosage."),
                   tags$li("Received at least one recommended IV antibiotic with none have recommended dosage includes cases who received either the full recommended regimen with no recommended dosages, or only part of it (e.g., one agent from the dual therapy) with none of the dosages aligned with WHO AWaRe book guidance.")
                 )
             )
      ),
      
      
      
      
      
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📝 Antibiotic Choice & Dosage Alignment with AWaRe book Recommendations for Sepsis", status = "info", solidHeader = TRUE,collapsible = TRUE,collapsed = TRUE,
                   htmlOutput(ns("dosage_appropriateness_summary"))
                   
               )
        )
      )
    )
  )
}


# Module Server - Handles all sepsis tabs
sepsisAnalysisServer <- function(id, data_reactive) {
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
        
        # Fix AWaRe column - convert NOT_RECOMMENDED to NOT RECOMMENDED 
        data_patients <- data_patients %>%
          mutate(
            AWaRe = ifelse(
              toupper(AWaRe) == "NOT_RECOMMENDED",
              "NOT RECOMMENDED",
              AWaRe
            )
          )
        
        # Filter eligible sepsis patients
        data_sepsis <- data_patients %>%
          filter(`Diagnosis code` == "SEPSIS") %>%
          mutate(
            Route = toupper(as.character(Route)),
            AWaRe_compatible = (`Age years` >= 18 & 
                                  Indication == "CAI" & 
                                  Treatment == "EMPIRICAL" & 
                                  AWaRe %in% AWaRe_abx)
          ) 
        
        # Count eligible unique sepsis cases
        eligible_sepsis_n <- data_sepsis %>%
          filter(AWaRe_compatible) %>%
          distinct(`Survey Number`) %>%
          nrow()
        
        # Format survey dates safely - try different approaches
        survey_start <- tryCatch({
          if (!is.null(data_info$`Survey start date`) && !is.na(data_info$`Survey start date`)) {
            format(as.Date(data_info$`Survey start date`), "%d %b %Y")
          } else if (nrow(data_info) >= 1 && ncol(data_info) >= 2) {
            # Try accessing by position if column names don't work
            date_val <- data_info[1, 2]
            if (!is.na(date_val)) {
              format(as.Date(date_val, origin = "1899-12-30"), "%d %b %Y")
            } else {
              "Not available"
            }
          } else {
            "Not available"
          }
        }, error = function(e) "Not available")
        
        survey_end <- tryCatch({
          if (!is.null(data_info$`Survey end date`) && !is.na(data_info$`Survey end date`)) {
            format(as.Date(data_info$`Survey end date`), "%d %b %Y")
          } else if (nrow(data_info) >= 1 && ncol(data_info) >= 4) {
            # Try accessing by position if column names don't work
            date_val <- data_info[1, 4]
            if (!is.na(date_val)) {
              format(as.Date(date_val, origin = "1899-12-30"), "%d %b %Y")
            } else {
              "Not available"
            }
          } else {
            "Not available"
          }
        }, error = function(e) "Not available")
        
        # Build status message
        status_message <- if(eligible_sepsis_n == 0) {
          "<div style='background-color:#fff3cd; border: 1px solid #ffeeba; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>🚫 No data available:</strong> There were no eligible cases for evaluation during this survey period. Please verify data availability.
          </div>"
        } else if(eligible_sepsis_n < 10) {
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
          "<strong>📅 Survey period:</strong> ", survey_start, " to ", survey_end,
          "</p>",
          "<p style='margin-bottom: 10px;'>",
          "This script applies <strong>WHO AWaRe Quality Indicators</strong> to adult inpatients with ",
          "empirical antibiotics for community-acquired sepsis.",
          "</p>",
          "<ul>",
          "<li><strong>Diagnostic code:</strong> SEPSIS (Clinical Sepsis of Unknown Origin)</li>",
          "<li><strong>Total eligible cases:</strong> ", eligible_sepsis_n, "</li>",
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
        
        # Fix AWaRe column - convert NOT_RECOMMENDED to NOT RECOMMENDED 
        data_patients <- data_patients %>%
          mutate(
            AWaRe = ifelse(
              toupper(AWaRe) == "NOT_RECOMMENDED",
              "NOT RECOMMENDED",
              AWaRe
            )
          )
        
        # Filter eligible sepsis patients
        data_sepsis <- data_patients %>%
          filter(`Diagnosis code` == "SEPSIS") %>%
          mutate(
            Route = toupper(as.character(Route)),
            AWaRe_compatible = (`Age years` >= 18 & 
                                  Indication == "CAI" & 
                                  Treatment == "EMPIRICAL" & 
                                  AWaRe %in% AWaRe_abx)
          ) 
        
        # Count eligible unique sepsis cases
        eligible_sepsis_n <- data_sepsis %>%
          filter(AWaRe_compatible) %>%
          distinct(`Survey Number`) %>%
          nrow()
        
        # Build status message
        status_message <- if(eligible_sepsis_n == 0) {
          "<div style='background-color:#fff3cd; border: 1px solid #ffeeba; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>🚫 No data available:</strong> There were no eligible cases for evaluation during this survey period. Please verify data availability.
          </div>"
        } else if(eligible_sepsis_n < 10) {
          "<div style='background-color:#ffe0e0; border: 1px solid #ffb3b3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>⚠️ Caution:</strong> Few eligible cases detected. Interpret results with caution.
          </div>"
        } else {
          "<div style='background-color:#e0ffe0; border: 1px solid #b3ffb3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>✅ Good to go!</strong> Sufficient eligible cases available to proceed with full evaluation.
          </div>"
        }
        
        # Build HTML feedback using paste0 - simplified for overview
        html_feedback <- HTML(paste0(
          "<div style='background-color: #f0f8ff; border: 1px solid #add8e6; padding: 15px; border-radius: 5px; font-family: sans-serif;'>",
          "<p style='margin-bottom: 10px;'>",
          "This script applies <strong>WHO AWaRe Quality Indicators</strong> to adult inpatients with ",
          "empirical antibiotics for community-acquired sepsis.",
          "</p>",
          "<ul>",
          "<li><strong>Diagnostic code:</strong> SEPSIS (Clinical Sepsis of Unknown Origin)</li>",
          "<li><strong>Total eligible cases:</strong> ", eligible_sepsis_n, "</li>",
          "</ul>",
          status_message,
          "</div>"
        ))
        
        return(html_feedback)
        
      }, error = function(e) {
        return(HTML(paste0("<div style='background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 15px; border-radius: 5px;'><p><strong>❌ Error loading eligibility information:</strong></p><p>", as.character(e$message), "</p></div>")))
      })
    })
    
    # Summary Insights Cards
    output$summary_insights_cards <- renderUI({
      if (!check_data()) {
        return(HTML("<p>No data available for insights</p>"))
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
        filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "SEPSIS") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      eligible_patients <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx, Treatment == "EMPIRICAL", `Diagnosis code` == "SEPSIS") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      total_prescriptions <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "SEPSIS") %>%
        nrow()
      
      eligible_prescriptions <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx, Treatment == "EMPIRICAL", `Diagnosis code` == "SEPSIS") %>%
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
        "<h4 style='margin-top: 0; color: #155724;'>👥 Proportion of Eligible Patients:</h4>",
        "<div style='font-size: 2.5em; font-weight: bold; color: #155724; margin: 10px 0;'>", patient_percentage, "%</div>",
        "<p style='margin-bottom: 0; color: #155724;'>",
        "<strong>", eligible_patients, "</strong> out of <strong>", total_patients, 
        "</strong> patients on antibiotics for sepsis were QI-eligible patients.",
        "</p>",
        "</div>",
        
        # Card 2: Prescriptions
        "<div style='flex: 1; min-width: 300px; background-color: ", prescription_color, 
        "; border-left: 6px solid #17a2b8; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>",
        "<h4 style='margin-top: 0; color: #0c5460;'>📑 Proportion of Eligible Prescriptions:</h4>",
        "<div style='font-size: 2.5em; font-weight: bold; color: #0c5460; margin: 10px 0;'>", prescription_percentage, "%</div>",
        "<p style='margin-bottom: 0; color: #0c5460;'>",
        "<strong>", eligible_prescriptions, "</strong> out of <strong>", total_prescriptions, 
        "</strong> antibiotic prescriptions for sepsis were given to QI-eligible patients.",
        "</p>",
        "</div>",
        
        "</div>"
      ))
      
      return(insight_cards)
      
    })
    
    # Patient summary table
    output$patient_summary_table <- DT::renderDT({
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
          "Number of all patients with a diagnosis of sepsis on any antibiotics",
          "**Number of eligible patients:** Adult patients (≥18 years) with a diagnosis of CA-Sepsis who were treated empirically with antibiotics"
        ),
        Count = c(
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Diagnosis code` == "SEPSIS", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "SEPSIS", AWaRe %in% AWaRe_abx) %>%
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
    
    # Prescription summary table
    output$prescription_summary_table <- DT::renderDT({
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
          "Number of all antibiotic prescriptions for patients diagnosed with sepsis",
          "**Number of eligible antibiotic prescriptions:** antibiotics empirically prescribed for adult patients (≥18 years) with CA-Sepsis"
        ),
        Count = c(
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Diagnosis code` == "SEPSIS", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "SEPSIS", AWaRe %in% AWaRe_abx) %>% nrow()
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
    
    # QI 1: Choice Appropriateness Analysis
    qi1_data <- reactive({
      if (!check_data()) {
        return(NULL)
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      tryCatch({
        # Fix AWaRe column - convert NOT_RECOMMENDED to NOT RECOMMENDED 
        data_patients <- data_patients %>%
          mutate(
            AWaRe = ifelse(
              toupper(AWaRe) == "NOT_RECOMMENDED",
              "NOT RECOMMENDED",
              AWaRe
            )
          )
        
        data_sepsis <- data_patients %>%
          filter(`Diagnosis code` == "SEPSIS") %>%
          mutate(
            Route = toupper(Route),
            AWaRe_compatible = ifelse(
              `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
              TRUE, FALSE
            )
          )
        
        # Get lookup names for sepsis QI
        lookup_names <- data_lookup %>%
          filter(Code == "H_SEP_APPROP_ABX") %>%
          select(starts_with("ABX-ATC")) %>%
          unlist(use.names = FALSE)
        
        if(length(lookup_names) < 4) {
          return(NULL)
        }
        
        # Summarise patient-level IV antibiotic usage (using "P" for IV route)
        patient_summary_sepsis <- data_sepsis %>%
          filter(AWaRe_compatible) %>%
          group_by(`Survey Number`, `Department name`) %>%
          summarise(
            Abx_names = list(unique(ATC5[Route == "P"])),
            Match_1_P = any(ATC5 == lookup_names[1] & Route == "P"),
            Match_2_P = any(ATC5 == lookup_names[2] & Route == "P"),
            Match_3_P = any(ATC5 == lookup_names[3] & Route == "P"),
            Match_4_P = any(ATC5 == lookup_names[4] & Route == "P"),
            Any_Oral = any(Route == "O"),  # Changed from "ORAL" to "O" to match R markdown
            Any_IV = any(Route == "P"),
            N_P = sum(Route == "P"),
            .groups = "drop"
          ) %>%
          rowwise() %>%
          mutate(
            Num_recommended_given = sum(c_across(Match_1_P:Match_4_P)),
            All_IV_names_flat = paste0(unlist(Abx_names), collapse = ","),
            
            # Full recommended regimen: one primary (1 or 2) + one secondary (3 or 4), exactly 2 IV drugs
            Received_full_recommended_IV = (
              (Match_1_P & Match_3_P) |
                (Match_1_P & Match_4_P) |
                (Match_2_P & Match_3_P) |
                (Match_2_P & Match_4_P)
            ) &
              Num_recommended_given == 2 & N_P == 2,
            
            Received_no_recommended_IV = Any_IV & !(Match_1_P | Match_2_P | Match_3_P | Match_4_P),
            
            Received_partial_recommended_IV = Any_IV & !Received_full_recommended_IV & !Received_no_recommended_IV,
            
            Received_oral_only = Any_Oral & !Received_full_recommended_IV & !Received_partial_recommended_IV & !Received_no_recommended_IV,
            
            Other_non_IV_or_oral = !Received_full_recommended_IV & !Received_partial_recommended_IV & !Received_no_recommended_IV & !Received_oral_only
          ) %>%
          ungroup()
        
        if(nrow(patient_summary_sepsis) == 0) {
          return(NULL)
        }
        
        # Identify ineligible patients
        not_eligible_patients <- data_sepsis %>%
          group_by(`Survey Number`, `Department name`) %>%
          summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
          filter(Ineligible)
        
        # Reshape to long format
        eligible_long_sepsis <- patient_summary_sepsis %>%
          select(
            `Survey Number`, `Department name`,
            Received_full_recommended_IV,
            Received_partial_recommended_IV,
            Received_oral_only,
            Received_no_recommended_IV,
            Other_non_IV_or_oral
          ) %>%
          pivot_longer(
            cols = -c(`Survey Number`, `Department name`),
            names_to = "Indicator",
            values_to = "Value"
          ) %>%
          filter(Value) %>%
          group_by(`Department name`, Indicator) %>%
          summarise(Patients = n(), .groups = "drop")
        
        # Generate full department-indicator grid
        all_combos <- expand_grid(
          `Department name` = unique(patient_summary_sepsis$`Department name`),
          Indicator = c(
            "Received_full_recommended_IV",
            "Received_partial_recommended_IV",
            "Received_oral_only",
            "Received_no_recommended_IV",
            "Other_non_IV_or_oral",
            "Not_Eligible"
          )
        )
        
        # Add ineligible data
        ineligible_summary <- not_eligible_patients %>%
          count(`Department name`) %>%
          mutate(Indicator = "Not_Eligible") %>%
          rename(Patients = n)
        
        qi_long <- bind_rows(eligible_long_sepsis, ineligible_summary)
        
        # Fill missing combinations with 0s
        qi_long <- all_combos %>%
          left_join(qi_long, by = c("Department name", "Indicator")) %>%
          mutate(Patients = replace_na(Patients, 0))
        
        # Compute totals and proportions
        dept_totals <- qi_long %>%
          group_by(`Department name`) %>%
          summarise(Total = sum(Patients), .groups = "drop")
        
        qi_summary_sepsis <- qi_long %>%
          left_join(dept_totals, by = "Department name") %>%
          mutate(
            Indicator = case_when(
              Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
              Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
              Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
              Indicator == "Received_oral_only" ~ "Received oral antibiotics",
              Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
              Indicator == "Not_Eligible" ~ "Not eligible for AWaRe sepsis QIs",
              TRUE ~ Indicator
            ),
            Proportion = round(Patients / Total, 3)
          )
        
        # Add Hospital-Wide summary
        hospital_row <- qi_summary_sepsis %>%
          group_by(Indicator) %>%
          summarise(Patients = sum(Patients), .groups = "drop") %>%
          mutate(`Department name` = "Hospital-Wide") %>%
          group_by(`Department name`) %>%
          mutate(Total = sum(Patients), Proportion = Patients / Total) %>%
          ungroup()
        
        # Final output
        qi_summary_sepsis <- bind_rows(qi_summary_sepsis, hospital_row) %>%
          arrange(`Department name`, Indicator)
        
        return(qi_summary_sepsis)
      }, error = function(e) {
        return(NULL)
      })
    })
    
    # Choice appropriateness plot - Sepsis 
    output$choice_appropriateness_plot <- renderPlotly({
      qi_summary_sepsis <- qi1_data()
      
      if (is.null(qi_summary_sepsis) || nrow(qi_summary_sepsis) == 0) {
        return(plotly_empty())
      }
      
      # Colors matching the R markdown (preserved)
      drug_choice_colors <- c(
        "Received recommended IV antibiotics" = "#1F77B4",         # Dark Blue
        "Partially received recommended IV antibiotics" = "#4FA9DC", # Light Blue
        "Received IV antibiotics not among recommended options" = "#EF476F", # Pink
        "Received oral antibiotics" = "#F9D99E",                   # Beige
        "Received other non-IV/oral antibiotics" = "#D3D3D3",      # Light Grey
        "Not eligible for AWaRe sepsis QIs" = "#A9A9A9"            # Dark Grey
      )
      
      all_categories <- names(drug_choice_colors)
      
      # Complete summary with all combinations (preserved logic)
      complete_summary <- expand_grid(
        `Department name` = unique(qi_summary_sepsis$`Department name`),
        Indicator = all_categories
      ) %>%
        left_join(qi_summary_sepsis, by = c("Department name", "Indicator")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, Patients / Total),
          Indicator = factor(Indicator, levels = all_categories),
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>",
                             `Department name`)
        )
      
      # X-axis department order (Hospital-Wide first) (preserved logic)
      label_order <- c("<b style='color:#0072B2;'>Hospital-Wide</b>",
                       sort(setdiff(unique(complete_summary$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>")))
      complete_summary$PlotLabel <- factor(complete_summary$PlotLabel, levels = label_order)
      
      # Create ggplot matching IAIs style
      p <- ggplot(
        complete_summary,
        aes(
          x = PlotLabel, y = Proportion, fill = Indicator,
          text = paste0(
            "Department: ", gsub("<.*?>", "", `Department name`), "<br>",
            "Category: ", Indicator, "<br>",
            "Patients: ", Patients, "<br>",
            "Total: ", Total, "<br>",
            "Proportion: ", scales::percent(Proportion, accuracy = 0.1)
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
          aes(x = PlotLabel, y = 1.05, label = paste0("n=", Total)), # Changed to match IAIs
          inherit.aes = FALSE, size = 3, color = "gray30", hjust = 0.5
        ) +
        scale_fill_manual(values = drug_choice_colors, drop = FALSE) +
        scale_y_continuous(limits = c(0, 1.09), expand = c(0, 0), # Changed to match IAIs
                           labels = scales::percent_format(accuracy = 1)) +
        scale_x_discrete(expand = c(0.01, 0.01)) +
        labs(
          title = NULL, # Changed to match IAIs
          subtitle = NULL, # Changed to match IAIs
          x = "Department",
          y = "Proportion of Patients", # Changed to match IAIs
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
        guides(fill = guide_legend(nrow = 3, byrow = TRUE, title.position = "top")) # Changed to nrow = 3
      
      # Convert to plotly (adjusted to match IAIs)
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Antibiotic Choice Alignment Summary for Sepsis</b><br>"
            ),
            x = 0.5, xanchor = "center",
            y = 0.97, yanchor = "top",
            font = list(size = 12)
          ),
          height = 450,
          width  = 680,
          margin = list(l = 30, r = 30, t = 60, b = 200), # Changed to match IAIs
          legend = list(
            orientation = "h",
            x = 0.5, xanchor = "center",
            y = -0.80, yanchor = "top", # Changed to match IAIs
            font = list(size = 9),
            title = list(text = "<b>Treatment Alignment Category</b>", font = list(size = 9)) # Changed to match IAIs
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
              text = "<b>Proportion of Patients</b>", # 
              standoff = 20
            )
          )
        ) %>%
        # Add background shading using shapes
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
    
    # Choice appropriateness summary
    output$choice_appropriateness_summary <- renderUI({
      qi_summary_sepsis <- qi1_data()
      
      if(is.null(qi_summary_sepsis)) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
          ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing IV antibiotic choice appropriateness for community-acquired sepsis.
          </div>"
        ))
      }
      
      # Filter only relevant IV treatment indicators
      relevant_data <- qi_summary_sepsis %>%
        filter(Indicator %in% c(
          "Received recommended IV antibiotics",
          "Partially received recommended IV antibiotics",
          "Received IV antibiotics not among recommended options"
        ))
      
      if (nrow(relevant_data) == 0) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
          ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing IV antibiotic choice appropriateness for community-acquired sepsis.
          </div>"
        ))
      }
      
      # Calculate total IV patients (excluding Hospital-Wide to avoid double counting)
      total_iv <- relevant_data %>%
        filter(`Department name` != "Hospital-Wide") %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Calculate total eligible patients (all categories except "Not eligible")
      total_eligible <- qi_summary_sepsis %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(!Indicator %in% c("Not eligible for AWaRe sepsis QIs")) %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      summary_data_sepsis <- relevant_data %>%
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
          Prop_Full = `Received recommended IV antibiotics` / Total,
          Prop_Partial = `Partially received recommended IV antibiotics` / Total,
          Prop_None = `Received IV antibiotics not among recommended options` / Total
        ) %>%
        filter(Total > 0)
      
      if (nrow(summary_data_sepsis) == 0) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
          ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing IV antibiotic choice appropriateness for community-acquired sepsis.
          </div>"
        ))
      }
      
      formatted_blocks <- summary_data_sepsis %>%
        mutate(block = pmap_chr(
          list(
            `Department name`,
            Prop_Full, `Received recommended IV antibiotics`,
            Prop_Partial, `Partially received recommended IV antibiotics`,
            Prop_None, `Received IV antibiotics not among recommended options`,
            Total
          ),
          function(dept, full_p, full_n, part_p, part_n, none_p, none_n, total_n) {
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            
            paste0(
              "<div style='background-color: ", bg, "; border-left: 5px solid ", color, "; padding: 14px; margin-bottom: 20px;'>",
              "<strong>🏥 ", dept, "</strong> <span style='color: #888;'>(n = ", total_n, " patients)</span><br><br>",
              "<ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>",
              "<li>✅ <strong>Received recommended IV antibiotics</strong> (as per WHO AWaRe book): <strong>", scales::percent(full_p, accuracy = 0.1), "</strong> (", full_n, " out of ", total_n, ")</li>",
              "<li>⚠️ <strong>Partially received recommended IV antibiotics</strong> (as per WHO AWaRe book): <strong>", scales::percent(part_p, accuracy = 0.1), "</strong> (", part_n, " out of ", total_n, ")</li>",
              "<li>❌ <strong>Received IV antibiotics not among recommended options</strong> (as per WHO AWaRe book): <strong>", scales::percent(none_p, accuracy = 0.1), "</strong> (", none_n, " out of ", total_n, ")</li>",
              "</ul>",
              "</div>"
            )
          }
        ))
      
      # Reorder for Hospital-Wide first
      formatted_blocks <- formatted_blocks %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>%
        select(-order)
      
      # Intro text matching R markdown
      intro_text <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💉 <strong>Denominator:</strong> Number of eligible patients who received any IV antibiotics for sepsis (<strong>", total_iv, "</strong> out of <strong>", total_eligible, "</strong>).",
        "</div><br><br>",
        "<strong>Summary:</strong><br><br>"
      )
      
      final_summary_html <- HTML(paste0(intro_text, paste(formatted_blocks$block, collapse = "\n")))
      return(final_summary_html)
    })
    
    # QI 2: Dosage Appropriateness Analysis
    qi2_data <- reactive({
      if (!check_data()) {
        return(NULL)
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      tryCatch({
        # Fix AWaRe column - convert NOT_RECOMMENDED to NOT RECOMMENDED 
        data_patients <- data_patients %>%
          mutate(
            AWaRe = ifelse(
              toupper(AWaRe) == "NOT_RECOMMENDED",
              "NOT RECOMMENDED",
              AWaRe
            )
          )
        
        data_sepsis2 <- data_patients %>%
          filter(`Diagnosis code` == "SEPSIS") %>%
          mutate(
            Route = toupper(Route),
            ATC5 = toupper(trimws(ATC5)),
            AWaRe_compatible = ifelse(
              `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
              TRUE, FALSE
            ),
            Weight = as.numeric(Weight)
          )
        
        # Lookup Drug & Dose Info for H_SEP_APPROP_DOSAGE
        lookup2 <- data_lookup %>% filter(Code == "H_SEP_APPROP_DOSAGE")
        
        if(nrow(lookup2) == 0) {
          return(NULL)
        }
        
        lookup_names2 <- unlist(lookup2[1, c("ABX-ATC-1", "ABX-ATC-2", "ABX-ATC-3", "ABX-ATC-4")], use.names = FALSE)
        lookup_names2 <- toupper(trimws(lookup_names2))
        
        # Compute Total Daily Dose
        data_sepsis2 <- data_sepsis2 %>%
          mutate(
            Unit_Factor = case_when(
              Unit == "mg" ~ 1,
              Unit == "g" ~ 1000,
              TRUE ~ NA_real_
            ),
            Total_Daily_Dose = as.numeric(`Single Unit Dose`) * as.numeric(`N Doses/day`) * Unit_Factor
          )
        
        # Match Drug + Dose + Route for ABX-ATC-1 to 4
        for (i in 1:4) {
          name_col <- paste0("ABX-ATC-", i)
          dose_col <- paste0("ABX-DOSE-", i)
          freq_col <- paste0("ABX-DAY-DOSE-", i)
          unit_col <- paste0("ABX-UNIT-", i)
          
          dose_match_col <- paste0("Match_Drug_Dose_", i)
          
          if(!all(c(name_col, dose_col, freq_col, unit_col) %in% names(lookup2))) {
            next
          }
          
          # Lookup values
          drug_lookup <- toupper(trimws(lookup2[[name_col]]))
          unit_value <- lookup2[[unit_col]]
          dose <- as.numeric(lookup2[[dose_col]])
          freq <- as.numeric(lookup2[[freq_col]])
          
          # Convert units to mg
          unit_factor <- case_when(
            unit_value == "mg" ~ 1,
            unit_value == "g" ~ 1000,
            unit_value == "mg/kg" ~ 1,
            TRUE ~ NA_real_
          )
          
          # Expected dose calculation
          expected_dose <- if (!is.na(unit_value) && unit_value == "mg/kg") {
            dose * freq * data_sepsis2$Weight * unit_factor
          } else {
            dose * freq * unit_factor
          }
          
          # Match logic with 10% tolerance for mg/kg, strict match for others
          data_sepsis2[[dose_match_col]] <- ifelse(
            data_sepsis2$ATC5 == drug_lookup &
              data_sepsis2$Route == "P" &
              (
                if (!is.na(unit_value) && unit_value == "mg/kg") {
                  abs(data_sepsis2$Total_Daily_Dose - expected_dose) / expected_dose <= 0.10
                } else {
                  abs(data_sepsis2$Total_Daily_Dose - expected_dose) < 1  # strict match for others
                }
              ),
            TRUE, FALSE
          )
        }
        
        # Summarise at Patient Level
        patient_summary <- data_sepsis2 %>%
          filter(AWaRe_compatible) %>%
          group_by(`Survey Number`, `Department name`) %>%
          summarise(
            Match_1_P = any(ATC5 == lookup_names2[1] & Route == "P"),
            Match_2_P = any(ATC5 == lookup_names2[2] & Route == "P"),
            Match_3_P = any(ATC5 == lookup_names2[3] & Route == "P"),
            Match_4_P = any(ATC5 == lookup_names2[4] & Route == "P"),
            
            Dose_1_OK = any(Match_Drug_Dose_1),
            Dose_2_OK = any(Match_Drug_Dose_2),
            Dose_3_OK = any(Match_Drug_Dose_3),
            Dose_4_OK = any(Match_Drug_Dose_4),
            
            Any_IV = any(Route == "P"),
            .groups = "drop"
          ) %>%
          mutate(
            Given_Primary   = Match_1_P | Match_2_P,
            Given_Secondary = Match_3_P | Match_4_P,
            Primary_OK      = Dose_1_OK | Dose_2_OK,
            Secondary_OK    = Dose_3_OK | Dose_4_OK,
            Any_Recommended_IV_Given = Given_Primary | Given_Secondary,
            
            Dose_Result = case_when(
              # Category 1: Full recommended regimen with recommended dosages
              Given_Primary & Given_Secondary & Primary_OK & Secondary_OK ~ 
                "Received recommended IV antibiotics with recommended dosage",
              
              # Category 2: At least one recommended IV antibiotic with only one having recommended dosage
              Any_Recommended_IV_Given & (Primary_OK | Secondary_OK) ~ 
                "Received at least one recommended IV antibiotic with only one has recommended dosage",
              
              # Category 3: At least one recommended IV antibiotic with none having recommended dosage
              Any_Recommended_IV_Given & !Primary_OK & !Secondary_OK ~ 
                "Received at least one recommended IV antibiotic with none have recommended dosage",
              
              # Category 4: No recommended IV antibiotics given at all
              Any_IV & !Any_Recommended_IV_Given ~ 
                "Received IV antibiotics not among recommended options",
              
              TRUE ~ NA_character_
            )
          ) %>%
          filter(!is.na(Dose_Result))
        
        if(nrow(patient_summary) == 0) {
          return(NULL)
        }
        
        # Create Summary Table by Department
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
        
        return(final_summary2)
      }, error = function(e) {
        return(NULL)
      })
    })
    
    # Dosage appropriateness plot (Updated to match R markdown with second code styling)
    output$dosage_appropriateness_plot <- renderPlotly({
      final_summary2 <- qi2_data()
      req(final_summary2, nrow(final_summary2) > 0)
      
      # Colors matching R markdown (keeping original logic)
      drug_dosage_colors <- c(
        "Received recommended IV antibiotics with recommended dosage" = "#084594",
        "Received at least one recommended IV antibiotic with only one has recommended dosage" = "#6BAED6",
        "Received at least one recommended IV antibiotic with none have recommended dosage" = "#FC9272",
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
      
      # --- Dynamic buffer (matching second code) ---
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # Create ggplot matching second code style but with original logic
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
      
      # --- Convert to plotly (matching second code layout) ---
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Antibiotic Choice & Dosage Alignment with AWaRe book Recommendations for Sepsis</b><br>"
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
    
    # Dosage appropriateness summary
    output$dosage_appropriateness_summary <- renderUI({
      final_summary2 <- qi2_data()
      
      if(is.null(final_summary2)) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
          ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for evaluating the appropriateness of IV antibiotic dosage for community-acquired sepsis.
          </div>"
        ))
      }
      
      # Exclude Hospital-Wide and non-recommended category for denominator calculation
      final_summary2_filtered <- final_summary2 %>%
        filter(`Department name` != "Hospital-Wide",
               Dose_Result != "Received IV antibiotics not among recommended options")
      
      # Calculate total eligible patients who received recommended (or partially recommended) antibiotics
      total_approp_iv_given <- final_summary2_filtered %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      if (total_approp_iv_given == 0 || is.na(total_approp_iv_given)) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
          ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for evaluating the appropriateness of IV antibiotic dosage for community-acquired sepsis. <br><br>
         <em>  This may indicate that no patients met the inclusion criteria, or no patients received recommended IV antibiotics during the reporting period. </em>
          </div>"
        ))
      }
      
      # Categories for analysis (excluding non-recommended)
      all_categories2 <- c(
        "Received recommended IV antibiotics with recommended dosage",
        "Received at least one recommended IV antibiotic with only one has recommended dosage",
        "Received at least one recommended IV antibiotic with none have recommended dosage"
      )
      
      # Get all unique departments and result categories
      dept_list <- unique(final_summary2$`Department name`)
      category_list <- all_categories2
      
      # Complete grid with zero-filled missing combos
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
      
      # Description function
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
      
      # Generate HTML summary blocks
      formatted_blocks2 <- complete_summary %>%
        group_by(`Department name`) %>%
        summarise(
          block = {
            dept <- first(`Department name`)
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            total_patients <- max(Total, na.rm = TRUE)
            
            list_items <- sapply(all_categories2, function(label) {
              row_data <- complete_summary %>%
                filter(`Department name` == dept, Dose_Result == label)
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
      total_eligible_all <- qi1_data() %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(!Indicator %in% c("Not eligible for AWaRe sepsis QIs")) %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      if(is.null(total_eligible_all)) total_eligible_all <- 0
      
      # Intro text matching R markdown
      intro_text2 <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💊 <strong>Denominator:</strong> Number of eligible sepsis patients who received recommended (or partially recommended) IV antibiotic choice based on WHO AWaRe book (<strong>", total_approp_iv_given, "</strong> out of ", total_eligible_all, ")",
        "</div><br><br>",
        "<strong>Summary:</strong><br><br>"
      )
      
      # Render full HTML output
      final_summary_html2 <- HTML(paste0(intro_text2, paste(formatted_blocks2$block, collapse = "\n")))
      return(final_summary_html2)
    })
  })
}