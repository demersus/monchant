module Monchant::Orderable
	extend ActiveSupport::Concern
	
	included do 
		include Monchant::LineItemContainer
		field :completed_at, type: Time
		field :fulfilled_at, type: Time
		field :total_in_cents, type: Integer
		field :ip_address, type: String

		embeds_one :payment, as: :container, inverse_of: :container
		accepts_nested_attributes_for :payment
		
		scope :paid, -> {
			where(:payment.exists => true, "payment.paid_at" => {"$exists" => true})
		}
		scope :unpaid, -> {
			any_of({:payment.exists => false},{"payment.paid_at" => {"$exists" => false}})
		}
		scope :pending_payment, -> {
			where(:payment.exists => true, "payment.pending" => true)
		}
		scope :completed, -> {
			where(:completed_at.exists => true)
		}
		scope :not_completed, -> {
			where(:completed_at.exists => false)
		}

	end
	
	def calculated_total
		items.sum(&:total)
	end

	def total
		tic = read_attribute(:total_in_cents)
		tic ? tic / BigDecimal.new(100) : super
	end

	def payment_completed?
		payment? && payment.paid_at?
	end


	def total_in_cents
		read_attribute(:total_in_cents) || (calculated_total * 100).to_i
	end

	def complete
		write_attribute(:completed_at,Time.now)
		write_attribute(:total_in_cents, total_in_cents)
	end

	# IMPORTANT: 
	# Override in your own implementation
	def fulfill
		items.each(&:fulfill)
		self.fulfilled_at = Time.now
	end

	def payment_reference_id
		id
	end
end
