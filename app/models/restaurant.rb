# frozen_string_literal: true

class Restaurant < ApplicationRecord
  # Associations
  has_many :restaurant_users, dependent: :destroy
  has_many :users, through: :restaurant_users
  has_many :menus, dependent: :destroy

  # Enums
  enum :status, {
    inactive: 0,
    active: 1,
    suspended: 2
  }

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :phone, format: { with: /\A[\+]?[1-9][\d]{0,15}\z/ }, allow_blank: true
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true
  validates :status, presence: true

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  # Callbacks
  before_validation :normalize_email
  before_validation :normalize_phone

  # Methods
  def display_name
    name
  end

  def active?
    status == 'active'
  end

  def admin_users
    restaurant_users.where(role: 'admin')
  end

  def manager_users
    restaurant_users.where(role: 'manager')
  end

  def staff_users
    restaurant_users.where(role: 'staff')
  end

  private

  def normalize_email
    self.email = email&.downcase&.strip
  end

  def normalize_phone
    self.phone = phone&.gsub(/\D/, '') if phone.present?
  end
end
