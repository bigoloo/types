class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Search::URI

  field :value
  field :property_id

  attr_accessor :uri
  attr_protected :property_id

  validates :uri, presence: true, url: true

  embedded_in :function

  before_save :set_property_id

  private

  def set_property_id
    self.property_id = find_id(uri)
  end
end
