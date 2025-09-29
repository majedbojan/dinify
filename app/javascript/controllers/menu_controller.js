import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "dish", "filter", "sort"]
  static values = { 
    restaurantId: String,
    currentUserId: String 
  }

  connect() {
    console.log("Menu controller connected")
    this.initializeFilters()
  }

  initializeFilters() {
    // Initialize any default filters or sorting
    this.applyFilters()
  }

  filterByCategory(event) {
    const category = event.target.value
    this.filterDishesByCategory(category)
  }

  filterByAllergens(event) {
    const allergen = event.target.value
    this.filterDishesByAllergen(allergen)
  }

  sortBy(event) {
    const sortBy = event.target.value
    this.sortDishes(sortBy)
  }

  filterDishesByCategory(category) {
    const dishes = this.dishTargets
    
    dishes.forEach(dish => {
      const dishCategory = dish.dataset.category
      const shouldShow = category === '' || dishCategory === category
      
      dish.style.display = shouldShow ? 'block' : 'none'
    })
  }

  filterDishesByAllergen(allergen) {
    const dishes = this.dishTargets
    
    dishes.forEach(dish => {
      const dishAllergens = dish.dataset.allergens || ''
      const shouldShow = allergen === '' || !dishAllergens.includes(allergen)
      
      dish.style.display = shouldShow ? 'block' : 'none'
    })
  }

  sortDishes(sortBy) {
    const container = this.menuTarget
    const dishes = Array.from(this.dishTargets)
    
    dishes.sort((a, b) => {
      switch(sortBy) {
        case 'name':
          return a.dataset.name.localeCompare(b.dataset.name)
        case 'price':
          return parseFloat(a.dataset.price) - parseFloat(b.dataset.price)
        case 'calories':
          return (parseInt(a.dataset.calories) || 0) - (parseInt(b.dataset.calories) || 0)
        case 'category':
          return a.dataset.category.localeCompare(b.dataset.category)
        default:
          return 0
      }
    })
    
    // Re-append sorted dishes
    dishes.forEach(dish => container.appendChild(dish))
  }

  applyFilters() {
    // Apply any active filters
    const categoryFilter = this.filterTargets.find(f => f.dataset.filterType === 'category')
    const allergenFilter = this.filterTargets.find(f => f.dataset.filterType === 'allergen')
    
    if (categoryFilter && categoryFilter.value) {
      this.filterDishesByCategory({ target: categoryFilter })
    }
    
    if (allergenFilter && allergenFilter.value) {
      this.filterDishesByAllergen({ target: allergenFilter })
    }
  }

  clearFilters() {
    this.filterTargets.forEach(filter => {
      filter.value = ''
    })
    
    this.dishTargets.forEach(dish => {
      dish.style.display = 'block'
    })
  }

  toggleDishStatus(event) {
    const dishId = event.target.dataset.dishId
    const newStatus = event.target.dataset.newStatus
    
    if (confirm(`Are you sure you want to ${newStatus} this dish?`)) {
      this.updateDishStatus(dishId, newStatus)
    }
  }

  async updateDishStatus(dishId, status) {
    try {
      const response = await fetch(`/dishes/${dishId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({ dish: { status: status } })
      })
      
      if (response.ok) {
        location.reload()
      } else {
        alert('Failed to update dish status')
      }
    } catch (error) {
      console.error('Error updating dish status:', error)
      alert('An error occurred while updating the dish')
    }
  }
}
