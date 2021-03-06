# Plots 4 graphs for 1/2/2007 -- 2/2/2007

# The function read.household.PC() is copied to each plotX.R file
# just in case external files are not allowed;
# normally it will reside in a separate file,
# which will be sourced in each plotX.R the following way:
# load function for reading data
#source('read_household_PC.R')

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


# Determine the range of lines to be read with grep command in BASH:
##
## $ grep -nm1 "^1/2/2007" household_power_consumption.txt
## 66638:1/2/2007;00:00:00;0.326;0.128;243.150;1.400;0.000;0.000;0.000
## $ grep -nm1 -B1 "^3/2/2007" household_power_consumption.txt
## 69517-2/2/2007;23:59:00;3.680;0.224;240.370;15.200;0.000;2.000;18.000
## 69518:3/2/2007;00:00:00;3.614;0.106;240.990;15.000;0.000;1.000;18.000

# read data
pwc <- read.household.PC(row.from = 66638, row.to = 69517)
pwc <- transform(pwc,
                 DateTime = strptime(paste(Date, Time), '%e/%m/%Y %H:%M:%S'))

# open PNG device
png('plot4.png', width = 480, height = 480)

par(mfcol=c(2,2))

# plot the graphs
with(pwc, {
    # Global Active Power ~ Time line graph
    plot(DateTime, Global_active_power
         , type = 'l'
         , main = ''
         , xlab = ''
         , ylab = 'Global Active Power (kilowatts)')

    # Energy sub metering ~ Time line graphs
    plot(DateTime, Sub_metering_1
         , type = 'l'
         , col = 'black'
         , main = ''
         , xlab = ''
         , ylab = 'Energy sub metering'
         , ylim = range(c(Sub_metering_1, Sub_metering_2, Sub_metering_3))
    )
    points(DateTime, Sub_metering_2
           , type = 'l'
           , col = 'red'
           , ylim = range(c(Sub_metering_1, Sub_metering_2, Sub_metering_3))
    )
    points(DateTime, Sub_metering_3
           , type = 'l'
           , col = 'blue'
           , ylim = range(c(Sub_metering_1, Sub_metering_2, Sub_metering_3))
    )
    legend('topright'
           , legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')
           , col = c('black', 'red', 'blue')
           , lty = 1
    )

    # Voltage ~ Time line graph
    plot(DateTime, Voltage
         , type = 'l'
         , main = ''
         , xlab = 'datetime'
         , ylab = 'Voltage'
         )

    # Global reactive power ~ Time line graph
    plot(DateTime, Global_reactive_power
         , type = 'l'
         , main = ''
         , xlab = 'datetime'
         , ylab = 'Global_reactive_power'
    )
})

# close the device
dev.off()
