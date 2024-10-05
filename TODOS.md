# TODOS

*DEPLOYMENT*
* research rails 8.x built-in containers, deployment solutions

*BACK END*
* refactor: case-insensitive sorting, research db collations
* refactor: DRY work#long_title vs works_helper#title_line vs Citation::Bibliography
  * use associated_object gem https://garrettdimon.com/journal/posts/organizing-rails-code-with-activerecord-associated-objects
* refactor: improve test coverage
  ! coverage gem broken
* refactor: SQL COALESCE on works.pg_search columns (i.e. super + title + sub as 1 value)
  * postgress trigger to save actual full name to cached column
* refactor: avoid hacky columns for non-book formats and citations,(use different models, not enums?)

* bugfix:
  * research pg_search custom settings, custom stop-word list (allow "after")
  * fix partial n+1 on works index, fix other n + 1 (without Bullet)

*FRONT END*

feature: producer bio/links
feature: add more attributes fields to forms, subforms

refactor: research extracting CSS into gem, reusable across apps (DIY CSS framework)

- missing author names on index (prod)