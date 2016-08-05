class Post < ActiveRecord::Base

  validates :title, :subject, :author, presence: true

  belongs_to :subject,
    primary_key: :id,
    foreign_key: :sub_id,
    class_name: :Sub

  belongs_to :author,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User



end
