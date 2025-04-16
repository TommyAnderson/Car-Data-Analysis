# Car-Data-Analysis

## Data Collection Process

Our group consisted of three members: Diya, Tommy, and Philip. We each recorded vehicle speed data separately at different times during the week of April 7th - April 14 2025, near the intersection of 30th St and 24th Avenue in Rock Island, IL.

Each member was responsible for documenting:
- The vehicle’s speed (measured via a radar detector)
- The time of observation
- Weather conditions
- Date
- License plate state
- Color and type of vehicle

### Data Collection Shifts
- **Diya** recorded on April 7th between 4:30 PM - 5:15 PM.
- **Tommy** collected data on April 9th 4:15 PM - 4:50 PM.
- **Philip** collected data on April 14th 2:15 PM - 3:15 PM.

### Communication and Coordination

To organize the assignment, we set up a group chat via Snapchat, where we planned our recording times to ensure no overlap and full coverage throughout different parts of the day. We shared our individual data in a shared Google Sheet, which we then exported as a CSV for analysis in R.

---

## Data Analysis

After cleaning the data in R using `dplyr` and `lubridate`, we conducted basic descriptive analysis on vehicle speeds. This included standardizing text values (like car color and type), converting time to 24-hour format, and visualizing the data using `ggplot2`.

### Summary Statistics:
- **Minimum Speed:** 23 mph  
- **Maximum Speed:** 38 mph  
- **Mean Speed:** 30.61 mph  
- **Median Speed:** 31 mph

These statistics provide a snapshot of typical driving behavior at the observed intersection.

---

## Shiny App

We developed an interactive Shiny web application that allows users to:
- Select any variable (e.g., Car Color, Type, Plate State) for the X-axis
- Compare average speeds split by another category
- View results as a bar chart (for categorical X) or scatter plot (for continuous X)
- Explore a searchable and sortable data table

### Screenshot of the App

Below is a preview of our working Shiny application, showing a plot of average speed by vehicle type, split by color:


