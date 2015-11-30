class Post < ActiveRecord::Base
  has_and_belongs_to_many :tags
  validates :author, presence: true
  validates :title, presence: true
  validates :body, presence: true
  validates :tags, presence: { message: "must have at least one tag" }
  validates_associated :tags

  def tags_string
    tags.map(&:name).join(",")
  end

  def tags_string=(new_value)
    tag_names = new_value.split(/[,\s]+/)
    self.tags = tag_names.map { |name| Tag.where('name = ?', name).first || Tag.create(:name => name) }
  end
end
