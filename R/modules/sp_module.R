# Surgical Prophylaxis Analysis Shiny Module - Corrected to match R Markdown
# This module contains all the SP-specific analysis functionality split into separate tabs

# Overview Tab UI
spOverviewUI <- function(id) {
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
               box(width = 12, title = "🎯 AWaRe Quality Indicators for surgical prophylaxis", status = "info", solidHeader = TRUE,
                   
                   h5("Within the gPPS data structure, the following antibiotic use quality indicators have been identified:"),
                   p("1) ","Proportion of patients given the appropriate IV surgical prophylaxis according to the WHO AWaRe book for any of the listed procedures: Bowel Surgery, Clean or Clean-Contaminated Procedure, Contaminated Procedure, Urologic Procedure."),
                   p("2) "," Proportion of patients given the prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book for any of the listed procedures: Bowel Surgery, Clean or Clean-Contaminated Procedure, Contaminated Procedure, Urologic Procedure.")
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
spEligibilityUI <- function(id) {
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
spPatientSummaryUI <- function(id) {
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
               box(width = 12, title = "🧾 Eligiblilty Criteria", status = "primary", solidHeader = TRUE,
                   p("Eligible patients for WHO AWaRe Quality Indicator (QI) assessment are defined as adult inpatients (≥18 years) who received empirical antibiotics as surgical prophylaxis.")
               )
        )
      )
    )
  )
}

# QI Guidelines Tab UI
spQIGuidelinesUI <- function(id) {
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
                       strong("This script evaluates ONE indicator:"), br(), br(),
                       strong("1. H_SP_APPROP_ABX:"), " Proportion of patients given the appropriate IV surgical prophylaxis according to the WHO AWaRe book for any of the listed procedures: Bowel Surgery, Clean or Clean-Contaminated Procedure, Contaminated Procedure, Urologic Procedure."
                   ),
                   
                   div(class = "note-box",
                       strong("🔍 WHO AWaRe book Recommendation:"), br(), br(),
                       tags$ul(style = "list-style-type: none; padding-left: 0; line-height: 1.8;",
                               tags$li(strong("Bowel Surgery:"), " Cefazolin (2 g single dose IV) + Metronidazole (500 mg single dose IV) OR Amoxicillin+clavulanic acid (2 g+200 mg single dose IV)"),
                               tags$li(strong("Clean or Clean-Contaminated Procedure:"), " Cefazolin (2 g single dose IV) OR Cefuroxime (1.5 g single dose IV)"),
                               tags$li(strong("Urologic Procedure:"), " Cefazolin (2 g single dose IV) OR Gentamicin (5 mg/kg single dose IV)"),
                               tags$li(strong("Contaminated Procedure:"), " Cefazolin (2 g single dose IV) + Metronidazole (500 mg single dose IV) OR Amoxicillin+clavulanic acid (2 g+200 mg single dose IV) OR Gentamicin (5 mg/kg single dose IV) + Metronidazole (500 mg single dose IV)")
                       )
                   ),
                   
                   div(class = "warning-box",
                       strong("🩺 WHO AWaRe Notes:"), br(),
                       tags$ul(
                         tags$li("Bowel surgery includes appendectomy, small intestine and colorectal surgical procedures"),
                         tags$li("Timing: 120 minutes or less before starting surgery"),
                         tags$li("If cloxacillin is unavailable, any other IV antistaphylococcal penicillin could be used."),
                         tags$li("A higher dose (e.g. 12 g/day) could be considered given the concerns with bone penetration."),
                         tags$li("Consider an additional dose only for prolonged procedures or if major blood loss"),
                         tags$li("Gentamicin should be given in combination with metronidazole because, if given alone, it provides insufficient coverage of anaerobic bacteria"),
                         tags$li("Antibiotic prophylaxis prior to dental surgeries is not addressed")
                       )
                   )
               )
        )
      )
    )
  )
}

# Choice Analysis Tab UI - Complete Version with White Backgrounds
spChoiceAnalysisUI <- function(id) {
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
                 title = "📌 Antibiotic Choice Alignment with AWaRe book Recommendations for surgical prophylaxis",
                 status = "primary", 
                 solidHeader = TRUE,
                 p("Proportion of patients given the appropriate IV surgical prophylaxis according to the WHO AWaRe book for any of the listed procedures: Bowel Surgery, Clean or Clean-Contaminated Procedure, Contaminated Procedure, Urologic Procedure")
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
                   tags$li(
                     strong("Bowel Surgery:"), 
                     " Cefazolin (2 g single dose IV) + Metronidazole (500 mg single dose IV) ", 
                     em("OR"), 
                     " Amoxicillin+clavulanic acid (2 g+200 mg single dose IV)"
                   ),
                   tags$li(
                     strong("Clean or Clean-Contaminated Procedure:"), 
                     " Cefazolin (2 g single dose IV) ", 
                     em("OR"), 
                     " Cefuroxime (1.5 g single dose IV)"
                   ),
                   tags$li(
                     strong("Urologic Procedure:"), 
                     " Cefazolin (2 g single dose IV) ", 
                     em("OR"), 
                     " Gentamicin (5 mg/kg single dose IV)"
                   ),
                   tags$li(
                     strong("Contaminated Procedure:"), 
                     " Cefazolin (2 g single dose IV) + Metronidazole (500 mg single dose IV) ", 
                     em("OR"), 
                     " Amoxicillin+clavulanic acid (2 g+200 mg single dose IV) ", 
                     em("OR"), 
                     " Gentamicin (5 mg/kg single dose IV) + Metronidazole (500 mg single dose IV)"
                   )
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
                   " Antibiotic Choice Alignment with AWaRe book Recommendations for surgical prophylaxis"
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
                       p("This visual summarises the proportion of surgical prophylaxis antibiotic alignment across hospital departments based on WHO AWaRe book"),
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
                       p("This visual summarises the proportion of surgical prophylaxis antibiotic alignment across hospital departments by WHO AWaRe Classification (Access, Watch, Reserve)"),
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
                   ),
                   
                   # Tab 3: Treatment Line
                   tabPanel(
                     tagList(icon("stethoscope"), " Treatment Line"),
                     div(
                       style = "background-color: white; padding: 15px;",
                       br(),
                       p("This visual summarises the proportion of surgical prophylaxis antibiotic choice appropriateness across hospital departments by line of treatment (First choice, Second choice)"),
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
                       ),
                       br(),
                       div(
                         class = "note-box",
                         style = "background-color: white; padding: 10px; border-radius: 5px; border-left: 4px solid #3498db;",
                         strong("💡 Note:"), 
                         " Patients who received metronidazole alone were not included in this analysis, as it serves as adjunct therapy for anaerobic coverage and does not independently define the prophylaxis choice for surgical prophylaxis according to the WHO AWaRe book."
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
                 title = "📊 Summary of Antibiotic Choice Alignment with AWaRe book Recommendations for surgical prophylaxis", 
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

# Dosage Analysis Tab UI
spDosageAnalysisUI <- function(id) {
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
               box(width = 12, title = "📌 Antibiotic Dosage Alignment with AWaRe book Recommendations for surgical prophylaxis", status = "primary", solidHeader = TRUE,
                   p("Proportion of patients given the prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book for any of the listed procedures: Bowel Surgery, Clean or Clean-Contaminated Procedure, Contaminated Procedure, Urologic Procedure.")
               )
        )
      ),
      
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🔍 WHO AWaRe book Recommendation:", status = "primary", solidHeader = TRUE,
                   "▸ ",strong("Bowel Surgery:"), "Cefazolin (2 g single dose IV) + Metronidazole (500 mg single dose IV)" , em("OR"), "Amoxicillin+clavulanic acid (2 g+200 mg single dose IV)", br(),
                   "▸ ",strong("Clean or Clean-Contaminated Procedure:"), " Cefazolin (2 g single dose IV)" , em("OR"), "Cefuroxime (1.5 g single dose IV)", br(),
                   "▸ ",strong("Urologic Procedure:"), " Cefazolin (2 g single dose IV) " , em("OR"), "  Gentamicin (5 mg/kg single dose IV)", br(),
                   "▸ ",strong("Contaminated Procedure:"), "Cefazolin (2 g single dose IV) + Metronidazole (500 mg single dose IV) " , em("OR"), " Amoxicillin+clavulanic acid (2 g+200 mg single dose IV) OR Gentamicin (5 mg/kg single dose IV) + Metronidazole (500 mg single dose IV)", br()
                   
               )
        )
      ),
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📈 Antibiotic Dosage Alignment with AWaRe book Recommendations for surgical prophylaxis",
            status = "primary", solidHeader = TRUE, 
            p("This visual summarises surgical prophylaxis dosage alignment across hospital departments based on WHO AWaRe book"),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("dosage_plot"), height = "450px", width = "100%"),
                  type = 4)
                
            )
          )
        )
      ),
      
      
      column(10, offset = 1,
             div(class = "info-box",
                 strong("💡 Note:"),
                 tags$ul(
                   tags$li("Received recommended IV antibiotics with recommended dosage indicates that the full recommended prophylaxis regimen (whether monotherapy or dual therapy) was given, with all dosages aligned with WHO AWaRe book guidance."),
                   tags$li("Received at least one recommended IV antibiotic with one has recommended dosage refers to cases where only part of the recommended dual therapy was given, and only one antibiotic was at the recommended dosage."),
                   tags$li("Received at least one recommended IV antibiotic with none have recommended dosage includes cases who received either the full recommended regimen with no recommended dosages, or only part of it (e.g., one agent from a dual therapy) with none of the dosages aligned with WHO AWaRe book guidance.")
                 )
             )
      ),
      
      
      
      # Dosage Summary Box at the bottom
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📊  Summary of Antibiotic Dosage Alignment with AWaRe book Recommendations for surgical prophylaxis", status = "success", solidHeader = TRUE,collapsible = TRUE,collapsed = TRUE,
                   htmlOutput(ns("dosage_summary"))
               )
        )
      )
    )
  )
}

# Module Server - Handles all SP tabs
spAnalysisServer <- function(id, data_reactive) {
  moduleServer(id, function(input, output, session) {
    
    # Constants
    AWaRe_abx <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
    surgical_indications <- c("SP1", "SP2", "SP3")
    
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
    
    # Helper function to get SP data - CORRECTED TO MATCH R MARKDOWN
    get_sp_data <- reactive({
      if (!check_data()) return(NULL)
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # CORRECTED: Apply standardization that matches R Markdown exactly
      data_patients <- data_patients %>%
        mutate(
          `Diagnosis code` = ifelse(
            Indication %in% c("SP1", "SP2", "SP3"),
            "Proph",
            `Diagnosis code`
          )
        )
      
      # Replace empty strings with NA
      data_patients[data_patients == ""] <- NA
      
      # CORRECTED: Fix AWaRe standardization to match R Markdown
      data_patients <- data_patients %>%
        mutate(
          AWaRe = ifelse(
            toupper(AWaRe) == "NOT_RECOMMENDED",
            "NOT RECOMMENDED",
            AWaRe
          )
        )
      
      # Flag eligible patients for Adults on Empirical prophylaxis for surgery
      data_SP <- data_patients %>%
        filter(`Diagnosis code` == "Proph" & Indication %in% surgical_indications) %>%
        mutate(
          Route = toupper(Route),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      return(data_SP)
    })
    
    # Eligibility feedback functions
    generate_eligibility_feedback <- function() {
      tryCatch({
        if (!check_data()) {
          return(HTML("<div style='background-color: #fff3cd; border: 1px solid #ffeeba; padding: 15px; border-radius: 5px;'><p><strong>⚠️ No data available</strong></p><p>Please upload your data files to check eligible cases.</p></div>"))
        }
        
        data <- data_reactive()
        data_info <- data$data_info
        
        data_SP <- get_sp_data()
        if (is.null(data_SP)) return(HTML("<div>Error processing SP data</div>"))
        
        # Count eligible unique patients
        eligible_SP_n <- data_SP %>%
          filter(AWaRe_compatible) %>%
          distinct(`Survey Number`) %>%
          nrow()
        
        # Format survey dates safely - CORRECTED TO MATCH R MARKDOWN
        survey_start <- if(!is.null(data_info) && nrow(data_info) >= 3 && !is.null(data_info[[2]][3])) {
          format(as.Date(data_info[[2]][3]), "%d %b %Y")
        } else {
          "Not available"
        }
        
        survey_end <- if(!is.null(data_info) && nrow(data_info) >= 3 && !is.null(data_info[[4]][3])) {
          format(as.Date(data_info[[4]][3]), "%d %b %Y")
        } else {
          "Not available"
        }
        
        # Build status message
        status_message <- if(eligible_SP_n == 0) {
          "<div style='background-color:#fff3cd; border: 1px solid #ffeeba; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>🚫 No eligible cases found:</strong> There were no eligible cases for evaluation during this survey period. Please verify data availability.
          </div>"
        } else if(eligible_SP_n < 10) {
          "<div style='background-color:#ffe0e0; border: 1px solid #ffb3b3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>⚠️ Caution:</strong> Few eligible cases detected. Interpret results with caution.
          </div>"
        } else {
          "<div style='background-color:#e0ffe0; border: 1px solid #b3ffb3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>✅ Good to go!</strong> Sufficient eligible cases available to proceed with full evaluation.
          </div>"
        }
        
        # Build HTML feedback - CORRECTED TO MATCH R MARKDOWN FORMAT
        html_feedback <- HTML(paste0(
          "<div style='background-color: #f0f8ff; border: 1px solid #add8e6; padding: 15px; border-radius: 5px; font-family: sans-serif;'>",
          "<p style='margin-bottom: 10px;'>",
          "This script applies <strong>WHO AWaRe Quality Indicators</strong> to adult inpatients who received ",
          "empirical antibiotics for surgical prophylaxis (SP).",
          "</p>",
          "<ul>",
          "<li><strong>Diagnostic code:</strong> Proph</li>",
          "<li><strong>Indication(s):</strong> SP1, SP2, SP3</li>",
          "<li><strong>Total eligible cases:</strong> ", eligible_SP_n, "</li>",
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
    
    # Summary Insights Cards - CORRECTED TO MATCH R MARKDOWN LOGIC
    output$summary_insights_cards <- renderUI({
      if (!check_data()) {
        return(HTML("<p>No data available for insights</p>"))
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # CORRECTED: Apply same data transformation as R Markdown
      data_patients <- data_patients %>%
        mutate(
          `Diagnosis code` = ifelse(
            Indication %in% c("SP1", "SP2", "SP3"),
            "Proph",
            `Diagnosis code`
          ),
          AWaRe = ifelse(
            toupper(AWaRe) == "NOT_RECOMMENDED",
            "NOT RECOMMENDED",
            AWaRe
          )
        )
      
      # Replace empty strings with NA
      data_patients[data_patients == ""] <- NA
      
      # CORRECTED: Use distinct() on Survey Number to match R Markdown
      total_patients <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "Proph") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      eligible_patients <- data_patients %>%
        filter(`Age years` >= 18, Indication %in% surgical_indications, AWaRe %in% AWaRe_abx, 
               Treatment == "EMPIRICAL", `Diagnosis code` == "Proph") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      # CORRECTED: Use nrow() instead of distinct() for prescriptions to match R Markdown  
      total_prescriptions <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "Proph") %>%
        nrow()
      
      eligible_prescriptions <- data_patients %>%
        filter(`Age years` >= 18, Indication %in% surgical_indications, AWaRe %in% AWaRe_abx, 
               Treatment == "EMPIRICAL", `Diagnosis code` == "Proph") %>%
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
        "</strong> patients on antibiotics for surgical prophylaxis were QI-eligible patients.",
        "</p>",
        "</div>",
        
        # Card 2: Prescriptions
        "<div style='flex: 1; min-width: 300px; background-color: ", prescription_color, 
        "; border-left: 6px solid #17a2b8; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>",
        "<h4 style='margin-top: 0; color: #0c5460;'>📑 Proportion of Eligible Prescriptions</h4>",
        "<div style='font-size: 2.5em; font-weight: bold; color: #0c5460; margin: 10px 0;'>", prescription_percentage, "%</div>",
        "<p style='margin-bottom: 0; color: #0c5460;'>",
        "<strong>", eligible_prescriptions, "</strong> out of <strong>", total_prescriptions, 
        "</strong> antibiotic prescriptions for surgical prophylaxis were given to QI-eligible patients.",
        "</p>",
        "</div>",
        
        "</div>"
      ))
      
      return(insight_cards)
      
    })
    
    # Patient Level Table - CORRECTED TO MATCH R MARKDOWN
    output$patient_level_table <- DT::renderDataTable({
      if (!check_data()) {
        return(DT::datatable(data.frame(Message = "No data available"), options = list(dom = 't'), rownames = FALSE))
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # Apply same transformations as R Markdown
      data_patients <- data_patients %>%
        mutate(
          `Diagnosis code` = ifelse(
            Indication %in% c("SP1", "SP2", "SP3"),
            "Proph",
            `Diagnosis code`
          ),
          AWaRe = ifelse(
            toupper(AWaRe) == "NOT_RECOMMENDED",
            "NOT RECOMMENDED",
            AWaRe
          )
        )
      
      # Replace empty strings with NA
      data_patients[data_patients == ""] <- NA
      
      # CORRECTED: Match R Markdown calculations exactly
      total_patients <- data_patients %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      n_all_SP_patients <- data_patients %>%
        filter(`Diagnosis code` == "Proph", Indication %in% c("SP1", "SP2", "SP3"), AWaRe %in% AWaRe_abx) %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      n_adult_SP_empirical_patients <- data_patients %>%
        filter(`Age years` >= 18, `Diagnosis code` == "Proph", Indication %in% surgical_indications, Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      patient_summary <- data.frame(
        Category = c(
          "Number of all patients with any surgical prophylaxis (SP1–SP3)",
          "Number of adult patients (≥18 years) who received empirical surgical prophylaxis"
        ),
        Count = c(
          n_all_SP_patients,
          n_adult_SP_empirical_patients
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
    
    # Prescription Level Table - CORRECTED TO MATCH R MARKDOWN 
    output$prescription_level_table <- DT::renderDataTable({
      if (!check_data()) {
        return(DT::datatable(data.frame(Message = "No data available"), options = list(dom = 't'), rownames = FALSE))
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # Apply same transformations as R Markdown
      data_patients <- data_patients %>%
        mutate(
          `Diagnosis code` = ifelse(
            Indication %in% c("SP1", "SP2", "SP3"),
            "Proph",
            `Diagnosis code`
          ),
          AWaRe = ifelse(
            toupper(AWaRe) == "NOT_RECOMMENDED",
            "NOT RECOMMENDED",
            AWaRe
          )
        )
      
      # Replace empty strings with NA
      data_patients[data_patients == ""] <- NA
      
      # CORRECTED: Match R Markdown calculations exactly
      n_total_prescriptions <- nrow(data_patients)
      
      n_all_SP_prescriptions <- data_patients %>%
        filter(`Diagnosis code` == "Proph", Indication %in% c("SP1", "SP2", "SP3"), AWaRe %in% AWaRe_abx) %>%
        nrow()
      
      n_adult_SP_empirical_prescriptions <- data_patients %>%
        filter(`Age years` >= 18, `Diagnosis code` == "Proph", Indication %in% surgical_indications, Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>%
        nrow()
      
      prescription_summary <- data.frame(
        Category = c(
          "Number of all antibiotic prescriptions for surgical prophylaxis (SP1–SP3)",
          "Number of empirical surgical prophylaxis prescriptions administered to adult patients (≥18 years)"
        ),
        Count = c(
          n_all_SP_prescriptions,
          n_adult_SP_empirical_prescriptions
        )
      ) %>%
        mutate(
          Percent = sprintf("%.1f%%", 100 * Count / n_total_prescriptions)
        )
      
      DT::datatable(
        prescription_summary,
        colnames = c("Prescription Category", "Number of Prescriptions", "Proportion of All Prescriptions"),
        options = list(pageLength = 10, dom = 't'),
        rownames = FALSE
      )
    })
    
    # Choice Analysis Data - CORRECTED TO MATCH R MARKDOWN EXACTLY
    choice_data_reactive <- reactive({
      if (!check_data()) return(list())
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      # Apply same standardizations as R Markdown
      data_patients <- data_patients %>%
        mutate(
          `Diagnosis code` = ifelse(
            Indication %in% c("SP1", "SP2", "SP3"),
            "Proph",
            `Diagnosis code`
          ),
          AWaRe = ifelse(
            toupper(AWaRe) == "NOT_RECOMMENDED",
            "NOT RECOMMENDED",
            AWaRe
          )
        )
      
      # Replace empty strings with NA
      data_patients[data_patients == ""] <- NA
      
      # CORRECTED: Match R Markdown SP data preparation exactly
      data_SP <- data_patients %>%
        filter(Indication %in% surgical_indications) %>%
        mutate(
          Route = toupper(Route),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      # Lookup ABX names for SP QI
      lookup_names <- data_lookup %>%
        filter(Code == "H_SP_APPROP_ABX") %>%
        select(starts_with("ABX-ATC")) %>%
        unlist(use.names = FALSE)
      
      # Flag matched prescriptions
      data_SP <- data_SP %>%
        mutate(
          Drug_Match = ATC5 %in% lookup_names
        )
      
      # Extract lookup info 
      lookup_SP_choice <- data_lookup %>%
        filter(Code == "H_SP_APPROP_ABX")
      
      # Create long format from lookup
      lookup_long <- tibble(
        Drug = unlist(lookup_SP_choice %>% select(starts_with("ABX-ATC")), use.names = FALSE),
        Choice = unlist(lookup_SP_choice %>% select(starts_with("ABX-CHOICE")), use.names = FALSE)
      ) %>%
        filter(!is.na(Drug))
      
      # Merge choice info with patient-level data
      data_SP <- data_SP %>%
        left_join(lookup_long, by = c("ATC5" = "Drug"))
      
      # CORRECTED: Match R Markdown patient summary logic exactly
      patient_summary_SP <- data_SP %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>% 
        summarise(
          
          Abx_names = list(unique(ATC5[Route == "P"])),
          
          # Match flags
          Match_1 = any(ATC5 == lookup_names[1]),
          Match_2 = any(ATC5 == lookup_names[2]),
          Match_3 = any(ATC5 == lookup_names[3]),
          Match_4 = any(ATC5 == lookup_names[4]),
          Match_5 = any(ATC5 == lookup_names[5]),
          Match_6 = any(ATC5 == lookup_names[6]),
          Match_7 = any(ATC5 == lookup_names[7]),
          Match_8 = any(ATC5 == lookup_names[8]),
          Match_9 = any(ATC5 == lookup_names[9]),
          
          # Route-specific match flags
          Match_1_P = any(ATC5 == lookup_names[1] & Route == "P"),
          Match_2_P = any(ATC5 == lookup_names[2] & Route == "P"),
          Match_3_P = any(ATC5 == lookup_names[3] & Route == "P"),
          Match_4_P = any(ATC5 == lookup_names[4] & Route == "P"),
          Match_5_P = any(ATC5 == lookup_names[5] & Route == "P"),
          Match_6_P = any(ATC5 == lookup_names[6] & Route == "P"),
          Match_7_P = any(ATC5 == lookup_names[7] & Route == "P"),
          Match_8_P = any(ATC5 == lookup_names[8] & Route == "P"),
          Match_9_P = any(ATC5 == lookup_names[9] & Route == "P"),
          
          Any_Oral = any(Route == "O"),
          Any_IV = any(Route == "P"),
          N_ABX = n_distinct(ATC5),
          .groups = "drop"
        ) %>%
        rowwise() %>%
        mutate(
          Num_recommended_given = sum(c_across(any_of(c("Match_1_P", "Match_2_P", "Match_3_P", "Match_5_P", "Match_9_P")))),
          All_IV_names_flat = paste0(unlist(Abx_names), collapse = ","),
          
          # Full match = recommended pair given and no extra IV abx
          Received_full_recommended_IV = (
            (
              # Monotherapy cases
              (Match_1_P & Num_recommended_given == 1 & N_ABX == 1) |
                (Match_3_P & Num_recommended_given == 1 & N_ABX == 1) |
                (Match_5_P & Num_recommended_given == 1 & N_ABX == 1)
            ) |
              (
                # Dual therapy cases
                ((Match_1_P & Match_2_P) |
                   (Match_2_P & Match_9_P)) &
                  Num_recommended_given == 2 & N_ABX == 2
              )
          ),
          
          # No match at all with recommended options
          Received_no_recommended_IV = Any_IV & Num_recommended_given == 0,
          
          # Partial = recommended abx used, but not in full combo or with extra abx
          Received_partial_recommended_IV = Any_IV & !Received_full_recommended_IV & !Received_no_recommended_IV,
          
          # flag patients who only got non-matching routes
          Other_non_IV = !Received_full_recommended_IV & !Received_partial_recommended_IV & 
            !Received_no_recommended_IV
        ) %>%
        ungroup()
      
      return(list(
        data_SP = data_SP,
        patient_summary_SP = patient_summary_SP,
        lookup_names = lookup_names
      ))
    })
    
    # Choice Summary - UPDATED TO MATCH DOSAGE_SUMMARY STRUCTURE
    output$choice_summary <- renderUI({
      choice_data <- choice_data_reactive()
      if(length(choice_data) == 0) {
        return(HTML("<p>No data available</p>"))
      }
      
      patient_summary_SP <- choice_data$patient_summary_SP
      
      # Calculate summary statistics
      total_eligible <- nrow(patient_summary_SP)
      
      total_iv <- patient_summary_SP %>%
        filter(Any_IV) %>%
        nrow()
      
      if (total_iv == 0 || is.na(total_iv)) {
        return(HTML(
          "<div class='warning-box'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients with valid IV antibiotic data for <strong>surgical prophylaxis assessment</strong>.<br><br>
      <em>This may indicate that no patients received IV antibiotics in recommended categories, or none met inclusion criteria.</em>
      </div>"
        ))
      }
      
      # Create summary by department for each category
      choice_categories <- c(
        "Received_full_recommended_IV",
        "Received_partial_recommended_IV", 
        "Received_no_recommended_IV"
      )
      
      # Create department summary (excluding Hospital-Wide for now)
      dept_summary <- patient_summary_SP %>%
        filter(Any_IV) %>%
        select(`Survey Number`, `Department name`, all_of(choice_categories)) %>%
        pivot_longer(
          cols = all_of(choice_categories),
          names_to = "Category",
          values_to = "Value"
        ) %>%
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(`Department name`, Category) %>%
        summarise(Patients = n(), .groups = "drop") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Add Hospital-Wide summary
      hospital_summary <- patient_summary_SP %>%
        filter(Any_IV) %>%
        select(`Survey Number`, all_of(choice_categories)) %>%
        pivot_longer(
          cols = all_of(choice_categories),
          names_to = "Category", 
          values_to = "Value"
        ) %>%
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(Category) %>%
        summarise(Patients = n(), .groups = "drop") %>%
        mutate(
          `Department name` = "Hospital-Wide",
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        select(`Department name`, Category, Patients, Total, Proportion)
      
      # Combine summaries
      final_summary <- bind_rows(dept_summary, hospital_summary)
      
      # Intro text card
      intro_text <- HTML(paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💊 <strong>Denominator:</strong> Number of eligible surgical prophylaxis patients who received any IV antibiotic ",
        "(<strong>", total_iv, "</strong> out of <strong>", total_eligible, "</strong>)",
        "</div>",
        
        "<strong>Summary:</strong><br><br>"
      ))
      
      # Icon and label function
      get_choice_info <- function(category) {
        switch(category,
               "Received_full_recommended_IV" = list(
                 icon = "✅",
                 label = "Received recommended IV antibiotics"
               ),
               "Received_partial_recommended_IV" = list(
                 icon = "⚠️", 
                 label = "Partially received recommended IV antibiotics"
               ),
               "Received_no_recommended_IV" = list(
                 icon = "❌",
                 label = "Received IV antibiotics not among recommended options"
               ),
               list(icon = "🛈", label = category)
        )
      }
      
      # Generate HTML blocks for each department
      dept_blocks <- final_summary %>%
        group_by(`Department name`) %>%
        summarise(
          block = {
            dept <- first(`Department name`)
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            total_patients <- first(Total)
            
            # Create list items for each category
            list_items <- choice_categories %>%
              map_chr(function(category) {
                row_data <- final_summary %>%
                  filter(`Department name` == dept, Category == category)
                
                count <- if(nrow(row_data) > 0) row_data$Patients else 0
                prop <- if(nrow(row_data) > 0) row_data$Proportion else 0
                
                choice_info <- get_choice_info(category)
                
                paste0(
                  "<li>", choice_info$icon, " <strong>", choice_info$label, "</strong> (as per WHO AWaRe book): ",
                  "<strong>", scales::percent(prop, accuracy = 0.1), "</strong> ",
                  "(", count, " out of ", total_patients, ")",
                  "</li>"
                )
              }) %>%
              paste(collapse = "")
            
            paste0(
              "<div style='background-color: ", bg, "; border-left: 5px solid ", color, "; padding: 14px; margin-bottom: 20px;'>",
              "<strong>🏥 ", dept, "</strong> <span style='color: #888;'>(n = ", total_patients, " patients)</span><br><br>",
              "<ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>",
              list_items,
              "</ul>",
              "</div>"
            )
          },
          .groups = "drop"
        ) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`)
      
      # Combine all parts
      final_html <- HTML(paste0(
        intro_text,
        paste(dept_blocks$block, collapse = "")
      ))
      
      return(final_html)
    })
    
    # Choice appropriateness plot - CORRECTED TO MATCH R MARKDOWN
    output$choice_plot <- renderPlotly({
      choice_data <- choice_data_reactive()
      if(length(choice_data) == 0) {
        return(plotly_empty())
      }
      
      patient_summary_SP <- choice_data$patient_summary_SP
      data_SP <- choice_data$data_SP
      
      # Get not eligible patients with department info
      not_eligible_patients_SP <- data_SP %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary table with Department name
      eligible_long_SP <- patient_summary_SP %>%
        select(`Survey Number`, `Department name`, Received_full_recommended_IV, Received_partial_recommended_IV, 
               Received_no_recommended_IV, Other_non_IV) %>%
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
        `Department name` = unique(patient_summary_SP$`Department name`),
        Indicator = c("Received_full_recommended_IV", "Received_partial_recommended_IV", 
                      "Received_no_recommended_IV", "Other_non_IV", "Not_Eligible")
      )
      
      # Left join and replace NAs with 0
      eligible_long_SP <- all_combos %>%
        left_join(eligible_long_SP, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      # Add not eligible
      ineligible_summary_SP <- not_eligible_patients_SP %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      # Combine
      qi_long_SP <- bind_rows(eligible_long_SP, ineligible_summary_SP)
      
      # Calculate total per department
      dept_totals <- qi_long_SP %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      # Final summary table with proportions
      qi_summary_SP <- qi_long_SP %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Other_non_IV" ~ "Received other non-IV antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe SP QIs",
            TRUE ~ Indicator
          ),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        select(`Department name`, Indicator, Patients, Total, Proportion)
      
      # Add Hospital Total row
      hospital_data <- qi_summary_SP %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        select(`Department name`, Indicator, Patients)
      
      # Combine with original data
      qi_summary_SP <- bind_rows(qi_summary_SP, hospital_data)
      
      # Recalculate totals and proportions
      qi_summary_SP <- qi_summary_SP %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Desired order of factor levels
      all_levels <- c(
        "Received recommended IV antibiotics", 
        "Partially received recommended IV antibiotics", 
        "Received IV antibiotics not among recommended options",
        "Received other non-IV antibiotics",
        "Not eligible for AWaRe SP QIs"
      )
      
      # Build all combinations of department × indicator
      all_departments <- unique(qi_summary_SP$`Department name`)
      
      full_data <- expand.grid(
        `Department name` = all_departments,
        Indicator = all_levels,
        stringsAsFactors = FALSE
      )
      
      # Fill missing combinations with 0
      qi_summary_SP_filled <- full_data %>%
        left_join(qi_summary_SP, by = c("Department name", "Indicator")) %>%
        mutate(
          Proportion = ifelse(is.na(Proportion), 0, Proportion),
          Patients = ifelse(is.na(Patients), 0, Patients),
          Total = ifelse(is.na(Total), 0, Total),
          Indicator = factor(Indicator, levels = all_levels),
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>",
                             `Department name`)
        )
      
      # Recalculate total after filling combinations
      qi_summary_SP_filled <- qi_summary_SP_filled %>%
        group_by(`Department name`) %>%
        mutate(Total = sum(Patients)) %>%
        ungroup()
      
      # X-axis department order
      label_order <- c("<b style='color:#0072B2;'>Hospital-Wide</b>",
                       sort(setdiff(unique(qi_summary_SP_filled$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>")))
      qi_summary_SP_filled$PlotLabel <- factor(qi_summary_SP_filled$PlotLabel, levels = label_order)
      
      # Color codes
      palette <- c(
        "Received recommended IV antibiotics"      = "#1F77B4",
        "Partially received recommended IV antibiotics" = "#4FA9DC",
        "Received IV antibiotics not among recommended options"    = "#EF476F",
        "Received other non-IV antibiotics"        = "#D3D3D3",
        "Not eligible for AWaRe SP QIs"             = "#A9A9A9"
      )
      
      # Create ggplot
      p <- ggplot(
        qi_summary_SP_filled,
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
          data = qi_summary_SP_filled %>% distinct(PlotLabel, Total),
          aes(x = PlotLabel, y = 1.02, label = paste0("n=", Total)),
          inherit.aes = FALSE, size = 3, color = "gray30", hjust = 0.5
        ) +
        scale_fill_manual(values = palette, drop = FALSE) +
        scale_y_continuous(limits = c(0, 1.08), expand = c(0, 0),
                           labels = scales::percent_format(accuracy = 1)) +
        scale_x_discrete(expand = c(0.01, 0.01)) +
        labs(
          title = NULL,
          subtitle = NULL,
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
      
      # Convert to plotly
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Antibiotic Choice alignment Summary for surgical prophylaxis</b><br>"
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
    
    # AWaRe classification plot - CORRECTED TO MATCH R MARKDOWN
    output$aware_plot <- plotly::renderPlotly({
      choice_data <- choice_data_reactive()
      if(length(choice_data) == 0) {
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
      
      data_SP <- choice_data$data_SP
      
      # CORRECTED: Fix typo in Amoxicillin name to match R Markdown
      data_SP_AWaRe <- data_SP %>%
        mutate(
          AWaRe2 = case_when(
            ATC5 %in% c("J01DB04", "J01XD01", "J01CR02", "J01GB03") ~ "ACCESS", 
            ATC5 %in% c("J01DC02") ~ "WATCH", 
            TRUE ~ NA_character_
          )
        )
      
      # Identify primary and secondary antibiotics
      data_SP_AWaRe <- data_SP_AWaRe %>%
        filter(AWaRe_compatible, Route == "P", !is.na(AWaRe2))
      
      # Filter only valid cases
      aware_expanded <- data_SP_AWaRe %>%
        select(`Survey Number`, `Department name`, AWaRe2) %>%
        distinct()
      
      # Summarise by department and AWaRe2
      AWaRe_long <- aware_expanded %>%
        group_by(`Department name`, AWaRe2) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Add totals and proportions per department
      AWaRe_dept_totals <- AWaRe_long %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      AWaRe_long <- AWaRe_long %>%
        left_join(AWaRe_dept_totals, by = "Department name") %>%
        mutate(Proportion = round(Patients / Total, 3))
      
      # Add Hospital-Wide totals
      AWaRe_hospital_data <- aware_expanded %>%
        group_by(AWaRe2) %>%
        summarise(Patients = n(), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      AWaRe_long <- bind_rows(AWaRe_long, AWaRe_hospital_data)
      
      # Recalculate totals and proportions with Hospital-Wide
      AWaRe_long <- AWaRe_long %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Filter out departments with no data
      AWaRe_long <- AWaRe_long %>% dplyr::filter(Total > 0)
      if (nrow(AWaRe_long) == 0) {
        return(plotly_empty() %>%
                 layout(title = list(text = "No data available for AWaRe classification analysis",
                                     font = list(size = 12))))
      }
      
      # Ensure AWaRe2 factor has full levels
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
      
      # --- Dynamic buffer ---
      max_digits <- max(nchar(as.character(label_data$dept_total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # --- ggplot ---
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
      
      # --- Convert to plotly ---
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Use of Recommended IV Antibiotics by AWaRe Classification for surgical prophylaxis</b><br>"
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
    
    # Choice line plot - CORRECTED TO MATCH TREATMENT PLOT STRUCTURE
    output$choice_line_plot <- plotly::renderPlotly({
      choice_data <- choice_data_reactive()
      if(length(choice_data) == 0) {
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
      
      data_SP <- choice_data$data_SP
      
      # Classify antibiotics into choice groups
      data_SP_choice <- data_SP %>%
        mutate(
          choice2 = case_when(
            ATC5 %in% c("J01DB04") ~ "First choice", 
            ATC5 %in% c("J01CR02","J01DC02", "J01GB03") ~ "Second choice", 
            TRUE ~ NA_character_
          )
        )
      
      # Identify primary and secondary choice antibiotics
      data_SP_choice <- data_SP_choice %>%
        filter(AWaRe_compatible, Route == "P", !is.na(choice2))
      
      # Filter only valid cases
      choice_expanded <- data_SP_choice %>%
        select(`Survey Number`, `Department name`, choice2) %>%
        distinct()
      
      # Summarise by department and choice2
      choice_long <- choice_expanded %>%
        group_by(`Department name`, choice2) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Add totals and proportions per department
      choice_dept_totals <- choice_long %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      choice_long <- choice_long %>%
        left_join(choice_dept_totals, by = "Department name") %>%
        mutate(Proportion = round(Patients / Total, 3))
      
      # Add Hospital-Wide totals
      choice_hospital_data <- choice_expanded %>%
        group_by(choice2) %>%
        summarise(Patients = n(), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      choice_long <- bind_rows(choice_long, choice_hospital_data)
      
      # Recalculate totals and proportions with Hospital-Wide
      choice_long <- choice_long %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Filter out departments with no data
      choice_long <- choice_long %>%
        group_by(`Department name`) %>%
        mutate(dept_total = sum(Patients, na.rm = TRUE)) %>%
        ungroup() %>%
        filter(dept_total > 0)
      
      if(nrow(choice_long) == 0) {
        return(plotly_empty() %>%
                 layout(title = list(text = "No data available for choice line analysis",
                                     font = list(size = 12))))
      }
      
      # MODIFIED: Updated stacking and legend order
      choice_levels_stack <- c("Second choice", "First choice")
      choice_levels_legend <- c("First choice", "Second choice")
      choice_long$choice2 <- factor(choice_long$choice2, levels = choice_levels_stack)
      
      # --- Integer counts per department ---
      choice_long <- choice_long %>%
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
      choice_long <- choice_long %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          IsHospitalWide = (`Department name` == "Hospital-Wide"),
          ProportionPct = Proportion * 100,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Choice Classification:</b> ", as.character(choice2), "<br>",
            "<b>Count:</b> ", Count, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      # --- Ordered labels ---
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(unique(choice_long$PlotLabel[choice_long$PlotLabel != "<b style='color:#0072B2;'>Hospital-Wide</b>"]))
      )
      choice_long$PlotLabel <- factor(choice_long$PlotLabel, levels = ordered_labels)
      
      # Create label_data from dept_total
      label_data <- choice_long %>%
        group_by(`Department name`, PlotLabel) %>%
        summarise(Total = sum(Patients, na.rm = TRUE), .groups = "drop") %>%
        mutate(
          PlotLabel = factor(PlotLabel, levels = levels(choice_long$PlotLabel))
        )
      
      # --- Dynamic buffer ---
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # --- ggplot ---
      p <- ggplot(choice_long, aes(y = PlotLabel, x = ProportionPct, fill = choice2, text = hover_text)) +
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
          values = c("First choice" = "#8E44AD", "Second choice" = "#00BCD4"),
          drop = FALSE
        ) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
          title = NULL,
          subtitle = NULL,
          x = "Proportion of Patients",
          y = "Department",
          fill = "Choice Classification"
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
        scale_y_discrete(limits = rev(levels(choice_long$PlotLabel)))
      
      # --- Convert to plotly ---
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Choice of Recommended IV Antibiotic Use for surgical prophylaxis</b><br>"
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
            title = list(text = "<b>Choice Classification</b>", font = list(size = 10)),
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
    
    # Dosage Analysis Data - CORRECTED TO MATCH R MARKDOWN EXACTLY
    dosage_data_reactive <- reactive({
      if (!check_data()) return(list())
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      # Apply same standardizations as R Markdown
      data_patients <- data_patients %>%
        mutate(
          `Diagnosis code` = ifelse(
            Indication %in% c("SP1", "SP2", "SP3"),
            "Proph",
            `Diagnosis code`
          ),
          AWaRe = ifelse(
            toupper(AWaRe) == "NOT_RECOMMENDED",
            "NOT RECOMMENDED",
            AWaRe
          )
        )
      
      # Replace empty strings with NA
      data_patients[data_patients == ""] <- NA
      
      # CORRECTED: Match R Markdown SP2 data preparation exactly
      data_SP2 <- data_patients %>%
        filter(Indication %in% surgical_indications) %>%
        mutate(
          Route = toupper(Route),
          ATC5 = trimws(toupper(ATC5)),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx, TRUE, FALSE
          ),
          Weight = as.numeric(Weight)
        )
      
      # Lookup Drug & Dose Info for H_SP_APPROP_ABX
      lookup2 <- data_lookup %>% filter(Code == "H_SP_APPROP_ABX")
      lookup_names2 <- unlist(lookup2[1, c("ABX-ATC-1", "ABX-ATC-2", "ABX-ATC-3", "ABX-ATC-4", "ABX-ATC-5", "ABX-ATC-6", "ABX-ATC-7", "ABX-ATC-8", "ABX-ATC-9")], use.names = FALSE)
      lookup_names2 <- toupper(trimws(lookup_names2))
      
      # Compute Total Daily Dose for each row in data_SP2 
      data_SP2 <- data_SP2 %>%
        mutate(
          Unit_Factor = case_when(
            Unit == "mg" ~ 1,
            Unit == "g"  ~ 1000,
            TRUE         ~ NA_real_
          ),
          Total_Daily_Dose = as.numeric(`Single Unit Dose`) * as.numeric(`N Doses/day`) * Unit_Factor
        )
      
      # Match Drug + Dose + Route 
      for (i in 1:9) {
        name_col <- paste0("ABX-ATC-", i)
        dose_col <- paste0("ABX-DOSE-", i)
        freq_col <- paste0("ABX-DAY-DOSE-", i)
        unit_col <- paste0("ABX-UNIT-", i)
        route_col <- paste0("ABX-ROUTE-", i)
        
        dose_match_col <- paste0("Match_Drug_Dose_", i)
        
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
        
        # Expected dose
        expected_dose <- if (!is.na(unit_value) && unit_value == "mg/kg") {
          dose * freq * data_SP2$Weight * unit_factor
        } else {
          dose * freq * unit_factor
        }
        
        # Expected dose & match against actual dose with tolerance for mg/kg
        data_SP2[[dose_match_col]] <- ifelse(
          data_SP2$ATC5 == drug_lookup &
            (
              # Use ±10% tolerance if mg/kg
              if (!is.na(unit_value) && unit_value == "mg/kg") {
                abs(data_SP2$Total_Daily_Dose - expected_dose) / expected_dose <= 0.10
              } else {
                abs(data_SP2$Total_Daily_Dose - expected_dose) < 1  # strict match for others
              }
            ),
          TRUE, FALSE
        )
      }
      
      # Summarise at patient level - CORRECTED TO MATCH R MARKDOWN EXACTLY
      patient_summary <- data_SP2 %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          # Drug + route matches
          Match_1_P = any(ATC5 == lookup_names2[1] & Route == "P"),
          Match_2_P = any(ATC5 == lookup_names2[2] & Route == "P"),
          Match_3_P = any(ATC5 == lookup_names2[3] & Route == "P"),
          Match_4_P = any(ATC5 == lookup_names2[4] & Route == "P"),
          Match_5_P = any(ATC5 == lookup_names2[5] & Route == "P"),
          Match_6_P = any(ATC5 == lookup_names2[6] & Route == "P"),
          Match_7_P = any(ATC5 == lookup_names2[7] & Route == "P"),
          Match_8_P = any(ATC5 == lookup_names2[8] & Route == "P"),
          Match_9_P = any(ATC5 == lookup_names2[9] & Route == "P"),
          
          # Dose flags
          Dose_1 = any(Match_Drug_Dose_1),
          Dose_2 = any(Match_Drug_Dose_2),
          Dose_3 = any(Match_Drug_Dose_3),
          Dose_4 = any(Match_Drug_Dose_4),
          Dose_5 = any(Match_Drug_Dose_5),
          Dose_6 = any(Match_Drug_Dose_6),
          Dose_7 = any(Match_Drug_Dose_7),
          Dose_8 = any(Match_Drug_Dose_8),
          Dose_9 = any(Match_Drug_Dose_9),
          
          Any_IV = any(Route == "P"),
          
          .groups = "drop"
        ) %>%
        mutate(
          # Define presence of any recommended IV antibiotic
          Any_Recommended_IV_Given = Match_1_P | Match_2_P | Match_3_P | Match_5_P | Match_9_P,
          
          # Define if any correct dosage among recommended ones
          Any_Recommended_Dose_Correct = (Match_1_P & Dose_1) |
            (Match_2_P & Dose_2) |
            (Match_3_P & Dose_3) |
            (Match_5_P & Dose_5) |
            (Match_9_P & Dose_9),
          
          # Define if all recommended IV antibiotics given had correct doses
          All_Matched_And_Dosed = (
            (Match_1_P & Dose_1) & (Match_2_P & Dose_2)) |
            (Match_1_P & Dose_1) &  !Match_2_P |
            (Match_3_P & Dose_3) |
            (Match_5_P & Dose_5) |
            ((Match_9_P & Dose_9) & (Match_2_P & Dose_2)) |
            (Match_9_P & Dose_9) & !Match_2_P,
          
          # CORRECTED: Match R Markdown category naming exactly 
          Dose_Result = case_when(
            # Fully correct recommended IVs and all at correct dosage
            All_Matched_And_Dosed ~ "Received recommended IV antibiotics with recommended dosage",
            
            # At least one recommended IV with correct dosage
            Any_Recommended_IV_Given & Any_Recommended_Dose_Correct & !All_Matched_And_Dosed ~
              "Received at least one recommended IV antibiotic with only one has recommended dosage",
            
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
      
      return(list(
        data_SP2 = data_SP2,
        patient_summary = patient_summary
      ))
    })
    
    # Dosage summary - CORRECTED TO MATCH R MARKDOWN EXACTLY
    output$dosage_summary <- renderUI({
      dosage_data <- dosage_data_reactive()
      if(length(dosage_data) == 0) {
        return(HTML("<p>No data available</p>"))
      }
      
      patient_summary <- dosage_data$patient_summary
      
      # Create the same summary structure as R Markdown
      dose_categories <- c(
        "Received recommended IV antibiotics with recommended dosage",
        "Received at least one recommended IV antibiotic with only one has recommended dosage",
        "Received at least one recommended IV antibiotic with none have recommended dosage"
      )
      
      # Create summary by department (excluding non-recommended group)
      dept_summary <- patient_summary %>%
        filter(Dose_Result %in% dose_categories) %>%
        group_by(`Department name`, Dose_Result) %>%
        summarise(Patients = n(), .groups = "drop") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Add Hospital-Wide summary
      hospital_summary <- patient_summary %>%
        filter(Dose_Result %in% dose_categories) %>%
        group_by(Dose_Result) %>%
        summarise(Patients = n(), .groups = "drop") %>%
        mutate(
          `Department name` = "Hospital-Wide",
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        select(`Department name`, Dose_Result, Patients, Total, Proportion)
      
      # Combine summaries
      final_summary2 <- bind_rows(dept_summary, hospital_summary)
      
      # Calculate total eligible patients (matching R Markdown method)
      # Exclude Hospital-Wide for total count
      final_summary2_IA_filtered <- final_summary2 %>%
        filter(`Department name` != "Hospital-Wide")
      
      # Calculate total eligible patients by summing Patients column
      total_approp_iv_given <- final_summary2_IA_filtered %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Get total eligible from choice data for context (matching R Markdown)
      choice_data <- choice_data_reactive()
      total_eligible <- if(length(choice_data) > 0) {
        choice_data$patient_summary_SP %>% nrow()
      } else {
        # Fallback: get from SP data if choice data not available
        data_SP <- get_sp_data()
        if(!is.null(data_SP)) {
          data_SP %>%
            filter(AWaRe_compatible) %>%
            distinct(`Survey Number`) %>%
            nrow()
        } else {
          total_approp_iv_given
        }
      }
      
      # Fallback message if no data
      if (is.na(total_approp_iv_given) || total_approp_iv_given == 0) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
          ⚠️ <strong>No summary available</strong> — there are currently no eligible patients with valid IV antibiotic dosage data for <strong>SP assessment</strong>.<br><br>
          <em>This may indicate that no patients received antibiotics with appropriate dosing, or none met the inclusion criteria.</em>
          </div>"
        ))
      }
      
      # Intro text card (matching R Markdown format)
      intro_text2 <- HTML(paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💊 <strong>Denominator:</strong> Number of eligible surgical prophylaxis patients who received recommended (<em>or partially recommended</em>) IV antibiotic choice based on WHO AWaRe book ",
        "(<strong>", total_approp_iv_given, "</strong> out of <strong>", total_eligible, "</strong>)",
        "</div>",
        
        "<strong>Summary:</strong><br><br>"
      ))
      
      # Icon function - exact string matching
      get_icon <- function(label) {
        if (label == "Received recommended IV antibiotics with recommended dosage") {
          return("✅")
        } else if (label == "Received at least one recommended IV antibiotic with only one has recommended dosage") {
          return("⚠️")
        } else if (label == "Received at least one recommended IV antibiotic with none have recommended dosage") {
          return("❌")
        } else {
          return("🛈")
        }
      }
      
      # Generate HTML blocks for each department (matching R Markdown structure)
      dept_blocks <- final_summary2 %>%
        group_by(`Department name`) %>%
        summarise(
          block = {
            dept <- first(`Department name`)
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            total_patients <- first(Total)
            
            # Create list items for each category
            list_items <- dose_categories %>%
              map_chr(function(category) {
                row_data <- final_summary2 %>%
                  filter(`Department name` == dept, Dose_Result == category)
                
                count <- if(nrow(row_data) > 0) row_data$Patients else 0
                prop <- if(nrow(row_data) > 0) row_data$Proportion else 0
                icon <- get_icon(category)
                
                paste0(
                  "<li>", icon, " <strong>", category, "</strong> (as per WHO AWaRe book): ",
                  "<strong>", scales::percent(prop, accuracy = 0.1), "</strong> ",
                  "(", count, " out of ", total_patients, ")",
                  "</li>"
                )
              }) %>%
              paste(collapse = "")
            
            paste0(
              "<div style='background-color: ", bg, "; border-left: 5px solid ", color, "; padding: 14px; margin-bottom: 20px;'>",
              "<strong>🏥 ", dept, "</strong> <span style='color: #888;'>(n = ", total_patients, " patients)</span><br><br>",
              "<ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>",
              list_items,
              "</ul>",
              "</div>"
            )
          },
          .groups = "drop"
        ) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`)
      
      # Combine all parts
      final_html <- HTML(paste0(
        intro_text2,
        paste(dept_blocks$block, collapse = "")
      ))
      
      return(final_html)
    })
    
    # Dosage appropriateness plot - CORRECTED TO MATCH R MARKDOWN EXACTLY with updated sizing
    output$dosage_plot <- renderPlotly({
      dosage_data <- dosage_data_reactive()
      if(length(dosage_data) == 0) {
        return(plotly_empty())
      }
      
      patient_summary <- dosage_data$patient_summary
      
      # Define all Dose_Result categories FIRST (for legend and completeness)
      all_categories2 <- c(
        "Received recommended IV antibiotics with recommended dosage",
        "Received at least one recommended IV antibiotic with only one has recommended dosage",
        "Received at least one recommended IV antibiotic with none have recommended dosage",
        "Received IV antibiotics not among recommended options"
      )
      
      # Color palette - MATCH R MARKDOWN
      dosage_colors <- c(
        "Received recommended IV antibiotics with recommended dosage" = "#084594",
        "Received at least one recommended IV antibiotic with only one has recommended dosage" = "#6BAED6",
        "Received at least one recommended IV antibiotic with none have recommended dosage" = "#FC9272",
        "Received IV antibiotics not among recommended options" = "#D3D3D3"
      )
      
      # Create Summary Table by Department (with 0s for missing combos)
      iv_dose_counts <- patient_summary %>%
        group_by(`Department name`, Dose_Result) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Use predefined categories for complete combinations
      all_combos2 <- expand_grid(
        `Department name` = unique(patient_summary$`Department name`),
        Dose_Result = all_categories2
      )
      
      iv_dose_summary <- all_combos2 %>%
        left_join(iv_dose_counts, by = c("Department name", "Dose_Result")) %>%
        mutate(Patients = replace_na(Patients, 0)) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = if_else(Total > 0, round(100 * Patients / Total, 1), 0)
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
          Proportion = if_else(Total > 0, round(100 * Patients / Total, 1), 0)
        ) %>%
        ungroup()
      
      # Combine and Sort Final Output
      final_summary2 <- bind_rows(iv_dose_summary, hospital_row) %>%
        arrange(`Department name`, Dose_Result)
      
      # Set factor levels with ALL categories
      final_summary2$Dose_Result <- factor(final_summary2$Dose_Result, levels = all_categories2)
      
      # Fill in all missing Department × Category combos (0 patients)
      complete_summary <- expand_grid(
        `Department name` = unique(final_summary2$`Department name`),
        Dose_Result = all_categories2
      ) %>%
        left_join(final_summary2, by = c("Department name", "Dose_Result")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, round(100 * Patients / Total, 1)),
          Dose_Result = factor(Dose_Result, levels = all_categories2)
        )
      
      # Format Department labels
      complete_summary <- complete_summary %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>",
                             `Department name`),
          PlotLabel = factor(PlotLabel, levels = c("<b style='color:#0072B2;'>Hospital-Wide</b>",
                                                   sort(setdiff(unique(`Department name`), "Hospital-Wide")))),
          # Create custom hover text matching second code style
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Category:</b> ", as.character(Dose_Result), "<br>",
            "<b>Patients:</b> ", Patients, "<br>",
            "<b>Proportion:</b> ", round(Proportion, 1), "%"
          )
        )
      
      # Dynamic buffer calculation (matching second code)
      label_data <- complete_summary %>%
        distinct(`Department name`, Total) %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`)
        )
      
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # Create ggplot - MATCH R MARKDOWN STYLING with updated layout
      p <- ggplot(complete_summary, aes(y = PlotLabel, x = Proportion, fill = Dose_Result, text = hover_text)) +
        geom_bar(stat = "identity", position = "fill", width = 0.85) +
        geom_text(aes(label = ifelse(Proportion > 5, paste0(Proportion, "%"), "")),
                  position = position_fill(vjust = 0.5),
                  size = 3, color = "black") +
        geom_text(
          data = complete_summary %>% distinct(PlotLabel, Total),
          aes(y = PlotLabel, label = paste0("n=", formatC(Total, format = "d", big.mark = ","))),
          x = label_x,
          inherit.aes = FALSE,
          size = 3, color = "gray30", hjust = 0, vjust = 0.5
        ) +
        scale_fill_manual(
          values = dosage_colors,
          drop = FALSE  # Keep all legend items regardless of data
        ) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
          title = "Antibiotic Dosage Alignment for surgical prophylaxis Cases",
          #subtitle = "Categories reflect combined appropriateness of antibiotic choice and dosage (n = raw patient counts)",
          x = "Proportion of Patients",
          y = "Department",
          fill = "Treatment Classification"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.y = ggtext::element_markdown(size = 7),
          axis.text.x = element_text(size = 7),
          axis.title = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text = element_text(size = 8),
          plot.title = element_text(face = "bold", hjust = 0.5, size = 10),
          plot.subtitle = element_text(hjust = 0.5, size = 8, color = "gray30"),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = 0.6),
          plot.margin = margin(6, 18, 6, 8)
        ) +
        guides(
          fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")
        ) +
        scale_y_discrete(limits = rev(levels(complete_summary$PlotLabel)))
      
      # Convert to plotly with updated layout matching second code
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>Antibiotic Choice and Dosage Appropriateness for SP Cases</b>",
            x = 0.5, xanchor = "center",
            y = 0.98, yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width = 680,
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
          yaxis = list(
            automargin = TRUE, 
            categoryorder = "array", 
            categoryarray = rev(levels(complete_summary$PlotLabel))
          ),
          xaxis = list(
            automargin = TRUE
          )
        ) %>%
        layout(
          shapes = list(list(
            type = "rect", xref = "paper", yref = "y", x0 = 0, x1 = 1,
            y0 = length(levels(complete_summary$PlotLabel)) - 0.5, 
            y1 = length(levels(complete_summary$PlotLabel)) + 0.5 - (length(levels(complete_summary$PlotLabel)) - 1),
            fillcolor = "rgba(240,240,240,0.5)",
            line = list(width = 0),
            layer = "below"
          ))
        ) %>%
        config(
          responsive = TRUE,
          displayModeBar = TRUE,
          displaylogo = FALSE,
          modeBarButtonsToRemove = c('pan2d', 'lasso2d', 'select2d'),
          scrollZoom = FALSE,
          doubleClick = 'reset'
        )
      
      plt
    })
    
  })
}