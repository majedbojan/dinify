import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  switchLanguage(event) {
    const locale = event.currentTarget.dataset.locale
    const currentUrl = new URL(window.location.href)
    
    // Update the locale in the URL
    currentUrl.pathname = currentUrl.pathname.replace(/^\/(en|ar)/, `/${locale}`)
    
    // Set the locale cookie
    document.cookie = `locale=${locale}; path=/; max-age=${60 * 60 * 24 * 365}`
    
    // Reload the page to apply the new locale
    window.location.href = currentUrl.toString()
  }
}
