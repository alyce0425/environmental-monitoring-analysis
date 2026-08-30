# Environmental Monitoring Data Analysis
# Portfolio Project 1

library(ggplot2)
# Create Dataset
em_project <- data.frame(
  Room = c("ISO7-A", "ISO7-A", "ISO7-A", 
           "ISO7-B", "ISO7-B", "ISO7-B", 
           "ISO8-A", "ISO8-A", "ISO8-A", 
           "ISO8-B", "ISO8-B", "ISO8-B"),
  Air_CFU = c(1, 0, 2,
            0, 1, 1,
            4, 7, 5,
            3, 2, 6),
  Surface_CFU = c(0, 1, 0,
                1, 0, 1,
                3, 5, 4,
                2, 1, 4),
  Temperature = c(20.1, 20.3, 20.2,
                20.5, 20.4, 20.6,
                21.2, 21.5, 21.3,
                21.0, 20.9, 21.1),
  Humidity = c(42, 44, 43,
             45, 46, 44,
             55, 58, 56,
             50, 49, 52),
  Date = c( "2026-05-01", "2026-06-01", "2026-07-01",
          "2026-05-01", "2026-06-01", "2026-07-01",
          "2026-05-01", "2026-06-01", "2026-07-01",
          "2026-05-01", "2026-06-01", "2026-07-01")
)

# Data Inspection

head(em_project)
str(em_project)

# Data Cleaning 
em_project$Date <- as.Date(em_project$Date)

str(em_project)

# Overall average Air CFU
mean(em_project$Air_CFU)

# Average Air CFU by Room
aggregate(Air_CFU ~ Room, 
          data = em_project, 
          FUN = mean
)

# Average Surface CFU by Room
Surface_avg <- aggregate(
  Surface_CFU ~ Room,
  data = em_project,
  FUN = mean
)

# Graph
ggplot(Surface_avg, aes(x = Room, y = Surface_CFU)) +
       geom_col() + 
       labs(
         title = "Surface average by Room",
         x = "Room",
         y = "Average Surface CFU"
       )

# Filtering Data
subset(em_project, Air_CFU > 3)
subset(em_project, Room == "ISO8-A")
subset(em_project, Surface_CFU >= 3)
subset(em_project, Room == "ISO8-A" & Air_CFU > 4)
subset(em_project, Room == "ISO7-A" | Room == "ISO8-A")
subset(em_project, Surface_CFU >= 4 & Humidity > 50)

# Trend Analysis

ggplot(em_project, aes(x = Date, y = Air_CFU, group = Room, color = Room)) +
      geom_line() +
      geom_point() +
      labs(
        title = "Air CFU Over Time by Room",
        x = "Date",
        y = "Air CFU"
      ) + theme_minimal()

ggplot(em_project, aes(x = Date, y = Surface_CFU, group = Room, color = Room)) +
      geom_line() + 
      geom_point() +
      labs(
        title = "Surface CFU Over Time by Room",
        x = "Date",
        y = "Surface CFU"
      )  + theme_minimal()

# Correlation Analysis 

ggplot(em_project, aes(x = Humidity, y = Air_CFU)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(
    title = "Humidity vs Air CFU",
    x = "Humidity",
    y = "Air CFU"
  ) + theme_minimal()

cor(em_project$Humidity, em_project$Air_CFU)
cor(em_project$Temperature, em_project$Surface_CFU) 

# Max and Min Values

max(em_project$Air_CFU)
subset(em_project, Air_CFU == 7)
max(em_project$Surface_CFU)
subset(em_project, Surface_CFU == max(Surface_CFU))
subset(em_project, Air_CFU == min(Air_CFU))

# Sorting and Ranking Data

Air_sorted <- em_project[order(em_project$Air_CFU, decreasing = TRUE), ]
print(Air_sorted)

Surface_sorted <- em_project[order(em_project$Surface_CFU, decreasing = TRUE),]
print(Surface_sorted)

Humidity_sorted <- em_project[order(em_project$Humidity, decreasing = TRUE), ]
print(Humidity_sorted)

# Creating New Data Columns

em_project$Total_CFU <- em_project$Air_CFU + em_project$Surface_CFU
head(em_project)
str(em_project)
mean(em_project$Total_CFU)
aggregate(Total_CFU ~ Room, data = em_project, FUN = mean)
em_project$Temp_F <- (em_project$Temperature * 9/5) + 32
head(em_project)

em_project$Air_Level <- ifelse(em_project$Air_CFU > 3, "Higher", "Lower")
head(em_project)

# Frequency Counts with table()

table(em_project$Air_Level)
prop.table(table(em_project$Air_Level)) * 100

em_project$Surface_Level <- ifelse(em_project$Surface_CFU >= 4, "Higher", "Lower")
head(em_project)
table(em_project$Surface_Level)
prop.table(table(em_project$Surface_Level)) * 100

# Missing Data

# Missing values in one column
sum(is.na(em_project$Temperature))

# Missing values in entire dataset
sum(is.na(em_project))

# Missing values by column
colSums(is.na(em_project))

# Calculate while ignoring missing values
mean(em_project$Temperature, na.rm = TRUE)

# Comparing Groups

aggregate(Air_CFU ~ Room + Air_Level, data = em_project, FUN = mean)
aggregate(Surface_CFU ~ Room + Surface_Level, data = em_project, FUN = mean)


