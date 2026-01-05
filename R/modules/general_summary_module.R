# ============================================================
# General Summary Module - Complete R Markdown Aligned Implementation
# ============================================================

# library(stringr)

# -------------------------
# Department Analysis Tab UI
# -------------------------
generalDepartmentUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Reminder of QI Eligibility"),  # two-line label
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
            Shiny.setInputValue('navigate_to_overview', Math.random(), {priority: 'event'});
            window.scrollTo({top: 0, behavior: 'smooth'});
          ")
             )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            div(class = "error-box",
                h4("⚠️ No Data Uploaded"),
                p("Please upload your data files to view department analysis.")
            )
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        valueBoxOutput(ns("total_admitted"), width = 3),
        valueBoxOutput(ns("total_treated"), width = 3),
        valueBoxOutput(ns("total_antibiotics"), width = 3),
        valueBoxOutput(ns("treatment_rate"), width = 3)
      ),
      
      fluidRow(
        box(
          title = "Patient Distribution by Department Type", 
          status = "primary", 
          solidHeader = TRUE,
          width = 6,
          plotlyOutput(ns("dept_type_chart"), height = "295px")
        ),
        box(
          title = "Patient Distribution by Activity Code", 
          status = "primary", 
          solidHeader = TRUE,
          width = 6,
          plotlyOutput(ns("activity_chart"), height = "295px")
        )
      )
    )
  )
}

# -------------------------
# Overall Diagnosis and Antibiotic Use Tab UI - Tight Box Version
# -------------------------
generalDiagnosisAntibioticUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Custom CSS for compact box and table spacing
    tags$head(
      tags$style(HTML("
        .box {
          background-color: white !important;
          margin-bottom: 5px !important; /* reduce bottom space between boxes */
        }
        .box-body, .tab-content, .nav-tabs-custom, .tab-pane {
          background-color: white !important;
        }
        /* Tighten spacing inside boxes */
        .box-body {
          padding: 5px 10px 5px 10px !important; /* minimal bottom padding */
        }
        .tab-content {
          padding: 5px 10px 5px 10px !important; /* reduce bottom padding */
        }
        .tab-pane {
          margin-bottom: 0px !important;
          padding-bottom: 0px !important;
        }
        /* Bring table closer to box edges */
        .dataTables_wrapper {
          margin-top: 0px !important;
          margin-bottom: 0px !important;
        }
        .dataTables_info {
          margin-bottom: 0px !important;
        }
      "))
    ),
    
    # Back Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Reminder of QI Eligibility"),
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
                   Shiny.setInputValue('navigate_to_overview', Math.random(), {priority: 'event'});
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
                 p("Please upload your data files to view the Overall Diagnosis and Antibiotic Use Summary.")
               )
        )
      )
    ),
    
    # Main Content when data is uploaded
    conditionalPanel(
      condition = "output.dataUploaded == true",
      
      # Overview Section
      fluidRow(
        column(10, offset = 1,
               box(
                 width = 12,
                 title = "📊 Overall Diagnosis and Antibiotic Use Summary",
                 status = "primary",
                 solidHeader = TRUE,
                 p("This section provides a comprehensive summary of treated patients and antibiotic prescriptions by diagnosis code, highlighting QI-eligible patients.")
               )
        )
      ),
      
      # Two Tables - Treated Patients and Antibiotic Prescriptions
      fluidRow(
        column(10, offset = 1,
               box(
                 width = 12,
                 title = tagList(icon("table"), " Diagnosis and Antibiotic Use Data"),
                 status = "info",
                 solidHeader = TRUE,
                 
                 tabsetPanel(
                   id = ns("diagnosis_tabs"),
                   type = "tabs",
                   
                   # Tab 1: Treated Patients
                   tabPanel(
                     tagList(icon("user-md"), " Treated Patients by Diagnosis"),
                     div(
                       style = "background-color: white; padding: 5px 5px 0px 5px;",  # minimal bottom padding
                       p("This table summarizes all patients treated by diagnosis code, including QI-eligible cases."),
                       div(
                         style = "overflow-x: auto; background-color: white; padding: 0px 2px 0px 2px;",
                         withSpinner(
                           DTOutput(ns("treated_patients_table")),
                           type = 4
                         )
                       )
                     )
                   ),
                   
                   # Tab 2: Antibiotic Prescriptions
                   tabPanel(
                     tagList(icon("pills"), " Antibiotic Prescriptions by Diagnosis"),
                     div(
                       style = "background-color: white; padding: 5px 5px 0px 5px;",
                       p("This table provides antibiotic prescription data by diagnosis, allowing comparison of treatment frequency and prescribing trends."),
                       div(
                         style = "overflow-x: auto; background-color: white; padding: 0px 2px 0px 2px;",
                         withSpinner(
                           DTOutput(ns("antibiotic_prescriptions_table")),
                           type = 4
                         )
                       )
                     )
                   )
                 )
               )
        )
      )
    )
  )
}




# -------------------------
# Patient Summary Tab UI
# -------------------------
generalPatientSummaryUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Reminder of QI Eligibility"),  # two-line label
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
            Shiny.setInputValue('navigate_to_overview', Math.random(), {priority: 'event'});
            window.scrollTo({top: 0, behavior: 'smooth'});
          ")
             )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view patient and prescription summary.")
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               h3("Overall summary of antibiotic use by AWaRe Classification", style = "text-align: center; margin-bottom: 10px;"),
               div(class = "note-box",
                   strong("💡 Note:"), "Eligible patients are adults on empirical antibiotics for predefined community-acquired infections or for surgical prophylaxis."
               )
        )
      ),
      
      # Hospital-Wide Summary Box
      fluidRow(
        uiOutput(ns("hospital_wide_summary"))
      ),
      column(10, offset = 1,
             div(class = "note-box",
                 strong("💡 Note:"), "The AWaRe classification divides antibiotics into three categories: Access, Watch, and Reserve. Access antibiotics are first-line treatments with a low risk of resistance, typically recommended for common infections. Watch antibiotics are associated with a higher risk of resistance and require careful monitoring. Reserve antibiotics are reserved for critical cases involving resistant infections, typically used only when other options are ineffective."
             )
      ),
      
      # Ward Summary Boxes
      uiOutput(ns("ward_summary_boxes"))
    )
  )
}

# -------------------------
# Diagnostic Analysis Tab UI (CENTERED)
# -------------------------
generalDiagnosticUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Reminder of QI Eligibility"),  # two-line label
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
            Shiny.setInputValue('navigate_to_overview', Math.random(), {priority: 'event'});
            window.scrollTo({top: 0, behavior: 'smooth'});
          ")
             )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view diagnostic analysis.")
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "Condition-specific summary of antibiotic use by AWaRe Classification",
            status = "primary", solidHeader = TRUE, 
            p("This plot provides a general summary of antibiotic prescriptions across pre-defined diagnostic groups, regardless of age, indication, or type of treatment"),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("diagnostic_plot"), height = "450px", width = "100%"),
                  type = 4
                ))
          )
        )
      )
    )
  )
}

# -------------------------
# Department Heatmap Tab UI (CENTERED)
# -------------------------
generalDeptHeatmapUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Reminder of QI Eligibility"),  # two-line label
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
            Shiny.setInputValue('navigate_to_overview', Math.random(), {priority: 'event'});
            window.scrollTo({top: 0, behavior: 'smooth'});
          ")
             )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view department heatmap.")
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "Condition- and department-specific summary of antibiotic use by AWaRe Classification",
            status = "primary", solidHeader = TRUE,
            p("This plot provides a general summary of antibiotic prescriptions for pre-defined diagnostic groups and across different departments, regardless of age, indication, or type of treatment"),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("dept_heatmap_plot"), height = "520px", width = "100%"),
                  type = 4
                ))
          )
        )
      )
      
    )
  )
}

# -------------------------
# Age Patterns Tab UI (CENTERED)
# -------------------------
generalAgePatternsUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Reminder of QI Eligibility"),  # two-line label
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
            Shiny.setInputValue('navigate_to_overview', Math.random(), {priority: 'event'});
            window.scrollTo({top: 0, behavior: 'smooth'});
          ")
             )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view age patterns.")
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "Treatment & Indication Patterns Across Age",
            status = "primary", solidHeader = TRUE, 
            p("This heatmap summarises the distribution across treatment types (empirical, targeted) and indications (CAI, HAI), separated by age groups."),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("age_patterns_plot"), height = "400px", width = "100%"),
                  type = 4
                ))
            ,
            br(),
            div(
              class = "note-box",
              style = "background-color: white; padding: 10px; border-radius: 5px; border-left: 4px solid #3498db;",
              strong("💡 Note:"), 
              "QI-eligible patients for the analysis are only adult patients on empiric treatment for community acquired infection (for the 7 predefined conditions)"
            )
          )
        )
        
      )
    )
  )
}

# -------------------------
# Prophylaxis Analysis Tab UI (CENTERED)
# -------------------------
generalProphylaxisUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Back to Clinical Conditions Button
    fluidRow(
      column(12,
             div(
               style = "text-align: right; margin-bottom: 10px;",
               actionButton(
                 ns("back_to_eligible"), 
                 HTML("← Reminder of QI Eligibility"),  # two-line label
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
            Shiny.setInputValue('navigate_to_overview', Math.random(), {priority: 'event'});
            window.scrollTo({top: 0, behavior: 'smooth'});
          ")
             )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == false",
      fluidRow(
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view prophylaxis analysis.")
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(
          10, offset = 1,
          box(
            width = 12, title = "Age-Specific Prophylaxis Patterns",
            status = "primary", solidHeader = TRUE,
            p("This section summarises prophylaxis indications (Surgical, Medical, Other, Unknown) across adult and pediatric patients."),
            div(style = "
              display: flex; 
              justify-content: center; 
              align-items: center; 
              max-width: 100%; 
              overflow: hidden;
            ",
                withSpinner(
                  plotlyOutput(ns("prophylaxis_plot"), height = "400px", width = "100%"),
                  type = 4
                ))
            ,
            br(),
            div(
              class = "note-box",
              style = "background-color: white; padding: 10px; border-radius: 5px; border-left: 4px solid #3498db;",
              strong("💡 Note:"), 
              "only patients on surgical prophylaxis in adults are QI-eligible for the analysis"
            )
          )
        )
      )
    )
  )
}

# -------------------------
# Helper Functions for Data Processing (EXACTLY FROM R MARKDOWN)
# -------------------------

# Function to calculate patient metrics (EXACTLY from R Markdown)
calculate_patient_metrics <- function(dataset) {
  AWaRe_abx <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
  
  bind_rows(
    dataset %>% summarise(Metric = "Total Patients Given **Antimicrobials**", Count = n_distinct(`Survey Number`)),
    dataset %>% filter(AWaRe %in% AWaRe_abx) %>%
      summarise(Metric = "Total Patients Given **Antibiotics**", Count = n_distinct(`Survey Number`)),
    dataset %>% group_by(`Department type`) %>%
      summarise(Metric = "Patients Given **Antibiotics**", Count = n_distinct(`Survey Number`), .groups = "drop"),
    
    dataset %>% filter(grepl("Access", AWaRe, ignore.case = TRUE)) %>%
      summarise(Metric = "Patients Given **Access** Antibiotics", Count = n_distinct(`Survey Number`)),
    dataset %>% filter(grepl("Access", AWaRe, ignore.case = TRUE)) %>%
      group_by(`Department type`) %>%
      summarise(Metric = "Patients Given **Access** Antibiotics", Count = n_distinct(`Survey Number`), .groups = "drop"),
    
    dataset %>% filter(grepl("Watch", AWaRe, ignore.case = TRUE)) %>%
      summarise(Metric = "Patients Given **Watch** Antibiotics", Count = n_distinct(`Survey Number`)),
    dataset %>% filter(grepl("Watch", AWaRe, ignore.case = TRUE)) %>%
      group_by(`Department type`) %>%
      summarise(Metric = "Patients Given **Watch** Antibiotics", Count = n_distinct(`Survey Number`), .groups = "drop"),
    
    dataset %>% filter(grepl("Reserve", AWaRe, ignore.case = TRUE)) %>%
      summarise(Metric = "Patients Given **Reserve** Antibiotics", Count = n_distinct(`Survey Number`)),
    dataset %>% filter(grepl("Reserve", AWaRe, ignore.case = TRUE)) %>%
      group_by(`Department type`) %>%
      summarise(Metric = "Patients Given **Reserve** Antibiotics", Count = n_distinct(`Survey Number`), .groups = "drop"),
    
    dataset %>% filter(grepl("Not recommended", AWaRe, ignore.case = TRUE)) %>%
      summarise(Metric = "Patients Given **Not Recommended** Antibiotics", Count = n_distinct(`Survey Number`)),
    dataset %>% filter(grepl("Not recommended", AWaRe, ignore.case = TRUE)) %>%
      group_by(`Department type`) %>%
      summarise(Metric = "Patients Given **Not Recommended** Antibiotics", Count = n_distinct(`Survey Number`), .groups = "drop")
  ) %>%
    rename(Ward = `Department type`) %>%
    mutate(Ward = replace_na(Ward, "Hospital-Wide"))
}

# Function to calculate prescription metrics (EXACTLY from R Markdown)
calculate_prescription_metrics <- function(dataset) {
  AWaRe_abx <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
  
  bind_rows(
    dataset %>% summarise(Metric = "Total **Antimicrobial** Prescriptions", Count = n()),
    dataset %>% filter(AWaRe %in% AWaRe_abx) %>%
      summarise(Metric = "Total **Antibiotics** Prescriptions", Count = n()),
    dataset %>% group_by(`Department type`) %>%
      summarise(Metric = "Total **Antibiotics** Prescriptions", Count = n(), .groups = "drop"),
    
    dataset %>% filter(grepl("Access", AWaRe, ignore.case = TRUE)) %>%
      summarise(Metric = "**Access** Antibiotics", Count = n()),
    dataset %>% filter(grepl("Access", AWaRe, ignore.case = TRUE)) %>%
      group_by(`Department type`) %>%
      summarise(Metric = "**Access** Antibiotics", Count = n(), .groups = "drop"),
    
    dataset %>% filter(grepl("Watch", AWaRe, ignore.case = TRUE)) %>%
      summarise(Metric = "**Watch** Antibiotics", Count = n()),
    dataset %>% filter(grepl("Watch", AWaRe, ignore.case = TRUE)) %>%
      group_by(`Department type`) %>%
      summarise(Metric = "**Watch** Antibiotics", Count = n(), .groups = "drop"),
    
    dataset %>% filter(grepl("Reserve", AWaRe, ignore.case = TRUE)) %>%
      summarise(Metric = "**Reserve** Antibiotics", Count = n()),
    dataset %>% filter(grepl("Reserve", AWaRe, ignore.case = TRUE)) %>%
      group_by(`Department type`) %>%
      summarise(Metric = "**Reserve** Antibiotics", Count = n(), .groups = "drop"),
    
    dataset %>% filter(grepl("Not recommended", AWaRe, ignore.case = TRUE)) %>%
      summarise(Metric = "**Not Recommended** Antibiotics", Count = n()),
    dataset %>% filter(grepl("Not recommended", AWaRe, ignore.case = TRUE)) %>%
      group_by(`Department type`) %>%
      summarise(Metric = "**Not Recommended** Antibiotics", Count = n(), .groups = "drop")
  ) %>%
    rename(Ward = `Department type`) %>%
    mutate(Ward = replace_na(Ward, "Hospital-Wide"))
}

# -------------------------
# Module Server - Handles all general summary tabs
# -------------------------
generalSummaryServer <- function(id, data_reactive) {
  moduleServer(id, function(input, output, session) {
    
    # Constants - EXACTLY ALIGNED WITH R MARKDOWN
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
    surgical_indications <- c("SP", "SP1", "SP2", "SP3")
    HAI_terms <- c("HAI1","HAI2","HAI2-CVC-BSI","HAI2-PVC-BSI","HAI2-VAP","HAI2-CAUTI",
                   "HAI3","HAI4","HAI4-BSI","HAI4-HAP","HAI4-UTI","HAI5","HAI6")
    SP_prophylaxis_terms <- c("SP", "SP1", "SP2", "SP3")
    
    # Apply R Markdown data preprocessing - EXACT MATCH
    processed_data <- reactive({
      data <- data_reactive()
      req(data)
      
      data_patients <- data$data_patients
      
      # Apply EXACT same preprocessing as R Markdown
      data_patients <- data_patients %>%
        # Standardised Proph codes to make it easier in coding
        mutate(
          `Diagnosis code` = ifelse(
            Indication %in% c("SP1", "SP2", "SP3"),
            "Proph",
            `Diagnosis code`
          )
        ) %>%
        # Fix NOT_RECOMMENDED to NOT RECOMMENDED
        mutate(
          AWaRe = ifelse(
            toupper(AWaRe) == "NOT_RECOMMENDED",
            "NOT RECOMMENDED",
            AWaRe
          )
        )
      
      # Make all empty spaces to N/A (R Markdown logic)
      data_patients[data_patients == ""] <- NA
      
      return(list(
        data_patients = data_patients,
        data_deps = data$data_deps
      ))
    })
    
    # -------------------------
    # FIXED: Define data_qi as a reactive for reuse across outputs
    # -------------------------
    data_qi <- reactive({
      data <- processed_data()
      req(data)
      data_patients <- data$data_patients
      
      data_patients %>%
        mutate(
          AWaRe_compatible = case_when(
            # Surgical prophylaxis cases
            startsWith(`Diagnosis code`, "Proph") &
              Indication %in% surgical_indications &
              `Age years` >= 18 &
              Treatment == "EMPIRICAL" ~ TRUE,
            # Community-acquired infection (CAI) cases
            !startsWith(`Diagnosis code`, "Proph") &
              `Diagnosis code` %in% names(diagnostic_labels) &
              Indication == "CAI" &
              `Age years` >= 18 &
              Treatment == "EMPIRICAL" ~ TRUE,
            TRUE ~ FALSE
          )
        )
    })
    
    # Helper function to check if data is available
    check_data <- function() {
      data <- processed_data()
      return(!is.null(data) && !is.null(data$data_patients))
    }
    
    # Output to control conditional panels
    output$dataUploaded <- reactive({ check_data() })
    outputOptions(output, "dataUploaded", suspendWhenHidden = FALSE)
    
    # -------------------------
    # Department Analysis Outputs
    # -------------------------
    output$total_admitted <- renderValueBox({
      data <- processed_data(); req(data)
      total <- sum(data$data_deps$Patients, na.rm = TRUE)
      valueBox(
        value = formatC(total, format = "d", big.mark = ","),
        subtitle = HTML("Total Admitted Patients<br><small style='font-size: 0.8em;'>&nbsp;</small>"),
        icon = icon("hospital"),
        color = "blue",
        width = 3
      )
    })
    
    output$total_treated <- renderValueBox({
      data <- processed_data(); req(data)
      data_patients <- data$data_patients
      total <- n_distinct(data_patients$`Survey Number`)
      valueBox(
        value = formatC(total, format = "d", big.mark = ","),
        subtitle = HTML("Total Patients<br>on Antimicrobials"),
        icon = icon("syringe"),
        color = "green",
        width = 3
      )
    })
    
    output$total_antibiotics <- renderValueBox({
      data <- processed_data(); req(data)
      data_patients <- data$data_patients
      
      total_abx <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx) %>%
        summarise(unique_patients = n_distinct(`Survey Number`)) %>%
        pull(unique_patients)
      
      valueBox(
        value = formatC(total_abx, format = "d", big.mark = ","),
        subtitle = HTML("Total Patients on Antibiotics<br><small style='font-size: 0.8em;'>&nbsp;</small>"),
        icon = icon("capsules"),
        color = "red",
        width = 3
      )
    })
    
    # Value Box: Treatment Rate (Antibiotics)
    output$treatment_rate <- renderValueBox({
      data <- processed_data(); req(data)
      data_patients <- data$data_patients
      total_admitted <- sum(data$data_deps$Patients, na.rm = TRUE)
      #total_treated  <- n_distinct(data_patients$`Survey Number`)
      total_abx <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx) %>%
        summarise(unique_patients = n_distinct(`Survey Number`)) %>%
        pull(unique_patients)
        
      rate <- if (total_admitted > 0) round((total_abx / total_admitted) * 100, 1) else 0
      
      valueBox(
        value = paste0(rate, "%"),
        subtitle = HTML("Proportion of Patient<br>on Antibiotics"),
        icon = icon("percentage"),
        color = "yellow",
        width = 3
      )
    })
    
    
    # Value Box: Treatment Rate (Antibiotics)
    #output$treatment_rate <- renderValueBox({
    #  data <- processed_data(); req(data)
    #  data_patients <- data$data_patients
    #  total_admitted <- sum(data$data_deps$Patients, na.rm = TRUE)
    #  total_treated  <- n_distinct(data_patients$`Survey Number`)
    #  rate <- if (total_admitted > 0) round((total_treated / total_admitted) * 100, 1) else 0
    
    # valueBox(
    #   value = paste0(rate, "%"),
    #   subtitle = HTML("Proportion of Patients<br><b>Treated with Antimicrobials</b>"),
    #   icon = icon("percentage"),
    #    color = "yellow",
    #   width = 3
    # )
    #})
    
    
    
    # Chart: Type Distribution (Antibiotic Treatment)
    output$dept_type_chart <- renderPlotly({
      data <- processed_data(); req(data)
      
      # Department abbreviation function
      create_abbreviation <- function(dept_name) {
        dept_clean <- dept_name %>%
          str_remove_all("(?i)\\b(or|and|the|of|in|at|to|for|with|by|department)\\b") %>%
          str_replace_all("-", " ") %>%
          str_split("\\s+") %>%
          unlist() %>%
          .[. != ""] %>%
          str_sub(1, 1) %>%
          toupper() %>%
          paste0(collapse = "")
        
        if (nchar(dept_clean) < 2) {
          main_word <- str_extract(dept_name, "\\b\\w{3,}\\b")
          if (!is.na(main_word)) dept_clean <- toupper(str_sub(main_word, 1, 4))
          else dept_clean <- toupper(str_sub(dept_name, 1, 4))
        }
        if (nchar(dept_clean) > 6) dept_clean <- str_sub(dept_clean, 1, 6)
        return(dept_clean)
      }
      
      # 1️⃣ Summarize admitted patients per Department type
      dept_summary <- data$data_deps %>%
        group_by(`Department type`) %>%
        summarise(
          Admitted = sum(Patients, na.rm = TRUE),
          .groups = "drop"
        )
      
      # 2️⃣ Summarize unique patients treated with ABX per Department type
      abx_by_dept <- data$data_patients %>%
        filter(AWaRe %in% AWaRe_abx) %>%
        group_by(`Department type`) %>%
        summarise(
          Treated_with_ABX = n_distinct(`Survey Number`),
          .groups = "drop"
        )
      
      # 3️⃣ Combine both summaries
      dept_summary <- dept_summary %>%
        left_join(abx_by_dept, by = "Department type") %>%
        mutate(
          Treated_with_ABX = replace_na(Treated_with_ABX, 0)
        ) %>%
        pivot_longer(
          cols = c(Admitted, Treated_with_ABX),
          names_to = "Type",
          values_to = "Count"
        ) %>%
        mutate(
          # ✅ Rename "Treated_with_ABX" to a cleaner label for legend & plot
          Type = if_else(Type == "Treated_with_ABX", "Treated With Antibiotics", Type)
        )
      
      # 4️⃣ Create department abbreviations
      unique_depts <- unique(dept_summary$`Department type`)
      dept_abbreviations <- tibble(
        full_name = unique_depts,
        abbreviated = map_chr(unique_depts, create_abbreviation)
      )
      
      dept_summary <- dept_summary %>%
        left_join(dept_abbreviations, by = c("Department type" = "full_name")) %>%
        mutate(
          abbreviated = ifelse(is.na(abbreviated), `Department type`, abbreviated),
          dept_original = `Department type`
        )
      
      # Main plot
      p <- ggplot(dept_summary, aes(
        x = abbreviated, y = Count, fill = Type,
        text = paste0("Ward: ", dept_original, "\n",
                      "Type: ", Type, "\n",
                      "Patients: ", scales::comma(Count))
      )) +
        geom_bar(stat = "identity", position = "dodge", width = 0.68) +
        geom_text(aes(label = scales::comma(Count)),
                  position = position_dodge(width = 0.68),
                  vjust = -0.5, size = 2.2) +
        scale_fill_manual(values = c("Admitted" = "#3498db", "Treated With Antibiotics" = "#D35442")) +
        labs(
          x = NULL,  # Leave x-axis title blank
          y = "Patients",
          fill = NULL # Remove legend title
        ) +
        theme_minimal(base_size = 8.5) +
        theme(
          axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 6),
          axis.text.y = element_text(size = 7),
          axis.title = element_text(size = 8),
          legend.position = "bottom"
        )
      
      # Abbreviation legend
      dept_legend_data <- dept_summary %>%
        select(dept_original, abbreviated) %>%
        distinct() %>%
        arrange(dept_original) %>%
        mutate(display_item = paste0("<b>", abbreviated, ":</b> ", dept_original))
      
      legend_items <- dept_legend_data$display_item
      legend_rows <- split(legend_items, ceiling(seq_along(legend_items) / 2))
      legend_text <- paste(sapply(legend_rows, function(row) paste(row, collapse = "     ")), collapse = "<br>")
      
      ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>Depatment Type Distribution</b><br><span style='font-size:11px;'>Patients admitted vs. Patients on Antibiotics</span>",
            x = 0.5, 
            xanchor = "center",
            y = 0.92,
            yanchor = "top",
            font = list(size = 15)
          ),
          height = 300,
          margin = list(t = 70, r = 8, b = 100, l = 45),
          legend = list(
            orientation = "h",
            x = 0.5,
            xanchor = "center",
            y = -0.22,
            font = list(size = 7.5)
          ),
          xaxis = list(title = list(text = "")),  # blank x-axis title
          yaxis = list(
            automargin = TRUE,
            title = list(font = list(size = 8))
          ),
          annotations = list(
            list(
              text = paste0("<b>Abbreviations:</b><br>", legend_text),
              showarrow = FALSE,
              xref = "paper", yref = "paper",
              x = 0.5, y = -0.38,
              xanchor = "center", yanchor = "top",
              font = list(size = 7)
            )
          )
        )
    })
    
    
    
    
    # Chart: Activity Code Distribution
    
    output$activity_chart <- renderPlotly({
      data <- processed_data(); req(data)
      
      # 1️⃣ Extract both datasets
      data_deps <- data$data_deps
      data_patients <- data$data_patients
      
      # 2️⃣ Calculate unique patients treated with antibiotics (per Activity)
      abx_by_activity <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx) %>%
        group_by(Activity) %>%
        summarise(
          Treated_with_ABX = n_distinct(`Survey Number`),
          .groups = "drop"
        )
      
      # 3️⃣ Calculate total admitted patients (per Activity code)
      admitted_by_activity <- data_deps %>%
        group_by(`Activity code`) %>%
        summarise(
          Admitted = sum(Patients, na.rm = TRUE),
          .groups = "drop"
        )
      
      # 4️⃣ Join both summaries using matching activity code columns
      combined_activity <- admitted_by_activity %>%
        left_join(abx_by_activity, by = c("Activity code" = "Activity")) %>%
        mutate(
          Treated_with_ABX = replace_na(Treated_with_ABX, 0),
          Activity_Label = case_when(
            `Activity code` %in% c("IC", "I") ~ "ICU",
            `Activity code` == "S" ~ "Surgical",
            `Activity code` == "M" ~ "Medical",
            TRUE ~ "Unknown"
          )
        ) %>%
        pivot_longer(
          cols = c(Admitted, Treated_with_ABX),
          names_to = "Type",
          values_to = "Count"
        ) %>%
        mutate(
          # Rename for display clarity
          Type = if_else(Type == "Treated_with_ABX", "Treated With Antibiotics", Type)
        )
      
      # 5️⃣ Create the plot
      p <- ggplot(combined_activity, aes(x = Activity_Label, y = Count, fill = Type)) +
        geom_bar(stat = "identity", position = "dodge", width = 0.68) +
        geom_text(aes(label = scales::comma(Count)), 
                  position = position_dodge(width = 0.68), 
                  vjust = -0.5, size = 2.5) +
        scale_fill_manual(values = c("Admitted" = "#3498db", "Treated With Antibiotics" = "#D35442")) +
        labs(
          title = paste0(
            "<b>Department Type Distribution</b><br>",
            "<span style='font-size:11px; font-weight:normal;'>Patients admitted vs. Patients on Antibiotics</span>"
          ),
          x = NULL,   # ⬅️ Remove "Activity Type" label
          y = "Patients",
          fill = NULL # ⬅️ Remove legend title
        ) +
        theme_minimal(base_size = 9.5) +
        theme(
          plot.title = element_markdown(hjust = 0.5, size = 12),
          axis.text.x = element_text(size = 8),
          legend.position = "bottom"
        )
      
      ggplotly(p, tooltip = c("x","y","fill")) %>%
        layout(
          height = 280,
          margin = list(t = 50, r = 6, b = 50, l = 40),
          legend = list(
            orientation = "h",
            x = 0.5, xanchor = "center", y = -0.35,
            font = list(size = 9),
            title = list(text = NULL)
          ),
          xaxis = list(automargin = TRUE, title = list(text = NULL)),  # ⬅️ Ensure x-axis title gone
          yaxis = list(automargin = TRUE)
        )
    })
    
    
    # -------------------------
    # Overall Diagnosis and Antibiotic Use Outputs - FIXED
    # -------------------------
    
    # Table 1: Treated Patients by Diagnosis Code - FIXED
    output$treated_patients_table <- renderDT({
      data <- processed_data(); req(data)
      data_patients <- data$data_patients
      data_qi_df <- data_qi()
      
      # === Step 1: Get QI-eligible patient counts by diagnosis ===
      qi_eligible_counts <- data_qi_df %>%
        filter(AWaRe_compatible) %>%
        group_by(`Diagnosis code`) %>%
        summarise(
          `QI eligible treated patients` = n_distinct(`Survey Number`),
          .groups = "drop"
        )
      
      # === Step 2: Summarize ALL patients by Diagnosis Code ===
      summary_table <- data_patients %>%
        group_by(`Diagnosis code`) %>%
        summarise(
          `Total treated patients` = n_distinct(`Survey Number`),
          .groups = "drop"
        ) %>%
        # === Step 3: Join with QI-eligible counts ===
        left_join(qi_eligible_counts, by = "Diagnosis code") %>%
        mutate(
          `QI eligible treated patients` = replace_na(`QI eligible treated patients`, 0)
        ) %>%
        arrange(desc(`Total treated patients`))
      
      # === Step 4: Add Overall Total row ===
      summary_table <- summary_table %>%
        bind_rows(
          tibble(
            `Diagnosis code` = "Overall Total",
            `Total treated patients` = n_distinct(data_patients$`Survey Number`),
            `QI eligible treated patients` = n_distinct(data_qi_df$`Survey Number`[data_qi_df$AWaRe_compatible])
          )
        )
      
      # === Step 5: Render as an interactive datatable (no export buttons) ===
      datatable(
        summary_table,
        rownames = FALSE,
        options = list(
          pageLength = 10,
          autoWidth = TRUE,
          dom = 't<"bottom"ip>',  # simple table + pagination
          initComplete = JS(
            "function(settings, json) {",
            "$(this.api().table().header()).css({'background-color': '#f5f5f5', 'font-weight': 'bold'});",
            "}"
          )
        ),
        caption = htmltools::tags$caption(
          style = 'caption-side: top; text-align: left; font-weight: bold;',
          "Treated Patients by Diagnosis Code",
          htmltools::tags$br(),
          htmltools::tags$span(
            style = 'font-weight: normal; font-size: 12px;',
            "Counts of all treated patients and QI-eligible treated patients (unique survey IDs)"
          )
        )
      ) %>%
        formatStyle(
          'Diagnosis code',
          target = 'row',
          fontWeight = styleEqual("Overall Total", "bold")
        ) %>%
        formatRound(
          columns = c('Total treated patients', 'QI eligible treated patients'),
          digits = 0
        )
    })
    
    # Table 2: Antibiotic Prescriptions by Diagnosis Code - ALREADY CORRECT
    output$antibiotic_prescriptions_table <- renderDT({
      data <- processed_data(); req(data)
      data_patients <- data$data_patients
      data_qi_df <- data_qi()
      
      # === Step 1: Identify QI-eligible patient IDs ===
      qi_eligible_ids <- data_qi_df %>%
        filter(AWaRe_compatible) %>%
        pull(`Survey Number`) %>%
        unique()
      
      # === Step 2: Build the summary table with correct QI-eligible counts ===
      abx_summary <- data_patients %>%
        group_by(`Diagnosis code`) %>%
        summarise(
          `Overall antimicrobials prescribed` = n(),
          `Overall antibiotics prescribed` = sum(AWaRe %in% AWaRe_abx, na.rm = TRUE),
          `Antibiotics prescribed for QI eligible patients` = sum(
            (`Survey Number` %in% qi_eligible_ids) & (AWaRe %in% AWaRe_abx),
            na.rm = TRUE
          ),
          .groups = "drop"
        ) %>%
        arrange(desc(`Overall antimicrobials prescribed`)) %>%
        bind_rows(
          tibble(
            `Diagnosis code` = "Overall Total",
            `Overall antimicrobials prescribed` = nrow(data_patients),
            `Overall antibiotics prescribed` = sum(data_patients$AWaRe %in% AWaRe_abx, na.rm = TRUE),
            `Antibiotics prescribed for QI eligible patients` = sum(
              (data_patients$`Survey Number` %in% qi_eligible_ids) &
                (data_patients$AWaRe %in% AWaRe_abx),
              na.rm = TRUE
            )
          )
        )
      
      # === Step 3: Render as an interactive datatable (no export buttons) ===
      datatable(
        abx_summary,
        rownames = FALSE,
        options = list(
          pageLength = 10,
          autoWidth = TRUE,
          dom = 't<"bottom"ip>',  # simple table layout, no buttons
          initComplete = JS(
            "function(settings, json) {",
            "$(this.api().table().header()).css({'background-color': '#f5f5f5', 'font-weight': 'bold'});",
            "}"
          )
        ),
        caption = htmltools::tags$caption(
          style = 'caption-side: top; text-align: left; font-weight: bold;',
          "Antimicrobial and Antibiotic Prescriptions by Diagnosis Code",
          htmltools::tags$br(),
          htmltools::tags$span(
            style = 'font-weight: normal; font-size: 12px;',
            "Counts of all antimicrobials, antibiotics, and antibiotics prescribed for QI-eligible patients"
          )
        )
      ) %>%
        formatStyle(
          'Diagnosis code',
          target = 'row',
          fontWeight = styleEqual("Overall Total", "bold")
        ) %>%
        formatRound(
          columns = c(
            'Overall antimicrobials prescribed',
            'Overall antibiotics prescribed',
            'Antibiotics prescribed for QI eligible patients'
          ),
          digits = 0
        )
    })
    
    
    # -------------------------
    # Patient Summary Outputs - EXACTLY MATCHING R MARKDOWN
    # -------------------------
    output$hospital_wide_summary <- renderUI({
      data <- processed_data(); req(data)
      data_patients <- data$data_patients
      
      # EXACT filtering logic from R Markdown
      filtered_data_patients <- data_patients %>%
        dplyr::filter(
          `Diagnosis code` %in% c("SEPSIS", "CNS", "Pneu", "IA", "Pye", "SST", "BJ", "Proph"),
          AWaRe %in% AWaRe_abx,
          Indication %in% c("CAI", "SP", "SP1", "SP2", "SP3"),
          Treatment == "EMPIRICAL",
          `Age years` >= 18
        )
      
      # Hospital-wide calculations
      ward_data_full <- data_patients %>%
        dplyr::filter(AWaRe %in% AWaRe_abx) 
      ward_data_filtered <- filtered_data_patients
      
      total_patients <- dplyr::n_distinct(ward_data_full$`Survey Number`)
      qi_patients <- dplyr::n_distinct(ward_data_filtered$`Survey Number`)
      total_prescriptions <- nrow(ward_data_full)
      qi_prescriptions <- nrow(ward_data_filtered)
      
      # Calculate AWaRe counts for full dataset - EXACT R MARKDOWN LOGIC
      access_patients_full <- ward_data_full %>%
        dplyr::filter(grepl("Access", AWaRe, ignore.case = TRUE)) %>%
        dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>%
        dplyr::pull(n)
      watch_patients_full  <- ward_data_full %>%
        dplyr::filter(grepl("Watch",  AWaRe, ignore.case = TRUE)) %>%
        dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>%
        dplyr::pull(n)
      reserve_patients_full<- ward_data_full %>%
        dplyr::filter(grepl("Reserve",AWaRe, ignore.case = TRUE)) %>%
        dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>%
        dplyr::pull(n)
      not_rec_patients_full<- ward_data_full %>%
        dplyr::filter(grepl("Not recommended", AWaRe, ignore.case = TRUE)) %>%
        dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>%
        dplyr::pull(n)
      unclass_patients_full<- ward_data_full %>%
        dplyr::filter(AWaRe == "UNCLASSIFIED" | is.na(AWaRe)) %>%
        dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>%
        dplyr::pull(n)
      
      # Calculate AWaRe counts for eligible dataset - EXACT R MARKDOWN LOGIC
      access_patients_qi <- ward_data_filtered %>%
        dplyr::filter(grepl("Access", AWaRe, ignore.case = TRUE)) %>%
        dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>%
        dplyr::pull(n)
      watch_patients_qi  <- ward_data_filtered %>%
        dplyr::filter(grepl("Watch",  AWaRe, ignore.case = TRUE)) %>%
        dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>%
        dplyr::pull(n)
      reserve_patients_qi<- ward_data_filtered %>%
        dplyr::filter(grepl("Reserve",AWaRe, ignore.case = TRUE)) %>%
        dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>%
        dplyr::pull(n)
      not_rec_patients_qi<- ward_data_filtered %>%
        dplyr::filter(grepl("Not recommended", AWaRe, ignore.case = TRUE)) %>%
        dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>%
        dplyr::pull(n)
      unclass_patients_qi<- ward_data_filtered %>%
        dplyr::filter(AWaRe == "UNCLASSIFIED" | is.na(AWaRe)) %>%
        dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>%
        dplyr::pull(n)
      
      # Calculate prescription counts for full dataset - EXACT R MARKDOWN LOGIC
      access_prescriptions_full <- ward_data_full %>%
        dplyr::filter(grepl("Access", AWaRe, ignore.case = TRUE)) %>%
        nrow()
      watch_prescriptions_full  <- ward_data_full %>%
        dplyr::filter(grepl("Watch",  AWaRe, ignore.case = TRUE)) %>%
        nrow()
      reserve_prescriptions_full<- ward_data_full %>%
        dplyr::filter(grepl("Reserve",AWaRe, ignore.case = TRUE)) %>%
        nrow()
      not_rec_prescriptions_full<- ward_data_full %>%
        dplyr::filter(grepl("Not recommended", AWaRe, ignore.case = TRUE)) %>%
        nrow()
      unclass_prescriptions_full<- ward_data_full %>%
        dplyr::filter(AWaRe == "UNCLASSIFIED" | is.na(AWaRe)) %>%
        nrow()
      
      # Calculate prescription counts for eligible dataset - EXACT R MARKDOWN LOGIC
      access_prescriptions_qi <- ward_data_filtered %>%
        dplyr::filter(grepl("Access", AWaRe, ignore.case = TRUE)) %>%
        nrow()
      watch_prescriptions_qi  <- ward_data_filtered %>%
        dplyr::filter(grepl("Watch",  AWaRe, ignore.case = TRUE)) %>%
        nrow()
      reserve_prescriptions_qi<- ward_data_filtered %>%
        dplyr::filter(grepl("Reserve",AWaRe, ignore.case = TRUE)) %>%
        nrow()
      not_rec_prescriptions_qi<- ward_data_filtered %>%
        dplyr::filter(grepl("Not recommended", AWaRe, ignore.case = TRUE)) %>%
        nrow()
      unclass_prescriptions_qi<- ward_data_filtered %>%
        dplyr::filter(AWaRe == "UNCLASSIFIED" | is.na(AWaRe)) %>%
        nrow()
      
      column(width = 10, offset = 1,
             box(
               title = "Hospital-Wide",
               status = "primary",
               solidHeader = TRUE,
               width = 12,
               class = "ward-summary-box",
               div(style = "padding: 8px;",
                   div(style = "margin-bottom: 8px;",
                       div(style = "display: flex; justify-content: space-between; margin-bottom: 4px;",
                           span(strong("Patients on antibiotics:"), style = "font-size: 12px;"),
                           span(total_patients, style = "font-size: 13px; font-weight: bold;")
                       ),
                       div(style = "display: flex; justify-content: space-between; margin-bottom: 4px;",
                           span(strong("QI-Eligible patients on antibiotics:"), style = "font-size: 12px;"),
                           span(qi_patients, style = "font-size: 13px; font-weight: bold; color: #e74c3c;")
                       ),
                       div(style = "display: flex; justify-content: space-between; margin-bottom: 4px;",
                           span(strong("Total antibiotic prescriptions (Rx):"), style = "font-size: 12px;"),
                           span(total_prescriptions, style = "font-size: 13px; font-weight: bold;")
                       ),
                       div(style = "display: flex; justify-content: space-between;",
                           span(strong("Total QI-Eligible antibiotic prescriptions (QI-Eligible Rx):"), style = "font-size: 12px;"),
                           span(qi_prescriptions, style = "font-size: 13px; font-weight: bold; color: #e74c3c;")
                       )
                   ),
                   hr(style = "margin: 6px 0;"),
                   div(style = "font-size: 11px;",
                       div(style = "display: flex; justify-content: space-between; margin-bottom: 5px;",
                           span(strong("Category"), style = "width: 20%;"),
                           span(strong("Total Patients"), style = "width: 20%; text-align: center;"),
                           span(strong("QI-Eligible Patients"), style = "width: 20%; text-align: center;"),
                           span(strong("Total Rx"), style = "width: 20%; text-align: center;"),
                           span(strong("QI-Eligible Rx"), style = "width: 20%; text-align: center;")
                       ),
                       div(style = "display: flex; justify-content: space-between; margin-bottom: 2px; padding: 3px; background-color: #1b9e77; border-radius: 3px;",
                           span("Access", style = "width: 20%; color: #fff; font-size: 11px; font-weight: bold;"),
                           span(access_patients_full, style = "width: 20%; text-align: center; color: #fff;"),
                           span(access_patients_qi, style = "width: 20%; text-align: center; font-weight: bold; color: #fff;"),
                           span(access_prescriptions_full, style = "width: 20%; text-align: center; color: #fff;"),
                           span(access_prescriptions_qi, style = "width: 20%; text-align: center; font-weight: bold; color: #fff;")
                       ),
                       div(style = "display: flex; justify-content: space-between; margin-bottom: 2px; padding: 3px; background-color: #ff7f00; border-radius: 3px;",
                           span("Watch", style = "width: 20%; color: #fff; font-size: 11px; font-weight: bold;"),
                           span(watch_patients_full, style = "width: 20%; text-align: center; color: #fff;"),
                           span(watch_patients_qi, style = "width: 20%; text-align: center; font-weight: bold; color: #fff;"),
                           span(watch_prescriptions_full, style = "width: 20%; text-align: center; color: #fff;"),
                           span(watch_prescriptions_qi, style = "width: 20%; text-align: center; font-weight: bold; color: #fff;")
                       ),
                       div(style = "display: flex; justify-content: space-between; margin-bottom: 2px; padding: 3px; background-color: #e41a1c; border-radius: 3px;",
                           span("Reserve", style = "width: 20%; color: #fff; font-size: 11px; font-weight: bold;"),
                           span(reserve_patients_full, style = "width: 20%; text-align: center; color: #fff;"),
                           span(reserve_patients_qi, style = "width: 20%; text-align: center; font-weight: bold; color: #fff;"),
                           span(reserve_prescriptions_full, style = "width: 20%; text-align: center; color: #fff;"),
                           span(reserve_prescriptions_qi, style = "width: 20%; text-align: center; font-weight: bold; color: #fff;")
                       ),
                       div(style = "display: flex; justify-content: space-between; margin-bottom: 2px; padding: 3px; background-color: #8c510a; border-radius: 3px;",
                           span("Not Recommended", style = "width: 20%; color: #fff; font-size: 11px; font-weight: bold;"),
                           span(not_rec_patients_full, style = "width: 20%; text-align: center; color: #fff;"),
                           span(not_rec_patients_qi, style = "width: 20%; text-align: center; font-weight: bold; color: #fff;"),
                           span(not_rec_prescriptions_full, style = "width: 20%; text-align: center; color: #fff;"),
                           span(not_rec_prescriptions_qi, style = "width: 20%; text-align: center; font-weight: bold; color: #fff;")
                       ),
                       div(style = "display: flex; justify-content: space-between; padding: 3px; background-color: #b3b3b3; border-radius: 3px;",
                           span("Unclassified", style = "width: 20%; color: #000; font-size: 11px; font-weight: bold;"),
                           span(unclass_patients_full, style = "width: 20%; text-align: center;"),
                           span(unclass_patients_qi, style = "width: 20%; text-align: center; font-weight: bold;"),
                           span(unclass_prescriptions_full, style = "width: 20%; text-align: center;"),
                           span(unclass_prescriptions_qi, style = "width: 20%; text-align: center; font-weight: bold;")
                       )
                   )
               )
             )
      )
    })
    
    # Ward Summary Boxes (compact; 2 per row; collapsed by default) - EXACT R MARKDOWN LOGIC
    output$ward_summary_boxes <- renderUI({
      data <- processed_data(); req(data)
      data_patients <- data$data_patients
      
      filtered_data_patients <- data_patients %>%
        dplyr::filter(
          `Diagnosis code` %in% c("SEPSIS", "CNS", "Pneu", "IA", "Pye", "SST", "BJ", "Proph"),
          Indication %in% c("CAI", "SP", "SP1", "SP2", "SP3"),
          Treatment == "EMPIRICAL",
          AWaRe %in% AWaRe_abx,
          `Age years` >= 18
        )
      
      all_wards <- unique(data_patients$`Department type`[!is.na(data_patients$`Department type`)])
      box_list <- list()
      
      for (ward in all_wards) {
        ward_data_full <- data_patients %>%
          dplyr::filter(
            `Department type` == ward,
            AWaRe %in% AWaRe_abx
          )
        ward_data_filtered <- filtered_data_patients %>% dplyr::filter(`Department type` == ward)
        
        total_patients <- dplyr::n_distinct(ward_data_full$`Survey Number`) 
        qi_patients <- dplyr::n_distinct(ward_data_filtered$`Survey Number`)
        total_prescriptions <- nrow(ward_data_full)
        qi_prescriptions <- nrow(ward_data_filtered)
        
        # Calculate AWaRe counts for each ward - EXACT R MARKDOWN LOGIC
        access_patients_full  <- ward_data_full  %>% dplyr::filter(grepl("Access", AWaRe, ignore.case = TRUE))  %>% dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>% dplyr::pull(n)
        watch_patients_full   <- ward_data_full  %>% dplyr::filter(grepl("Watch",  AWaRe, ignore.case = TRUE))  %>% dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>% dplyr::pull(n)
        reserve_patients_full <- ward_data_full  %>% dplyr::filter(grepl("Reserve",AWaRe, ignore.case = TRUE))  %>% dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>% dplyr::pull(n)
        not_rec_patients_full <- ward_data_full  %>% dplyr::filter(grepl("Not recommended", AWaRe, ignore.case = TRUE))%>% dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>% dplyr::pull(n)
        unclass_patients_full <- ward_data_full  %>% dplyr::filter(AWaRe == "UNCLASSIFIED" | is.na(AWaRe)) %>% dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>% dplyr::pull(n)
        
        access_patients_qi  <- ward_data_filtered %>% dplyr::filter(grepl("Access", AWaRe, ignore.case = TRUE))  %>% dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>% dplyr::pull(n)
        watch_patients_qi   <- ward_data_filtered %>% dplyr::filter(grepl("Watch",  AWaRe, ignore.case = TRUE))  %>% dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>% dplyr::pull(n)
        reserve_patients_qi <- ward_data_filtered %>% dplyr::filter(grepl("Reserve",AWaRe, ignore.case = TRUE))  %>% dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>% dplyr::pull(n)
        not_rec_patients_qi <- ward_data_filtered %>% dplyr::filter(grepl("Not recommended", AWaRe, ignore.case = TRUE)) %>% dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>% dplyr::pull(n)
        unclass_patients_qi <- ward_data_filtered %>% dplyr::filter(AWaRe == "UNCLASSIFIED" | is.na(AWaRe)) %>% dplyr::summarise(n = dplyr::n_distinct(`Survey Number`)) %>% dplyr::pull(n)
        
        access_prescriptions_full  <- ward_data_full  %>% dplyr::filter(grepl("Access", AWaRe, ignore.case = TRUE))  %>% nrow()
        watch_prescriptions_full   <- ward_data_full  %>% dplyr::filter(grepl("Watch",  AWaRe, ignore.case = TRUE))  %>% nrow()
        reserve_prescriptions_full <- ward_data_full  %>% dplyr::filter(grepl("Reserve",AWaRe, ignore.case = TRUE))  %>% nrow()
        not_rec_prescriptions_full <- ward_data_full  %>% dplyr::filter(grepl("Not recommended", AWaRe, ignore.case = TRUE)) %>% nrow()
        unclass_prescriptions_full <- ward_data_full  %>% dplyr::filter(AWaRe == "UNCLASSIFIED" | is.na(AWaRe)) %>% nrow()
        
        access_prescriptions_qi  <- ward_data_filtered %>% dplyr::filter(grepl("Access", AWaRe, ignore.case = TRUE))  %>% nrow()
        watch_prescriptions_qi   <- ward_data_filtered %>% dplyr::filter(grepl("Watch",  AWaRe, ignore.case = TRUE))  %>% nrow()
        reserve_prescriptions_qi <- ward_data_filtered %>% dplyr::filter(grepl("Reserve",AWaRe, ignore.case = TRUE))  %>% nrow()
        not_rec_prescriptions_qi <- ward_data_filtered %>% dplyr::filter(grepl("Not recommended", AWaRe, ignore.case = TRUE)) %>% nrow()
        unclass_prescriptions_qi <- ward_data_filtered %>% dplyr::filter(AWaRe == "UNCLASSIFIED" | is.na(AWaRe)) %>% nrow()
        
        box_list[[ward]] <- box(
          title = ward, status = "primary", solidHeader = TRUE,
          width = 6, collapsible = TRUE, 
          class = "ward-summary-box",
          div(style = "padding: 8px;",
              div(style = "margin-bottom: 6px;",
                  div(style = "display: flex; justify-content: space-between; margin-bottom: 3px;",
                      span(strong("Patients on antibiotics:"), style = "font-size: 11px;"),
                      span(total_patients, style = "font-size: 12px; font-weight: bold;")
                  ),
                  div(style = "display: flex; justify-content: space-between; margin-bottom: 3px;",
                      span(strong("QI-Eligible patients on antibiotics:"), style = "font-size: 11px;"),
                      span(qi_patients, style = "font-size: 12px; font-weight: bold; color: #e74c3c;")
                  ),
                  div(style = "display: flex; justify-content: space-between; margin-bottom: 3px;",
                      span(strong("Total antibiotic prescriptions (Rx):"), style = "font-size: 11px;"),
                      span(total_prescriptions, style = "font-size: 12px; font-weight: bold;")
                  ),
                  div(style = "display: flex; justify-content: space-between;",
                      span(strong("Total QI-Eligible antibiotic prescriptions (QI-Eligible Rx):"), style = "font-size: 11px;"),
                      span(qi_prescriptions, style = "font-size: 12px; font-weight: bold; color: #e74c3c;")
                  )
              ),
              hr(style = "margin: 6px 0;"),
              div(style = "font-size: 10.5px;",
                  div(style = "display: flex; justify-content: space-between; margin-bottom: 3px;",
                      span(strong("Category"), style = "width: 20%;"),
                      span(strong("Total Patients"), style = "width: 20%; text-align: center;"),
                      span(strong("QI-Eligible Patients"), style = "width: 20%; text-align: center;"),
                      span(strong("Total Rx"), style = "width: 20%; text-align: center;"),
                      span(strong("QI-Eligible Rx"), style = "width: 20%; text-align: center;")
                  ),
                  div(style = "display: flex; justify-content: space-between; margin-bottom: 2px; padding: 2px; background-color: #1b9e77;",
                      span("Access", style = "width: 20%; color: #fff;"),
                      span(access_patients_full, style = "width: 20%; text-align: center; color:#fff;"),
                      span(access_patients_qi, style = "width: 20%; text-align: center; font-weight: bold; color:#fff;"),
                      span(access_prescriptions_full, style = "width: 20%; text-align: center; color:#fff;"),
                      span(access_prescriptions_qi, style = "width: 20%; text-align: center; font-weight: bold; color:#fff;")
                  ),
                  div(style = "display: flex; justify-content: space-between; margin-bottom: 2px; padding: 2px; background-color: #ff7f00;",
                      span("Watch", style = "width: 20%; color: #fff;"),
                      span(watch_patients_full, style = "width: 20%; text-align: center; color:#fff;"),
                      span(watch_patients_qi, style = "width: 20%; text-align: center; font-weight: bold; color:#fff;"),
                      span(watch_prescriptions_full, style = "width: 20%; text-align: center; color:#fff;"),
                      span(watch_prescriptions_qi, style = "width: 20%; text-align: center; font-weight: bold; color:#fff;")
                  ),
                  div(style = "display: flex; justify-content: space-between; margin-bottom: 2px; padding: 2px; background-color: #e41a1c;",
                      span("Reserve", style = "width: 20%; color: #fff;"),
                      span(reserve_patients_full, style = "width: 20%; text-align: center; color:#fff;"),
                      span(reserve_patients_qi, style = "width: 20%; text-align: center; font-weight: bold; color:#fff;"),
                      span(reserve_prescriptions_full, style = "width: 20%; text-align: center; color:#fff;"),
                      span(reserve_prescriptions_qi, style = "width: 20%; text-align: center; font-weight: bold; color:#fff;")
                  ),
                  div(style = "display: flex; justify-content: space-between; margin-bottom: 2px; padding: 2px; background-color: #8c510a;",
                      span("Not Recommended", style = "width: 20%; color: #fff;"),
                      span(not_rec_patients_full, style = "width: 20%; text-align: center; color:#fff;"),
                      span(not_rec_patients_qi, style = "width: 20%; text-align: center; font-weight: bold; color:#fff;"),
                      span(not_rec_prescriptions_full, style = "width: 20%; text-align: center; color:#fff;"),
                      span(not_rec_prescriptions_qi, style = "width: 20%; text-align: center; font-weight: bold; color:#fff;")
                  ),
                  div(style = "display: flex; justify-content: space-between; padding: 2px; background-color: #b3b3b3;",
                      span("Unclassified", style = "width: 20%; color: #000;"),
                      span(unclass_patients_full, style = "width: 20%; text-align: center;"),
                      span(unclass_patients_qi, style = "width: 20%; text-align: center; font-weight: bold;"),
                      span(unclass_prescriptions_full, style = "width: 20%; text-align: center;"),
                      span(unclass_prescriptions_qi, style = "width: 20%; text-align: center; font-weight: bold;")
                  )
              )
          )
        )
      }
      
      do.call(tagList, lapply(seq(1, length(box_list), by = 2), function(i) {
        fluidRow(box_list[i:min(i+1, length(box_list))])
      }))
    })
    
    # -------------------------
    # Diagnostic Plot - EXACTLY MATCHING R MARKDOWN STACKING ORDER
    # -------------------------
    output$diagnostic_plot <- renderPlotly({
      data <- processed_data()
      req(data)
      data_patients <- data$data_patients
      
      # AWaRe stacking order - EXACTLY FROM R MARKDOWN
      aware_levels_stack <- c("UNCLASSIFIED", "NOT RECOMMENDED", "RESERVE", "WATCH", "ACCESS")
      
      # MODIFIED: Legend order to match the attached image
      aware_levels_legend <- c("ACCESS", "WATCH", "RESERVE", "NOT RECOMMENDED", "UNCLASSIFIED")
      
      # All combinations of Diagnosis × AWaRe - EXACT R MARKDOWN LOGIC
      all_combos <- expand_grid(
        `Diagnosis code` = names(diagnostic_labels),
        AWaRe = aware_levels_stack
      )
      
      # Summarise prescriptions with EXACT R MARKDOWN logic
      aware_summary <- data_patients %>%
        filter(`Diagnosis code` %in% names(diagnostic_labels)) %>%
        filter(!is.na(AWaRe), !is.na(`Diagnosis code`)) %>%
        group_by(`Diagnosis code`, AWaRe) %>%
        summarise(Prescriptions = n(), .groups = "drop") %>%
        right_join(all_combos, by = c("Diagnosis code", "AWaRe")) %>%
        mutate(Prescriptions = replace_na(Prescriptions, 0)) %>%
        group_by(`Diagnosis code`) %>%
        mutate(
          Total = sum(Prescriptions),
          Percentage = if_else(Total > 0, 100 * Prescriptions / Total, 0)
        ) %>%
        ungroup() %>%
        mutate(
          FriendlyLabel = diagnostic_labels[`Diagnosis code`],
          FriendlyLabel = factor(FriendlyLabel, levels = diagnostic_labels)
        )
      
      # Control stacking via factor levels - EXACTLY FROM R MARKDOWN
      aware_summary$AWaRe <- factor(aware_summary$AWaRe, levels = aware_levels_stack)
      
      # --- FIX: integer counts per diagnosis ---
      aware_summary <- aware_summary %>%
        group_by(`Diagnosis code`) %>%
        group_modify(~ {
          df <- .x
          dt <- max(df$Total, na.rm = TRUE)
          raw <- df$Percentage / 100 * dt
          base <- floor(raw)
          remainder <- dt - sum(base)
          if (remainder > 0) {
            frac_order <- order(-(raw - base))
            base[frac_order[seq_len(remainder)]] <- base[frac_order[seq_len(remainder)]] + 1L
          }
          df$Count <- as.integer(base)
          df$diag_total <- dt
          df
        }) %>%
        ungroup()
      
      # --- Labels and hover text ---
      aware_summary <- aware_summary %>%
        filter(Total > 0) %>%
        mutate(
          PlotLabel = FriendlyLabel,
          PercentagePct = Percentage,
          hover_text = paste0(
            "<b>Diagnosis:</b> ", as.character(PlotLabel), "<br>",
            "<b>AWaRe Category:</b> ", as.character(AWaRe), "<br>",
            "<b>Count:</b> ", Count, "<br>",
            "<b>Percentage:</b> ", round(PercentagePct, 1), "%"
          )
        )
      
      # MODIFIED: Plot order to match the attached image (top to bottom)
      plot_order <- c(
        "Undifferentiated Sepsis",
        "Meningitis",
        "Respiratory Tract Infection",
        "Intra-abdominal Infection",
        "Upper Urinary Tract Infection",
        "Skin/Soft Tissue Infection",
        "Bone/Joint Infection",
        "Surgical Prophylaxis"
      )
      
      aware_summary$PlotLabel <- factor(aware_summary$PlotLabel, levels = plot_order)
      
      # --- n= labels ---
      label_data <- aware_summary %>%
        distinct(`Diagnosis code`, PlotLabel, diag_total)
      
      # --- Dynamic buffer ---
      max_digits <- max(nchar(as.character(label_data$diag_total)), na.rm = TRUE)
      y_buffer <- max(0.06, 0.03 + 0.035 * max_digits)
      ylim_max <- min(1 + y_buffer, 1.5)
      label_y <- 1 + y_buffer * 0.48
      
      # --- ggplot ---
      p <- ggplot(
        aware_summary,
        aes(x = fct_rev(PlotLabel), y = PercentagePct / 100, fill = AWaRe, text = hover_text)
      ) +
        geom_bar(stat = "identity", position = "fill", width = 0.85) +
        geom_text(
          aes(label = ifelse(Percentage >= 5, paste0(round(PercentagePct), "%"), "")),
          position = position_fill(vjust = 0.5),
          size = 3,
          color = "black"
        ) +
        geom_text(
          data = label_data,
          aes(x = PlotLabel, label = paste0("n=", formatC(diag_total, format = "d", big.mark = ","))),
          y = label_y,
          inherit.aes = FALSE,
          size = 3,
          color = "gray30",
          vjust = 0.5,
          hjust = 0
        ) +
        scale_fill_manual(
          breaks = aware_levels_legend,  # MODIFIED: controls legend order - ACCESS, WATCH, RESERVE, NOT RECOMMENDED, UNCLASSIFIED
          values = c(
            "ACCESS" = "#1b9e77",
            "WATCH" = "#ff7f00",
            "RESERVE" = "#e41a1c",
            "NOT RECOMMENDED" = "#8c510a",
            "UNCLASSIFIED" = "gray70"
          ),
          drop = FALSE
        ) +
        coord_flip(ylim = c(0, ylim_max), expand = FALSE) +
        labs(
          x = "Diagnosis Group",
          y = "Proportion of Prescriptions",
          fill = "AWaRe Category"
        ) +
        theme_minimal(base_size = 10) +
        theme(
          axis.text.y = element_text(size = 7),
          axis.text.x = element_text(size = 7),
          axis.title = element_text(face = "bold", size = 10),
          panel.border = element_rect(color = "gray70", fill = NA, linewidth = .6),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9),
          legend.text = element_text(size = 8),
          plot.margin = margin(6, 18, 6, 8)
        ) +
        guides(fill = guide_legend(nrow = 1, byrow = TRUE, title.position = "top", 
                                   override.aes = list(fill = c("#1b9e77", "#ff7f00", "#e41a1c", "#8c510a", "gray70"))))
      
      # --- Convert to plotly ---
      x_margin <- 40 + round(300 * y_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Use of Antibiotics by Diagnosis Group (AWaRe Classification)</b><br>"
            ),
            x = 0.5,
            xanchor = "center",
            y = 0.98,
            yanchor = "top",
            font = list(size = 11)
          ),
          height = 450,
          width = 680,
          margin = list(l = 30, r = x_margin, t = 60, b = 170),
          legend = list(
            orientation = "h",
            x = 0.5,
            xanchor = "center",
            y = -0.40,
            yanchor = "top",
            font = list(size = 10),
            title = list(text = "<b>AWaRe Category</b>", font = list(size = 10)),
            traceorder = "normal"  # ADDED: Force plotly to respect the order
          ),
          bargap = 0,
          bargroupgap = 0
        ) %>%
        layout(
          xaxis = list(automargin = TRUE, categoryorder = "array", categoryarray = rev(plot_order)),
          yaxis = list(automargin = TRUE)
        )
      
      # ADDED: Force reorder legend traces in plotly
      # Legend order: ACCESS, WATCH, RESERVE, NOT RECOMMENDED, UNCLASSIFIED
      legend_order_map <- setNames(seq_along(aware_levels_legend), aware_levels_legend)
      
      # Reorder the traces
      plt$x$data <- plt$x$data[order(sapply(plt$x$data, function(trace) {
        legend_order_map[trace$name]
      }))]
      
      plt
    })
    
    # -------------------------
    # Department Heatmap Plot - WITH ABBREVIATED X-AXIS LABELS
    # -------------------------
    output$dept_heatmap_plot <- renderPlotly({
      data <- processed_data(); req(data)
      data_patients <- data$data_patients
      
      # MODIFIED: Legend order and color mapping to match attached image
      aware_levels <- c("Access", "Watch", "Reserve")
      color_mapping <- c("Access" = "#1b9e77", "Watch" = "#ff7f00", "Reserve" = "#e41a1c")
      
      diagnostic_lookup <- tibble(
        `Diagnosis code` = names(diagnostic_labels),
        FriendlyLabel = unname(diagnostic_labels)
      )
      
      # Total patients per diagnosis (including 0s) - EXACT R MARKDOWN
      infection_totals <- data_patients %>%
        filter(`Diagnosis code` %in% names(diagnostic_labels)) %>%
        group_by(`Diagnosis code`) %>%
        summarise(Total_Infection_Patients = n(), .groups = "drop") %>%
        right_join(diagnostic_lookup, by = "Diagnosis code") %>%
        mutate(Total_Infection_Patients = replace_na(Total_Infection_Patients, 0))
      
      # Department-level data - EXACT R MARKDOWN LOGIC
      dept_data <- data_patients %>%
        filter(`Diagnosis code` %in% names(diagnostic_labels)) %>%
        mutate(
          Antibiotic_Type = case_when(
            AWaRe == "ACCESS" ~ "Access",
            AWaRe == "WATCH" ~ "Watch", 
            AWaRe == "RESERVE" ~ "Reserve",
            TRUE ~ NA_character_
          )
        ) %>%
        filter(!is.na(Antibiotic_Type)) %>%
        group_by(`Department type`, `Diagnosis code`, Antibiotic_Type) %>%
        summarise(Count = n(), .groups = "drop")
      
      # Use only department data (no hospital-wide)
      heatmap_data <- dept_data
      
      # Create all possible combinations
      all_combos <- expand_grid(
        `Department type` = unique(heatmap_data$`Department type`),
        `Diagnosis code` = names(diagnostic_labels),
        Antibiotic_Type = aware_levels
      )
      
      # Merge with observed data, fill 0s - EXACT R MARKDOWN
      heatmap_data <- all_combos %>%
        left_join(heatmap_data, by = c("Department type", "Diagnosis code", "Antibiotic_Type")) %>%
        mutate(Count = replace_na(Count, 0)) %>%
        left_join(infection_totals, by = "Diagnosis code") %>%
        mutate(
          FriendlyLabel_n = paste0(FriendlyLabel, "\n(n=", Total_Infection_Patients, ")"),
          FriendlyLabel_n = factor(
            FriendlyLabel_n,
            levels = paste0(
              unname(diagnostic_labels),
              "\n(n=", infection_totals$Total_Infection_Patients[
                match(names(diagnostic_labels), infection_totals$`Diagnosis code`)
              ], ")"
            )
          ),
          Antibiotic_Type = factor(Antibiotic_Type, levels = aware_levels),
          Label = ifelse(Count > 0, as.character(Count), "")
        )
      
      # DYNAMIC DEPARTMENT ABBREVIATION FUNCTION (Hospital-Wide handling removed)
      create_abbreviation <- function(dept_name) {
        # Remove common words and create abbreviation
        dept_clean <- dept_name %>%
          # Remove common words
          str_remove_all("\\b(or|and|the|of|in|at|to|for|with|by)\\b") %>%
          # Handle hyphenated words
          str_replace_all("-", " ") %>%
          # Split into words
          str_split("\\s+") %>%
          unlist() %>%
          # Remove empty strings
          .[. != ""] %>%
          # Take first letter of each significant word
          str_sub(1, 1) %>%
          # Convert to uppercase
          toupper() %>%
          # Combine
          paste0(collapse = "")
        
        # If abbreviation is too short (less than 2 chars), use different strategy
        if (nchar(dept_clean) < 2) {
          # Use first few characters of the main word
          main_word <- str_extract(dept_name, "\\b\\w{3,}\\b")
          if (!is.na(main_word)) {
            dept_clean <- toupper(str_sub(main_word, 1, 4))
          } else {
            dept_clean <- toupper(str_sub(dept_name, 1, 4))
          }
        }
        
        # Limit to maximum 6 characters for readability
        if (nchar(dept_clean) > 6) {
          dept_clean <- str_sub(dept_clean, 1, 6)
        }
        
        return(dept_clean)
      }
      
      # GET UNIQUE DEPARTMENTS FROM ACTUAL DATA AND CREATE ABBREVIATIONS
      unique_depts <- unique(heatmap_data$`Department type`)
      dept_abbreviations <- tibble(
        full_name = unique_depts,
        abbreviated = map_chr(unique_depts, create_abbreviation)
      )
      
      # Apply abbreviations - simplified without Hospital-Wide special handling
      heatmap_data <- heatmap_data %>%
        left_join(dept_abbreviations, by = c("Department type" = "full_name")) %>%
        mutate(
          # Use abbreviation for all departments, fallback to original if not found
          abbreviated = ifelse(is.na(abbreviated), `Department type`, abbreviated),
          dept_display = abbreviated,
          # Store original department name for tooltip
          dept_original = `Department type`
        )
      
      max_count <- max(heatmap_data$Count, na.rm = TRUE)
      
      # Simplified label formatting (no Hospital-Wide special treatment)
      heatmap_data <- heatmap_data %>%
        mutate(
          text_size = 2.2,
          text_face = "bold",
          text_color = "black"
        )
      
      p <- ggplot(
        heatmap_data,
        aes(x = dept_display, y = FriendlyLabel_n,
            fill = Antibiotic_Type,
            text = paste0(
              "Ward: ", dept_original, "\n",
              "Infection: ", gsub("\n.*", "", FriendlyLabel_n), "\n",
              "AWaRe: ", Antibiotic_Type, "\n",
              "Patients: ", Count
            ))
      ) +
        geom_tile(aes(alpha = Count), color = "white", linewidth = 0.55) +
        # Single text layer for all departments
        geom_text(
          aes(label = Label), size = 2.2, fontface = "bold", color = "black"
        ) +
        facet_wrap(~Antibiotic_Type, ncol = 3) +
        scale_fill_manual(
          values = color_mapping, 
          name = "AWaRe Category", 
          drop = FALSE,
          guide = "none"  # MODIFIED: Remove the fill legend from plot
        ) +
        scale_alpha_continuous(limits = c(0, max_count), range = c(0.12, 1), guide = "none") +
        labs(x = "Deparment", y = "Diagnosis Group") +
        theme_minimal(base_size = 9) +
        theme(
          axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 6.5),
          axis.text.y = element_text(size = 6.5, face = "bold"),
          strip.background = element_rect(fill = "black", color = "black"),
          strip.text = element_text(color = "white", face = "bold", size = 9.5),
          panel.grid = element_blank(),
          legend.position = "none",  # MODIFIED: No legend from ggplot
          legend.title = element_text(face = "bold", size = 8.5),
          legend.text  = element_text(size = 8)
        )
      
      # CREATE DEPARTMENT LEGEND TABLE - 3 ITEMS PER ROW FORMAT
      dept_legend_data <- heatmap_data %>%
        select(dept_original, abbreviated) %>%
        distinct() %>%
        arrange(dept_original) %>%
        mutate(
          display_item = paste0("<b>", abbreviated, ":</b> ", dept_original)
        )
      
      # Split into groups of 3 for better visibility
      legend_items <- dept_legend_data$display_item
      legend_rows <- split(legend_items, ceiling(seq_along(legend_items) / 3))
      legend_text <- paste(sapply(legend_rows, function(row) paste(row, collapse = " | ")), collapse = "<br>")
      
      # MODIFIED: Create standalone AWaRe Categories legend with 25px colored boxes
      aware_legend_html <- paste0(
        "<b>AWaRe Categories:</b>  ",
        "<span style='font-size:25px; color:#1b9e77'>&#9632;</span> Access  ",
        "<span style='font-size:25px; color:#ff7f00'>&#9632;</span> Watch  ",
        "<span style='font-size:25px; color:#e41a1c'>&#9632;</span> Reserve"
      )
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = "<b>Antibiotic Use by Diagnosis Group and Department</b>",
            x = 0.5, xanchor = "center",
            y = 0.95,
            yanchor = "top",
            font = list(size = 11)
          ),
          height = 520,
          margin = list(t = 80, r = 10, b = 220, l = 60),  # MODIFIED: Increased bottom margin for proper spacing
          xaxis = list(automargin = TRUE),
          yaxis = list(automargin = TRUE),
          uniformtext = list(minsize = 6),
          dragmode = "pan",
          hovermode = "closest",
          annotations = list(
            # MODIFIED: AWaRe Categories legend - positioned with space from x-axis
            list(
              text = aware_legend_html,
              showarrow = FALSE,
              xref = "paper", yref = "paper",
              x = 0.5, y = -0.22,
              xanchor = "center", yanchor = "top",
              font = list(size = 11)
            ),
            # MODIFIED: Department abbreviations - positioned with space from AWaRe legend
            list(
              text = paste0("<b>Department Abbreviations:</b><br>", legend_text),
              showarrow = FALSE,
              xref = "paper", yref = "paper",
              x = 0.5, y = -0.38,
              xanchor = "center", yanchor = "top",
              font = list(size = 8)
            )
          )
        )
      
      plt
    })
    
    
    # -------------------------
    # Age Patterns Plot - WITH FORCED COLORBAR HEIGHT
    # -------------------------
    output$age_patterns_plot <- renderPlotly({
      data <- processed_data(); req(data)
      data_patients <- data$data_patients
      
      # Define expected categories
      expected_indications <- c("CAI", "HAI")
      expected_age_groups  <- c("Children", "Adult")
      expected_treatments  <- c("EMPIRICAL", "TARGETED")
      
      # Prepare patient-level data
      patient_level_data <- data_patients %>%
        filter(Indication %in% c("CAI", HAI_terms)) %>%
        filter(Treatment %in% expected_treatments) %>%
        filter(AWaRe %in% AWaRe_abx) %>%
        mutate(
          AgeGroup   = ifelse(`Age years` < 18, "Children", "Adult"),
          Indication = ifelse(Indication %in% HAI_terms, "HAI", Indication),
          Treatment  = factor(Treatment, levels = expected_treatments)
        ) %>%
        distinct(`Survey Number`, Indication, Treatment, AgeGroup)
      
      # Create all combinations
      all_combinations <- expand.grid(
        Indication = expected_indications,
        AgeGroup   = expected_age_groups,
        Treatment  = factor(expected_treatments, levels = expected_treatments),
        stringsAsFactors = FALSE
      )
      
      # Count patients and merge
      summary_table_QIs <- all_combinations %>%
        left_join(
          patient_level_data %>% group_by(Indication, AgeGroup, Treatment) %>%
            summarise(Patients = n(), .groups = "drop"),
          by = c("Indication","AgeGroup","Treatment")
        ) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      # Calculate percentages within each age group
      summary_table_QIs <- summary_table_QIs %>%
        group_by(AgeGroup) %>%
        mutate(
          Total_in_AgeGroup = sum(Patients),
          Percentage = ifelse(Total_in_AgeGroup > 0, 
                              round((Patients / Total_in_AgeGroup) * 100, 1), 
                              0)
        ) %>%
        ungroup()
      
      # Prepare heatmap data
      heatmap_data <- summary_table_QIs %>%
        pivot_wider(names_from = Treatment, values_from = c(Patients, Percentage), 
                    values_fill = list(Patients = 0, Percentage = 0)) %>%
        pivot_longer(cols = c(paste0("Patients_", expected_treatments), 
                              paste0("Percentage_", expected_treatments)),
                     names_to = c(".value", "Treatment"), 
                     names_pattern = "(.*)_(.*)") %>%
        mutate(
          Treatment  = factor(Treatment,  levels = expected_treatments),
          Indication = factor(Indication, levels = expected_indications),
          AgeGroup   = factor(AgeGroup,   levels = expected_age_groups)
        )
      
      p <- ggplot(
        heatmap_data,
        aes(
          x = Treatment, y = Indication, fill = Patients,
          text = paste0(
            "Age Group: ", AgeGroup, "<br>",
            "Treatment: ", Treatment, "<br>",
            "Indication: ", Indication, "<br>",
            "Patients: <b>", Patients, "</b><br>",
            "Percentage: <b>", Percentage, "%</b>"
          )
        )
      ) +
        geom_tile(color = NA) +
        geom_tile(fill = NA, color = "grey40", linewidth = 0.35) +
        geom_text(aes(label = Patients), color = "black", size = 3.8, fontface = "bold") +
        facet_wrap(~AgeGroup, nrow = 1) +
        scale_fill_gradient(low = "#dceeff", high = "#004488", name = "Number of\nPatients") +
        scale_x_discrete(expand = c(0, 0)) +
        scale_y_discrete(expand = c(0, 0)) +
        labs(x = "Treatment Type", y = "Indication") +
        theme_minimal(base_size = 9.5) +
        theme(
          panel.grid = element_blank(),
          strip.background = element_blank(),
          strip.text = element_text(face = "bold", size = 10),
          axis.text = element_text(size = 8.8),
          legend.position = "right",
          legend.title = element_text(size = 9, face = "bold"),
          legend.text = element_text(size = 8)
        )
      
      # Convert to plotly
      plt <- ggplotly(p, tooltip = "text")
      
      # Calculate the actual plot domain to match colorbar height
      # The plot area typically spans from y = 0.1 to y = 0.85 when accounting for margins
      plot_y_min <- 0.15  # Bottom of plot area
      plot_y_max <- 0.80  # Top of plot area
      
      # FORCE colorbar to match exact plot height using style()
      plt <- plt %>%
        style(
          colorbar = list(
            len = plot_y_max - plot_y_min,  # Exact height as fraction
            lenmode = "fraction",
            y = (plot_y_max + plot_y_min) / 2,  # Center position
            yanchor = "middle",
            thickness = 20,
            thicknessmode = "pixels",
            title = list(
              text = "Number of<br>Patients",
              side = "right",
              font = list(size = 10)
            ),
            tickfont = list(size = 9),
            outlinewidth = 1,
            outlinecolor = "grey40",
            xpad = 5,
            ypad = 0
          ),
          traces = 1:length(plt$x$data)  # Apply to all traces
        ) %>%
        layout(
          title = list(
            text = "<b>Patient Distribution by Treatment, Indication and Age Group</b>",
            x = 0.5, 
            xanchor = "center",
            y = 0.95,
            yanchor = "top",
            font = list(size = 11)
          ),
          height = 400,
          margin = list(t = 80, r = 120, b = 90, l = 60),
          xaxis = list(automargin = TRUE),
          yaxis = list(automargin = TRUE),
          uniformtext = list(minsize = 8)
        )
      
      # Alternative approach: Directly modify the colorbar in data traces
      for(i in seq_along(plt$x$data)) {
        if(!is.null(plt$x$data[[i]]$marker$colorscale)) {
          plt$x$data[[i]]$colorbar <- list(
            y = 0.5,
            yanchor = "middle",
            len = 0.65,  # Adjust this value to match your specific plot
            lenmode = "fraction",
            thickness = 20,
            thicknessmode = "pixels",
            title = list(
              text = "Number of<br>Patients",
              side = "right"
            )
          )
        }
      }
      
      plt
    })
    
    
    
    # -------------------------
    # Prophylaxis Plot - EXACTLY MATCHING R MARKDOWN
    # -------------------------
    output$prophylaxis_plot <- renderPlotly({
      data <- processed_data(); req(data)
      data_patients <- data$data_patients
      
      # Define expected categories - EXACTLY FROM R MARKDOWN
      expected_age_groups <- c("Children", "Adult")
      expected_indications <- c("Surgical Prophylaxis", "Medical Prophylaxis", "Other Prophylaxis", "Unknown Indication")
      
      # Prepare and clean data - EXACTLY FROM R MARKDOWN LOGIC
      proph_summary_data <- data_patients %>%
        filter(Treatment == "EMPIRICAL") %>%
        filter(AWaRe %in% AWaRe_abx) %>%
        mutate(
          AgeGroup = ifelse(`Age years` < 18, "Children", "Adult"),
          Indication = case_when(
            toupper(Indication) %in% SP_prophylaxis_terms ~ "Surgical Prophylaxis",
            toupper(Indication) == "MP" ~ "Medical Prophylaxis",
            toupper(Indication) == "OTH" ~ "Other Prophylaxis",
            toupper(Indication) == "UNK" ~ "Unknown Indication",
            TRUE ~ toupper(Indication)
          ),
          Indication = factor(Indication, levels = expected_indications),
          AgeGroup   = factor(AgeGroup, levels = expected_age_groups)
        ) %>%
        filter(!is.na(Indication)) %>%
        distinct(`Survey Number`, Indication, AgeGroup)
      
      # Summarise and complete missing categories - EXACTLY FROM R MARKDOWN
      proph_summary_counts <- proph_summary_data %>%
        group_by(AgeGroup, Indication) %>%
        summarise(Patients = n(), .groups = 'drop') %>%
        complete(AgeGroup = expected_age_groups,
                 Indication = expected_indications,
                 fill = list(Patients = 0))
      
      # Calculate proportions - EXACTLY FROM R MARKDOWN
      group_totals <- proph_summary_counts %>%
        group_by(AgeGroup) %>%
        summarise(GroupTotal = sum(Patients), .groups = 'drop')
      
      proph_prop <- proph_summary_counts %>%
        left_join(group_totals, by = "AgeGroup") %>%
        mutate(
          Proportion = ifelse(GroupTotal == 0, 0, Patients / GroupTotal),
          Indication = factor(Indication, levels = expected_indications)
        )
      
      p <- ggplot(proph_prop, aes(x = AgeGroup, y = Proportion, fill = Indication, text = paste0(
        "Age Group: ", AgeGroup, "<br>",
        "Indication: ", Indication, "<br>",
        "Patients: ", Patients, "<br>",
        "Proportion: ", round(Proportion * 100, 1), "%"
      ))) +
        geom_bar(stat = "identity", position = "fill", width = 0.7) +
        geom_text(
          aes(label = ifelse(Patients > 0, Patients, "")),
          position = position_fill(vjust = 0.5),
          size = 3,
          fontface = "bold",
          color = "black"
        ) +
        scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
        scale_fill_manual(
          values = c(
            "Surgical Prophylaxis" = "#4e79a7",  # bluish for Surgical Prophylaxis
            "Medical Prophylaxis"  = "#9ecae1",  # lighter blue for Medical Prophylaxis  
            "Other Prophylaxis"    = "#59a14f",  # green for Other
            "Unknown Indication"   = "#a1d99b"   # light green for Unknown
          ),
          drop = FALSE
        ) +
        coord_flip() +
        labs(x = "Age Group", y = "Proportion", fill = "Indication") +
        theme_bw(base_size = 9.5) +
        theme(
          plot.title = element_blank(),
          axis.title = element_text(face = "bold"),
          axis.text.y = element_text(face = "bold"),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 9)
        )
      
      ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Prophylaxis Antibiotic Use Across Age Groups</b><br>"
            ),
            x = 0.5, xanchor = "center",
            y = 0.95,
            yanchor = "top",
            font = list(size = 11)
          ),
          height = 400,
          margin = list(t = 80, r = 10, b = 90, l = 60),
          legend = list(
            orientation = "h", 
            x = 0.5, 
            xanchor = "center", 
            y = -0.35,
            font = list(size = 9)
          ),
          xaxis = list(automargin = TRUE),
          yaxis = list(automargin = TRUE),
          uniformtext = list(minsize = 8)
        )
    })
    
  })
}