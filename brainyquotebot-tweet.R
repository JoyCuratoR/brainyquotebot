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


full <- paste0(quote_title, quote_content, quote_author)

cleaned <- gsub('\n', " ", 
           gsub('Quote of the Day', "Quote of the Day |", full))



# create the tweet's text
tweet_text <- paste0(cleaned)

# Create a token containing your Twitter keys
bot_token <- rtweet::create_token(
  app = "brainyquotebot",
  # the name of the Twitter app
  consumer_key = Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token = Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret = Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET"),
  set_renv = FALSE
)

# post tweet
post_tweet(status = tweet_text,
           token = bot_token)
