class User < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  before_save :set_role

  mount_uploader :photo, PhotoUploader
  validate :photo_size

  devise :omniauthable, :database_authenticatable, :registerable,
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
  validates :phone, allow_blank: true,
    length: {maximum: Settings.user.phone_max_length},
    format: {with: VALID_PHONE_REGEX}
  validates :address, allow_blank: true,
    length: {maximum: Settings.user.address_max_length}

  enum role: [:user, :admin]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.photo = auth.info.image
      user.password = Devise.friendly_token[0,20]
    end
  end

  private
  def photo_size
    return true unless photo.size > Settings.user.photo_max_size
    errors.add :photo, I18n.t("devise.registrations.new.photo_max_size_error",
      max_size: number_to_human_size(Settings.user.photo_max_size))
  end

  def set_role
    self.role ||= :user
  end
end
