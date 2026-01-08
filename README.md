
# 📊 AWaRe Quality Indicators – Inpatient Dashboard 

#### Overview 

This repository hosts the AWaRe Quality Indicators (QI) Inpatient Dashboard, including: 

- The R Shiny dashboard source code and prototypes 

- R Markdown source code and prototypes 

- Supporting documentation (User Manual, Interpretation Guides, Data Conversion Guide) 

- Relevant publications and resources 

The dashboard uses existing antimicrobial use (AMU) surveillance data, specifically Global Point Prevalence Survey (Global-PPS) data, to automatically generate AWaRe-based prescribing quality indicators. It supports antimicrobial stewardship (AMS) decision-making at hospital, national, and global levels. 

Although the dashboard is built on the Global-PPS data structure, a Data Standardisation (Conversion) Guide is provided to enable facilities using other surveillance systems (e.g. WHO PPS) to adapt their data and benefit from the dashboard outputs. 

##### Repository Structure  
``` text
AWaRe_QI_Inpatient/
├──Markdown  
├── R/
│   └── modules/
├── www/
│   └── css/
│   └── js/     
│   └── img/ 
└── data/
├──example/  
├──app.R  
├──LICENSE  
├──README
```

<h1>🚀 Dashboard Access</h1>

<h2>Run Locally (Recommended for Development)</h2>
<p> download the </p>

<p>Clone the repository:</p>
<pre><code>git clone https://github.com/CNPI-ADILA/AWaRe_QI_inpatient.git
cd aware-inpatient-dashboard</code></pre>

<p>Open R or RStudio and install required packages:</p>
<pre><code>install.packages(c(
  "shiny",
  "tidyverse",
  "lubridate",
  "plotly",
  "DT",
  "shinythemes"
))</code></pre>

<p>Run the dashboard:</p>
<pre><code>shiny::runApp("inpatient_dashboard")</code></pre>


<hr>

<h2>🧪 Navigate Using Dummy Data</h2>

<p>The <code>dummy_data/</code> folder provides example datasets that allow you to:</p>
<ul>
    <li>Explore all dashboard features</li>
    <li>Navigate across AWaRe indicators and conditions</li>
    <li>Test report generation without exposing real or sensitive data</li>
</ul>

<hr>

<h2>📄 Reports (R Markdown)</h2>

<p>The <code>inpatient_rmarkdown_reports/</code> directory contains R Markdown templates for:</p>
<ul>
    <li>Automated inpatient feedback reports</li>
    <li>Condition-specific summaries (e.g., sepsis, meningitis, etc.)</li>
</ul>

<p>You can render reports directly in RStudio or via:</p>
<pre><code>rmarkdown::render("inpatient_rmarkdown_reports/report_template.Rmd")</code></pre>

<hr>

<h2>📚 Supporting Documentation</h2>

<p>The <code>docs/</code> folder includes comprehensive guidance for dashboard users and analysts:</p>

<table>
    <tr>
        <th>Document</th>
        <th>Description</th>
    </tr>
    <tr>
        <td>User Manual</td>
        <td>Step-by-step instructions for dashboard setup and use</td>
    </tr>
    <tr>
        <td>AMU Interpretation Guide</td>
        <td>How to interpret AWaRe QIs and performance metrics</td>
    </tr>
    <tr>
        <td>Graph Interpretation Guide</td>
        <td>Explains dashboard visualizations</td>
    </tr>
    <tr>
        <td>Data Standardisation (Conversion) Guide</td>
        <td>Prepares input data for compatibility with the Global-PPS structure</td>
    </tr>
</table>

<p>These resources are designed for AMS teams, data analysts, and policy stakeholders.</p>

<hr>

<h2>🏷️ Releases</h2>

<table>
    <tr>
        <th>Version</th>
        <th>Description</th>
    </tr>
    <tr>
        <td>v1.0.0</td>
        <td>Initial public release</td>
    </tr>
</table>

<hr>

<h2>🔐 Data Privacy</h2>

<p>This repository does <strong>not</strong> contain any real patient-level data. Users are responsible for ensuring all uploaded or processed data comply with local data protection, ethical, and governance requirements.</p>

<hr>

<h2>🔗 Related Resources</h2>

<ul>
    <li><a href="https://antibioticpolicy.org/" target="_blank" rel="noopener noreferrer">Antibiotic Policy Group (APG) Website</a></li>
    <li><a href="https://www.global-pps.com/" target="_blank" rel="noopener noreferrer">Global Point Prevalence Survey (Global-PPS)</a></li>
    <li><a href="https://www.who.int/teams/surveillance-prevention-control-AMR/control-and-response-strategies/AWaRe" target="_blank" rel="noopener noreferrer">WHO AWaRe Classification</a></li>
    <li><a href="https://www.who.int/publications/i/item/9789240062382" target="_blank" rel="noopener noreferrer">WHO AWaRe Antibiotic Book</a></li>
    <li>Relevant Publications – see <code>docs/</code> for references</li>
</ul>


<hr>

<h2>📬 Contact</h2>

<p>For questions, feedback, or collaboration enquiries, please contact:<br>
📧 <a href="mailto:aicook@sgul.ac.uk">Aislinn Cook</a>
📧 <a href="mailto:halmadho@sgul.ac.uk">Hossam Almadhoon</a>
📧<a href="mailto:bnjie@sgul.ac.uk">Baboucarr Njie</a></p>

<hr>



</body>
</html>

