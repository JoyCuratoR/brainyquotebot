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
We'll copy the link of the site we want to scrape from, in this case it's Brainy Quote's 'Quote of the Day' page, and create a variable called ``` link```. Then we'll create a second variable called ```page``` using the function ``` read_html ``` that reads the page's HTML.
``` r
link <- "https://www.brainyquote.com/quote_of_the_day"
page <- read_html(link)
```
# Step 3: Extracting the HTML nodes
We'll be extracting the first quote using a selector tool [chrome extension](https://chrome.google.com/webstore/detail/selectorgadget/mhjhnkcfbdhnjickkkdbjoemdmbfginb?hl=en). 

![screenshot 37](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(37).png)

## A basic rundown of how to use the Selector Gadget extension
Once you've installed it as an extension, click on the icon to open it up. A thin white box should appear on the lower right corner of your screen. Additionally, where your mouse is on the screen, there should be an orange box highlighting a part of the page. 

![screenshot 38](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(38).png)

Click on the actual quote, it should highlight the quote in green with a red box outlining it. The rest of the page is highlighted yellow.

![screenshot 39](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(39).png)

What's happening now is that Selector Gadget wants us to specify exactly which HTML nodes we want and to do that we will click on the yellow parts - the parts we don't want. After specifying the parts we don't want the extension to grab, only the quote we clicked on is highlighted green, the rest of the quotes that have the same HTML node is highlighted yellow and the section where we said we don't want is highlighted in red. Sometimes we may have to click on more yellow parts to specify further to the extension which parts we don't need.

Finally, we'll end up with a specific HTML node that appears in the bottom right corner box (see arrow).
![screenshot 40](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(40).png)

## Extracting nodes
Next, we want to get the HTML node's XPath and to do this we click on the Xpath button.
![screenshot 40.1](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(40.1).png)

Once we do that a box will pop up. 
![screenshot 41](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(41).png)

We'll copy the XPath to use in our script. 
![screenshot 42](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(42).png)

# Step 4: Creating the individual parts of the tweet
Now that we have our copied XPath, we're going to create a variable called ``` quote_content ```
``` r
quote_content <- page %>%
  html_element(xpath = '//*[contains(concat( " ", @class, " " ),
               concat( " ", "oncl_q", " " ))]//div') %>%
  html_text()
```

``` r
quote_title <- page %>%
  html_element(xpath = '//*[contains(concat( " ", @class, " " ),
               concat( " ", "qotd-h2", " " ))]') %>%
  html_text()
```

