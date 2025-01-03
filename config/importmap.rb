# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# https://github.com/rails/request.js
# $ ./bin/importmap pin @rails/request.js
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.9

# https://chartkick.com/
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"