# TODOS

*DEVELOPMENT*
* Debug Ruby Language Server (Shopify) with VSCode in WSL2

*BACK END*
* refactor: case-insensitive sorting, research db collations
* refactor: DRY work#long_title vs works_helper#title_line vs Citation::Bibliography
  * use associated_object gem https://garrettdimon.com/journal/posts/organizing-rails-code-with-activerecord-associated-objects
* refactor: improve test coverage
  ! coverage gem broken
* refactor: SQL COALESCE on works.pg_search columns (i.e. super + title + sub as 1 value)
  * postgress trigger to save actual full name to cached column
* refactor: avoid hacky columns for non-book formats and citations,(use different models, not enums?)
* research pg_search custom settings, custom stop-word list (allow "after")
* user-scoped authorization, allow for multiple users/libraries

* bugfix:
  * fix partial n+1 on works index, fix other n + 1 (without Bullet)

*FRONT END*

* mobile-friendly views
* improve pipe_spacer
* tabs for lists of associated authors/quotes/notes/reqding sessions on show views
* refactor: research extracting CSS into gem, reusable across apps (DIY CSS framework)

*FEATURES*

* producer bio/links
* add more attributes fields to subforms
* dynamic work form, fields change based on publication_format (maybe it should be a new subclassed model)
* location field on publisher
* flipper gem or feature toggling, admin view, disable reading sessions
* add hardback/paperback, condition

