# TODOS

*DEVELOPMENT*
exclude coverage from vscode search results

*BACK END*
* refactor: case-insensitive sorting, research db collations
* refactor: DRY work#long_title vs works_helper#title_line vs Citation::Bibliography
! fix: improve test coverage, coverage gem broken
* refactor: SQL COALESCE on works.pg_search columns (i.e. super + title + sub as 1 value)
  * postgress trigger to save actual full name to cached column
* refactor: avoid hacky columns for non-book formats and citations,(use different models, not enums?)
* research pg_search custom settings, custom stop-word list (allow "after")
* user-scoped authorization, allow for multiple users/libraries
* fix: partial n+1 on works index, fix other n + 1 (without Bullet)


*FRONT END*

* mobile-friendly views
* tabs for lists of associated authors/quotes/notes/reqding sessions on show views
* refactor: research extracting CSS into gem, reusable across apps (DIY CSS framework)
* use Titleize gem more (fix Chrisman Author: Morality: objective, relative or emotive? )

*FEATURES*

* producer bio/links
* add more attributes fields to subforms
* add wishlist checkbox
* flipper enable various work types (after further development)
* imprint, place of publication, edition