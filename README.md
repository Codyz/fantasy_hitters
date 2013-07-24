# Fantasy Hitters

## Summary
App for ranking offensive major league players according to custom fantasy league settings. It does so by defining a replacement player at each position and valuing players with respect to the replacement player. Includes a scraper in Ruby for baseball-reference.com.

## Todo/Problems

### Straightforward
* Add pitchers
* Allow AL/NL only leagues
* DHs are too valuable
* Add favoriting capability
* Allow the user to access per-game and absolute rankings?
* Add ZIPS projections

### Philosophical/Interesting
* Dynamically define the relative values of different categories based on league parameters (hard)
* Add model checking on rankings as year progresses

## Technologies Used
Rails, Ruby, JavaScript, jQuery, Nokogiri, Roo