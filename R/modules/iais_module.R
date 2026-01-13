# IAIs Analysis Shiny Module - Complete Implementation with Plotly
# Updated to match R Markdown graph logic exactly

# Overview Tab UI
iaisOverviewUI <- function(id) {
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
               box(width = 12, title = "🎯 WHO AWaRe QIs for Intra-abdominal infections", status = "info", solidHeader = TRUE,
                   
                   h5("Within the gPPS data structure, the following antibiotic use quality indicators have been identified:"),
                   p("1) ", " Proportion of patients presenting with any Intra-abdominal infections (e.g. Cholecystitis, Cholangitis, Acute Appendicitis, Acute Diverticulitis) given IV antibiotics."),
                   p("2) ", " Proportion of patients presenting with intra-abdominal infections given IV/oral antibiotics by AWaRe category (Access or Watch)."),
                   p("3) ", " Proportion of patients presenting with any intra-abdominal infections given the appropriate IV antibiotic according to the WHO AWaRe book."),
                   p("4) ", " Proportion of patients presenting with any Intra-abdominal infections prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book.")
                   
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
iaisEligibilityUI <- function(id) {
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
        box(width = 12, title = "🔍 Initial Eligible Cases Check", status = "primary", solidHeader = TRUE,
            htmlOutput(ns("eligibility_feedback"))
        )
      )
    )
  )
}

# Patient Summary Tab UI
iaisPatientSummaryUI <- function(id) {
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
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view patient summary.")
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🧾 Eligiblilty Criteria", status = "primary", solidHeader = TRUE,
                   p("Eligible patients for WHO AWaRe Quality Indicator (QI) assessment are defined as adult inpatients (≥18 years) who received empirical antibiotics for community-acquired intra-abdominal infections (CA-IAIs).")
               )
        )
      )
    )
  )
}

# QI Guidelines Tab UI
iaisQIGuidelinesUI <- function(id) {
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
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view QI guidelines.")
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
                       strong("1. H_IAI_IV_ABX:"), " Proportion of patients presenting with any IAI (e.g. Cholecystitis, Cholangitis, Acute Appendicitis, Acute Diverticulitis) given IV antibiotics.", br(), br(),
                       strong("2. H_IAI_WATCH_ABX:"), " Proportion of patients presenting with intra-abdominal infections given IV antibiotics by AWaRe category (Access or Watch).", br(), br(),
                       strong("3. H_IAI_APPROP_DOSAGE:"), " Proportion of patients presenting with any IAI prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book."
                   ),
                   
                   div(class = "note-box",
                       strong("🔍 WHO AWaRe book Recommendation:"), br(), br(),
                       tags$ul(
                         strong("First choice"),
                         tags$li(strong("Amoxicillin + clavulanic acid"), " (1 g + 200 mg q8h IV or 875 mg + 125 mg q8h ORAL)"),
                         tags$li(strong("Cefotaxime"), " (2 g q8h IV) + ", strong("Metronidazole"), " (500 mg q8h IV/ORAL)"),
                         tags$li(strong("Ceftriaxone"), " (2 g q24h IV) + ", strong("Metronidazole"), " (500 mg q8h IV/ORAL)"),
                         tags$li(strong("Ciprofloxacin"), " (500 mg q12h ORAL) + ", strong("Metronidazole"), " (500 mg q8h IV/ORAL)"),
                         tags$li(strong("Piperacillin + tazobactam"), " (4 g + 500 mg q6h IV)"),
                         tags$li(strong("Meropenem"), " (1 g q8h IV)")
                       )
                   ),
                   
                   div(class = "warning-box",
                       strong("🩺 WHO AWaRe Notes:"), br(),
                       tags$ul(
                         tags$li("Please refer to the WHO AWaRe Antibiotic Book for detailed case-specific recommendations and considerations for different IAIs")
                       )
                   )
               )
        )
      )
    )
  )
}

# IV Analysis Tab UI
iaisIVAnalysisUI <- function(id) {
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
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view IV antibiotic analysis.")
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📌 IV Antibiotic Use", status = "primary", solidHeader = TRUE,
                   " Proportion of patients presenting with any Intra-abdominal infections (e.g. Cholecystitis, Cholangitis, Acute Appendicitis, Acute Diverticulitis) given IV antibiotics."
                   
               )
        ),
        
        fluidRow(
          column(10, offset = 1,
                 box(width = 12, title = "📈 Antibiotic Prescription by Route of Administration", status = "info", solidHeader = TRUE,
                     div(style = "
                       display: flex; 
                       justify-content: center; 
                       align-items: center; 
                       max-width: 100%; 
                       overflow: hidden;
                     ",
                         withSpinner(
                           plotlyOutput(ns("route_plot"), height = "450px", width = "100%"),
                           type = 4
                         ))
                 )
          )
        ),
        
        column(10, offset = 1,
               div(class = "note-box",
                   strong("💡 Note:"), "The proportions shown reflect the number of unique adult patients with IAIs who received antibiotics via the IV or non-IV (e.g., oral or other) route. Each patient is counted only once per route category, even if multiple antibiotics were prescribed via the same route."
               )
        ),
        
        
        
        fluidRow(
          column(10, offset = 1,
                 box(width = 12, title = "📌 Summary of  IV Antibiotic Use", status = "primary", solidHeader = TRUE,collapsible = TRUE ,collapsed = TRUE,
                     htmlOutput(ns("iv_summary"))
                     
                 )
          )
        ) 
      )
      
    )
  )
}

# Watch Analysis Tab UI
iaisWatchAnalysisUI <- function(id) {
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
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view watch antibiotic analysis.")
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📌 IV/Oral Watch Antibiotic Use", status = "primary", solidHeader = TRUE,
                   " Proportion of patients presenting with intra-abdominal infections given IV/oral antibiotics by AWaRe category (Access or Watch)."
                   
               )
        )
      ),
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📈 Antibiotic Prescription by AWaRe Classification", status = "info", solidHeader = TRUE,
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
                 strong("💡 Note:"), "This count in this visual represents the number of unique patients who were prescribed at least one antibiotic within a specific WHO AWaRe category (Access, Watch, or Reserve) during their encounter. A patient is counted once for each distinct AWaRe category they received an antibiotic from."
             )
      ),
      
      
      # fluidRow(
      #   column(10, offset = 1,
      #          box(width = 12, title = "📈 Watch Antibiotics by Route of Administration", status = "info", solidHeader = TRUE,
      #              div(style = "
      #                display: flex; 
      ##                justify-content: center; 
      #                align-items: center; 
      #                max-width: 100%; 
      #                overflow: hidden;
      #              ",
      #                  withSpinner(
      #                    plotlyOutput(ns("watch_route_plot"), height = "450px", width = "100%"),
      #                    type = 4
      #                  ))
      #          )
      #   )
      # ),
      
      # Watch Summary Box
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📊 Watch Summary", status = "success", solidHeader = TRUE,collapsible = T,
                   htmlOutput(ns("watch_summary")),
                   div(class = "note-box",
                       strong("💡 Note:"), "The proportions are based on the number of unique IAIs patients per department for each specific combination of WHO AWaRe antibiotic category and route of administration. A patient contributes to the count for each distinct AWaRe category and route combination they received. Receiving the same combination multiple times does not increase the count for that combination for that patient."
                   )
               )
        )
      )
    )
  )
}


# Choice Analysis Tab UI - Complete Version with White Backgrounds
iaisChoiceAnalysisUI <- function(id) {
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
                 title = "📌 Antibiotic Choice Alignment with AWaRe book Recommendations for Intra-abdominal infections", 
                 status = "primary", 
                 solidHeader = TRUE,
                 p("Proportion of patients presenting with any intra-abdominal infections given the appropriate IV antibiotic according to the WHO AWaRe book.")
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
                   tags$li(strong("Amoxicillin + clavulanic acid"), " (1 g + 200 mg q8h IV or 875 mg + 125 mg q8h ORAL)"),
                   tags$li(strong("Cefotaxime"), " (2 g q8h IV) + ", strong("Metronidazole"), " (500 mg q8h IV/ORAL)"),
                   tags$li(strong("Ceftriaxone"), " (2 g q24h IV) + ", strong("Metronidazole"), " (500 mg q8h IV/ORAL)"),
                   tags$li(strong("Piperacillin + tazobactam"), " (4 g + 500 mg q6h IV)"),br(),
                   strong("Second  choice:"),
                   tags$li(strong("Ciprofloxacin"), " (500 mg q12h ORAL) + ", strong("Metronidazole"), " (500 mg q8h IV/ORAL)"),
                   tags$li(strong("Meropenem"), " (1 g q8h IV)")
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
                   " Antibiotic Choice Alignment with AWaRe book Recommendations for Intra-abdominal infections"
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
                       p("This section assesses whether adult inpatients with CA-IAIs were prescribed the appropriate empirical IV antibiotics based on the WHO AWaRe Antibiotic Book."),
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
                       ),
                       br(),
                       div(
                         class = "note-box",
                         style = "background-color: white; padding: 10px; border-radius: 5px; border-left: 4px solid #3498db;",
                         strong("💡 Note:"), 
                         " The partially recommended category refers to cases where patients received only part of the recommended antibiotic regimen. This includes cases where only part of the recommended antibiotic regimen was given, or where recommended antibiotics were combined with others outside the intended combination."
                       )
                     )
                   ),
                   
                   # Tab 2: AWaRe Classification
                   tabPanel(
                     tagList(icon("layer-group"), " AWaRe Classification"),
                     div(
                       style = "background-color: white; padding: 15px;",
                       br(),
                       p("This visual summarises the proportion of IV antibiotic choice appropriateness for IAIs across hospital departments by WHO AWaRe Classification (Access, Watch, Reserve)."),
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
                       ),
                       br(),
                       div(
                         class = "info-box",
                         style = "background-color: white; padding: 10px; border-radius: 5px; border-left: 4px solid #3498db;",
                         strong("💡 Note:"),
                         tags$ul(
                           tags$li("Each patient is counted once per AWaRe category if they received at least one recommended IV antibiotic from that category. Patients treated with recommended antibiotic combinations from multiple categories are included in each, so category totals can exceed the number of unique patients."),
                           tags$li("For subgrouping within the WHO AWaRe 'Watch' category, we applied the method of Russell et al. (2023), who divided 'Watch' antibiotics into Low (e.g., cefotaxime, ceftriaxone), Medium (e.g., piperacillin–tazobactam), and High (e.g., meropenem) subgroups. This stratification reflects WHO guidance and accounts for resistance risk when antibiotics are used outside recommended indications."),
                           tags$li("Further details are available in: Russell NJ et al. (2023). Patterns of antibiotic use, pathogens, and prediction of mortality in hospitalized neonates and young infants with sepsis: A global neonatal sepsis observational cohort study (NeoOBS). PLOS Medicine 20(6): e1004179. https://doi.org/10.1371/journal.pmed.1004179")
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
                       p("This visual summarises the proportion of antibiotic choice Alignment for Intra-abdominal infections across hospital departments by line of treatment (First choice, Second choice)"),
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
                         " Patients who received metronidazole alone were not included in this analysis, as it serves as adjunct therapy for anaerobic coverage and does not independently define the treatment line for IAIs according to the WHO AWaRe book."
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
                 title = "📝 Summary of Choice Alignment for Intra-abdominal infections", 
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
iaisDosageAnalysisUI <- function(id) {
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
        box(width = 12, title = "📤 Upload Required", status = "warning", solidHeader = TRUE,
            p("Please upload your data files to view dosage appropriateness analysis.")
        )
      )
    ),
    
    conditionalPanel(
      condition = "output.dataUploaded == true",
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📌 Antibiotic Dosage Alignment with AWaRe book Recommendations for Intra-abdominal infections", status = "primary", solidHeader = TRUE,
                   
                   "Proportion of patients presenting with any Intra-abdominal infections prescribed the recommended total daily dose of IV antibiotics according to the WHO AWaRe book."
               )
        )
      ),
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "🔍 WHO AWaRe book Recommendation:", status = "primary", solidHeader = TRUE,
                   
                   tags$ul(
                     strong("First choice:"),
                     tags$li(strong("Amoxicillin + clavulanic acid"), " (1 g + 200 mg q8h IV or 875 mg + 125 mg q8h ORAL)"),
                     tags$li(strong("Cefotaxime"), " (2 g q8h IV) + ", strong("Metronidazole"), " (500 mg q8h IV/ORAL)"),
                     tags$li(strong("Ceftriaxone"), " (2 g q24h IV) + ", strong("Metronidazole"), " (500 mg q8h IV/ORAL)"),
                     tags$li(strong("Piperacillin + tazobactam"), " (4 g + 500 mg q6h IV)"),br(),
                     strong("Second  choice:"),
                     tags$li(strong("Ciprofloxacin"), " (500 mg q12h ORAL) + ", strong("Metronidazole"), " (500 mg q8h IV/ORAL)"),
                     tags$li(strong("Meropenem"), " (1 g q8h IV)")
                   )
               )
        )
      ),
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📈 Antibiotic Dosage Alignment with AWaRe book Recommendations for Intra-abdominal infections", status = "primary", solidHeader = TRUE,
                   p("This visual summarises the proportion of antibiotic dosage alignment for Intra-abdominal infections across hospital departments based on the WHO AWaRe book."),
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
                   tags$li("Received recommended IV antibiotics with recommended dosage indicates that the full recommended treatment regimen (whether monotherapy or dual therapy) was given, with all dosages aligned with WHO AWaRe book guidance."),
                   tags$li("Received at least one recommended IV antibiotic with one has recommended dosage refers to cases where only part of the recommended dual therapy was given, and only one antibiotic was at the recommended dosage."),
                   tags$li("Received at least one recommended IV antibiotic with none have recommended dosage includes cases who received either the full recommended regimen with no recommended dosages, or only part of it (e.g., one agent from a dual therapy) with none of the dosages aligned with WHO AWaRe book guidance.")
                 )
             )
      ), 
      
      
      
      
      fluidRow(
        column(10, offset = 1,
               box(width = 12, title = "📝 Summary of Antibiotic Dosage Alignment for Intra-abdominal infections", status = "info", solidHeader = TRUE,collapsible = TRUE,collapsed = TRUE,
                   htmlOutput(ns("dosage_summary"))
               )
        )
      )
    )
  )
}


# Module Server - Handles all IAIs tabs
iaisAnalysisServer <- function(id, data_reactive) {
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
        
        # Filter eligible IAIs patients - MATCH R MARKDOWN LOGIC
        data_IA <- data_patients %>%
          filter(`Diagnosis code` == "IA") %>%
          mutate(
            Route = toupper(as.character(Route)),
            AWaRe_compatible = (`Age years` >= 18 & 
                                  Indication == "CAI" & 
                                  Treatment == "EMPIRICAL" & 
                                  AWaRe %in% AWaRe_abx)
          ) 
        
        # Count eligible unique IAIs cases
        eligible_IA_n <- data_IA %>%
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
        status_message <- if(eligible_IA_n == 0) {
          "<div style='background-color:#fff3cd; border: 1px solid #ffeeba; padding: 10px; border-radius: 3px; margin-top: 10px;'>
            <strong>🚫 No eligible cases found:</strong> There were no eligible cases for evaluation during this survey period. Please verify data availability.
          </div>"
        } else if(eligible_IA_n < 10) {
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
          "empirical antibiotics for community-acquired intra-abdominal infections (CA-IAIs).",
          "</p>",
          "<ul>",
          "<li><strong>Diagnostic code:</strong> IA</li>",
          "<li><strong>Total eligible cases:</strong> ", eligible_IA_n, "</li>",
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
        filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "IA") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      eligible_patients <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx, Treatment == "EMPIRICAL", `Diagnosis code` == "IA") %>%
        distinct(`Survey Number`) %>%
        nrow()
      
      total_prescriptions <- data_patients %>%
        filter(AWaRe %in% AWaRe_abx, `Diagnosis code` == "IA") %>%
        nrow()
      
      eligible_prescriptions <- data_patients %>%
        filter(`Age years` >= 18, Indication == "CAI", AWaRe %in% AWaRe_abx, Treatment == "EMPIRICAL", `Diagnosis code` == "IA") %>%
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
        "</strong> patients on antibiotics for Intra-abdominal infections were QI-eligible patients.",
        "</p>",
        "</div>",
        
        # Card 2: Prescriptions
        "<div style='flex: 1; min-width: 300px; background-color: ", prescription_color, 
        "; border-left: 6px solid #17a2b8; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>",
        "<h4 style='margin-top: 0; color: #0c5460;'>📑 Proportion of Eligible Prescriptions:</h4>",
        "<div style='font-size: 2.5em; font-weight: bold; color: #0c5460; margin: 10px 0;'>", prescription_percentage, "%</div>",
        "<p style='margin-bottom: 0; color: #0c5460;'>",
        "<strong>", eligible_prescriptions, "</strong> out of <strong>", total_prescriptions, 
        "</strong> antibiotic prescriptions for Intra-abdominal infections were given to QI-eligible patients.",
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
          "Number of all patients with a diagnosis of Intra-abdominal infections on any antibiotics",
          "Number of eligible patients: Adult patients (≥18 years) with a diagnosis of Intra-abdominal infections who were treated empirically with antibiotics"
        ),
        Count = c(
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Diagnosis code` == "IA", AWaRe %in% AWaRe_abx) %>%
            distinct(`Survey Number`) %>%
            nrow(),
          data_patients %>%
            filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "IA", AWaRe %in% AWaRe_abx) %>%
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
          "Number of all antibiotic prescriptions for patients diagnosed with Intra-abdominal infections",
          "Number of eligible antibiotic prescriptions: antibiotics empirically prescribed for adult patients (≥18 years) with Intra-abdominal infections"
        ),
        Count = c(
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Diagnosis code` == "IA", AWaRe %in% AWaRe_abx) %>% nrow(),
          data_patients %>% filter(`Age years` >= 18, Indication == "CAI", Treatment == "EMPIRICAL", `Diagnosis code` == "IA", AWaRe %in% AWaRe_abx) %>% nrow()
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
    
    # IV Analysis Data - MATCH R MARKDOWN
    iv_data_reactive <- reactive({
      if (!check_data()) {
        return(list())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # Filter IA patients & flag eligibility - MATCH R MARKDOWN
      data_IA <- data_patients %>%
        filter(`Diagnosis code` == "IA") %>%
        mutate(
          Route = toupper(Route),
          Eligible = ifelse(`Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx, TRUE, FALSE)
        )
      
      # Keep eligible patients only
      data_IA_eligible <- data_IA %>%
        filter(Eligible == TRUE)
      
      # Summarise whether IV route was used (unique patient-level)
      summary_iv <- data_IA_eligible %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          Received_IV = any(Route == "P"),
          .groups = "drop"
        )
      
      # Department-level summary
      summary_iv_dept <- summary_iv %>%
        group_by(`Department name`) %>%
        summarise(
          Eligible = n(),
          Received_IV = sum(Received_IV),
          Not_IV = Eligible - Received_IV,
          Prop_IV = round(100 * Received_IV / Eligible, 1),
          .groups = "drop"
        )
      
      # Hospital-wide summary
      summary_iv_total <- summary_iv %>%
        summarise(
          `Department name` = "Hospital-Wide",
          Eligible = n(),
          Received_IV = sum(Received_IV),
          Not_IV = Eligible - Received_IV,
          Prop_IV = round(100 * Received_IV / Eligible, 1)
        )
      
      # Combine summaries
      summary_iv_final <- bind_rows(summary_iv_total, summary_iv_dept)
      
      list(
        data_IA_eligible = data_IA_eligible,
        summary_iv_final = summary_iv_final
      )
    })
    
    # IV Summary - MATCH R MARKDOWN
    output$iv_summary <- renderUI({
      iv_data <- iv_data_reactive()
      if(length(iv_data) == 0) {
        return(HTML("<p>No data available</p>"))
      }
      
      # Get both datasets
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # Filter IA patients & flag eligibility - MATCH R MARKDOWN
      data_IA <- data_patients %>%
        filter(`Diagnosis code` == "IA") %>%
        mutate(
          Route = toupper(Route),
          Eligible = ifelse(`Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx, TRUE, FALSE)
        )
      
      # Keep eligible patients only
      data_IA_eligible <- data_IA %>%
        filter(Eligible == TRUE)
      
      # Total counts
      total_IA <- data_IA %>% distinct(`Survey Number`) %>% nrow()
      eligible_IA <- data_IA_eligible %>% distinct(`Survey Number`) %>% nrow()
      
      if (eligible_IA == 0 || is.na(eligible_IA)) {
        final_summary_html <- HTML(paste0(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>",
          "⚠️ <strong>No summary available</strong> — there are currently no eligible patients for evaluating IV antibiotic use in community-acquired IAIs.<br><br>",
          "<em>This may indicate that no patients received antibiotics, or none met inclusion criteria.</em>",
          "</div>"
        ))
        return(final_summary_html)
      }
      
      # Summarise whether IV route was used (unique patient-level)
      summary_iv <- data_IA_eligible %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          Received_IV = any(Route == "P"),
          .groups = "drop"
        )
      
      # Department-level summary
      summary_iv_dept <- summary_iv %>%
        group_by(`Department name`) %>%
        summarise(
          Eligible = n(),
          Received_IV = sum(Received_IV),
          Not_IV = Eligible - Received_IV,
          Prop_IV = round(100 * Received_IV / Eligible, 1),
          .groups = "drop"
        )
      
      # Hospital-wide summary
      summary_iv_total <- summary_iv %>%
        summarise(
          `Department name` = "Hospital-Wide",
          Eligible = n(),
          Received_IV = sum(Received_IV),
          Not_IV = Eligible - Received_IV,
          Prop_IV = round(100 * Received_IV / Eligible, 1)
        )
      
      # Combine summaries
      summary_iv_final <- bind_rows(summary_iv_total, summary_iv_dept)
      
      # Intro block
      intro_text <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💉 <strong>Denominator:</strong> Number of eligible Intra-abdominal infections patients who received any antibiotics (<strong>", eligible_IA, "</strong> out of ", total_IA, ")",
        "</div><br><br>",
        "<strong>Summary:</strong><br><br>"
      )
      
      # Format summary cards
      formatted_blocks <- summary_iv_final %>%
        mutate(block = pmap_chr(
          list(`Department name`, Prop_IV, Received_IV, Eligible),
          function(dept, iv_p, iv_n, total_n) {
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            not_iv_n <- total_n - iv_n
            not_iv_p <- 100 - iv_p
            
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
              "<strong>Did not receive IV antibiotic</strong>: <strong>", scales::percent(not_iv_p / 100, accuracy = 0.1), "</strong> (", not_iv_n, " out of ", total_n, ")",
              "</li>",
              "</ul>",
              "</div>"
            )
          }
        )) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>%
        select(-order)
      
      # Combine all into HTML
      final_summary_html <- HTML(paste0(intro_text, paste(formatted_blocks$block, collapse = "\n")))
      return(final_summary_html)
    })
    
    # Route plot (converted to plotly) - MATCH R MARKDOWN
    output$route_plot <- renderPlotly({
      iv_data <- iv_data_reactive()
      if(length(iv_data) == 0) {
        return(plotly_empty() %>% layout(title = "No eligible data available"))
      }
      
      data_IA_eligible <- iv_data$data_IA_eligible
      
      # MATCH R MARKDOWN LOGIC EXACTLY
      summary_iv_route <- data_IA_eligible %>%
        mutate(
          Route_Group = case_when(
            Route == "P" ~ "IV",
            Route == "O" ~ "Oral",
            TRUE ~ "Other"
          )
        ) %>%
        distinct(`Survey Number`, `Department name`, Route_Group) %>%
        count(`Department name`, Route_Group, name = "Count")
      
      dept_list <- unique(data_IA_eligible$`Department name`)
      route_levels <- c("IV", "Oral", "Other")
      
      complete_grid <- expand.grid(
        `Department name` = dept_list,
        Route_Group = route_levels,
        stringsAsFactors = FALSE
      )
      
      summary_iv_route <- complete_grid %>%
        left_join(summary_iv_route, by = c("Department name", "Route_Group")) %>%
        mutate(Count = replace_na(Count, 0))
      
      # Add hospital-wide summary - MATCH R MARKDOWN
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
              "<b>Route of Antibiotic Use by Department (Intra-abdominal infections)</b><br>"
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
    
    # Watch Analysis Data - MATCH R MARKDOWN
    watch_data_reactive <- reactive({
      if (!check_data()) {
        return(list())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      
      # Filter IAIs patients & flag eligibility - MATCH R MARKDOWN
      data_IAI3 <- data_patients %>%
        filter(`Diagnosis code` == "IA") %>%
        mutate(
          Route = toupper(Route),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      # Filter eligible patients only
      data_IAI3_eligible <- data_IAI3 %>%
        filter(AWaRe_compatible == TRUE)
      
      list(
        data_IAI3 = data_IAI3,
        data_IAI3_eligible = data_IAI3_eligible
      )
    })
    
    # Watch Summary - MATCH R MARKDOWN
    output$watch_summary <- renderUI({
      watch_data <- watch_data_reactive()
      if(length(watch_data) == 0) {
        return(HTML("<p>No data available</p>"))
      }
      
      data_IAI3 <- watch_data$data_IAI3
      data_IAI3_eligible <- watch_data$data_IAI3_eligible
      
      total_IAI3 <- data_IAI3 %>% distinct(`Survey Number`) %>% nrow()
      eligible_IAI3 <- data_IAI3_eligible %>% distinct(`Survey Number`) %>% nrow()
      
      if (eligible_IAI3 == 0 || is.na(eligible_IAI3)) {
        final_summary_html <- HTML(paste0(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>",
          "⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing IV/Oral WATCH antibiotic use in IAIs.<br><br>",
          "<em>This may indicate that no patients met the criteria, or none received compatible antibiotics during the reporting period.</em>",
          "</div>"
        ))
        return(final_summary_html)
      }
      
      # One row per patient per AWaRe + Route group - MATCH R MARKDOWN
      summary_watch <- data_IAI3_eligible %>%
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
      
      # Hospital-wide summary
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
      
      # Intro block
      intro_text <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💊 <strong>Denominator:</strong> Number of eligible Intra-abdominal infections patients who received antibiotics (<strong>", eligible_IAI3, "</strong> out of ", total_IAI3, ")",
        "</div><br><br>",
        "<strong>Summary:</strong><br><br>"
      )
      
      # Formatted blocks
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
        )) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>%
        select(-order)
      
      # Render HTML output
      final_summary_html <- HTML(paste0(intro_text, paste(formatted_blocks$block, collapse = "\n")))
      return(final_summary_html)
    })
    
    # AWaRe plot (converted to plotly) - MATCH R MARKDOWN
    output$aware_plot <- renderPlotly({
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
      
      data_IAI3_eligible <- watch_data$data_IAI3_eligible
      
      # MATCH R MARKDOWN LOGIC EXACTLY
      aware_summary <- data_IAI3_eligible %>%
        group_by(`Department name`, Survey_ID = `Survey Number`, AWaRe) %>%
        summarise(Prescriptions = n(), .groups = "drop") %>%
        group_by(`Department name`, AWaRe) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Add totals and proportions per department
      aware_dept_totals <- aware_summary %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      aware_summary <- aware_summary %>%
        left_join(aware_dept_totals, by = "Department name") %>%
        mutate(Proportion = round(Patients / Total, 3))
      
      # Create hospital-level summary - MATCH R MARKDOWN NAME
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
              "<b>Proportion of Intra-abdominal infections Patients on Antibiotics by AWaRe</b><br>"
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
    
    # Watch route plot (converted to plotly) - MATCH R MARKDOWN
    output$watch_route_plot <- renderPlotly({
      watch_data <- watch_data_reactive()
      if (length(watch_data) == 0) {
        return(plotly_empty() %>% layout(title = "No eligible data available"))
      }
      
      data_IAI3_eligible <- watch_data$data_IAI3_eligible
      
      # MATCH R MARKDOWN LOGIC EXACTLY
      watch_route_summary <- data_IAI3_eligible %>%
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
          Proportion = Patients / Total
        )
      
      # Add hospital-level row - MATCH R MARKDOWN
      hospital_watch_summary <- watch_route_summary %>%
        group_by(Route_Clean) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(
          `Department name` = "Hospital-Wide",
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        select(names(watch_route_summary))
      
      # Combine with main data
      watch_route_final <- bind_rows(watch_route_summary, hospital_watch_summary)
      
      # Ensure all department × route combinations are present
      route_levels <- c("IV/Oral", "Others")
      all_combos3 <- expand_grid(
        `Department name` = unique(watch_route_final$`Department name`),
        Route_Clean = route_levels
      )
      
      # Rebuild full dataset with 0s where missing
      watch_route_final <- all_combos3 %>%
        left_join(watch_route_final, by = c("Department name", "Route_Clean")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total > 0, Patients / Total, 0),
          PlotLabel = ifelse(
            `Department name` == "Hospital-Wide",
            "<b style='color:#0072B2;'>Hospital-Wide</b>",
            `Department name`
          ),
          Route_Clean = factor(Route_Clean, levels = route_levels)
        )
      
      # X-axis department order
      label_order <- c("<b style='color:#0072B2;'>Hospital-Wide</b>",
                       sort(setdiff(unique(watch_route_final$PlotLabel), "<b style='color:#0072B2;'>Hospital-Wide</b>")))
      watch_route_final$PlotLabel <- factor(watch_route_final$PlotLabel, levels = label_order)
      
      # Color palette
      palette <- c(
        "IV/Oral" = "#3B8EDE",
        "Others" = "#e41a1c"
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
            "Total: ", Total
          )
        )
      ) +
        geom_bar(stat = "identity", position = "fill", width = 0.7) +
        geom_text(
          aes(label = ifelse(Proportion > 0.05, scales::percent(Proportion, accuracy = 1), "")),
          position = position_fill(vjust = 0.5),
          size = 2.6, color = "black"
        ) +
        geom_text(
          data = watch_route_final %>% distinct(PlotLabel, Total),
          aes(x = PlotLabel, y = 1.02, label = paste0("n=", Total)),
          inherit.aes = FALSE, size = 3, color = "gray30", hjust = 0.5
        ) +
        scale_fill_manual(
          values = palette,
          labels = c("IV/Oral" = "IV or Oral", "Others" = "Other Routes"),
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
              "<b>Route of Administration for WATCH Antibiotics (Intra-abdominal infections Patients)</b><br>"
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
    
    
    # Choice analysis data - MATCH R MARKDOWN exactly (ALL 6 CATEGORIES)
    choice_data_reactive <- reactive({
      if (!check_data()) {
        return(list())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      # Prepare the data (Select IAIs data only) - MATCH R MARKDOWN
      data_IA_choice <- data_patients %>%
        filter(`Diagnosis code` == "IA") %>%
        mutate(
          Route = toupper(Route),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx,
            TRUE, FALSE
          )
        )
      
      # Lookup ABX names for IAIs QI
      lookup_names <- data_lookup %>%
        filter(Code == "H_IAI_APPROP_DOSAGE") %>%
        select(starts_with("ABX-ATC")) %>%
        unlist(use.names = FALSE)
      
      # Create long format from lookup - MATCH R MARKDOWN
      lookup_long <- tibble(
        Drug = unlist(data_lookup %>% filter(Code == "H_IAI_APPROP_DOSAGE") %>% select(starts_with("ABX-ATC")), use.names = FALSE),
        Choice = unlist(data_lookup %>% filter(Code == "H_IAI_APPROP_DOSAGE") %>% select(starts_with("ABX-CHOICE")), use.names = FALSE)
      ) %>%
        filter(!is.na(Drug))
      
      # Merge choice info with patient-level data
      data_IA_choice <- data_IA_choice %>%
        left_join(lookup_long, by = c("ATC5" = "Drug"))
      
      # Patient Summary for Intra-Abdominal Infection - MATCH R MARKDOWN EXACTLY
      patient_summary_IA <- data_IA_choice %>%
        filter(AWaRe_compatible) %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(
          Match_1_P = any(ATC5 == lookup_names[1] & Route == "P"),
          Match_2_P = any(ATC5 == lookup_names[2] & Route == "P"),
          Match_3_P = any(ATC5 == lookup_names[3] & Route == "P"),
          Match_4_P = any(ATC5 == lookup_names[4] & Route == "P"),
          Match_5_P = any(ATC5 == lookup_names[5] & Route == "P"),
          Match_6_P = any(ATC5 == lookup_names[6] & Route == "P"),
          Match_7_P = any(ATC5 == lookup_names[7] & Route == "P"),
          
          Any_Oral = any(Route == "O"),
          Any_IV = any(Route == "P"),
          N_ABX = n_distinct(ATC5),
          .groups = "drop"
        ) %>%
        rowwise() %>%
        mutate(
          Num_recommended_given = sum(c_across(c(Match_1_P, Match_2_P, Match_3_P, Match_4_P, Match_6_P, Match_7_P))),
          
          # Full match = correct pair given and no extra IV abx - MATCH R MARKDOWN
          Received_full_recommended_IV = (
            (
              # Monotherapy cases
              (Match_1_P & Num_recommended_given == 1 & N_ABX == 1) |
                (Match_6_P & Num_recommended_given == 1 & N_ABX == 1) |
                (Match_7_P & Num_recommended_given == 1 & N_ABX == 1)
            ) |
              (
                # Dual therapy cases
                ((Match_2_P & Match_4_P) |
                   (Match_3_P & Match_4_P)) &
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
        data_IA_choice = data_IA_choice,
        patient_summary_IA = patient_summary_IA
      ))
    })
    
    # Choice plot - MATCH R MARKDOWN WITH ALL 6 CATEGORIES
    output$choice_plot <- renderPlotly({
      choice_data <- choice_data_reactive()
      if (length(choice_data) == 0) {
        return(plotly_empty() %>% layout(title = "No eligible data available"))
      }
      
      data_IA_choice <- choice_data$data_IA_choice
      patient_summary_IA <- choice_data$patient_summary_IA
      
      # Get not eligible patients with department info
      not_eligible_patients_IA <- data_IA_choice %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary table with ALL categories including ineligible
      eligible_long_IA <- patient_summary_IA %>%
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
        `Department name` = unique(c(patient_summary_IA$`Department name`, not_eligible_patients_IA$`Department name`)),
        Indicator = c("Received_full_recommended_IV", "Received_partial_recommended_IV", 
                      "Received_no_recommended_IV", "Received_oral_only", 
                      "Other_non_IV_or_oral", "Not_Eligible")
      )
      
      # Left join and replace NAs with 0
      eligible_long_IA <- all_combos %>%
        left_join(eligible_long_IA, by = c("Department name", "Indicator")) %>%
        mutate(Count = replace_na(Count, 0))
      
      # Add not eligible counts
      ineligible_summary_IA <- not_eligible_patients_IA %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Count = n)
      
      # Combine
      plot_summary <- bind_rows(
        eligible_long_IA %>% filter(Indicator != "Not_Eligible"),
        ineligible_summary_IA
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
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe IAIs QIs",
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
              "Not eligible for AWaRe IAIs QIs"
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
        "Not eligible for AWaRe IAIs QIs" = "#A9A9A9"
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
          y = "Proportional of Partients",
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
              "<b>Antibiotic Choice Alignment Summary for Intra-abdominal infections</b><br>"
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
    
    
    
    # AWaRe choice plot - UPDATED to match format
    output$choice_aware_plot <- renderPlotly({
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
      
      data_IA_choice <- choice_data$data_IA_choice
      
      # Classify antibiotics into AWaRe groups
      data_IA_AWaRe <- data_IA_choice %>%
        mutate(
          AWaRe2 = case_when(
            ATC5 %in% c("J01DD01", "J01DD04") ~ "LOW WATCH", 
            ATC5 == "J01CR05" ~ "MEDIUM WATCH", 
            ATC5 == "J01DH02" ~ "HIGH WATCH",   
            ATC5 %in% c("J01CR02", "J01XD01") ~ "ACCESS", 
            TRUE ~ NA_character_
          )
        )
      
      
      # Filter
      data_IA_AWaRe <- data_IA_AWaRe %>%
        filter(AWaRe_compatible, Route == "P", !is.na(AWaRe2))
      
      if (nrow(data_IA_AWaRe) == 0) {
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
      
      # Filter only valid cases
      aware_expanded <- data_IA_AWaRe %>%
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
      
      # Colors (matching requested order)
      aware_colors <- c(
        "ACCESS"       = "#1B9E77",
        "LOW WATCH"    = "#FDB863",
        "MEDIUM WATCH" = "#E08214",
        "HIGH WATCH"   = "#B35806"
      )
      
      # Define legend order ONLY - this will ONLY affect the legend display
      legend_order <- c("ACCESS", "LOW WATCH", "MEDIUM WATCH", "HIGH WATCH")
      
      # All AWaRe categories
      all_aware_categories <- c("ACCESS", "LOW WATCH", "MEDIUM WATCH", "HIGH WATCH")
      
      # Fill in all missing Department × Category combos (0 patients)
      # Do NOT set factor levels here - let the bars stack naturally
      complete_summary <- expand_grid(
        `Department name` = unique(AWaRe_long$`Department name`),
        AWaRe2 = all_aware_categories
      ) %>%
        left_join(AWaRe_long, by = c("Department name", "AWaRe2")) %>%
        mutate(
          Patients = replace_na(Patients, 0),
          Total = ave(Patients, `Department name`, FUN = sum),
          Proportion = ifelse(Total == 0, 0, Patients / Total)
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
            "<b>Count:</b> ", Patients, "<br>",
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
      
      # Dynamic buffer
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # ggplot - bars will stack in natural order, legend will be forced
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
        scale_fill_manual(
          values = aware_colors, 
          breaks = legend_order,  # This ONLY controls legend order
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
        guides(fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")) +
        scale_y_discrete(limits = rev(levels(complete_summary$PlotLabel)))
      
      # Convert to plotly
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
    
    # Choice line plot (converted to plotly) - MATCH R MARKDOWN
    output$choice_line_plot <- renderPlotly({
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
      
      data_IA_choice <- choice_data$data_IA_choice
      
      # Summarise choice of IV antibiotic line (First vs Second) for IAIs
      choice_summary <- data_IA_choice %>%
        filter(AWaRe_compatible == TRUE, Route == "P", Choice != "Both", !is.na(Choice)) %>%
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
      choice_levels <- c("First choice", "Second choice")
      choice_levels_stack <- c("Second choice", "First choice")
      choice_levels_legend <- c("First choice", "Second choice")
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
      
      # Filter out departments with no data
      complete_data <- complete_data %>%
        group_by(`Department name`) %>%
        mutate(dept_total_check = sum(Prescriptions, na.rm = TRUE)) %>%
        ungroup() %>%
        filter(dept_total_check > 0) %>%
        select(-dept_total_check)
      
      if(nrow(complete_data) == 0) {
        return(plotly_empty() %>%
                 layout(title = list(text = "No data available for IAI choice analysis",
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
              "<b>Use of Recommended IV Antibiotics by Line of Treatment for Intra-abdominal infections</b><br>"
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
    
    # Choice Summary - MATCH R MARKDOWN
    output$choice_summary <- renderUI({
      choice_data <- choice_data_reactive()
      if(length(choice_data) == 0) {
        return(HTML("<p>No data available</p>"))
      }
      
      patient_summary_IA <- choice_data$patient_summary_IA
      data_IA_choice <- choice_data$data_IA_choice
      
      # Get not eligible patients with department info
      not_eligible_patients_IA <- data_IA_choice %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary table with Department name - MATCH R MARKDOWN
      eligible_long_IA <- patient_summary_IA %>%
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
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Get all possible combinations of departments and indicators
      all_combos <- expand_grid(
        `Department name` = unique(c(patient_summary_IA$`Department name`, not_eligible_patients_IA$`Department name`)),
        Indicator = c("Received_full_recommended_IV", 
                      "Received_partial_recommended_IV", 
                      "Received_no_recommended_IV",
                      "Received_oral_only",
                      "Other_non_IV_or_oral",
                      "Not_Eligible")
      )
      
      # Left join and replace NAs with 0
      eligible_long_IA <- all_combos %>%
        left_join(eligible_long_IA, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      # Add not eligible
      ineligible_summary_IA <- not_eligible_patients_IA %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      # Combine
      qi_long_IA <- bind_rows(
        eligible_long_IA %>% filter(Indicator != "Not_Eligible"),
        ineligible_summary_IA
      )
      
      # Calculate total per department
      dept_totals <- qi_long_IA %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      # Final summary table with proportions - MATCH R MARKDOWN naming convention
      qi_summary_IA <- qi_long_IA %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Received_oral_only" ~ "Received oral antibiotics",
            Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe IAIs QIs",
            TRUE ~ Indicator
          ),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        select(`Department name`, Indicator, Patients, Total, Proportion)
      
      # Add Hospital Total row
      hospital_data <- qi_summary_IA %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        select(`Department name`, Indicator, Patients)
      
      # Combine with original data
      qi_summary_IA <- bind_rows(qi_summary_IA, hospital_data)
      
      # Recalculate totals and proportions
      qi_summary_IA <- qi_summary_IA %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Total eligible IAI patients (excluding "Not eligible")
      total_eligible <- qi_summary_IA %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(Indicator != "Not eligible for AWaRe IAIs QIs") %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Total receiving any IV antibiotic in relevant categories
      total_iv <- qi_summary_IA %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(Indicator %in% c(
          "Received recommended IV antibiotics",
          "Partially received recommended IV antibiotics",
          "Received IV antibiotics not among recommended options"
        )) %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Extract relevant subset
      relevant_data <- qi_summary_IA %>%
        filter(Indicator %in% c(
          "Received recommended IV antibiotics",
          "Partially received recommended IV antibiotics",
          "Received IV antibiotics not among recommended options"
        ))
      
      # If no relevant data, return message
      if (nrow(relevant_data) == 0 || total_iv == 0 || is.na(total_iv)) {
        final_summary_html <- HTML(paste0(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>",
          "⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing IV antibiotic choice appropriateness for IAI.<br><br>",
          "<em>This may indicate that no patients received IV antibiotics, or that none met the inclusion criteria during the reporting period.</em>",
          "</div>"
        ))
        return(final_summary_html)
      }
      
      # Summarise department-level proportions
      summary_data_IA <- relevant_data %>%
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
      
      # If pivoted data is empty, fallback again
      if (nrow(summary_data_IA) == 0) {
        final_summary_html <- HTML(paste0(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>",
          "⚠️ <strong>No summary available</strong> — there are currently no eligible patients for assessing IV antibiotic choice appropriateness for IAI.<br><br>",
          "<em>This may indicate that no patients received IV antibiotics, or that none met the inclusion criteria during the reporting period.</em>",
          "</div>"
        ))
        return(final_summary_html)
      }
      
      # Intro block
      intro_text <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💊 <strong>Denominator:</strong> Number of eligible Intra-abdominal infections patients who received any IV antibiotic (<strong>", total_iv, "</strong> out of <strong>", total_eligible, "</strong>)",
        "</div><br><br>",
        "<strong>Summary:</strong><br><br>"
      )
      
      # Format department blocks
      formatted_blocks <- summary_data_IA %>%
        mutate(block = pmap_chr(
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
        )) %>%
        mutate(order = ifelse(`Department name` == "Hospital-Wide", 0, 1)) %>%
        arrange(order, `Department name`) %>%
        select(-order)
      
      # Combine HTML
      final_summary_html <- HTML(paste0(intro_text, paste(formatted_blocks$block, collapse = "\n")))
      
      return(final_summary_html)
    })
    
    # Dosage Analysis Data - MATCH R MARKDOWN EXACTLY
    dosage_data_reactive <- reactive({
      if (!check_data()) {
        return(list())
      }
      
      data <- data_reactive()
      data_patients <- data$data_patients
      data_lookup <- data$data_lookup
      
      # Filter IA Patients and Add AWaRe Eligibility - MATCH R MARKDOWN
      data_IA2 <- data_patients %>%
        filter(`Diagnosis code` == "IA") %>%
        mutate(
          Route = toupper(Route),
          AWaRe_compatible = ifelse(
            `Age years` >= 18 & Indication == "CAI" & Treatment == "EMPIRICAL" & AWaRe %in% AWaRe_abx, TRUE, FALSE
          )
        )
      
      # Lookup Drug & Dose Info for H_IAI_APPROP_DOSAGE - MATCH R MARKDOWN
      lookup2 <- data_lookup %>% filter(Code == "H_IAI_APPROP_DOSAGE")
      lookup_names2 <- unlist(lookup2[1, c("ABX-ATC-1", "ABX-ATC-2", "ABX-ATC-3", "ABX-ATC-4", "ABX-ATC-5", "ABX-ATC-6", "ABX-ATC-7")], use.names = FALSE)
      
      # DON'T convert lookup names to uppercase - keep as is
      lookup_names2 <- trimws(lookup_names2)
      
      # Compute Total Daily Dose for each row in data_IA2 - MATCH R MARKDOWN
      data_IA2 <- data_IA2 %>%
        mutate(
          Unit_Factor = case_when(
            Unit == "mg" ~ 1,
            Unit == "g"  ~ 1000,
            TRUE         ~ NA_real_
          ),
          Total_Daily_Dose = as.numeric(`Single Unit Dose`) * as.numeric(`N Doses/day`) * Unit_Factor
        )
      
      # Match Drug + Dose + Route - MATCH R MARKDOWN
      for (i in 1:7) {
        name_col <- paste0("ABX-ATC-", i)
        dose_col <- paste0("ABX-DOSE-", i)
        freq_col <- paste0("ABX-DAY-DOSE-", i)
        unit_col <- paste0("ABX-UNIT-", i)
        route_col <- paste0("ABX-ROUTE-", i)
        
        dose_match_col <- paste0("Match_Drug_Dose_", i)
        
        # Standardise lookup info
        expected_dose <- as.numeric(lookup2[[dose_col]]) * as.numeric(lookup2[[freq_col]])
        dose_unit_factor <- case_when(
          lookup2[[unit_col]] == "mg" ~ 1,
          lookup2[[unit_col]] == "g"  ~ 1000,
          TRUE                       ~ NA_real_
        )
        total_expected_dose <- expected_dose * dose_unit_factor
        route_lookup <- toupper(trimws(lookup2[[route_col]]))
        drug_lookup <- trimws(lookup2[[name_col]])  # Keep original case
        
        # Create matching column - match drug name as-is, not uppercase
        data_IA2[[dose_match_col]] <- ifelse(
          data_IA2$ATC5 == drug_lookup &
            abs(data_IA2$Total_Daily_Dose - total_expected_dose) < 1 &
            data_IA2$Route == "P",
          TRUE, FALSE
        )
      }   
      
      # Summarise at Patient Level - MATCH R MARKDOWN
      patient_summary2 <- data_IA2 %>%
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
          
          Dose_1 = any(Match_Drug_Dose_1),
          Dose_2 = any(Match_Drug_Dose_2),
          Dose_3 = any(Match_Drug_Dose_3),
          Dose_4 = any(Match_Drug_Dose_4),
          Dose_5 = any(Match_Drug_Dose_5),
          Dose_6 = any(Match_Drug_Dose_6),
          Dose_7 = any(Match_Drug_Dose_7),
          
          Any_IV = any(Route == "P"),
          .groups = "drop"
        ) %>%
        mutate(
          # Define presence of any recommended IV antibiotic
          Any_Recommended_IV_Given = Match_1_P | Match_2_P | Match_3_P |
            Match_4_P | Match_6_P | Match_7_P,
          
          # Define if any recommended dosage among recommended ones
          Any_Recommended_Dose_Correct = (Match_1_P & Dose_1) |
            (Match_2_P & Dose_2) |
            (Match_3_P & Dose_3) |
            (Match_4_P & Dose_4) |
            (Match_6_P & Dose_6) |
            (Match_7_P & Dose_7),
          
          # Define if all recommended IV antibiotics given had recommended doses
          All_Matched_And_Dosed = (
            (Match_1_P & Dose_1) |
              ((Match_2_P & Dose_2) & (Match_4_P & Dose_4)) |
              ((Match_3_P & Dose_3) & (Match_4_P & Dose_4)) |
              (Match_6_P & Dose_6) |
              (Match_7_P & Dose_7)
          ),
          
          Dose_Result = case_when(
            # Fully recommended recommended IVs and all at recommended dosage
            All_Matched_And_Dosed ~ "Received recommended IV antibiotics with recommended dosage",
            
            # At least one recommended IV with recommended dosage
            Any_Recommended_IV_Given & Any_Recommended_Dose_Correct & !All_Matched_And_Dosed ~
              "Received at least one recommended IV antibiotic with only one has recommended dosage",
            
            # Received recommended IV(s) but none were at recommended dose
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
        data_IA2 = data_IA2,
        patient_summary2 = patient_summary2
      ))
    })
    
    # Dosage plot (converted to plotly) - MATCH R MARKDOWN
    output$dosage_plot <- renderPlotly({
      dosage_data <- dosage_data_reactive()
      if (length(dosage_data) == 0) {
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
      
      patient_summary2 <- dosage_data$patient_summary2
      
      # Create Summary Table by Department (with 0s for missing combos)
      all_categories <- unique(patient_summary2$Dose_Result)
      
      iv_dose_counts <- patient_summary2 %>%
        group_by(`Department name`, Dose_Result) %>%
        summarise(Patients = n(), .groups = "drop")
      
      # Add totals and proportions per department
      iv_dose_dept_totals <- iv_dose_counts %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      iv_dose_summary <- iv_dose_counts %>%
        left_join(iv_dose_dept_totals, by = "Department name") %>%
        mutate(Proportion = round(Patients / Total, 3))
      
      # Add Hospital-Wide Summary Row
      hospital_row <- iv_dose_summary %>%
        group_by(Dose_Result) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      # Combine summaries
      final_summary2 <- bind_rows(iv_dose_summary, hospital_row)
      
      # Recalculate totals and proportions with Hospital-Wide
      final_summary2 <- final_summary2 %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Colors matching original
      drug_dosage_colors <- c(
        "Received recommended IV antibiotics with recommended dosage" = "#084594",
        "Received at least one recommended IV antibiotic with only one has recommended dosage" = "#6BAED6",
        "Received at least one recommended IV antibiotic with none have recommended dosage" = "#FC9272",
        "Received IV antibiotics not among recommended options" = "#D3D3D3"
      )
      
      # Define all Dose_Result categories (for legend and completeness)
      all_categories2 <- names(drug_dosage_colors)
      
      # Fill in all missing Department × Category combos (0 patients)
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
      
      # Labels and hover text
      complete_summary <- complete_summary %>%
        filter(Total > 0) %>%
        mutate(
          PlotLabel = ifelse(`Department name` == "Hospital-Wide",
                             "<b style='color:#0072B2;'>Hospital-Wide</b>", `Department name`),
          ProportionPct = Proportion * 100,
          hover_text = paste0(
            "<b>Department:</b> ", gsub("<.*?>", "", as.character(PlotLabel)), "<br>",
            "<b>Category:</b> ", as.character(Dose_Result), "<br>",
            "<b>Count:</b> ", Patients, "<br>",
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
      
      # Dynamic buffer
      max_digits <- max(nchar(as.character(label_data$Total)), na.rm = TRUE)
      x_buffer   <- max(0.06, 0.03 + 0.035 * max_digits)
      xlim_max   <- min(1 + x_buffer, 1.5)
      label_x    <- 1 + x_buffer * 0.48
      
      # ggplot
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
      
      # Convert to plotly
      r_margin <- 40 + round(300 * x_buffer)
      
      plt <- ggplotly(p, tooltip = "text") %>%
        layout(
          title = list(
            text = paste0(
              "<b>Antibiotic Choice and Dosage alignment for Intra-abdominal infections Cases</b><br>"
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
    
    # Dosage summary - MATCH R MARKDOWN WITH ALL INDICATORS INCLUDING 0s
    output$dosage_summary <- renderUI({
      dosage_data <- dosage_data_reactive()
      if (length(dosage_data) == 0) {
        return(HTML("<p>No data available for dosage summary</p>"))
      }
      
      patient_summary2 <- dosage_data$patient_summary2
      
      # Get all possible Dose_Result categories
      all_dose_categories <- c(
        "Received recommended IV antibiotics with recommended dosage",
        "Received at least one recommended IV antibiotic with only one has recommended dosage",
        "Received at least one recommended IV antibiotic with none have recommended dosage",
        "Received IV antibiotics not among recommended options"
      )
      
      # Create summary with all departments and all dose categories
      all_depts <- unique(patient_summary2$`Department name`)
      
      complete_dose_summary <- expand_grid(
        `Department name` = all_depts,
        Dose_Result = all_dose_categories
      ) %>%
        left_join(
          patient_summary2 %>%
            group_by(`Department name`, Dose_Result) %>%
            summarise(Patients = n(), .groups = "drop"),
          by = c("Department name", "Dose_Result")
        ) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      # Add Hospital-Wide summary
      hospital_dose_summary <- complete_dose_summary %>%
        group_by(Dose_Result) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide")
      
      # Combine department and hospital-wide
      final_summary2 <- bind_rows(complete_dose_summary, hospital_dose_summary) %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = ifelse(Total == 0, 0, round(100 * Patients / Total, 1))
        ) %>%
        ungroup()
      
      # Filter for calculating totals (exclude non-recommended options)
      final_summary2_IA_filtered <- final_summary2 %>%
        filter(`Department name` != "Hospital-Wide",
               Dose_Result != "Received IV antibiotics not among recommended options")
      
      # Calculate total eligible IAI patients who received recommended/partially recommended
      total_approp_iv_given <- final_summary2_IA_filtered %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Get total_eligible from the choice_summary calculation
      choice_data <- choice_data_reactive()
      patient_summary_IA <- choice_data$patient_summary_IA
      data_IA_choice <- choice_data$data_IA_choice
      
      # Get not eligible patients
      not_eligible_patients_IA <- data_IA_choice %>%
        group_by(`Survey Number`, `Department name`) %>%
        summarise(Ineligible = all(AWaRe_compatible == FALSE), .groups = "drop") %>%
        filter(Ineligible)
      
      # Create summary to get total_eligible
      eligible_long_IA <- patient_summary_IA %>%
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
        mutate(Value = as.logical(Value)) %>%
        filter(Value) %>%
        group_by(`Department name`, Indicator) %>%
        summarise(Patients = n(), .groups = "drop")
      
      all_combos <- expand_grid(
        `Department name` = unique(c(patient_summary_IA$`Department name`, not_eligible_patients_IA$`Department name`)),
        Indicator = c("Received_full_recommended_IV", 
                      "Received_partial_recommended_IV", 
                      "Received_no_recommended_IV",
                      "Received_oral_only",
                      "Other_non_IV_or_oral",
                      "Not_Eligible")
      )
      
      eligible_long_IA <- all_combos %>%
        left_join(eligible_long_IA, by = c("Department name", "Indicator")) %>%
        mutate(Patients = replace_na(Patients, 0))
      
      ineligible_summary_IA <- not_eligible_patients_IA %>%
        count(`Department name`) %>%
        mutate(Indicator = "Not_Eligible") %>%
        rename(Patients = n)
      
      qi_long_IA <- bind_rows(
        eligible_long_IA %>% filter(Indicator != "Not_Eligible"),
        ineligible_summary_IA
      )
      
      dept_totals <- qi_long_IA %>%
        group_by(`Department name`) %>%
        summarise(Total = sum(Patients), .groups = "drop")
      
      qi_summary_IA <- qi_long_IA %>%
        left_join(dept_totals, by = "Department name") %>%
        mutate(
          Indicator = case_when(
            Indicator == "Received_full_recommended_IV" ~ "Received recommended IV antibiotics",
            Indicator == "Received_partial_recommended_IV" ~ "Partially received recommended IV antibiotics",
            Indicator == "Received_no_recommended_IV" ~ "Received IV antibiotics not among recommended options",
            Indicator == "Received_oral_only" ~ "Received oral antibiotics",
            Indicator == "Other_non_IV_or_oral" ~ "Received other non-IV/oral antibiotics",
            Indicator == "Not_Eligible" ~ "Not eligible for AWaRe IAIs QIs",
            TRUE ~ Indicator
          ),
          Proportion = round(100 * Patients / Total, 1)
        ) %>%
        select(`Department name`, Indicator, Patients, Total, Proportion)
      
      hospital_data <- qi_summary_IA %>%
        group_by(Indicator) %>%
        summarise(Patients = sum(Patients), .groups = "drop") %>%
        mutate(`Department name` = "Hospital-Wide") %>%
        select(`Department name`, Indicator, Patients)
      
      qi_summary_IA <- bind_rows(qi_summary_IA, hospital_data)
      
      qi_summary_IA <- qi_summary_IA %>%
        group_by(`Department name`) %>%
        mutate(
          Total = sum(Patients),
          Proportion = Patients / Total
        ) %>%
        ungroup()
      
      # Calculate total_eligible
      total_eligible <- qi_summary_IA %>%
        filter(`Department name` != "Hospital-Wide") %>%
        filter(Indicator != "Not eligible for AWaRe IAIs QIs") %>%
        summarise(Total = sum(Patients, na.rm = TRUE)) %>%
        pull(Total)
      
      # Handle case with no eligible patients
      if (total_approp_iv_given == 0 || is.na(total_approp_iv_given)) {
        final_summary_html2 <- HTML(paste0(
          "<div style='background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 14px; margin-top: 10px;'>",
          "⚠️ <strong>No summary available</strong> — there are currently no eligible patients for evaluating the <strong>appropriateness of IV antibiotic dosage</strong> for IAI.<br><br>",
          "<em>This may indicate that no patients met the inclusion criteria, or that no patients received recommended IV antibiotics during the reporting period.</em>",
          "</div>"
        ))
        return(final_summary_html2)
      }
      
      # Intro text card
      intro_text2 <- paste0(
        "<div style='background-color: #f8f9fa; border-left: 5px solid #17a2b8; padding: 14px; margin-top: 10px; margin-bottom: 10px;'>",
        "💊 <strong>Denominator:</strong> Number of eligible Intra-abdominal infections patients who received recommended (<em>or partially recommended</em>) IV antibiotic choice based on WHO AWaRe book (<strong>", total_approp_iv_given, "</strong> out of ", total_eligible, ")",
        "</div><br><br>",
        "<strong>Summary:</strong><br><br>"
      )
      
      # Relevant categories to display (excluding non-recommended)
      all_categories2 <- c(
        "Received recommended IV antibiotics with recommended dosage",
        "Received at least one recommended IV antibiotic with only one has recommended dosage",
        "Received at least one recommended IV antibiotic with none have recommended dosage"
      )
      
      # Calculate the total for display (sum of the 3 displayed categories only)
      dept_display_totals <- final_summary2 %>%
        filter(Dose_Result %in% all_categories2) %>%
        group_by(`Department name`) %>%
        summarise(Display_Total = sum(Patients), .groups = "drop")
      
      # Filter for display purposes and add display totals
      complete_summary <- final_summary2 %>%
        filter(Dose_Result %in% all_categories2) %>%
        left_join(dept_display_totals, by = "Department name")
      
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
      
      # Generate HTML summary blocks - INCLUDING departments with 0 patients
      formatted_blocks2 <- complete_summary %>%
        group_by(`Department name`) %>%
        summarise(
          block = {
            dept <- first(`Department name`)
            color <- if (dept == "Hospital-Wide") "#0072B2" else "#6c757d"
            bg <- if (dept == "Hospital-Wide") "#f0f0f0" else "#ffffff"
            total_patients <- first(Display_Total)
            
            list_items <- purrr::map_chr(all_categories2, function(label) {
              row_data <- complete_summary %>%
                filter(`Department name` == dept, Dose_Result == label)
              count <- if(nrow(row_data) > 0) row_data$Patients[1] else 0
              prop <- if(total_patients > 0) (count / total_patients) * 100 else 0
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
      final_summary_html2 <- HTML(paste0(intro_text2, paste(formatted_blocks2$block, collapse = "\n")))
      return(final_summary_html2)
    })
    
  })
}