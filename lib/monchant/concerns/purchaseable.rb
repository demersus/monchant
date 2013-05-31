module Monchant::Product
	extend ActiveSupport::Concern

	# STUBS
	
	def product_stock?
		false
	end
	
	def product_price(product_params)
		raise "Implement in your own class"
	end

	def product_description(product_params)
		to_s
	end

	def purchase(itm)
		# Do something here		
	end

	def digital_delivery?
		true
	end

	def product_tax(itm)
		0
	end

	def product_shipping(itm)
		0
	end

end
