# Title: Generate Interactive Pie Charts for Transcript Data
# Molly Romanis
# 05/08/2024
#
# Description: This script processes transcript data files by creating and saving interactive pie charts
# showing the distribution of transcript class codes. Each file corresponds to a different set of transcripts,
# and pie charts are saved as HTML files in the specified output folder.

##### Load Libraries #####
library(ggplot2)    # For creating plots (though not used directly here)
library(plotly)     # For creating interactive plots
library(dplyr)      # For data manipulation
library(glue)       # For constructing strings
library(stringr)   # For string manipulation

##### Set Working Directory and Folder Paths #####
# Set the working directory to the folder where the transcript files are located
setwd("~/masters/thesis_project/wf_trancriptomics_results/directRNA_ref_guided")

# Define folder paths for input (transcript files) and output (where plots will be saved)
transcripts_folder <- "transcripts_tables"   # Folder containing transcript data files
pie_plots_folder <- "pie_plots"  # Folder where pie chart reports will be saved

##### List Transcript Files #####
# List all transcript files in the input folder, including their full paths
transcript_files <- list.files(transcripts_folder, full.names = TRUE)

##### Process Each Transcript File #####
# Loop through each transcript file
for (file in transcript_files) {
  
  ##### Extract Prefix and Define Title #####
  # Extract prefix from the filename to use as the title and to name the output file
  prefix <- str_remove(basename(file), "_transcripts_table\\.tsv$")
  
  # Define the title for the pie chart using the extracted prefix
  title_name <- glue("Pie Chart of Transcripts Discovered for {prefix}")
  
  # Print a message to the console indicating which file is being processed
  cat(glue("Organizing table for {prefix}\n"))
  
  ##### Read and Clean Data #####
  # Read the transcript data from the file, using tab as the separator
  data <- read.csv(file, sep = "\t", stringsAsFactors = FALSE)
  
  # Replace all instances of "-" with NA to handle missing values
  data[data == "-"] <- NA
  
  # Remove rows with any NA values to clean the dataset
  updated_data <- na.omit(data)
  
  ##### Count and Prepare Data for Plotting #####
  # Count occurrences of each 'class_code' in the dataset
  class_code_counts <- table(updated_data$class_code)
  
  # Convert the table to a data frame for easier manipulation and plotting
  class_code_df <- as.data.frame(class_code_counts)
  colnames(class_code_df) <- c("class_code", "count")  # Rename columns for clarity
  
  # Calculate the percentage of each 'class_code' relative to the total count
  class_code_df$percentage <- (class_code_df$count / sum(class_code_df$count)) * 100
  
  ##### Define Colors and Create Pie Chart #####
  # Define colors for the pie chart slices
  colors <- c("#66c2a5", "#fc8d62", "#8da0cb", "#e78ac3", "#a6d854", "#ffd92f", "#e5c494", "#b3b3b3")
  
  # Print a message to the console indicating that the plot is being created
  cat(glue("Creating plots for {prefix}\n"))
  
  # Create the pie chart using Plotly
  pie_chart <- plot_ly(class_code_df, labels = ~class_code, values = ~count, type = 'pie',
                       textinfo = 'label+percent',       # Show labels and percentages on the chart
                       hoverinfo = 'text',               # Show text when hovering over slices
                       text = ~paste(class_code, ': ', round(percentage, 2), '%'), # Display detailed text
                       marker = list(colors = colors, line = list(color = '#FFFFFF', width = 1))) %>%
    layout(title = list(text = title_name, font = list(size = 20)),  # Set title and font size
           showlegend = TRUE,                                           # Display legend
           legend = list(title = list(text = 'Class Codes', font = list(size = 14)), # Customize legend
                         x = 1, y = 0.5),
           margin = list(l = 50, r = 50, b = 50, t = 50),               # Set margins around the plot
           paper_bgcolor = 'rgba(0,0,0,0)',                              # Transparent background for the paper
           plot_bgcolor = 'rgba(0,0,0,0)')                              # Transparent background for the plot area
  
  ##### Save Pie Chart as HTML #####
  # Define the output file path and name for the pie chart
  output_file <- file.path(pie_plots_folder, paste0(prefix, "_pie_chart.html"))
  
  # Save the pie chart as an HTML file in the specified output folder
  htmlwidgets::saveWidget(pie_chart, output_file)
}
