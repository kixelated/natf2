class UploadCategory < ActiveRecord::Base
  has_many :uploads

  validates_presence_of :name

  def to_s
    name
  end
end
