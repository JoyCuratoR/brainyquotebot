# Brainy Quote Automated Twitter Bot

Huge thank you to Matt Dray for providing the tutorial and basic framework for this project, I wouldn't have known where to start. You can find the guide and documentation [here](https://github.com/matt-dray/londonmapbot). Additionally, the idea to build a bot that webscrapes content instead of using an API came from this repo [here](https://github.com/TimTeaFan/rstatspkgbot). 

## The Premise 
Even before beginning my data analytics journey, automation has always fascinated me. Building an automated Twitter bot isn't anything complex in terms of what can be automated but it's a simple start. In this tutorial, we'll be building a bot that scrapes HTML nodes from a site called Brainy Quote and use Windows Task Scheduler to automate posting on Twitter.  

# Step 1: Install & Load Packages
Please note that along with the necessary packages, you'll also need to have a [selector tool](https://chrome.google.com/webstore/detail/selectorgadget/mhjhnkcfbdhnjickkkdbjoemdmbfginb?hl=en).
``` r
library(rvest)
library(dplyr)
library(rtweet)
```
# Step 2: Establish Website Link & Read the HTML
We'll copy the link of the site we want to scrape from, in this case it's Brainy Quote's 'Quote of the Day' page, and create a variable called link. Then we'll create a second variable called page using the function ``` read_html ``` that reads the page's HTML.
``` r
link <- "https://www.brainyquote.com/quote_of_the_day"
page <- read_html(link)
```
# Step 3: Extracting the HTML nodes
We'll be extracting the first quote using a selector tool [chrome extension](https://chrome.google.com/webstore/detail/selectorgadget/mhjhnkcfbdhnjickkkdbjoemdmbfginb?hl=en). 
## A basic rundown of how to use the Selector Gadget extension
Once you've installed it as an extension, click on the icon to open it up. A thin white box should appear on the lower right corner of your screen. Additionally, where your
``` r

