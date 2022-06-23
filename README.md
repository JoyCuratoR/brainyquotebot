# Brainy Quote Automated Twitter Bot

Huge thank you to Matt Dray for providing the tutorial and basic framework for this project, I wouldn't have known where to start. You can find the guide and documentation [here](https://github.com/matt-dray/londonmapbot). Additionally, the idea to build a bot that webscrapes content instead of using an API came from this [repo](https://github.com/TimTeaFan/rstatspkgbot) and the [guide](https://rpubs.com/mccannecology/54352) I used to help me with Task Scheduler.

# The Premise 
Even before beginning my data analytics journey, automation has always fascinated me. Building an automated Twitter bot isn't anything complex in terms of what can be automated but it's a simple start. In this tutorial, we'll be building a bot that scrapes HTML nodes from a site called Brainy Quote and use Windows Task Scheduler to automate posting on Twitter.  

There's two main components to how this works: we create an Rscript file that scrapes the necessary content then we schedule a task through Windows Task Scheduler to automatically post our tweet.

# Before You Begin
This tutorial is assuming that you already have a Twitter Developer account, Elevated Access to Twitter's API and have changed your app/project's permissions to Read and Write as well as have generated your API tokens. For more information on how to do this, please [go here](
https://oscarbaruffa.com/twitterbot/).

# Step 1: Writing the Rscript (Install & Load Packages)
Please note that along with the necessary packages, you'll also need to have a [CSS selector tool](https://chrome.google.com/webstore/detail/selectorgadget/mhjhnkcfbdhnjickkkdbjoemdmbfginb?hl=en).
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
# Step 3: Extracting the HTML Nodes
We'll be extracting the first quote using the selector tool chrome extension. 

![screenshot 37](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(37).png)

## A Basic Rundown of How to Use the Selector Gadget Extension
Once you've installed it as an extension, click on the icon to open it up. A thin white box should appear on the lower right corner of your screen. Additionally, where your mouse is on the screen, there should be an orange box highlighting a part of the page. 

![screenshot 38](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(38).png)

Click on the text of the quote, it should highlight the words in green with a red box outlining it while the rest of the page is highlighted yellow.

![screenshot 39](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(39).png)

What's happening now is that Selector Gadget wants us to specify exactly which HTML nodes we want and to do that we will click on the yellow parts - the parts we don't want. After specifying the parts we don't want the extension to grab, only the quote we clicked on is highlighted green, the rest of the quotes that have the same HTML node is highlighted yellow and the section where we said we don't want is highlighted in red. Sometimes we may have to click on more yellow parts to specify further to the extension which parts we don't need.

Finally, we'll end up with a specific HTML node that appears in the bottom right corner box (see arrow).
  
![screenshot 40](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(40).png)

## Extracting Nodes
Next, we want to get the HTML node's XPath and to do this we click on the Xpath button (see arrow).

![screenshot 40.1](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(40.1).png)

Once we do that a box will pop up. 

![screenshot 41](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(41).png)

We'll copy the XPath to use in our script. 

![screenshot 42](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(42).png)

# Step 4: Creating the Individual Parts of the Tweet

## Quote Content
Now that we have our copied XPath, we're going to create a variable called ``` quote_content ```. 

``` r
quote_content <- page %>%
  html_element(xpath = '//*[contains(concat( " ", @class, " " ),
               concat( " ", "oncl_q", " " ))]//div') %>%
  html_text()
```
We're using the function ```html_element``` instead of its plural counterpart ```html_elements``` because with the singluar ```html_element``` we're determining out of all the quotes that share the same HTML node ```.oncl_q div``` we only want one of them. Had we gone ahead and copied the HTML node ```.oncl_q div``` instead of the XPath and used the function ```html_elements``` we would've returned all the quotes highlighted in yellow.

## Quote Title
Let's extract the title next - this part is **optional**.

We'll go back to the Selector Gadget and at the top left corner right under the logo Brainy Quote, we'll click on the ```Quote of the Day``` title. It should be the only part highlighted green. 

Again, we'll click on XPath, copy it, and use the following code to extract it.

``` r
quote_title <- page %>%
  html_element(xpath = '//*[contains(concat( " ", @class, " " ),
               concat( " ", "qotd-h2", " " ))]') %>%
  html_text()
```
## Quote Author
Extracting the author of the quote is much of the same process as before. Use the extension to select which HTML node we want, exclude the parts we don't want until all that's highlighted in green and yellow are the ones we need. Click XPath, copy it, and use the following code to extract it.

``` r
quote_author <- page %>%
  html_element(xpath = '//*[contains(concat( " ", @class, " " ),
               concat( " ", "oncl_a", " " ))]') %>%
  html_text()
```
## Tags
Assuming that we'd want to add Twitter tags to our post, here's how to do it. 

First, let's create a variable called ```tags```, then we use the combine function ```c``` and quotation marks ```"``` to write a string containing the hashtags. 
``` r
tags <- c("#quoteoftheday #InspirationalQuotes #quotestoliveby #quotesdaily")
```
# Step 5: Piecing it All Together
To put it all together, let's create a variable called ```full```.
``` r
full <- paste0(quote_title, quote_content, quote_author, tags)
```
And then let's do a bit of cleaning. 
``` r
cleaned <- gsub('\n', " ", 
           gsub('Quote of the Day', "Quote of the Day |",
           gsub ('#quoteoftheday', " | #quoteoftheday", full)))
cleaned
```
What we'll get is this:

```>"Quote of the Day | Hope is being able to see that there is light despite all of the darkness. Desmond Tutu | #quoteoftheday #InspirationalQuotes #quotestoliveby #quotesdaily"```
# Step 6: Communicating with Twitter's API
Finally, we'll use our Twitter Tokens but first let's define to the API what the content of our tweet is. 
``` r
tweet_text <- paste0(cleaned)
```
Then using use the package ```rtweet```, create a token that holds all of the Twitter Tokens in one variable called ```bot_token```.
``` r
bot_token <- rtweet::create_token(
  app = "brainyquotebot",
  consumer_key = "INSERT_YOUR_TOKEN",
  consumer_secret = "INSERT_YOUR_TOKEN",
  access_token = "INSERT_YOUR_TOKEN",
  access_secret = "INSERT_YOUR_TOKEN",
  set_renv = FALSE
)
```
Please note that the ```Bearer Token``` is not needed for this.

Next, let's create the command to post our tweet. 
``` r
post_tweet(status = tweet_text,
           token = bot_token)
```
We can check if the programming works by running the entire script. If it's successful, the message returned will indicate that our post has been published and if we go to our Twitter account, we'll see the tweet. 

# Step 7: Automating with Windows Task Scheduler
Open up the Windows Start button and in the search bar type ```Task Scheduler```. Once we've opened it up, on the side bar we'll click on ```Create Task```. 

![screenshot 43](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(43).png)

In the ```General``` tab, give the task a name and check the ```Run only when user is logged on```. Click OK.

![screenshot 44](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(44).png)

Then go to the ```Triggers``` tab, click new, and make sure to begin the task ```On Schedule```. For my bot, I wanted it to run once everyday at a specific time, but you can choose weekly or monthly and define which days you want this task to run. Click OK.

![screenshot 45](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(45).png)

Next, go to the ```Actions``` tab, click new, and set ```Action:``` to ```Start a Program```. 

Then in ```Program/Script``` we'll want to set the path of where we can find our ```Rscript.exe```. Mine, for instance, was found here ```D:\R\R-4.1.2\bin\Rscript.exe```.

In ```Add Arguments``` input what the name of our Rscript file is, in my case, I named mine ```brainyquotebot_tweet```.

And lastly, in ```Start in``` we'll set the path of where we can find our Rscript file - my path was ```D:\R_Studio\Project_Vault\OP_TwitterBot\```

![screenshot 46](https://github.com/JoyCuratoR/brainyquotebot/blob/master/Screenshot%20(46).png)

Then, click OK all the way through and exit out of the program.

# The End
That was a lot but now we have a fully functioning automated Twitter bot that we can let it run without a worry. If you want to check out my bot go to: @Sunshinecatleo or follow me @joycuratoR on Twitter and GitHub to see what I'm working on next.
