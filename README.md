# Weather Me Timbers
## Description As per the requirements, this is a simple
weather retrieval app with zip code caching, basic error handling, and a
function over form UI. Behind the scenes we have no database usage (still added
a DB in case an extension or something required it), bootstrap, UI tests (no e2e
or integration)

## Setup Disclaimer, I did not try to run this on another machine, but it seems
vanilla enough. Rails 7.1.1 Ruby 3.1.2 run bundle bundle exec rspec 8 examples
should pass

Edit credentials: ```VISUAL="nvim" bin/rails credentials:edit``` and add a
```weather_api_key: yourkeyhere``` Obtained from the website
https://www.visualcrossing.com/sign-up Sign up is free and takes like 2 minutes,
don't be a baby.

## Design & Architecture & Patterns & Cromulence My goals here were: 1 speed and
2 easy to understand code with few dependencies.

Our entry point is a single route, no post or anything like that. Very simply we
have a single page which always attempts to create in memory an address
(sometimes null) and a forecast (sometimes null). A simple Address is handed to
a WeatherForecast which conditionally relies on a WeatherApi to contact
visualcrossing.com. The WeatherApi returns a raw response in the form of a hash
which is easy to cache. The WeatherForecast then uses a WeatherApiResponse which
holds the methods the frontend eventually relies upon.

The caching has a bit more complexity than expected in trying to preserve the
`was_cached` concept. There might be an idiomatic way to do this, but I don't
know of it and could not find it. I tested the happy paths and obvious sad
paths, but I acknowledge there is code untested here. Mostly it's code I don't
expect tests to add much value to. The WeatherApiResponse is a simple shell
which a UI test would cover, but Rails view tests take a lot of time to make
valuable imo, and I'm not getting into that now lol

Keep an eye out for 3 flash messages which are exemplary of the functionality of
the app: ``` flash.now[:info] = "This result was retrieved from the cache!"
flash.now[:alert] = "The cache was set!" flash.now[:alert] = "Something went
wrong!\nMake sure your address is correct!" ```

## What I would do different in hindsight/with more time "Include a UI" tells me
it is not a priority. If I had more time to tinker, I would have tried out
stimulus and tailwindcss which are all the hotness right now. Maybe I would have
thrown together Angular 2 or some other JS framework I haven't yet used.

Everything in this app is ephemeral. Using Redis as a big kid cache solution
would give a better feeling of permanence and gravity. Additionally, tracking
the addresses which are searched for would be useful. The data of which
addresses the API couldn't handle vs those which didn't, and also which
addresses/zips/states get the most hits seem useful. Without clear direction,
these things don't really hold any weight.

I worked on this between girl scout meetings, birthday parties, and D&D. I felt
very much out of my element, so I dropped my usual rigorous git workflow. That
always feels dirty.

Scope creep tried to rear it's head when I saw the card accuweather uses [found
here](https://www.accuweather.com/en/us/commerce-city/80022/weather-forecast/2201461).
Adding those bells and whistles seemed like easy wins, but I knew coercing the
data into the response object and getting it all to show up exactly how I wanted
would actually zap a bunch of my time. Especially since I know I would go back
and forth on which columsn to use for the flex box and colors, and ooh maybe an
icon...

## Final thoughts As someone who once used weather apps multiple times a day as
part of my job, I found it annoying that an address was expected as an input.
Most weather apps work off of their own specific zones, or more commonly, zip
codes. The caching keyed off of zip codes, so why addresses are part of this at
all escapes me.

Addresses as a form and as a error vector cost me the most time by far. A one
input zip would actually be helpful. Instead I have to enter a real enough
address to get past the weather app. Ultimately I'm emphasizing this because I
would push back on this requirement before any tickets were written.

While the challenge tests some of my daily skills, setting up an app from
scratch while having a UI that isn't literally just text is outside the purvue
of what I expect to work on. Similar to having pushback for the product, I would
have pushback for any design team which let me spin up whatever I like. It's
going to be the quickest and easiest possible option haha

I liked the project, but it took more time than I want an assessment to take. I
hope you can gleam something out of this, because it only shows a small slice of
what kind of dev I am, how I work, and what I can do. Thank you for reviewing
all of this.
