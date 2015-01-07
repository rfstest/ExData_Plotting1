# This module contains the function read.household.PC (power consumption),
# which is specifically designed to read the data from the
# "Individual household electric power consumption Data Set"
# provided by UC Irvine Machine Learning Repository
# [http://archive.ics.uci.edu/ml/]

# returns the dataframe from the filename
#    row.from, row.to can be used to set up the rows to be read
read.household.PC <- function (filename = 'household_power_consumption.txt'
                               , row.from = 2 # skip header line
                               , row.to = -1) {

    # predefined classes for the variables:
    classes <- c(rep('character', 2), rep('numeric', 7))

    # predefined names (can't read header due to skipping lines)
    names <- c('Date', 'Time'
               , 'Global_active_power', 'Global_reactive_power'
               , 'Voltage', 'Global_intensity'
               , 'Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')

    # the number of rows to be read
    rows <- if (row.to == -1) -1 else (row.to - row.from + 1)

    read.table(filename
               , sep = ';'
               , header = FALSE # set names manually...
               , col.names = names # ... due to row skipping
               , na.strings = '?'
               , colClasses = classes # predefined classes
               , comment.char = ''
               , skip = row.from - 1
               , nrows = rows)
}
