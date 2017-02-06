class User < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  mount_uploader :photo, PhotoUploader
  validate :photo_size

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    password_length:
      Settings.user.password_min_length..Settings.user.password_max_length

  validates :name, presence: true,
    length: {maximum: Settings.user.name_max_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    length: {maximum: Settings.user.email_max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  VALID_PHONE_REGEX = /\d[0-9]\)*\z/i
  validates :phone, presence: true,
    length: {maximum: Settings.user.phone_max_length},
    format: {with: VALID_PHONE_REGEX}
  validates :address, presence: true,
    length: {maximum: Settings.user.address_max_length}

  private
  def photo_size
    return true unless photo.size > Settings.user.photo_max_size
    errors.add :photo, I18n.t("devise.registrations.new.photo_max_size_error",
      max_size: number_to_human_size(Settings.user.photo_max_size))
  end
end
