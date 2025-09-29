# frozen_string_literal: true

class RestaurantUser < ApplicationRecord
  # Associations
  belongs_to :restaurant
  belongs_to :user

  # Enums
  enum :role, {
    admin: 'admin',
    manager: 'manager',
    chef: 'chef',
    staff: 'staff',
    viewer: 'viewer'
  }

  enum :status, {
    inactive: 0,
    active: 1,
    suspended: 2
  }

  # Validations
  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :status, presence: true
  validates :restaurant_id, uniqueness: { scope: :user_id }

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :by_role, ->(role) { where(role: role) }
  scope :admins, -> { where(role: :admin) }
  scope :managers, -> { where(role: :manager) }
  scope :staff, -> { where(role: :staff) }

  # Methods
  def active?
    status == 'active'
  end

  def admin?
    role == 'admin'
  end

  def manager?
    role == 'manager'
  end

  def chef?
    role == 'chef'
  end

  def staff?
    role == 'staff'
  end

  def viewer?
    role == 'viewer'
  end

  def can_manage_menus?
    admin? || manager? || chef?
  end

  def can_view_menus?
    true # All roles can view menus
  end

  def can_manage_dishes?
    admin? || manager? || chef?
  end

  def can_view_dishes?
    true # All roles can view dishes
  end
end
