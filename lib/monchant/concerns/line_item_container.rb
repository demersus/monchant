module Monchant::LineItemContainer
	extend ActiveSupport::Concern

	included do
		embeds_many :items, class_name: 'Monchant::LineItem', as: :container
		accepts_nested_attributes_for :items, allow_destroy: true
		before_save :delete_zero_quantity_line_items#, unless: :completed_at?
		before_save :combine_line_items#, unless: :completed_at?
	end
	
	def total
		items.sum(&:total)
	end
	
	def combine_line_items
		tmp_items = []
		items.group_by{|i| [i.product_type,i.product_id,i.product_params]}.each do |prod,itms|
			if itms.size > 1
				itms.first.quantity = itms.collect(&:quantity).sum
			end
			tmp_items << itms.first
		end
		self.items = tmp_items
	end

	def delete_zero_quantity_line_items
		items.each do |itm|
			itm.destroy if itm.quantity <= 0
		end
	end

	def has_shippable_items?
		!items.all?{|i| i.product.digital_delivery?}
	end
end
