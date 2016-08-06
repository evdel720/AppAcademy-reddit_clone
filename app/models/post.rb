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

  has_many :comments

  def comments_by_parent_id
    comments_hash = Hash.new {|h, k| h[k] = []}
    @all_comments = self.comments.includes(:user)
    @all_comments.each do |comment|
      comments_hash[comment.parent_comment_id] << comment
    end
    comments_hash
  end

end
