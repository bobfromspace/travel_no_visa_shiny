# travel_no_visa_shiny
Description and script of a web app mapping mutually visa-free countries for citizens of two different countries

## Description of the app and data

The app allows to get informed about visa policies of different countries, in particular, the opportunity to travel unconstrained by visas between two countries. It can serve as a starting point for planning a trip with a longstanding pen friend as well as a basic material to learn about the most and least open countries for tourists. You know, there are many other applications of this service that I cannot forsee.

The data on visa status comes from [Wikipedia](https://en.wikipedia.org/wiki/Template:Visa_requirements). First I scraped it using R statistical package and then transformed as I needed using MO Excel. Shapefiles to map selected countries were retrieved from [Natural Earth's page](https://www.naturalearthdata.com/downloads/50m-cultural-vectors/). I used Shiny and [shinyapps.io](https://www.shinyapps.io/) to create and store the app for public use.

## Link

You can learn about and play with the application [here](https://nina-ilchenko.shinyapps.io/travel_no_visa/). As I am using the basic subscription plan the app might not be available for public use from time to time. I am not charged for displaying it that is why it has limited time to be on show.

The script of the app - to learn, develop or borrow some parts - is available at all times [here, on Github](app.R).

## How did I come to this?

The idea to visualise the map came to me first when, together with my partner (of another citizenship), I was considering where to travel next without the need to worry about the decisions on visas. Several months later, I was stimulated even more by Prince Harry and Meghan Markle's wedding and Roman Abramovich's (one of the Russian oligarchs) problems with British visa. These occasions might look extraordinary but they ensured me that getting visa and travelling is an urgent matter in highly globalised and transcontinental world. So, if getting visa is the obstacle to see a friend or soulmate then travelling freely is important (I acknowledge that Mr. Abramovich is not that sentimental if he travels but anyways). That is where my (quite basic to be honest) web app comes in handy!

## Further plans

I am open to any suggestions and commits.
What I forsee is that the project can be extended so that one could compare visa requirements of three and even more countries and select not only the countries that do not require visa but also those that have visa, visa on arrival, and electronic visa regime. It is not up to me only if these changes will be implemented, there is much to do for anybody else!
