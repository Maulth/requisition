# frozen_string_literal: true

class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :timeoutable,
  # :recoverable,
  # :rememberable,
  # :trackable,
  # :lockable,
  # :registerable,
  # :validatable,
  devise :confirmable,
         :database_authenticatable, # only needed so the delete session path is available
         :omniauthable

  # Associations
  has_many :user_abilities, inverse_of: :user
  has_many :orders, inverse_of: :user
  has_many :identities, inverse_of: :user

  accepts_nested_attributes_for :user_abilities

  # Validations / Callbacks
  after_initialize :set_defaults, if: :new_record?
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update

  def ability?(kind)
    user_abilities.joins(:ability).where(abilities: { kind: kind }).any?
  end

  # Ability helper methods 'can_ability_kind?'
  Ability.kinds.each do |kind|
    define_method('can_' + kind.to_s + '?') do
      ability? kind
    end
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource || identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.find_by email: email if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.info.character_name,
          email: email || "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end

  def image_url(size = 32)
    character_id = identities.find_by(provider: :eve_online)&.uid
    if character_id
      # TODO: validate the size choices (Not sure whats valid)
      "https://image.eveonline.com/Character/#{character_id}_#{size}.jpg"
    else
      "https://image.eveonline.com/Character/1_#{size}.jpg"
    end
  end

private

  def set_defaults
    unless user_abilities.empty?
      return
    end
    if User.any?
      place_order = Ability.find_by(kind: :place_order)
      if place_order
        user_abilities.new ability: place_order
      end
    else
      Ability.find_each do |ability|
        user_abilities.new ability: ability
      end
    end
  end
end
