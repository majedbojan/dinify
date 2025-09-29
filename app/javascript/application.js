// Import and start Turbo
import "@hotwired/turbo-rails"

// Import and register Stimulus controllers
import { Application } from "@hotwired/stimulus"

// Import controllers manually
import MobileMenuController from "./controllers/mobile_menu_controller"
import DropdownController from "./controllers/dropdown_controller"
import LanguageSwitcherController from "./controllers/language_switcher_controller"

window.Stimulus = Application.start()
Stimulus.register("mobile-menu", MobileMenuController)
Stimulus.register("dropdown", DropdownController)
Stimulus.register("language-switcher", LanguageSwitcherController)



