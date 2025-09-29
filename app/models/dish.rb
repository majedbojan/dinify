# frozen_string_literal: true

class Dish < ApplicationRecord
  # Associations
  belongs_to :menu
  has_one :restaurant, through: :menu

  # Enums
  enum :status, {
    draft: 0,
    published: 1,
    archived: 2
  }

  enum :category, {
    appetizer: 'appetizer',
    soup: 'soup',
    salad: 'salad',
    main: 'main',
    side: 'side',
    dessert: 'dessert',
    beverage: 'beverage',
    alcoholic_beverage: 'alcoholic_beverage'
  }

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :category, presence: true, inclusion: { in: categories.keys }
  validates :status, presence: true
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :calories, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :protein, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :carbs, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :fat, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :fiber, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :sodium, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :sugar, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :published, -> { where(status: :published) }
  scope :draft, -> { where(status: :draft) }
  scope :archived, -> { where(status: :archived) }
  scope :by_category, ->(category) { where(category: category) }
  scope :ordered, -> { order(:position, :created_at) }
  scope :for_menu, ->(menu_id) { where(menu_id: menu_id) }
  scope :with_allergens, -> { where.not(allergens: [nil, '']) }
  scope :vegetarian, -> { where("allergens NOT ILIKE ?", "%meat%") }
  scope :vegan, -> { where("allergens NOT ILIKE ? AND allergens NOT ILIKE ?", "%meat%", "%dairy%") }
  scope :gluten_free, -> { where("allergens NOT ILIKE ?", "%gluten%") }

  # Callbacks
  before_validation :set_default_position, on: :create
  after_create :reorder_positions

  # Methods
  def published?
    status == 'published'
  end

  def draft?
    status == 'draft'
  end

  def archived?
    status == 'archived'
  end

  def has_allergens?
    allergens.present?
  end

  def allergen_list
    return [] unless has_allergens?
    
    allergens.split(',').map(&:strip).reject(&:blank?)
  end

  def ingredient_list
    return [] unless ingredients.present?
    
    ingredients.split(',').map(&:strip).reject(&:blank?)
  end

  def nutritional_info_complete?
    calories.present? && protein.present? && carbs.present? && fat.present?
  end

  def formatted_price
    "%.2f" % price
  end

  def move_to_position(new_position)
    return false if new_position < 0

    old_position = position
    return true if old_position == new_position

    if new_position > old_position
      # Moving down
      menu.dishes.where('position > ? AND position <= ?', old_position, new_position)
          .update_all('position = position - 1')
    else
      # Moving up
      menu.dishes.where('position >= ? AND position < ?', new_position, old_position)
          .update_all('position = position + 1')
    end

    update!(position: new_position)
  end

  def nutritional_summary
    return {} unless nutritional_info_complete?

    {
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: fiber,
      sodium: sodium,
      sugar: sugar
    }.compact
  end

  private

  def set_default_position
    return if position.present?

    max_position = menu.dishes.maximum(:position) || -1
    self.position = max_position + 1
  end

  def reorder_positions
    menu.dishes.where.not(id: id).ordered.each_with_index do |dish, index|
      dish.update_column(:position, index)
    end
  end
end
