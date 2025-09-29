# frozen_string_literal: true

class Menu < ApplicationRecord
  # Associations
  belongs_to :restaurant
  has_many :dishes, dependent: :destroy

  # Enums
  enum :status, {
    draft: 0,
    published: 1,
    archived: 2
  }

  enum :menu_type, {
    breakfast: 'breakfast',
    lunch: 'lunch',
    dinner: 'dinner',
    brunch: 'brunch',
    drinks: 'drinks',
    desserts: 'desserts',
    seasonal: 'seasonal',
    special: 'special'
  }

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :menu_type, presence: true, inclusion: { in: menu_types.keys }
  validates :status, presence: true
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :published, -> { where(status: :published) }
  scope :draft, -> { where(status: :draft) }
  scope :archived, -> { where(status: :archived) }
  scope :by_type, ->(type) { where(menu_type: type) }
  scope :ordered, -> { order(:position, :created_at) }
  scope :for_restaurant, ->(restaurant_id) { where(restaurant_id: restaurant_id) }

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

  def dishes_count
    dishes.count
  end

  def published_dishes_count
    dishes.published.count
  end

  def can_be_published?
    dishes.published.any?
  end

  def publish!
    return false unless can_be_published?
    
    update!(status: :published)
  end

  def archive!
    update!(status: :archived)
  end

  def move_to_position(new_position)
    return false if new_position < 0

    old_position = position
    return true if old_position == new_position

    if new_position > old_position
      # Moving down
      restaurant.menus.where('position > ? AND position <= ?', old_position, new_position)
                .update_all('position = position - 1')
    else
      # Moving up
      restaurant.menus.where('position >= ? AND position < ?', new_position, old_position)
                .update_all('position = position + 1')
    end

    update!(position: new_position)
  end

  private

  def set_default_position
    return if position.present?

    max_position = restaurant.menus.maximum(:position) || -1
    self.position = max_position + 1
  end

  def reorder_positions
    restaurant.menus.where.not(id: id).ordered.each_with_index do |menu, index|
      menu.update_column(:position, index)
    end
  end
end
