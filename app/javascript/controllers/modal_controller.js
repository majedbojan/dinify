import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "backdrop", "content"]
  static values = { 
    open: Boolean,
    size: String 
  }

  connect() {
    this.modalTarget.style.display = 'none'
    this.setupEventListeners()
  }

  setupEventListeners() {
    // Close modal when clicking outside
    this.backdropTarget?.addEventListener('click', (e) => {
      if (e.target === this.backdropTarget) {
        this.close()
      }
    })

    // Close modal with Escape key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && this.openValue) {
        this.close()
      }
    })
  }

  open() {
    this.openValue = true
    this.modalTarget.style.display = 'flex'
    document.body.style.overflow = 'hidden'
    
    // Focus first input in modal
    const firstInput = this.modalTarget.querySelector('input, textarea, select')
    firstInput?.focus()
    
    this.dispatch('opened')
  }

  close() {
    this.openValue = false
    this.modalTarget.style.display = 'none'
    document.body.style.overflow = ''
    
    this.dispatch('closed')
  }

  toggle() {
    if (this.openValue) {
      this.close()
    } else {
      this.open()
    }
  }

  get modalClasses() {
    const baseClasses = 'fixed inset-0 z-50 flex items-center justify-center p-4'
    const sizeClasses = {
      sm: 'max-w-md',
      md: 'max-w-lg',
      lg: 'max-w-2xl',
      xl: 'max-w-4xl',
      full: 'max-w-full mx-4'
    }
    
    return `${baseClasses} ${sizeClasses[this.sizeValue] || sizeClasses.md}`
  }

  get backdropClasses() {
    return 'fixed inset-0 bg-black bg-opacity-50 transition-opacity'
  }

  get contentClasses() {
    return 'bg-white rounded-lg shadow-xl max-h-full overflow-y-auto'
  }
}
