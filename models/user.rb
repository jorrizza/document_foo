class User
  ROLES = [:customer, :accountant, :admin]
  include Mongoid::Document
  include BCrypt

  attr_accessor :password, :password_confirmation
  attr_protected :password_hash
  
  field :username, type: String
  field :password_hash, type: String
  field :role, type: Symbol

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_length_of :password, minimum: 5
  validates_confirmation_of :password
  validates_inclusion_of :role, in: ROLES, allow_blank: false

  has_many :users
  belongs_to :user
  has_many :documents

  def accountant
    self.user
  end
  def accountant=(u)
    self.user = u
  end

  before_save :encrypt_password
  before_destroy :purge_documents

  def self.auth(username, password)
    u = where(username: username).first
    return false unless u
    Password.new(u.password_hash) == password
  end

  protected

  def encrypt_password
    unless @password == 'stupiddefault'
      self.password_hash = Password.create(@password)
    end
  end

  def purge_documents
    self.documents.each do |doc|
      doc.destroy
    end
  end
end
