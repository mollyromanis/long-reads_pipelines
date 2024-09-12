# Script for Processing JAFFA Fusion Results and Generating Chimeraviz Reports
# Molly Romanis
# 04/08/2024
#
# This script performs the following tasks:
# 1. Loads necessary libraries for fusion analysis and reporting.
# 2. Sets the working directory and folder paths.
# 3. Lists JAFFA result files and processes each one.
# 4. Imports fusion data, generates visualizations, and creates HTML reports using Chimeraviz.

########## Load Required Libraries ##########
# Load the required libraries into the R session
library(chimeraviz)  # For visualizing and analyzing fusion genes
library(glue)        # For creating strings with embedded R expressions
library(stringr)     # For string manipulation functions

########## Set Working Directory and Folder Paths ##########
# Set the working directory to the folder containing your results
setwd("~/masters/thesis_project/wf_trancriptomics_results/directRNA")

# Define folder paths for input and output
jaffa_results_folder <- "jaffa_results"           # Folder containing JAFFA results
chimeraviz_output_folder <- "chimeraviz_reports"  # Folder where reports will be saved
circle_plots_folder <- "circle_plots"             # Folder where circle plots will be saved

########## List and Process JAFFA Result Files ##########
# List all files in the 'jaffa_results' folder that match the pattern '_jaffa_results.csv'
jaffa_files <- list.files(path = jaffa_results_folder, pattern = "_jaffa_results\\.csv$", full.names = TRUE)

# Process each JAFFA result file
for (file in jaffa_files) {
  # Extract the base name of the file (without the '_jaffa_results.csv' suffix)
  prefix <- str_remove(basename(file), "_jaffa_results\\.csv$")
  
  # Create the output file names
  report_file_name <- glue("{chimeraviz_output_folder}/{prefix}report.html")
  plot_file_name <- glue("{circle_plots_folder}/{prefix}_circle_plot.png")
  
  # Print a message indicating the progress
  cat(glue("Creating plots for {prefix}"))
  
  ########## Import Fusion Data and Generate Reports ##########
  # Import fusion data from the JAFFA results file for the 'hg38' genome build
  fusions <- import_jaffa(file, "hg38")
  # Generate a circle plot of the fusion data
  plot <- plot_circle(fusions)
  
  # Save the circle plot to a file
  png(filename = plot_file_name, width = 800, height = 800)
  print(plot)  # Ensure the plot is printed to the device
  dev.off()    # Close the device
  
  # Create an HTML report of the fusion data and save it to the specified file
  create_fusion_report(fusions, report_file_name)
}
