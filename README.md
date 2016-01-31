# TwitterRandomSampler
Grabs a stream of tweets and displays them in the terminal.

# Usage
ruby TwitterRandomSampler.rb [LANGUAGE]

where LANGUAGE is a 2 (or 4) character [BCP-47 language tag.](https://tools.ietf.org/html/bcp47) 

Without LANGUAGE, tweets from all languages are sampled. 

There is a [list of supported language tags](https://dev.twitter.com/web/overview/languages) on twitter's dev page.

# A note about API keys:
You will need to set up your API keys in an environment.rb file
The file format will be:
```ruby
CONSUMER_KEY = "<YOUR_CONSUMER_KEY>"
CONSUMER_SECRET = "<YOUR_CONSUMER_SECRET>"
ACCESS_TOKEN = "<YOUR_ACCESS_TOKEN>"
ACCESS_TOKEN_SECRET = "<YOUR_ACCESS_TOKEN_SECRET>"
```
# Get your API keys by creating an app on http://apps.twitter.com
