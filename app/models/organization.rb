class Organization < ActiveRecord::Base
  has_one :user, dependent: :nullify
  has_many :claim_requests

  validates :name, presence: true
  validates :address, presence: true
  validates :overview, presence: true
  validates :employee_count, presence: true, numericality: {greater_than_or_equal_to: 1}
  validates :tech_team_size, presence: true, numericality: {greater_than_or_equal_to: 1}

  has_many :organization_technologies, dependent: :destroy
  has_many :technologies, through: :organization_technologies
  has_many :media, dependent: :destroy

  # # validates :twitter, uniqueness: true
  validates_inclusion_of :published, :in => [true, false]

  geocoded_by :address
  after_validation :geocode

  # Company Avatar
  mount_uploader :image, ImageUploader
  # Company Pictures
  # Commented this out to allow multiple images saved to database
  # mount_uploader :image2, ImageUploader
  # mount_uploader :image3, ImageUploader
  # mount_uploader :image4, ImageUploader

  mount_uploaders :images, ImageUploader



  def user_full_name
    user ? user.full_name : ""
  end

  def self.published
    where(published: true)
  end

  private



end
