#PSYC 259 Homework 1 - Data Import
#For full credit, provide answers for at least 6/8 questions

#List names of students collaborating with (no more than 2): 
# Dylan, Sarah (completed mostly alone, but some collaboration happened)

#GENERAL INFO 
#data_A contains 12 files of data. 
#Each file (6192_3.txt) notes the participant (6192) and block number (3)
#The header contains metadata about the session
#The remaining rows contain 4 columns, one for each of 20 trials:
#trial_number, speed_actual, speed_response, correct
#Speed actual was whether the figure on the screen was actually moving faster/slower
#Speed response was what the participant report
#Correct is whether their response matched the actual speed

### QUESTION 1 ------ 

# Load the readr package

library(readr)
library(here)
library(fs)
library(tidyverse)

### QUESTION 2 ----- 

# Read in the data for 6191_1.txt using here()

# Hint 1: use getwd first to check working directory
getwd()
# Hint 2: make sure you let R know about the data_A subfolder
file.exists(here("data_A","6191_1.txt"))
# Hint 3: nest the readr and here() functions 
read_tsv(here("data_A","6191_1.txt"))
# Store it to an object called ds1
# Ignore the header information, and just import the 20 trials
# Be sure to look at the format of the file to determine what read_* function to use
# And what arguments might be needed
?read_tsv

# using read_tsv because it is a .txt file. 
# Skipping header information (rows 1-7) as per instructions, using skip = 7

# oops I see now they provided column names; keeping for transparency ds1 <- read_tsv(here("data_A","6191_1.txt"), skip = 7, col_names = FALSE)

# A list of column names are provided to use:
#col_names  <-  c("trial_num","speed_actual","speed_response","correct")

# 2 -- ANSWER
ds1 <- read_tsv(here("data_A","6191_1.txt"),
                skip = 7,
                col_names = c("trial_num","speed_actual","speed_response","correct")
                )
# my explanation: I used read_tsv because its a .txt file and that seemed the most appropriate.
#   I used the "skip = 7" argument because we were told to skip the header info
#   I used the col_names = c() argument once I noticed we were provided with col names.

### QUESTION 3a. ----- 

# For some reason, the trial numbers for this experiment should start at 100
# Create a new column in ds1 that takes trial_num and adds 100

# 3a -- ANSWER
ds1$trial_num_corrected <- ds1$trial_num + 100
glimpse(ds1)

### QUESTION 3b. ----- 
# Write the new data from question 3a to a CSV file in the "data_A_cleaned" folder
# Make sure to include code to create a "data_A_cleaned" folder if it doesn't already exist
# Choose a naming convention for this new dataset (ex. snake_case, no spaces, a date or version prefix/suffix)
# Add one comment explaining your naming choice

# 3b -- ANSWER
if (!dir.exists("data_A_cleaned")) dir.create("data_A_cleaned")

# writing CSV file for new dataset
write_csv(ds1, file="data_A_cleaned/6191_1_10112026.csv")

# I have chosen snake_case because that is what r uses on the back-end and is the most straightforward to this purpose.
# I may sometimes mix lowerCamel with snake_case to create more efficient names if needed. 
# But I'll try to stick to one or the other.

### QUESTION 4 ----- 

# Use list.files() to get a list of the full file names of everything in "data_A"
# Store it to a variable

# 4 -- ANSWER
data_A_all_fullnames <- list.files('data_A', full.names = TRUE)
data_A_all_fullnames

### QUESTION 5 ----- 

# Read all of the files in data_A into a single tibble called ds

# 5 -- ANSWER

ds <- read_tsv(data_A_all_fullnames,
               skip = 7,
               col_names = c("trial_num",
                             "speed_actual",
                             "speed_response",
                             "correct")
               )
glimpse(ds)

### QUESTION 6 -----

# Try creating the "add 100" to the trial number variable again
# There's an error! Take a look at 6191_5.txt to see why.
# Use the col_types argument to force trial number to be an integer "i"
# You might need to check ?read_tsv to see what options to use for the columns
# trial_num should be integer, speed_actual and speed_response should be character, and correct should be logical
# After fixing it, create the column to add 100 to the trial numbers 
# (It should work now, but you'll see a warning because of the erroneous data point)

# 6 -- ANSWER
#data_A_all_fullnames <- ds$trial_num + 100

ds <- read_tsv(data_A_all_fullnames, 
               skip = 7,
               col_names = c("trial_num",
                             "speed_actual",
                             "speed_response",
                             "correct"), 
               col_types = "iccl"
               )
glimpse(ds)

ds$trial_num_corrected <- ds$trial_num + 100
glimpse(ds)

#iccl = integer, character, character, logical; no need to separate by commas


### QUESTION 7 -----

# Now that the column type problem is fixed, take a look at ds()
# We're missing some important information (which participant/block each set of trials comes from)
# Read the help file for read_tsv to use the "id" argument to capture that information in the file
# Re-import the data so that filename becomes a column

# 7 -- ANSWER
glimpse(ds)
?read_tsv
ds <- read_tsv(data_A_all_fullnames,
               skip = 7,
               col_names = c("trial_num",
                             "speed_actual",
                             "speed_response",
                             "correct"),
               col_types = "iccl",
               id = "participant_id"
               )


ds$trial_num_corrected <- ds$trial_num + 100
glimpse(ds)

### QUESTION 8 -----

# Your PI emailed you an Excel file with the list of participant info 
# Install the readxl package, load it, and use it to read in the .xlsx data in data_B
# There are two sheets of data -- import each one into a new tibble

# 8 -- ANSWER

library(readxl)
read_xlsx("data_B/participant_info.xlsx")

sheet1 <- read_excel("data_B/participant_info.xlsx", sheet = 1)
print(sheet1)
sheet2 <- read_excel("data_B/participant_info.xlsx", sheet = 2, col_names = FALSE)
print(sheet2)
# needed col_names False to be able to have correct formatting for sheet 2 
# because our first column does have data
