
library(rvest)
library(dplyr)
library(rtweet)

link <- "https://www.brainyquote.com/quote_of_the_day"
page <- read_html(link)

quote_title <- page %>%
  html_element(xpath = '//*[contains(concat( " ", @class, " " ),
               concat( " ", "qotd-h2", " " ))]') %>%
  html_text()

quote_content <- page %>%
  html_element(xpath = '//*[contains(concat( " ", @class, " " ),
               concat( " ", "oncl_q", " " ))]//div') %>%
  html_text()

quote_author <- page %>%
  html_element(xpath = '//*[contains(concat( " ", @class, " " ),
               concat( " ", "oncl_a", " " ))]') %>%
  html_text()

tags <- c("#quoteoftheday #InspirationalQuotes #quotestoliveby #quotesdaily")

full <- paste0(quote_title, quote_content, quote_author, tags)

cleaned <- gsub('\n', " ", 
           gsub('Quote of the Day', "Quote of the Day |",
           gsub ('#quoteoftheday', " | #quoteoftheday", full)))
cleaned


# create the tweet's text/content
tweet_text <- paste0(cleaned)
tweet_text

# Create a token containing your Twitter keys
bot_token <- rtweet::create_token(
  app = "brainyquotebot",
  # the name of the Twitter app
  consumer_key = "INSERT_YOUR_KEY",
  consumer_secret = "INSERT_YOUR_KEY",
  access_token = "INSERT_YOUR_KEY",
  access_secret = "INSERT_YOUR_KEY",
  set_renv = FALSE
)

# post tweet
post_tweet(status = tweet_text,
           token = bot_token)

