class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :restaurant_users, dependent: :destroy
  has_many :restaurants, through: :restaurant_users

  normalizes :email, with: ->(e) { e.strip.downcase }

  # Methods
  def admin_restaurants
    restaurants.joins(:restaurant_users).where(restaurant_users: { role: "admin" })
  end

  def manager_restaurants
    restaurants.joins(:restaurant_users).where(restaurant_users: { role: [ "admin", "manager" ] })
  end

  def can_manage_restaurant?(restaurant)
    restaurant_users.exists?(restaurant: restaurant, role: [ "admin", "manager" ])
  end

  def can_view_restaurant?(restaurant)
    restaurant_users.exists?(restaurant: restaurant)
  end
end
