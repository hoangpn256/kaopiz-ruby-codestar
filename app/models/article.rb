class Article < ApplicationRecord
  # ransack_alias :any_column, User.column_names.excluding('id', 'created_at', 'updated_at').join('_or_')
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



  def self.published_articles_in_week
    Article.where(created_at: Time.now.to_date - 7.days..Time.now).published.order("created_at DESC")
  end

  def self.published_articles_in_month
    Article.where(created_at: Time.now.to_date - 1.month..Time.now).published.order("created_at DESC")
  end

  def self.top_view(articles)
    if articles.class != Article
      articles.published.reorder(viewed: :desc)
    else
      articles
    end
  end

  def self.top_like(articles)
    if articles.class != Article
      articles.published.reorder("cached_votes_total DESC")
    else
      articles
    end
  end

end
