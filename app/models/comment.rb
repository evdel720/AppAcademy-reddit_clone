class Comment < ActiveRecord::Base
  validates :user_id, :post_id, :content, presence: true
  validates :content, length: { minimum: 10 }
  belongs_to :user
  belongs_to :post
  belongs_to :parent_comment,
    primary_key: :id,
    foreign_key: :parent_comment_id,
    class_name: :Comment
  has_many :children_comments,
    primary_key: :id,
    foreign_key: :parent_comment_id,
    class_name: :Comment
end
