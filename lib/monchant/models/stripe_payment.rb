class Monchant::StripePayment < Monchant::Payment
	field :token, type: String
	field :charge_id, type: String
	field :access_token, type: String

	validates :token, presence: true

	def charge=(ch)
		self.charge_id = ch['id']
		if ch['paid']
			mark_paid
		else
			self.messages << ch['failure_message']
			self.error = true
		end
		@response = ch
	end

	def charge
		return nil unless charge_id?
		@response ||=
			Stripe::Charge.retrieve(charge_id)
	end

	def refund
		resp = charge.refund
		if resp.refunded
			mark_refunded
		end
	end

	def do_charge
		unless paid?
			self.charge = Stripe::Charge.create({
				amount: container.total_in_cents,
				currency: 'usd',
				card: token
			}, access_token)
		  return paid?
		end
	end
end
