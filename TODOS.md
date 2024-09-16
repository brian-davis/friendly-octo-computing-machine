# TODOS

*DEPLOYMENT*
* research home server with dynamic dns
* research rails 7.x, 8.x built-in containers
* research rails 7.x, 8.x built-in deployment solutions

*BACK END*
* feature: more citations (all formats)

* refactor: case-insensitive sorting
  * research db collations
* refactor: DRY work#long_title vs works_helper#title_line vs Citation::Bibliography
  * use associated_object gem https://garrettdimon.com/journal/posts/organizing-rails-code-with-activerecord-associated-objects
* refactor: improve test coverage
  ! coverage gem broken

* bugfix:
  * research pg_search custom settings, custom stop-word list (allow "after")
  * fix partial n+1 on works index

*FRONT END*

feature: producer bio/links
feature: add more attributes fields to subforms

refactor: research extracting CSS into gem, reusable across apps (DIY CSS framework)