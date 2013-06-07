class Monchant::Payment
	include Mongoid::Document
	embedded_in :container, polymorphic: true
	
	field :refunded_at, type: DateTime
	field :messages, type: Array, default: []
	field :paid_at, type: DateTime
	field :error, type: Boolean
	field :pending, type: Boolean
	field :pending_refund, type: Boolean
	
	def status
		messages.last.to_s
	end

	def paid?
		paid_at?
	end

	def mark_paid
		self.paid_at = Time.now
		self.pending = nil
		self.error = nil
		self.messages << "PAYMENT COMPLETED (#{self.paid_at})"
	end

	def mark_pending
		self.pending = true
		self.error = nil
		self.messages << "PAYMENT PENDING (#{Time.now})"
	end

	def refunded?
		refunded_at?
	end
	
	def mark_refunded
		self.refunded_at = Time.now
		self.pending_refund = nil
		self.error = nil
		self.messages <<  "REFUND COMPLETED (#{self.refunded_at})"
	end

end
