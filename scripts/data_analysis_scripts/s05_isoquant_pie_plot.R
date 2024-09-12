# Title: Generate Pie Chart of Transcripts Discovered from ISOQuant Analysis
# Description: This script reads a TSV file containing transcript data, processes the data to count
# the occurrences of each transcript match type, calculates the percentage of each match type,
# and creates a pie chart to visualize the distribution of transcript matches. The pie chart is saved as an HTML file.

##### Load Libraries #####
library(plotly)
library(htmlwidgets)

##### Set Working Directory #####
setwd("~/masters/thesis_project/wf_trancriptomics_results/directRNA")

##### Define Title #####
# Define the title for the pie chart
title_name <- "Pie Chart of Transcripts Discovered from ISOQuant Analysis"

cat("Organizing table\n")  # Print message to the console

##### Read and Process Data #####
# Read the TSV file into a data frame
data <- read.table("OUT.novel_vs_known.SQANTI-like.tsv", header = TRUE, sep = "\t")

# Extract the 6th column from the data frame
match_counts <- data[, 6]

# Print the extracted 6th column to the console
print(match_counts)

# Create a data frame with counts of each unique value in the 6th column
match_counts_table <- as.data.frame(table(match_counts))
# Rename the columns to "match" and "count"
colnames(match_counts_table) <- c("match", "count")

# Calculate the percentage of each match type
match_counts_table$percentage <- (match_counts_table$count / sum(match_counts_table$count)) * 100

# Define colors for the pie chart slices
colors <- c("#66c2a5", "#fc8d62", "#8da0cb", "#e78ac3", "#a6d854", "#ffd92f", "#e5c494", "#b3b3b3")

cat("Creating plots\n")  # Print message to the console

##### Create and Customize Pie Chart #####
# Create the pie chart using plotly
pie_chart <- plot_ly(
  match_counts_table, 
  labels = ~match, 
  values = ~count, 
  type = 'pie', 
  textinfo = 'label+percent',  # Show labels and percentages on the chart
  hoverinfo = 'text',  # Show text when hovering over slices
  text = ~paste(match, ': ', round(percentage, 2), '%'),  # Detailed text display
  marker = list(colors = colors, line = list(color = '#FFFFFF', width = 1))  # Set slice colors and border
) %>%
  layout(
    title = list(text = title_name, font = list(size = 20)),  # Set title and font size
    showlegend = TRUE,  # Display legend
    legend = list(title = list(text = 'Match', font = list(size = 14)), x = 1, y = 0.5),  # Customize legend
    margin = list(l = 50, r = 50, b = 50, t = 50),  # Set margins around the plot
    paper_bgcolor = 'rgba(0,0,0,0)',  # Transparent background for the paper
    plot_bgcolor = 'rgba(0,0,0,0)'  # Transparent background for the plot area
  )

##### Save Pie Chart as HTML #####
# Save the pie chart as an HTML file
htmlwidgets::saveWidget(pie_chart, "isoquant_pie_chart.html")
