class Document
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :name, type: String
  field :file, type: BSON::ObjectId

  validates_presence_of :name
  validates_presence_of :file

  belongs_to :user

  before_destroy :purge_gridfs

  protected

  def purge_gridfs
    if self.file
      grid = Mongo::Grid.new Mongoid.config.master
      grid.delete self.file
    end
  end
end
