# TwitterRandomSampler
Grabs a stream of tweets and displays them in the terminal.

# Usage
ruby TwitterRandomSampler.rb

Once you've got the script started, press ? to get a list of options.

# A note about languages

Languages, on twitter, are  2 to 4 character [BCP-47 language tags.](https://tools.ietf.org/html/bcp47)

At the moment, the default is English, and it is not possible to turn off language filtering, as I have disabled that while I work on a few cleanup related tasks. If you wish to view tweets in all languages, remove ```&language=#{language}``` from TwitterConnector.rb.

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
