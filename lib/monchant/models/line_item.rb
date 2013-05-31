# In order to be compatible with order purchases, the product
# must define these methods:
# #purchase(line_item), #product_description(product_params), and #price(product_params)
# Please use Monchant::Purchaseable

class Monchant::LineItem
	include Mongoid::Document
	embedded_in :container, polymorphic: true

	field :price_in_cents, type: Integer, :default => 0
	field :quantity, type: Integer, :default => 1
	field :description, type: String
  field :product_params
	
	#has_and_belongs_to_many :credits
	belongs_to :product, polymorphic: true

	validates :quantity, :price_in_cents, presence: true

	before_validation do
		if product_id_changed?
			reset
		end
	end

  def total
    price * quantity + shipping
  end
	
	def price
    price_in_cents / BigDecimal.new(100)
  end
	
	def shipping
		return 0 unless product.respond_to?(:product_shipping)
		product.product_shipping(self)
	end

	def tax
		return 0 unless product.respond_to?(:product_tax)
		product.product_tax(self)
	end
  
	def price=(p)
    self.price_in_cents = p * BigDecimal.new(100)
  end
  
	def fulfill
		product.purchase(self)
  end
  
	def reset
    copy_product_data
  end
  
  def copy_product_data
    self.price = product.product_price(product_params)
    self.description = product.product_description(product_params)
  end
end
