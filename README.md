Bookshelf is a personal library catalog, note-taking, and reading and writing app.

To clone, install the app, and set up the database (assuming there is a PostgreSQL server):

* `$ git clone git@github.com:brian-davis/friendly-octo-computing-machine.git`

* `$ cd friendly-octo-computing-machine`

* `friendly-octo-computing-machine $ bundle install`

* `friendly-octo-computing-machine $ rails db:create db:migrate db:seed`

Set up an admin user in the console:

* `$ rails c`
* `> User.create({ email: "user@example.com", password: "password", password_confirmation: "password" })`
* `> exit`

Run the server:

* `friendly-octo-computing-machine $ rails s`

Access the app at `localhost:3000`, and log in with the user credentials you just made.  The app is currently set up for only 1 master user, and all resources created by `seeds.rb` should be available to the master user.