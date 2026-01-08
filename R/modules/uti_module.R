# Upper UTI Analysis Shiny Module - Complete Implementation
# This module contains all the upper UTI-specific analysis functionality split into separate tabs

# Overview Tab UI
utiOverviewUI <- function(id) {
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
               box(width = 12, title = "🎯 AWaRe Quality Indicators for Upper UTI", status = "info", solidHeader = TRUE,
                   #div(class = "info-box",
                   h5("Within the gPPS data structure, the following antibiotic use quality indicators have been identified:"),
                   p("1) "," Proportion of patients presenting with Upper UTI given IV antibiotics."),
                   p("2) "," Proportion of patients presenting with upper urinary tract infections given IV/oral antibiotics by AWaRe category (Access or Watch)."),
                   p("3) "," Proportion of patients presenting with upper urinary tract infections given the appropriate IV antibiotic according to the WHO AWaRe book."),
                   p("4) "," Proportion of patients presenting with Upper UTIs prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book.")
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
utiEligibilityUI <- function(id) {
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
utiPatientSummaryUI <- function(id) {
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
                   p("Eligible patients for WHO AWaRe Quality Indicator (QI) assessment are defined as adult inpatients (≥18 years) who received empirical antibiotics for CA-Upper UTI.")
               )
        )
      )
    )
  )
}

# QI Guidelines Tab UI
utiQIGuidelinesUI <- function(id) {
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
                       strong("This script evaluates THREE indicators:"), br(), br(),
                       strong("1. H_UUTI_APPROP_DOSAGE:"), " Proportion of patients presenting with Upper UTIs prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book.", br(), br(),
                       strong("2. H_UUTI_WATCH_ABX:"), " Proportion of patients presenting with upper urinary tract infections given IV/oral antibiotics by AWaRe category (Access or Watch).", br(), br(),
                       strong("3. H_UUTI_IV_ABX:"), " Proportion of patients presenting with Upper UTI given IV antibiotics."
                   ),
                   
                   div(class = "note-box",
                       strong("🔍 WHO AWaRe book Recommendation:"), br(), br(),
                       tags$ul(style = "list-style-type: none; padding-left: 0; line-height: 1.8;",
                               tags$li(strong("Ciprofloxacin"), " (500 mg q12h ORAL)"),
                               tags$li("OR"),
                               tags$li(strong("Cefotaxime"), " (1 g q8h IV/IM) ", strong("OR"), " ", strong("Ceftriaxone"), " (1 g q24h IV/IM)"),
                               tags$li("AND/OR"),
                               tags$li(strong("Amikacin"), " (15 mg/kg q24h IV)"),
                               tags$li("AND/OR"),
                               tags$li(strong("Gentamicin"), " (5 mg/kg q24h IV)")
                       )
                   ),
                   
                   div(class = "warning-box",
                       strong("🩺 WHO AWaRe Notes:"), br(),
                       tags$ul(
                         tags$li("This recommendation focuses on community-acquired pyelonephritis in patients with no catheter"),
                         tags$li("Step down to oral treatment is based on improvement of symptoms"),
                         tags$li("Consider amikacin or gentamicin where ESBL-producing isolates are highly prevalent"),
                         tags$li("In very sick patients, amikacin or gentamicin can be given in combination with cefotaxime or ceftriaxone")
                       )
                   )
               )
        )
      )
    )
  )
}

# Choice Analysis Tab UI
utiChoiceAnalysisUI <- function(id) {
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
                   p("Please upload your data files to view choice appropriateness analysis.")
               )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📌 Antibiotic Choice Alignment with AWaRe book Recommendations for Upper UTI", status = "primary", solidHeader = TRUE,
                   
                   "Proportion of patients presenting with upper urinary tract infections given the appropriate IV antibiotic according to the WHO AWaRe book"
                   
               )
        )
      ),
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🔍 WHO AWaRe book Recommendation:", status = "primary", solidHeader = TRUE,
                   tags$ul(
                     tags$li(strong("Ciprofloxacin"), " (500 mg q12h ORAL)"),
                     "OR",
                     tags$li(strong("Cefotaxime"), " (1 g q8h IV/IM) ", strong("OR"), " ", strong("Ceftriaxone"), " (1 g q24h IV/IM)"),
                     "AND/OR",
                     tags$li(strong("Amikacin"), " (15 mg/kg q24h IV)"),
                    "AND/OR",
                     tags$li(strong("Gentamicin"), " (5 mg/kg q24h IV)")
                   )
               )
        )
      ),
      
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📈 Antibiotic Choice Alignment with AWaRe book Recommendations for Upper UTI",
            status = "primary", solidHeader = TRUE,
            p("This section assesses whether adult inpatients with CA-Upper UTI were prescribed the appropriate empirical IV antibiotics based on the WHO AWaRe Antibiotic Book."),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("choice_plot"), height = "450px", width = "100%"),
                  type = 4
                ))
          )
        )
      ),
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📝 Summary of Antibiotic Choice Alignment with AWaRe book Recommendations for Upper UTI", status = "success", solidHeader = TRUE,collapsible = TRUE,collapsed = TRUE,
                   htmlOutput(ns("choice_summary"))
               )
        )
      )
    )
  )
}

# Dosage Analysis Tab UI
utiDosageAnalysisUI <- function(id) {
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
               box(width = 12, title = "📌 Antibiotic Dosage Alignment with AWaRe book Recommendations for Upper UTI", status = "primary", solidHeader = TRUE,
                   p("Proportion of patients presenting with upper urinary tract infections prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book.")
               )
        )
      ),
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🔍 WHO AWaRe book Recommendation:", status = "primary", solidHeader = TRUE,
                   tags$ul(
                     tags$li(strong("- Ciprofloxacin"), " (500 mg q12h ORAL)"),
                     "OR",
                     tags$li(strong("- Cefotaxime"), " (1 g q8h IV/IM) ", strong("OR"), " ", strong("Ceftriaxone"), " (1 g q24h IV/IM)"),
                     "AND/OR",
                     tags$li(strong("- Amikacin"), " (15 mg/kg q24h IV)"),
                     "AND/OR",
                     tags$li(strong("Gentamicin"), " (5 mg/kg q24h IV)")
                   )
               )
        )
      ),
      
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📈 Antibiotic Dosage Alignment with AWaRe book Recommendations for Upper UTI",
            status = "primary", solidHeader = TRUE,
            p("This visual summarises the proportion of antibiotic choice & dosage appropriateness for Upper UTI across hospital departments based on the WHO AWaRe book."),
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
                 strong("Note:"),
                 tags$ul(
                   tags$li("Received recommended IV antibiotics with recommended dosage indicates that the full recommended treatment regimen (whether monotherapy or dual therapy) was given, with all dosages aligned with WHO AWaRe book guidance."),
                   tags$li("Received at least one recommended IV antibiotic with one has recommended dosage refers to cases where only part of the recommended dual therapy was given, and only one antibiotic was at the recommended dosage."),
                   tags$li("Received at least one recommended IV antibiotic with none have recommended dosage includes cases who received either the full recommended regimen with no recommended dosages, or only part of it (e.g., one agent from a dual therapy) with none of the dosages aligned with WHO AWaRe book guidance.")
                 )
             )
      ),
      
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📝 Summary of Antibiotic Dosage Alignment with AWaRe book Recommendations for Upper UTI", status = "success", solidHeader = TRUE,collapsible = TRUE,collapsed = TRUE,
                   htmlOutput(ns("dosage_summary"))
               )
        )
      )
    )
  )
}

# Watch Analysis Tab UI
utiWatchAnalysisUI <- function(id) {
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
                   p("Please upload your data files to view watch antibiotic analysis.")
               )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📌 IV/Oral Watch Antibiotic Use", status = "primary", solidHeader = TRUE,
                   " Proportion of patients presenting with upper urinary tract infections given IV/oral antibiotics by AWaRe category (Access or Watch)."
                   
               )
        )
      ),
      
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📈 Antibiotic Prescription by AWaRe Classification",
            status = "primary", solidHeader = TRUE,
            p("This visual summarises the proportion of antibiotic prescription for Upper UTI across hospital departments by WHO AWaRe Classification (Access, Watch, Reserve)"),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("aware_plot"), height = "450px", width = "100%"),
                  type = 4
                ))
          )
        )
      ),
      column(10, offset = 1,
             div(class = "note-box",
                 strong("Note:"), "This count in this visual represents the number of unique patients who were prescribed at least one antibiotic within a specific WHO AWaRe category (Access, Watch, or Reserve) during their encounter. A patient is counted once for each distinct AWaRe category they received an antibiotic from."
             )
      ),
      
      
      
      
      #  fluidRow(
      #   column(
      #    10, offset = 1,
      #   box(
      #     width = 12, title = "📈 Route of Administration for WATCH Antibiotics",
      #     status = "primary", solidHeader = TRUE,
      #     p("This visual summarises the proportion of Upper UTI Patients on Watch Antibiotics across hospital departments by Route of Administration"),
      #     div(style = "
      #       display: flex; 
      #       justify-content: center; 
      #       align-items: center; 
      #       max-width: 100%; 
      #       overflow: hidden;
      #     ",
      #         withSpinner(
      #           plotlyOutput(ns("watch_route_plot"), height = "450px", width = "100%"),
      #           type = 4
      #        ))
      #  )
      # )
      #),
      
      # Watch Summary Box at the bottom
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📊 IV/Oral Antibiotic Use for Upper UTI", status = "success", solidHeader = TRUE,collapsible = TRUE,collapsed = TRUE,
                   htmlOutput(ns("watch_summary"))
               )
        )
      )
    )
  )
}

# IV Analysis Tab UI
utiIVAnalysisUI <- function(id) {
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
                   p("Please upload your data files to view IV antibiotic analysis.")
               )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📌 IV Antibiotic Use", status = "primary", solidHeader = TRUE,
                   " Proportion of patients presenting with Upper UTI given IV antibiotics."
                   
               )
        )
      ),
      
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "📈 Antibiotic Prescription by Route of Administration",
            status = "primary", solidHeader = TRUE,
            p("This visual summarises the proportion of patients with Upper UTI who received an IV antibiotic across hospital departments by route of administration"),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("iv_route_plot"), height = "450px", width = "100%"),
                  type = 4
                ))
          )
        )
      ),
      
      column(10, offset = 1,
             div(class = "note-box",
                 strong("Note:"), "The proportions shown reflect the number of unique adult patients with Upper UTIs who received antibiotics via the IV or non-IV (e.g., oral or other) route. Each patient is counted only once per route category, even if multiple antibiotics were prescribed via the same route."
             )
      ),
      
      
      # IV Summary Box at the bottom
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📊 Summary of IV Antibiotic Use for Upper UTI", status = "success", solidHeader = TRUE,collapsible = TRUE ,collapsed = TRUE,
                   htmlOutput(ns("iv_summary"))
               )
        )
      )
    )
  )
}

# Module Server - Handles all upper UTI tabs
utiAnalysisServer <- function(id, data_reactive) {
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
        
        # Filter eligible upper UTI patients - match R Markdown logic exactly
        data_UTI <- data_patients %>%
          filter(`Diagnosis code` == "Pye") %>%
          mutate(
            Route = toupper(as.character(Route)),
            AWaRe_compatible = (`Age years` >= 18 & 
                                  Indication == "CAI" & 
                                  Treatment == "EMPIRICAL" & 
                                  AWaRe %in% AWaRe_abx)
          ) 
        
        # Count eligible unique upper UTI cases
        eligible_UTI_n <- data_UTI %>%
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
        status_message <- if(eligible_UTI_n == 0) {
          "<div style='background-color:#fff3cd; border: 1px solid #ffeeba; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>🚫 No eligible cases found:</strong> There were no eligible cases for evaluation during this survey period. Please verify data availability.
          </div>"
        } else if(eligible_UTI_n < 10) {
          "<div style='background-color:#ffe0e0; border: 1px solid #ffb3b3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>⚠️ Caution:</strong> Few eligible cases detected. Interpret results with caution.
          </div>"
        } else {
          "<div style='background-color:#e0ffe0; border: 1px solid #b3ffb3; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>✅ Good to go!</strong> Sufficient eligible cases available to proceed with full evaluation.
          </div>"
        }
        
        # Build HTML feedback using paste0 - matching R Markdown exactly
        html_feedback <- HTML(paste0(
          "<div style='background-color: #f0f8ff; border: 1px solid #add8e6; padding: 15px; border-radius: 5px; font-family: sans-serif;'>",
          "<p style='margin-bottom: 10px;'>",
          "This script applies <strong>WHO AWaRe Quality Indicators</strong> to adult inpatients who received empirical antibiotics for community-acquired upper urinary tract infections (CA-Upper UTI).",
          "</p>",
          "<ul>",
          "<li><strong>Diagnostic code:</strong> Pye</li>",
          "<li><strong>Total eligible cases:</strong> ", eligible_UTI_n, "</li>",
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
        filter(AWaRe %in% AWaRe_abx , `Diagnosis code` == "Pye") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      eligible_patients <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx, Treatment == "EMPIRICAL", `Diagnosis code` == "Pye") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      total_prescriptions <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "Pye") %>%
        nrow()
      
      eligible_prescriptions <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx, Treatment == "EMPIRICAL", `Diagnosis code` == "Pye") %>%
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
        "</strong> patients on antibiotics for Upper UTI were QI-eligible patients.",
        "</p>",
        "</div>",
        
        # Card 2: Prescriptions
        "<div style='flex: 1; min-width: 300px; background-color: ", prescription_color, 
        "; border-left: 6px solid #17a2b8; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>",
        "<h4 style='margin-top: 0; color: #0c5460;'>📑 Proportion of Eligible Prescriptions</h4>",
        "<div style='font-size: 2.5em; font-weight: bold; color: #0c5460; margin: 10px 0;'>", prescription_percentage, "%</div>",
        "<p style='margin-bottom: 0; color: #0c5460;'>",
        "<strong>", eligible_prescriptions, "</strong> out of <strong>", total_prescriptions, 
        "</strong> antibiotic prescriptions for Upper UTI were given to QI-eligible patients.",
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
          "Number of all patients with a diagnosis of upper UTI on any antibiotics",
          "Number of eligible patients: Adult patients (≥18 years) with a diagnosis of CA-Upper UTI who were treated empirically with antibiotics"
        ),
        Count = c(
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Diagnosis code` == "Pye", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "Pye", AWaRe %in% AWaRe_abx) %>%
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
          "Number of all antibiotic prescriptions for patients diagnosed with upper UTI",
          "Number of eligible antibiotic prescriptions: antibiotics empirically prescribed for adult patients (≥18 years) with CA-Upper UTI"
        ),
        Count = c(
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Diagnosis code` == "Pye", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "Pye", AWaRe %in% AWaRe_abx) %>% nrow()
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
    
    # Choice analysis data - MATCH R MARKDOWN exactly (ALL 6 CATEGORIES)
    choice_data_reactive <- reactive({
      if (!check_data()) {
        return(list())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      # Prepare the data (Select Upper UTI data only) - MATCH R MARKDOWN
      data_UTI_choice <- data_patients %>%
        filter(`Diagnosis code` == "Pye") %>%
        mutate(
          Route = toupper(Route),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      # Lookup ABX names for Upper UTI QI
      lookup_names <- data_lookup %>%
        filter(Code == "H_UUTI_APPROP_DOSAGE") %>%
        select(starts_with("ABX-ATC")) %>%
        unlist(use.names = FALSE)
      
      # Create long format from lookup - MATCH R MARKDOWN
      lookup_long <- tibble(
        Drug = unlist(data_lookup %>% filter(Code == "H_UUTI_APPROP_DOSAGE") %>% select(starts_with("ABX-ATC")), use.names = FALSE),
        Choice = unlist(data_lookup %>% filter(Code == "H_UUTI_APPROP_DOSAGE") %>% select(starts_with("ABX-CHOICE")), use.names = FALSE)
      ) %>%
        filter(!is.na(Drug))
      
      # Merge choice info with patient-level data
      data_UTI_choice <- data_UTI_choice %>%
        left_join(lookup_long, by = c("ATC5" = "Drug"))
      
      # Patient Summary for Upper UTI - MATCH R MARKDOWN EXACTLY
      patient_summary_UTI <- data_UTI_choice %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          Match_2_P = any(ATC5 == lookup_names[2] & Route == "P"),
          Match_3_P = any(ATC5 == lookup_names[3] & Route == "P"),
          Match_4_P = any(ATC5 == lookup_names[4] & Route == "P"),
          Match_5_P = any(ATC5 == lookup_names[5] & Route == "P"),
          
          Any_Oral = any(Route == "O"),
          Any_IV = any(Route == "P"),
          N_ABX = n_distinct(ATC5),
          .groups = "drop"
        ) %>%
        rowwise() %>%
        mutate(
          Num_recommended_given = sum(c_across(c(Match_2_P, Match_3_P, Match_4_P, Match_5_P))),
          
          # Full match = correct pair given and no extra IV abx - MATCH R MARKDOWN
          Received_full_recommended_IV = (
            (
              # Monotherapy cases
              (Match_2_P & Num_recommended_given == 1 & N_ABX == 1) |
                (Match_3_P & Num_recommended_given == 1 & N_ABX == 1) |
                (Match_4_P & Num_recommended_given == 1 & N_ABX == 1) |
                (Match_5_P & Num_recommended_given == 1 & N_ABX == 1)
            ) |
              (
                # Dual therapy cases
                ((Match_2_P & Match_4_P) |
                   (Match_2_P & Match_5_P) |
                   (Match_3_P & Match_4_P) |
                   (Match_3_P & Match_5_P)) &
                  Num_recommended_given == 2 & N_ABX == 2
              )
          ),
          
          # No match at all with recommended options
          Received_no_recommended_IV = Any_IV & Num_recommended_given == 0,
          
          # Partial = recommended abx used, but not in full combo or with extra abx
          Received_partial_recommended_IV = Any_IV & !Received_full_recommended_IV & !Received_no_recommended_IV,
          
          # flag patients who only got oral (no IV at all)
          Received_oral_only = Any_Oral & !Any_IV,
          
          # Other non-IV/oral (KEEP THIS - it's in R Markdown)
          Other_non_IV_or_oral = !Received_full_recommended_IV & !Received_partial_recommended_IV & 
            !Received_no_recommended_IV & !Received_oral_only & !Any_IV & !Any_Oral
        ) %>%
        ungroup()
      
      return(list(
        data_UTI_choice = data_UTI_choice,
        patient_summary_UTI = patient_summary_UTI
      ))
    })
    
    # Choice plot - MATCH R MARKDOWN WITH ALL 6 CATEGORIES
    output$choice_plot <- renderPlotly({
      choice_data <- choice_data_reactive()
      if (length(choice_data) == 0) {
        return(plotly_empty() %>% layout(title = "No eligible data available"))
      }
      
      data_UTI_choice <- choice_data$data_UTI_choice
      patient_summary_UTI <- choice_data$patient_summary_UTI
      
      # Get not eligible patients with department info
      not_eligible_patients_UTI <- data_UTI_choice %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary table with ALL categories including ineligible
      eligible_long_UTI <- patient_summary_UTI %>%
        select(`Survey Number`, `Department name`, 
               Received_full_recommended_IV, 
               Received_partial_recommended_IV, 
               Received_no_recommended_IV,
               Received_oral_only,
               Other_non_IV_or_oral) %>%
        pivot_longer(
          cols = -c(`Survey Number`, `Department name`),
          names_to = "Indicator",
          values_to = "Value"
        ) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Count = n(), .groups = "drop")
      
      # Get all possible combinations
      all_combos <- expand_grid(
        `Department name` = unique(c(patient_summary_UTI$`Department name`, not_eligible_patients_UTI$`Department name`)),
        Indicator = c("Received_full_recommended_IV", "Received_partial_recommended_IV", 
                      "Received_no_recommended_IV", "Received_oral_only", 
                      "Other_non_IV_or_oral", "Not_Eligible")
      )
      
      # Left join and replace NAs with 0
      eligible_long_UTI <- all_combos %>%
        left_join(eligible_long_UTI, by = c("Department name", "Indicator")) %>%
        mutate(Count = replace_na(Count, 0))
      
      # Add not eligible counts
      ineligible_summary_UTI <- not_eligible_patients_UTI %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Count = n)
      
      # Combine
      plot_summary <- bind_rows(
        eligible_long_UTI %>% filter(Indicator != "Not_Eligible"),
        ineligible_summary_UTI
      )
      
      # Add hospital-wide data
      hospital_data <- plot_summary %>%
        group_by(Indicator) %>%
        summarise(Count = sum(Count), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      plot_summary <- bind_rows(plot_summary, hospital_data)
      
      # Calculate totals and proportions
      plot_summary <- plot_summary %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Count),
          Proportion = ifelse(Total > 0, Count / Total, 0)
        ) %>%
        ungroup() %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Received_oral_only" ~ "Received oral antibiotics",
            Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe Upper UTI QIs",
            TRUE ~ Indicator
          ),
          PlotLabel = ifelse(
            `Department name` == "Hospital-Wide",
            "<b style='color:#0072B2;'>Hospital-Wide</b>",
            `Department name`
          ),
          Indicator = factor(
            Indicator,
            levels = c(
              "Received recommended IV antibiotics",
              "Partially received recommended IV antibiotics", 
              "Received IV antibiotics not among recommended options",
              "Received oral antibiotics",
              "Received other non-IV/oral antibiotics",
              "Not eligible for AWaRe Upper UTI QIs"
            )
          )
        )
      
      # X-axis department order
      label_order <- c("<b style='color:#0072B2;'>Hospital-Wide</b>",
                       sort(setdiff(unique(plot_summary$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>")))
      plot_summary$PlotLabel <- factor(plot_summary$PlotLabel, levels = label_order)
      
      # Color palette - ALL 6 COLORS
      drug_choice_colors <- c(
        "Received recommended IV antibiotics" = "#1F77B4",
        "Partially received recommended IV antibiotics" = "#4FA9DC",
        "Received IV antibiotics not among recommended options" = "#EF476F",
        "Received oral antibiotics" = "#F9D99E",
        "Received other non-IV/oral antibiotics" = "#D3D3D3",
        "Not eligible for AWaRe Upper UTI QIs" = "#A9A9A9"
      )
      
      # Create ggplot
      p <- ggplot(
        plot_summary,
        aes(
          x = PlotLabel, y = Proportion, fill = Indicator,
          text = paste0(
            "Department: ", `Department name`, "<br>",
            "Category: ", Indicator, "<br>",
            "Count: ", Count, "<br>",
            "Total: ", Total
          )
        )
      ) +
        geom_bar(stat = "identity", position = "fill", width = 0.7) +
        geom_text(
          aes(label = ifelse(Count > 0, Count, "")),
          position = position_fill(vjust = 0.5),
          size = 2.6, color = "black"
        ) +
        geom_text(
          data = plot_summary %>% distinct(PlotLabel, Total),
          aes(x = PlotLabel, y = 1.05, label = paste0("n=", Total)),
          inherit.aes = FALSE,
          size = 3, color = "gray30", hjust = 0.5
        ) +
        scale_fill_manual(values = drug_choice_colors, drop = FALSE) +
        scale_y_continuous(limits = c(0, 1.09), expand = c(0, 0)) +
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
        guides(fill = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"))
      
      # Convert to plotly
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Antibiotic Choice Alignment for UTIs</b><br>"
            ),
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
            y = -0.80, yanchor = "top",
            font = list(size = 9),
            title = list(text = "<b>Treatment Alignment Category</b>", font = list(size = 9))
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
    
# Choice Summary
output$choice_summary <- renderUI({
  choice_data <- choice_data_reactive()
  if(length(choice_data) == 0) {
    return(HTML("<p>No data available for choice summary</p>"))
  }
  
  patient_summary_UTI <- choice_data$patient_summary_UTI
  data_UTI_choice <- choice_data$data_UTI_choice
  
  if(nrow(patient_summary_UTI) == 0) {
    return(HTML(
      "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
  ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing IV antibiotic choice appropriateness for Upper UTI.<br><br>
  <em>This may indicate that no patients received IV antibiotics or none met the inclusion criteria during the reporting period.</em>
  </div>"
    ))
  }
  
  # First, rebuild qi_summary_UTI from patient_summary_UTI (matching the plot logic)
  not_eligible <- data_UTI_choice %>%
    group_by(`Survey Number`, `Department name`) %>%
    summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
    filter(Ineligible)
  
  eligible_long <- patient_summary_UTI %>%
    select(`Survey Number`, `Department name`,
           Received_full_recommended_IV, Received_partial_recommended_IV,
           Received_no_recommended_IV, Received_oral_only, Other_non_IV_or_oral) %>%
    pivot_longer(
      -c(`Survey Number`, `Department name`),
      names_to = "Indicator", values_to = "Value"
    ) %>%
    mutate(Value = as.logical(Value)) %>%
    filter(Value) %>%
    group_by(`Department name`, Indicator) %>%
    summarise(Patients = n(), .groups = "drop")
  
  all_combos <- expand_grid(
    `Department name` = unique(patient_summary_UTI$`Department name`),
    Indicator = c("Received_full_recommended_IV", "Received_partial_recommended_IV", 
                  "Received_no_recommended_IV", "Received_oral_only", 
                  "Other_non_IV_or_oral", "Not_Eligible")
  )
  
  eligible_long <- all_combos %>%
    left_join(eligible_long, by = c("Department name", "Indicator")) %>%
    mutate(Patients = replace_na(Patients, 0))
  
  ineligible_sum <- not_eligible %>%
    count(`Department name`) %>%
    mutate(Indicator = "Not_Eligible") %>%
    rename(Patients = n)
  
  qi_long <- bind_rows(eligible_long, ineligible_sum)
  
  dept_totals <- qi_long %>%
    group_by(`Department name`) %>%
    summarise(Total = sum(Patients), .groups = "drop")
  
  qi_summary_UTI <- qi_long %>%
    left_join(dept_totals, by = "Department name") %>%
    mutate(
      Indicator = case_when(
        Indicator == "Received_full_recommended_IV"   ~ "Received recommended IV antibiotics",
        Indicator == "Received_partial_recommended_IV"~ "Partially received recommended IV antibiotics",
        Indicator == "Received_no_recommended_IV"     ~ "Received IV antibiotics not among recommended options",
        Indicator == "Received_oral_only"             ~ "Received oral antibiotics",
        Indicator == "Other_non_IV_or_oral"           ~ "Received other non-IV/oral antibiotics",
        Indicator == "Not_Eligible"                   ~ "Not eligible for AWaRe Upper UTIs QIs"
      ),
      Proportion = if_else(Total > 0, Patients/Total, 0)
    ) %>%
    select(`Department name`, Indicator, Patients, Total, Proportion)
  
  # Add Hospital-Wide
  hospital <- qi_summary_UTI %>%
    group_by(Indicator) %>%
    summarise(Patients = sum(Patients), .groups = "drop") %>%
    mutate(`Department name` = "Hospital-Wide")
  
  qi_summary_UTI <- bind_rows(qi_summary_UTI, hospital) %>%
    group_by(`Department name`) %>%
    mutate(Total = sum(Patients), Proportion = if_else(Total>0, Patients/Total, 0)) %>%
    ungroup()
  
  # Now follow R Markdown logic exactly
  # Total eligible patients (excluding 'Not eligible' group and Hospital-Wide)
  total_eligible <- qi_summary_UTI %>%
    filter(`Department name` != "Hospital-Wide") %>%
    filter(Indicator != "Not eligible for AWaRe Upper UTIs QIs") %>%
    summarise(Total = sum(Patients, na.rm = TRUE)) %>%
    pull(Total)
  
  # Total receiving any IV antibiotic (via eligible categories, excluding Hospital-Wide)
  total_iv <- qi_summary_UTI %>%
    filter(`Department name` != "Hospital-Wide") %>%
    filter(Indicator %in% c(
      "Received recommended IV antibiotics",
      "Partially received recommended IV antibiotics",
      "Received IV antibiotics not among recommended options"
    )) %>%
    summarise(Total = sum(Patients, na.rm = TRUE)) %>%
    pull(Total)
  
  # Filter relevant data (ALL departments including Hospital-Wide)
  relevant_data <- qi_summary_UTI %>%
    filter(Indicator %in% c(
      "Received recommended IV antibiotics",
      "Partially received recommended IV antibiotics",
      "Received IV antibiotics not among recommended options"
    ))
  
  # If no relevant patients, show no-data summary
  if (is.na(total_iv) || total_iv == 0 || nrow(relevant_data) == 0) {
    return(HTML(
      "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients with IV antibiotic data for upper UTIs.<br><br>
      <em>This may indicate that no patients received IV antibiotics, or none met the inclusion criteria during the reporting period.</em>
      </div>"
    ))
  }
  
  # Build proportion summary for ALL departments
  summary_data_UTI <- relevant_data %>%
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
      Prop_Recommended = `Received recommended IV antibiotics` / Total,
      Prop_Partial = `Partially received recommended IV antibiotics` / Total,
      Prop_Not_Recommended = `Received IV antibiotics not among recommended options` / Total
    ) %>%
    filter(Total > 0)
  
  # Intro block
  intro_text <- paste0(
    "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
    "💊 <strong>Denominator:</strong> Number of eligible upper UTI patients who received any IV antibiotic ",
    "(<strong>", total_iv, "</strong> out of <strong>", total_eligible, "</strong>)",
    "</div><br><br>",
    "<strong>Summary:</strong><br><br>"
  )
  
  # Format summary blocks for ALL departments
  formatted_blocks <- summary_data_UTI %>%
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
            "<div style='background-color: ", bg, "; border-left: 5px solid ", color, "; padding: 14px; margin-bottom: 20px;'>",
            
            "<strong>🏥 ", dept, "</strong> <span style='color: #888;'>(n = ", total_n, " patients)</span><br><br>",
            
            "<ul style='margin-left: 1.2em; line-height: 1.7; padding-left: 0; list-style-type: none;'>",
            "<li>✅ <strong>Received recommended IV antibiotics</strong> (as per WHO AWaRe book): ",
            "<strong>", scales::percent(prop_rec, accuracy = 0.1), "</strong> ",
            "(", n_rec, " out of ", total_n, ")",
            "</li>",
            
            "<li>⚠️ <strong>Partially received recommended IV antibiotics</strong> (as per WHO AWaRe book): ",
            "<strong>", scales::percent(prop_part, accuracy = 0.1), "</strong> ",
            "(", n_part, " out of ", total_n, ")",
            "</li>",
            
            "<li>❌ <strong>Received IV antibiotics not among recommended options</strong> (as per WHO AWaRe book): ",
            "<strong>", scales::percent(prop_not, accuracy = 0.1), "</strong> ",
            "(", n_not, " out of ", total_n, ")",
            "</li>",
            "</ul>",
            
            "</div>"
          )
        }
      )
    ) %>%
    mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
    arrange(order, `Department name`) %>%
    pull(block)
  
  # Final HTML output
  HTML(paste0(intro_text, paste(formatted_blocks, collapse = "\n")))
})
    
    # Dosage Analysis Data and Plots  
    dosage_data_reactive <- reactive({
      if (!check_data()) {
        return(list())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      # Filter Upper UTI Patients and Add AWaRe Eligibility - matching R Markdown exactly
      data_UTI2 <- data_patients %>%
        filter(`Diagnosis code` == "Pye") %>%
        mutate(
          Route = toupper(Route),
          ATC5 = trimws(toupper(ATC5)),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx, 
            TRUE, FALSE
          ),
          Weight = as.numeric(Weight)
        )
      
      # Lookup Drug & Dose Info for H_UUTI_APPROP_DOSAGE 
      lookup2 <- data_lookup %>% filter(Code == "H_UUTI_APPROP_DOSAGE")
      lookup_names2 <- unlist(lookup2[1, c("ABX-ATC-1", "ABX-ATC-2", "ABX-ATC-3", "ABX-ATC-4", "ABX-ATC-5")], use.names = FALSE)
      lookup_names2 <- toupper(trimws(lookup_names2))
      
      # Compute Total Daily Dose for each row  
      data_UTI2 <- data_UTI2 %>%
        mutate(
          Unit_Factor = case_when(
            Unit == "mg" ~ 1,
            Unit == "g"  ~ 1000,
            TRUE         ~ NA_real_
          ),
          Total_Daily_Dose = as.numeric(`Single Unit Dose`) * as.numeric(`N Doses/day`) * Unit_Factor
        )
      
      # Match Drug + Dose + Route 
      for (i in 1:5) {
        name_col <- paste0("ABX-ATC-", i)
        dose_col <- paste0("ABX-DOSE-", i)
        freq_col <- paste0("ABX-DAY-DOSE-", i)
        unit_col <- paste0("ABX-UNIT-", i)
        
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
          dose * freq * data_UTI2$Weight * unit_factor
        } else {
          dose * freq * unit_factor
        }
        
        # Match against actual dose with tolerance for mg/kg
        data_UTI2[[dose_match_col]] <- ifelse(
          data_UTI2$ATC5 == drug_lookup &
            (
              if (!is.na(unit_value) && unit_value == "mg/kg") {
                abs(data_UTI2$Total_Daily_Dose - expected_dose) / expected_dose <= 0.10
              } else {
                abs(data_UTI2$Total_Daily_Dose - expected_dose) < 1
              }
            ),
          TRUE, FALSE
        )
      }
      
      # Summarise at Patient Level - matching R Markdown exactly
      patient_summary2 <- data_UTI2 %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          Match_2_P = any(ATC5 == lookup_names2[2] & Route == "P"),
          Match_3_P = any(ATC5 == lookup_names2[3] & Route == "P"),
          Match_4_P = any(ATC5 == lookup_names2[4] & Route == "P"),
          Match_5_P = any(ATC5 == lookup_names2[5] & Route == "P"),
          
          Dose_2 = any(Match_Drug_Dose_2),
          Dose_3 = any(Match_Drug_Dose_3),
          Dose_4 = any(Match_Drug_Dose_4),
          Dose_5 = any(Match_Drug_Dose_5),
          
          Any_IV = any(Route == "P"),
          
          .groups = "drop"
        ) %>%
        mutate(
          Any_Recommended_IV_Given = Match_2_P | Match_3_P | Match_4_P | Match_5_P,
          
          Any_Recommended_Dose_Correct = (Match_2_P & Dose_2) |
            (Match_3_P & Dose_3) |
            (Match_4_P & Dose_4) |
            (Match_5_P & Dose_5),
          
          All_Matched_And_Dosed = (
            ((Match_2_P & Dose_2) & (!Match_4_P & !Match_5_P)) |
              ((Match_3_P & Dose_3) & (!Match_4_P & !Match_5_P)) |
              ((Match_4_P & Dose_4) & (!Match_2_P & !Match_3_P)) |
              ((Match_5_P & Dose_5) & (!Match_2_P & !Match_3_P)) |
              ((Match_2_P & Dose_2) & (Match_4_P & Dose_4)) |
              ((Match_2_P & Dose_2) & (Match_5_P & Dose_5)) |
              ((Match_3_P & Dose_3) & (Match_4_P & Dose_4)) |
              ((Match_3_P & Dose_3) & (Match_5_P & Dose_5))
          ),
          
          Dose_Result = case_when(
            All_Matched_And_Dosed ~ "Received recommended IV antibiotics with recommended dosage",
            
            Any_Recommended_IV_Given & Any_Recommended_Dose_Correct & !All_Matched_And_Dosed ~
              "Received at least one recommended IV antibiotic with only one has recommended dosage",
            
            Any_Recommended_IV_Given & !Any_Recommended_Dose_Correct ~
              "Received at least one recommended IV antibiotic with none have recommended dosage",
            
            Any_IV & !Any_Recommended_IV_Given ~
              "Received IV antibiotics not among recommended options",
            
            TRUE ~ NA_character_
          )
        ) %>%
        filter(!is.na(Dose_Result))
      
      list(
        data_UTI2 = data_UTI2,
        patient_summary2 = patient_summary2
      )
    })
    
    # Dosage Plot (matching fourth code format for horizontal bars)
    output$dosage_plot <- renderPlotly({
      dosage_data <- dosage_data_reactive()
      if(length(dosage_data) == 0) {
        return(plotly_empty())
      }
      
      patient_summary2 <- dosage_data$patient_summary2
      
      if(nrow(patient_summary2) == 0) {
        return(plotly_empty())
      }
      
      # Create Summary Table by Department - matching R Markdown
      all_categories <- unique(patient_summary2$Dose_Result)
      
      iv_dose_counts2 <- patient_summary2 %>%
        group_by(`Department name`, Dose_Result) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos2 <- expand_grid(
        `Department name` = unique(patient_summary2$`Department name`),
        Dose_Result = all_categories
      )
      
      iv_dose_summary2 <- all_combos2 %>%
        left_join(iv_dose_counts2, by = c("Department name", "Dose_Result")) %>%
        mutate(Patients = replace_na(Patients, 0)) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = ifelse(Total > 0, Patients / Total, 0)
        ) %>%
        ungroup()
      
      # Add Hospital-Wide Summary Row
      hospital_row2 <- iv_dose_summary2 %>%
        group_by(Dose_Result) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = ifelse(Total > 0, Patients / Total, 0)
        ) %>%
        ungroup()
      
      # Combine and Sort Final Output
      final_summary2 <- bind_rows(iv_dose_summary2, hospital_row2)
      
      # Define categories and format
      all_categories2 <- c(
        "Received recommended IV antibiotics with recommended dosage",
        "Received at least one recommended IV antibiotic with only one has recommended dosage",
        "Received at least one recommended IV antibiotic with none have recommended dosage",
        "Received IV antibiotics not among recommended options"
      )
      
      final_summary2$Dose_Result <- factor(final_summary2$Dose_Result, levels = all_categories2)
      
      # Fill missing combinations
      complete_summary <- expand_grid(
        `Department name` = unique(final_summary2$`Department name`),
        Dose_Result = all_categories2
      ) %>%
        left_join(final_summary2, by = c("Department name", "Dose_Result")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, Patients / Total),
          Dose_Result = factor(Dose_Result, levels = all_categories2)
        )
      
      # Format Department labels + hover text (matching fourth code format)
      complete_summary <- complete_summary %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>",
                             `Department name`),
          ProportionPct = Proportion * 100,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Category:</b> ", as.character(Dose_Result), "<br>",
            "<b>Patients:</b> ", Patients, "<br>",
            "<b>Total (n):</b> ", Total, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      # Ordered labels
      ordered_labels <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(unique(complete_summary$PlotLabel[complete_summary$PlotLabel != "<b style='color:#0072B2;'>Hospital-Wide</b>"]))
      )
      complete_summary$PlotLabel <- factor(complete_summary$PlotLabel, levels = ordered_labels)
      
      # Label data for n= annotations
      label_data <- complete_summary %>%
        group_by(`Department name`, PlotLabel) %>%
        summarise(Total = sum(Patients), .groups = "drop") %>%
        mutate(PlotLabel = factor(PlotLabel, levels = levels(complete_summary$PlotLabel)))
      
      # Dynamic buffer for totals (matching fourth code format)
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max <- min(1 + x_buffer, 1.5)
      label_x <- 1 + x_buffer * 0.48
      
      # Colors
      dosage_colors <- c(
        "Received recommended IV antibiotics with recommended dosage" = "#084594",
        "Received at least one recommended IV antibiotic with only one has recommended dosage" = "#6BAED6",
        "Received at least one recommended IV antibiotic with none have recommended dosage" = "#FC9272",
        "Received IV antibiotics not among recommended options" = "#D3D3D3"
      )
      
      # Plot (matching fourth code format exactly for horizontal bars)
      p <- ggplot(complete_summary, aes(y = PlotLabel, x = ProportionPct, fill = Dose_Result, text = hover_text)) +
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
        scale_fill_manual(values = dosage_colors) +
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
      
      # Convert to plotly with adaptive right margin (matching fourth code)
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Antibiotic Prescriptions by Dosage</b><br>"
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
        )
      
      plt
    })
    
    # Dosage Summary
    output$dosage_summary <- renderUI({
      dosage_data <- dosage_data_reactive()
      if(length(dosage_data) == 0) {
        return(HTML("<p>No data available for dosage summary</p>"))
      }
      
      patient_summary2 <- dosage_data$patient_summary2
      data_UTI2 <- dosage_data$data_UTI2  # We need access to the full dataset
      
      if(nrow(patient_summary2) == 0) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
  ⚠️ <strong>No summary available</strong> — there are currently no eligible patients with appropriate IV antibiotic data for Upper UTI.<br><br>
  <em>This may indicate that no patients met the inclusion criteria, or that no patients received recommended IV antibiotics during the reporting period.</em>
  </div>"
        ))
      }
      
      # First, rebuild final_summary2 from patient_summary2
      all_categories <- unique(patient_summary2$Dose_Result)
      
      iv_dose_counts2 <- patient_summary2 %>%
        group_by(`Department name`, Dose_Result) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos2 <- expand_grid(
        `Department name` = unique(patient_summary2$`Department name`),
        Dose_Result = all_categories
      )
      
      iv_dose_summary2 <- all_combos2 %>%
        left_join(iv_dose_counts2, by = c("Department name", "Dose_Result")) %>%
        mutate(Patients = replace_na(Patients, 0)) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = ifelse(Total > 0, Patients / Total, 0)
        ) %>%
        ungroup()
      
      # Add Hospital-Wide Summary Row
      hospital_row2 <- iv_dose_summary2 %>%
        group_by(Dose_Result) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = ifelse(Total > 0, Patients / Total, 0)
        ) %>%
        ungroup()
      
      # Combine
      final_summary2 <- bind_rows(iv_dose_summary2, hospital_row2)
      
      # CRITICAL FIX: Calculate total_eligible from ALL eligible Upper UTI patients
      # This matches the R Markdown logic which uses the full eligible patient population
      total_eligible <- data_UTI2 %>%
        filter(AWaRe_compatible == TRUE) %>%
        filter(`Department name` != "Hospital-Wide") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      # Calculate denominator: patients who received recommended IV (excluding Hospital-Wide and non-recommended)
      final_summary2_UTI_filtered <- final_summary2 %>%
        filter(`Department name` != "Hospital-Wide",
               Dose_Result != "Received IV antibiotics not among recommended options")
      
      total_approp_iv_given <- final_summary2_UTI_filtered %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Handle zero eligible patients
      if (is.na(total_approp_iv_given) || total_approp_iv_given == 0) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients for evaluating the <strong>appropriateness of IV antibiotic dosage</strong> for Upper UTI.<br><br>
      <em>This may indicate that no patients met the inclusion criteria, or that no patients received recommended IV antibiotics during the reporting period.</em>
      </div>"
        ))
      }
      
      # Intro text
      intro_text2 <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💊 <strong>Denominator:</strong> Number of eligible Upper UTI patients who received recommended (<em>or partially recommended</em>) IV antibiotic choice based on WHO AWaRe book (<strong>", total_approp_iv_given, "</strong> out of ", total_eligible, ")",
        "</div><br><br>",
        "<strong>Summary:</strong><br><br>"
      )
      
      # Categories to summarize
      all_categories2 <- c(
        "Received recommended IV antibiotics with recommended dosage",
        "Received at least one recommended iv antibiotic with only one has recommended dosage",
        "Received at least one recommended IV antibiotic with none have recommended dosage"
      )
      
      dept_list <- unique(final_summary2$`Department name`)
      
      complete_summary <- expand_grid(
        `Department name` = dept_list,
        Dose_Result = all_categories2
      ) %>%
        left_join(final_summary2, by = c("Department name", "Dose_Result")) %>%
        filter(Dose_Result %in% all_categories2) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, round(100 * Patients / Total, 1))
        )
      
      # Icon helper function
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
      
      # Description helper function
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
      
      # Generate department-wise HTML blocks
      formatted_blocks2 <- complete_summary %>%
        group_by(`Department name`) %>%
        summarise(
          block = {
            dept <- first(`Department name`)
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            total_patients <- max(Total, na.rm = TRUE)
            
            list_items <- purrr::map_chr(all_categories2, function(label) {
              row_data <- complete_summary %>%
                filter(`Department name` == dept, Dose_Result == label)
              count <- row_data$Patients
              prop <- row_data$Proportion
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
      
      # Final render
      HTML(paste0(intro_text2, paste(formatted_blocks2$block, collapse = "\n")))
    })
    
    # Watch Analysis Data
    watch_data_reactive <- reactive({
      if (!check_data()) {
        return(list())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # Filter Upper UTI patients & flag eligibility - matching R Markdown exactly
      data_UTI <- data_patients %>%
        filter(`Diagnosis code` == "Pye") %>%
        mutate(
          Route = toupper(Route),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      # Filter eligible patients only
      data_UTI_eligible <- data_UTI %>%
        filter(AWaRe_compatible == TRUE)
      
      # One row per patient per AWaRe + Route group - matching R Markdown exactly
      summary_watch <- data_UTI_eligible %>%
        mutate(
          Route_Group = case_when(
            Route %in% c("P", "O") ~ "IV_ORAL",
            TRUE ~ "OTHER"
          ),
          WATCH_IV_ORAL = (AWaRe == "WATCH" & Route_Group == "IV_ORAL"),
          WATCH_OTHER   = (AWaRe == "WATCH" & Route_Group == "OTHER"),
          NON_WATCH     = (AWaRe != "WATCH")
        ) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          WATCH_IV_ORAL = any(WATCH_IV_ORAL),
          WATCH_OTHER   = any(WATCH_OTHER),
          NON_WATCH     = any(NON_WATCH),
          .groups = "drop"
        )
      
      # Department-level summary
      summary_watch_dept <- summary_watch %>%
        group_by(`Department name`) %>%
        summarise(
          Eligible = n(),
          WATCH_IV_ORAL = sum(WATCH_IV_ORAL),
          WATCH_OTHER = sum(WATCH_OTHER),
          NON_WATCH = sum(NON_WATCH),
          Prop_WATCH_IV_ORAL = round(100 * WATCH_IV_ORAL / Eligible, 1),
          Prop_WATCH_OTHER = round(100 * WATCH_OTHER / Eligible, 1),
          Prop_NON_WATCH = round(100 * NON_WATCH / Eligible, 1),
          .groups = "drop"
        )
      
      # Add hospital-level summary
      summary_watch_total <- summary_watch %>%
        summarise(
          `Department name` = "Hospital-Wide",
          Eligible = n(),
          WATCH_IV_ORAL = sum(WATCH_IV_ORAL),
          WATCH_OTHER = sum(WATCH_OTHER),
          NON_WATCH = sum(NON_WATCH),
          Prop_WATCH_IV_ORAL = round(100 * WATCH_IV_ORAL / Eligible, 1),
          Prop_WATCH_OTHER = round(100 * WATCH_OTHER / Eligible, 1),
          Prop_NON_WATCH = round(100 * NON_WATCH / Eligible, 1)
        )
      
      # Combine summaries
      summary_watch_final <- bind_rows(summary_watch_total, summary_watch_dept)
      
      list(
        data_UTI_eligible = data_UTI_eligible,
        summary_watch_final = summary_watch_final
      )
    })
    
    # Watch Summary
    output$watch_summary <- renderUI({
      watch_data <- watch_data_reactive()
      if(length(watch_data) == 0) {
        return(HTML("<p>No data available</p>"))
      }
      
      summary_watch_final <- watch_data$summary_watch_final
      data_UTI_eligible <- watch_data$data_UTI_eligible
      
      # Need to get the TOTAL Upper UTI patients (before eligibility filter)
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # Calculate total Upper UTI patients (before eligibility filtering)
      total_UTI <- data_patients %>%
        filter(`Diagnosis code` == "Pye") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      # Calculate eligible Upper UTI patients
      eligible_UTI <- data_UTI_eligible %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      # Handle case: no eligible UTI patients
      if (eligible_UTI == 0 || is.na(eligible_UTI)) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>",
          "⚠️ <strong>No summary available</strong> — there are currently no eligible patients for evaluating Upper UTI antibiotic use.<br><br>",
          "<em>This may indicate no adult patients with empirical Upper UTI treatment met the inclusion criteria during the reporting period.</em>",
          "</div>"
        ))
      }
      
      # Intro block with "out of" total
      intro_text <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💊 <strong>Denominator:</strong> Number of eligible Upper UTI patients who received any antibiotics (<strong>", eligible_UTI, "</strong> out of ", total_UTI, ")",
        "</div><br><br>",
        "<strong>Summary:</strong><br><br>"
      )
      
      # Build formatted summary blocks
      formatted_blocks <- summary_watch_final %>%
        mutate(block = pmap_chr(
          list(
            `Department name`,
            Prop_WATCH_IV_ORAL, WATCH_IV_ORAL,
            Prop_WATCH_OTHER, WATCH_OTHER,
            Prop_NON_WATCH, NON_WATCH,
            Eligible
          ),
          function(dept, ivoral_p, ivoral_n, other_p, other_n, nonwatch_p, nonwatch_n, total_n) {
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            
            paste0(
              "<div style='background-color: ", bg, "; border-left: 5px solid ", color, "; padding: 14px; margin-bottom: 20px;'>",
              
              "<strong>🏥 ", dept, "</strong> <span style='color: #888;'>(n = ", total_n, " patients)</span><br><br>",
              
              "<ul style='margin-left: 1.2em; line-height: 1.8; padding-left: 0; list-style-type: none;'>",
              "<li>",
              "<span style='display: inline-block; background-color: #007bff; color: white; border-radius: 50%; width: 22px; height: 22px; text-align: center; line-height: 22px; font-size: 12px; margin-right: 8px;'>1</span>",
              "<strong>Received a WATCH antibiotic via IV or Oral route</strong>: <strong>", scales::percent(ivoral_p / 100, accuracy = 0.1), "</strong> (", ivoral_n, " out of ", total_n, ")",
              "</li>",
              "<li>",
              "<span style='display: inline-block; background-color: #17a2b8; color: white; border-radius: 50%; width: 22px; height: 22px; text-align: center; line-height: 22px; font-size: 12px; margin-right: 8px;'>2</span>",
              "<strong>Received a WATCH antibiotic via other route</strong>: <strong>", scales::percent(other_p / 100, accuracy = 0.1), "</strong> (", other_n, " out of ", total_n, ")",
              "</li>",
              "<li>",
              "<span style='display: inline-block; background-color: #ffc107; color: black; border-radius: 50%; width: 22px; height: 22px; text-align: center; line-height: 22px; font-size: 12px; margin-right: 8px;'>3</span>",
              "<strong>Received a NON-WATCH antibiotic</strong>: <strong>", scales::percent(nonwatch_p / 100, accuracy = 0.1), "</strong> (", nonwatch_n, " out of ", total_n, ")",
              "</li>",
              "</ul>",
              
              "</div>"
            )
          }
        ))
      
      # Reorder Hospital-Wide first
      formatted_blocks <- formatted_blocks %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>%
        select(-order)
      
      # Final output
      HTML(paste0(intro_text, paste(formatted_blocks$block, collapse = "\n")))
    })
    
    # AWaRe Plot (Plotly) - horizontal bars matching fourth code format
    output$aware_plot <- plotly::renderPlotly({
      watch_data <- watch_data_reactive()
      if (length(watch_data) == 0) {
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
      
      data_UTI_eligible <- watch_data$data_UTI_eligible
      
      # Summarise AWaRe category by department - matching R Markdown exactly  
      aware_summary <- data_UTI_eligible %>%
        dplyr::group_by(`Department name`, Survey_ID = `Survey Number`, AWaRe) %>%
        dplyr::summarise(Prescriptions = dplyr::n(), .groups = "drop") %>%
        dplyr::group_by(`Department name`, AWaRe) %>%
        dplyr::summarise(Patients = dplyr::n(), .groups = "drop")
      
      # Hospital-level summary
      hospital_row <- aware_summary %>%
        dplyr::group_by(AWaRe) %>%
        dplyr::summarise(Patients = sum(Patients), .groups = "drop") %>%
        dplyr::mutate(`Department name` = "Hospital-Wide")
      
      # Define AWaRe levels
      aware_levels_stack  <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
      aware_levels_legend <- aware_levels_stack
      
      # Ensure all AWaRe levels are represented
      all_combos2 <- tidyr::expand_grid(
        `Department name` = unique(c(aware_summary$`Department name`, "Hospital-Wide")),
        AWaRe = aware_levels_stack
      )
      
      aware_summary_all <- all_combos2 %>%
        dplyr::left_join(dplyr::bind_rows(aware_summary, hospital_row), by = c("Department name", "AWaRe")) %>%
        dplyr::mutate(Patients = tidyr::replace_na(Patients, 0)) %>%
        dplyr::group_by(`Department name`) %>%
        dplyr::mutate(
          Total = sum(Patients),
          Proportion = ifelse(Total > 0, Patients / Total, 0),
          ProportionPct = Proportion * 100
        ) %>%
        dplyr::ungroup()
      
      aware_summary_all$AWaRe <- factor(aware_summary_all$AWaRe, levels = aware_levels_stack)
      
      # Department labels
      aware_summary_all <- aware_summary_all %>%
        dplyr::mutate(
          PlotLabel = ifelse(
            `Department name` == "Hospital-Wide",
            "<b style='color:#0072B2;'>Hospital-Wide</b>",
            `Department name`
          ),
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>AWaRe Category:</b> ", as.character(AWaRe), "<br>",
            "<b>Patients:</b> ", Patients, "<br>",
            "<b>Total (n):</b> ", Total, "<br>",
            "<b>Proportion:</b> ", round(ProportionPct, 1), "%"
          )
        )
      
      aware_summary_all$PlotLabel <- factor(
        aware_summary_all$PlotLabel,
        levels = rev(c(
          "<b style='color:#0072B2;'>Hospital-Wide</b>",
          sort(setdiff(unique(aware_summary_all$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>"))
        ))
      )
      
      # Totals for n= labels
      label_data <- aware_summary_all %>%
        dplyr::group_by(`Department name`, PlotLabel) %>%
        dplyr::summarise(Total = sum(Patients), .groups = "drop")
      
      # Dynamic buffer for right margin (matching fourth code format)
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max <- min(1 + x_buffer, 1.5)
      label_x <- 1 + x_buffer * 0.48
      
      # Colors
      aware_colors <- c(
        "ACCESS"           = "#1b9e77",
        "WATCH"            = "#ff7f00",
        "RESERVE"          = "#e41a1c",
        "NOT RECOMMENDED"  = "#8c510a",
        "UNCLASSIFIED"     = "gray70"
      )
      
      # Plot (horizontal bars matching fourth code format)
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
        scale_fill_manual(values = aware_colors, breaks = aware_levels_legend, drop = FALSE) +
        coord_cartesian(xlim = c(0, xlim_max), expand = FALSE) +
        labs(
          x = "Proportion of Patients",
          y = "Department",
          fill = "AWaRe Category"
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
        guides(fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"))
      
      # Convert to plotly with adaptive right margin (matching fourth code)
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Proportion of Upper UTI Patients on Antibiotics by AWaRe</b><br>"
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
            title = list(text = "<b>AWaRe Category</b>", font = list(size = 10))
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          yaxis = list(
            automargin = TRUE,
            categoryorder = "array",
            categoryarray = rev(levels(aware_summary_all$PlotLabel))
          ),
          xaxis = list(automargin = TRUE)
        )
      
      plt
    })
    
    # WATCH Route Plot (UTI; vertical stacked bars; matching third code format)
    output$watch_route_plot <- renderPlotly({
      wd <- watch_data_reactive()
      if (is.null(wd)) return(plotly_empty())
      data_UTI_eligible <- wd$data_UTI_eligible
      
      # Filter eligible Upper UTI patients receiving WATCH antibiotics - matching R Markdown exactly
      watch_route_summary <- data_UTI_eligible %>%
        filter(AWaRe == "WATCH") %>%
        mutate(
          Route_Clean = case_when(
            Route %in% c("P", "O") ~ "IV/Oral",
            TRUE ~ "Others"
          )
        ) %>%
        group_by(`Department name`, `Survey Number`, Route_Clean) %>%
        summarise(Prescriptions = n(), .groups = "drop") %>%
        group_by(`Department name`, Route_Clean) %>%
        summarise(Patients = n_distinct(`Survey Number`), .groups = "drop") %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = if_else(Total > 0, Patients / Total, 0)
        )
      
      # Hospital-Wide summary
      hospital <- watch_route_summary %>%
        group_by(Route_Clean) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(
          `Department name` = "Hospital-Wide",
          Total = sum(Patients),
          Proportion = if_else(Total > 0, Patients / Total, 0)
        ) %>%
        select(names(watch_route_summary))
      
      watch_route_final <- bind_rows(watch_route_summary, hospital)
      
      # Ensure all department × route combos exist
      route_levels <- c("IV/Oral", "Others")
      route_labels <- c("IV or Oral", "Other Routes")
      all_combos <- expand_grid(
        `Department name` = unique(watch_route_final$`Department name`),
        Route_Clean = route_levels
      )
      
      watch_route_final <- all_combos %>%
        left_join(watch_route_final, by = c("Department name", "Route_Clean")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = if_else(Total > 0, Patients / Total, 0)
        )
      
      # Labels and ordering
      watch_route_final <- watch_route_final %>%
        mutate(
          Indicator = factor(Route_Clean, levels = route_levels, labels = route_labels),
          PlotLabel = ifelse(
            `Department name` == "Hospital-Wide",
            "<b style='color:#0072B2;'>Hospital-Wide</b>",
            `Department name`
          )
        )
      
      label_order <- c(
        "<b style='color:#0072B2;'>Hospital-Wide</b>",
        sort(setdiff(unique(watch_route_final$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>"))
      )
      watch_route_final$PlotLabel <- factor(watch_route_final$PlotLabel, levels = label_order)
      
      # Colours (keep original logic)
      palette <- c(
        "IV or Oral"   = "#3B8EDE",
        "Other Routes" = "#e41a1c"
      )
      
      # Base ggplot (matching third code format exactly)
      p <- ggplot(
        watch_route_final,
        aes(
          x = PlotLabel, y = Proportion, fill = Indicator,
          text = paste0(
            "Department: ", `Department name`, "<br>",
            "Route: ", Indicator, "<br>",
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
          data = watch_route_final %>% distinct(PlotLabel, Total),
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
          fill = "Route"
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
        guides(fill = guide_legend(nrow = 1, byrow = TRUE, title.position = "top"))
      
      # Convert to plotly (matching third code format)
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Route of Administration for WATCH Antibiotics (Upper UTI Patients)</b><br>"
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
      
      plt
    })
    
    # IV Analysis Data
    iv_data_reactive <- reactive({
      if (!check_data()) {
        return(list())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # Filter Upper UTI patients & flag eligibility - matching R Markdown exactly
      data_UUTI <- data_patients %>%
        filter(`Diagnosis code` == "Pye") %>%
        mutate(
          Route = toupper(Route),
          Eligible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      # Keep eligible patients only
      data_UUTI_eligible <- data_UUTI %>%
        filter(Eligible == TRUE)
      
      # Summarise whether IV route was used
      summary_iv <- data_UUTI_eligible %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          Received_IV = any(Route == "P"),
          .groups = "drop"
        )
      
      summary_iv_dept <- summary_iv %>%
        group_by(`Department name`) %>%
        summarise(
          Eligible = n(),
          Received_IV = sum(Received_IV),
          Not_IV = Eligible - Received_IV,
          Prop_IV = round(100 * Received_IV / Eligible, 1),
          Prop_Not = round(100 * Not_IV / Eligible, 1),
          .groups = "drop"
        )
      
      summary_iv_total <- summary_iv %>%
        summarise(
          `Department name` = "Hospital-Wide",
          Eligible = n(),
          Received_IV = sum(Received_IV),
          Not_IV = Eligible - Received_IV,
          Prop_IV = round(100 * Received_IV / Eligible, 1),
          Prop_Not = round(100 * Not_IV / Eligible, 1)
        )
      
      summary_iv_final <- bind_rows(summary_iv_total, summary_iv_dept)
      
      list(
        data_UUTI_eligible = data_UUTI_eligible,
        summary_iv_final = summary_iv_final
      )
    })
    
    # IV Summary
    output$iv_summary <- renderUI({
      iv_data <- iv_data_reactive()
      if(length(iv_data) == 0) {
        return(HTML("<p>No data available</p>"))
      }
      
      summary_iv_final <- iv_data$summary_iv_final
      data_UUTI_eligible <- iv_data$data_UUTI_eligible
      
      # Need to get the TOTAL Upper UTI patients (before eligibility filter)
      # This requires accessing the original data
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # Calculate total Upper UTI patients (before eligibility filtering)
      total_UUTI <- data_patients %>%
        filter(`Diagnosis code` == "Pye") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      # Calculate eligible Upper UTI patients
      eligible_UUTI <- data_UUTI_eligible %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      # Handle case: no eligible Upper UTI patients
      if (eligible_UUTI == 0 || is.na(eligible_UUTI)) {
        return(HTML(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>
      ⚠️ <strong>No summary available</strong> — there are currently no eligible patients with valid IV antibiotic data for <strong>Upper UTIs</strong>.<br><br>
      <em>This may indicate that no patients received antibiotics, or none met inclusion criteria.</em>
      </div>"
        ))
      }
      
      # Build HTML-formatted intro block - NOW WITH "out of" TOTAL
      intro_text <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💉 <strong>Denominator:</strong> Number of eligible Upper UTI patients who received any antibiotic (<strong>", eligible_UUTI, "</strong> out of ", total_UUTI, ")",
        "</div><br><br>"
      )
      
      # Build formatted summary blocks - matching R Markdown exactly
      formatted_blocks3 <- summary_iv_final %>%
        mutate(block = pmap_chr(
          list(`Department name`, Prop_IV, Received_IV, Prop_Not, Not_IV, Eligible),
          function(dept, iv_p, iv_n, not_p, not_n, total_n) {
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            
            paste0(
              "<div style='background-color: ", bg, "; border-left: 5px solid ", color, "; padding: 14px; margin-bottom: 20px;'>",
              "<strong>🏥 ", dept, "</strong> <span style='color: #888;'>(n = ", total_n, " patients)</span><br><br>",
              "<ul style='margin-left: 1.2em; line-height: 1.8; padding-left: 0; list-style-type: none;'>",
              "<li>",
              "<span style='display: inline-block; background-color: #007bff; color: white; border-radius: 50%; width: 22px; height: 22px; text-align: center; line-height: 22px; font-size: 12px; margin-right: 8px;'>1</span>",
              "<strong>Received IV antibiotic</strong>: <strong>", scales::percent(iv_p / 100, accuracy = 0.1), "</strong> (", iv_n, " out of ", total_n, ")",
              "</li>",
              "<li>",
              "<span style='display: inline-block; background-color: #ffc107; color: black; border-radius: 50%; width: 22px; height: 22px; text-align: center; line-height: 22px; font-size: 12px; margin-right: 8px;'>2</span>",
              "<strong>Did not receive IV antibiotic</strong>: <strong>", scales::percent(not_p / 100, accuracy = 0.1), "</strong> (", not_n, " out of ", total_n, ")",
              "</li>",
              "</ul>",
              "</div>"
            )
          }
        ))
      
      # Sort: Hospital-Wide first, then others alphabetically
      formatted_blocks3 <- formatted_blocks3 %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>%
        select(-order)
      
      # Final HTML output
      HTML(paste0(intro_text, paste(formatted_blocks3$block, collapse = "\n")))
    })
    
    # IV Route Plot (Plotly) - stacked bar chart matching the second code style
    output$iv_route_plot <- renderPlotly({
      iv_data <- iv_data_reactive()
      if(length(iv_data) == 0) {
        return(plotly_empty() %>% layout(title = "No eligible data available"))
      }
      
      data_UUTI_eligible <- iv_data$data_UUTI_eligible
      
      # Classify routes - matching R Markdown exactly
      summary_iv_route <- data_UUTI_eligible %>%
        mutate(
          Route_Group = case_when(
            Route == "P" ~ "IV",
            Route == "O" ~ "Oral",
            TRUE ~ "Other"
          )
        ) %>%
        distinct(`Survey Number`, `Department name`, Route_Group) %>%
        count(`Department name`, Route_Group, name = "Count")
      
      dept_list <- unique(data_UUTI_eligible$`Department name`)
      route_levels <- c("IV", "Oral", "Other")
      
      complete_grid <- expand.grid(
        `Department name` = dept_list,
        Route_Group = route_levels,
        stringsAsFactors = FALSE
      )
      
      summary_iv_route <- complete_grid %>%
        left_join(summary_iv_route, by = c("Department name", "Route_Group")) %>%
        mutate(Count = replace_na(Count, 0))
      
      # Add Hospital-wide summary
      hospital_route_summary <- summary_iv_route %>%
        group_by(Route_Group) %>%
        summarise(Count = sum(Count), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      plot_data <- bind_rows(summary_iv_route, hospital_route_summary) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Count),
          Proportion = ifelse(Total == 0, 0, Count / Total)
        ) %>%
        ungroup() %>%
        mutate(
          PlotLabel = ifelse(
            `Department name` == "Hospital-Wide",
            "<b style='color:#0072B2;'>Hospital-Wide</b>",
            `Department name`
          ),
          Route_Group = factor(Route_Group, levels = route_levels)
        )
      
      # Order departments (Hospital-Wide first)
      label_order <- c("<b style='color:#0072B2;'>Hospital-Wide</b>",
                       sort(setdiff(unique(plot_data$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>")))
      plot_data$PlotLabel <- factor(plot_data$PlotLabel, levels = label_order)
      
      # Color palette
      palette <- c(
        "IV" = "#4682B4",
        "Oral" = "#CD5C5C", 
        "Other" = "#A9A9A9"
      )
      
      # Create ggplot
      p <- ggplot(
        plot_data,
        aes(
          x = PlotLabel, y = Proportion, fill = Route_Group,
          text = paste0(
            "Department: ", `Department name`, "<br>",
            "Route: ", Route_Group, "<br>",
            "Count: ", Count, "<br>",
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
          data = plot_data %>% distinct(PlotLabel, Total),
          aes(x = PlotLabel, y = 1.02, label = paste0("n=", Total)),
          inherit.aes = FALSE, size = 3, color = "gray30", hjust = 0.5
        ) +
        scale_fill_manual(
          values = palette,
          labels = c("IV" = "IV", 
                     "Oral" = "Oral",
                     "Other" = "Other"),
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
          axis.title  = element_text(face = "bold", size = 10),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text  = element_text(size = 8),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          plot.margin  = margin(6, 8, 6, 8)
        ) +
        guides(fill = guide_legend(nrow = 1, byrow = TRUE, title.position = "top"))
      
      # Convert to plotly
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Route of Antibiotic Use by Department (Upper UTI)</b><br>"
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
    
    # Complete the module server closure
  })
}