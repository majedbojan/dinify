// Import and start Turbo
import "@hotwired/turbo-rails"

// Import and register Stimulus controllers
import { Application } from "@hotwired/stimulus"
// import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

window.Stimulus = Application.start()
// const context = require.context("./controllers", true, /\.js$/)
// Stimulus.load(definitionsFromContext(context))



