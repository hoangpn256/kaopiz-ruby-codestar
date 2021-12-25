class Article < ApplicationRecord
  acts_as_votable
  belongs_to :user
  has_rich_text :body
  has_one :action_text_rich_text,  class_name: 'ActionText::RichText',   as: :record
  has_many :comments, as: :commentable
  has_many :taggings
  has_many :tags, through: :taggings
  accepts_nested_attributes_for :tags,  reject_if: proc { |attributes| attributes['name'].blank? }, allow_destroy: true
  validates :title, presence: true, length: { maximum: 100}
  validates :body, presence: true
  attribute :viewed, :integer, default: 0
  
  enum status: [ :draft, :published ]

end
