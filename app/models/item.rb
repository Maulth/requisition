class Item < ActiveRecord::Base
  # Scopes
  scope :for_sale,      -> { where(for_sale: true) }
  scope :not_for_sale,  -> { where(for_sale: false) }

  # Relations
  has_many :orders, through: :order_items
  has_many :order_items
  belongs_to :category

  # Validations
  validates :category,  presence: true
  validates :type_id,   presence: true
  validates :type_id,   numericality: { only_integer: true, greater_than: 0 }
  validates :type_id,   uniqueness: true
  validates :name,      presence: true
  validates :name,      uniqueness: true
  validates :for_sale,  inclusion: [true, false]

  # Callbacks
  before_save :set_type

  def image_url(size = 128)
    # TODO validate the size choices (Not sure whats valid)
    "https://image.eveonline.com/Render/#{type_id}_#{size}.png"
  end

private

  def set_type
    self.type = category.name.gsub(" ", "_").classify
  end
end
