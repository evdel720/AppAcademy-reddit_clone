class Post < ActiveRecord::Base

  validates :title, :author, presence: true

  belongs_to :author,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :postsubs, dependent: :destroy, inverse_of: :post

  has_many :subs,
    through: :postsubs,
    source: :sub

end
