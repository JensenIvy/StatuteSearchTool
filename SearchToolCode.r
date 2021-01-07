---
title: OKLAHOMA STATUTE SEARCH TOOL
output: 
  flexdashboard::flex_dashboard:
    orientation: rows #makes tab/tabset work
    vertical_layout: scroll #allows vertical scrolling
    theme: bootstrap #formatting
    source_code: embed
runtime: shiny
---
 
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE,
                      collapse = TRUE,
                      comment = "#>"
)

library(tidyverse)
library(DT)
library(shiny)
library(flexdashboard)
library(formattable) #centering column content
library(jsonlite) #data table header fill
library(rhandsontable) #spacing around data table
library(knitr) #html tables
library(kableExtra) #html table aesthetics

statutes <- read_csv("statutes.csv") 

```

SEARCH {.tab}
=========

<font size = "6"><center>**Search Oklahoma's Criminal Statutes**</center></font>

---

<br><font size = "3">Navigate to other tabs for more information.</font>
<br>
<br>

```{r, echo=FALSE}

shinyApp(
ui = fluidPage(
      fluidRow(
        column(12,
          dataTableOutput('statutes')
        ),
        rHandsontableOutput("myTable", width = "600px", height = "800px"),
        tags$head(
          tags$style(HTML("
      .handsontable {
        overflow: visible;
      }
    "))
        )
    )),
    server = function(input, output) {
     output$statutes <- renderDataTable(statutes,
       filter = "top",
       class = 'cell-border stripe',
       rownames = FALSE,
       selection = c("multiple", "single", "none"),      
       extensions = list(Scroller=NULL, #need for vi_width
                         FixedColumns=list(leftColumns=2)), #need for vi_width
       options = list(initComplete = JS(
                          "function(settings, json) {",
                          "$(this.api().table().header()).css
                          ({'background-color': '#000000', 
                                                'color':     
                                                '#fff'});",
                                            "}"), ###2F5E74' is an ADA-clear color, column heads
                          dom = 'T<"clear">lfrtip', #need for vi_width
                          autoWidth = TRUE, 
                          columnDefs = list(list(
                                        className = 'dt-center', 
                                        targets=0:14), #col_center all
                                        list(width=200, targets=0)), #vi_width
                           deferRender = TRUE, #need for vi_width
                           scrollX = TRUE, scrollY = 1000, #need for vi_width
                           scrollCollapse = TRUE, #need for vi_width
                           pageLength = 10,
                           lengthMenu = c(10,25,50,100,200) 
                          )
      )
    }
  )

```

<br>

---


LEGEND {.tab}
================

<font size="5"><center>**Key Definitions**</center></font>

---

<br><font size="3">

 - **Restitution** is either the return of something taken or the compensation of loss or injury, according to Cornell's [Legal Information Institute](https://www.law.cornell.edu/wex/restitution). Courts may demand resitution from a defendant on behalf of a plaintiff or victim.
<br><br>

 - In this database, the **Public Official** column indicates whether a statute applies specifically or differently to public figures than it does to the general public. Public officials are loosely defined here as individuals with some measure of authority (e.g. law enforcement agents, elected officials, individuals in certain appointed government positions, individuals operating contractually on behalf of the government, etc.)
<br><br>

 - **Statute 21-9** defines the punishment of *felonies*. Where a felony's penalties (sentences and/or fines) are labelled as "Unspecified," either another statute outlines the offense's lawful punishment or the penalties defined in Statute 21-9 may apply:
<br>

| Sentence     | Fine |
| :---: | :---: |
| 0 to 2 years | $0 to $1000 |

<br>

 - **Statute 21-10** defines the punishment of *misdemeanors*. Where a misdemeanor's penalties (sentences and/or fines) are labelled as "Unspecified," either another statute outlines the offense's lawful punishment or the penalties defined in Statute 21-10 may apply:
<br>

| Sentence | Fine |
| :---: | :---: |
| 0 to 1 year | $0 to $500 |

<br>

 - **Statute 21-64** states: 
 <br> 
 **1)** anyone who is convicted of any *misdemeanor* that's punishable by any sentence may also be punished by an additional fine worth up to $1,000; and
 <br> 
 **2)** anyone who is convicted of any *felony* that's punishable by any sentence may also be punished by an additional fine of up to $10,000.

</font>


ABOUT {.tabset}
============

<font size="5"><center>**About the Search Tool**</center></font>

---

<br><font size="3">
This database currently allows you to search the criminal offenses addressed in **Title 21: Crimes and Punishments**, the main criminal code under the Oklahoma Statutes. We recorded the information in this database from the [Oklahoma State Courts Network](https://www.oscn.net/applications/oscn/index.asp?ftdb=STOKST&level=1) website and last updated Title 21 in June 2019. 
<br>

To search the whole database, you can enter a word or phrase into the main search bar. You can also get results that suit multiple criteria by entering your query into the individualized search bars of each column. You don't need to worry about capitalization, but correct spelling is important! If your first thought doesn't return results, try using similar words or phrases. Keep in mind that this database does not include statutes found in any other title.
<br><br>

Anyone is welcome to download the raw table data using the button above. The source code for this search tool is available via the button in the upper right-hand corner. If you notice an incorrect or missing entry, you can email ojointern@okpolicy.org with the corrected information. Please include "Statute Search Correction" in the subject line or your email may not be viewed. Thank you.

<br>
<center>

```{r echo=FALSE}
downloadButton("downloadData", "Download Data")
  downloadHandler(filename = "Criminal_Catalog_Title_21_Shiny_Ready.csv",
                  content = function(file) {
                    write.csv(data, file, row.names = FALSE)
                  })  
```

</center>
<br>