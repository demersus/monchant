class Monchant::PaypalPayment < Monchant::Payment
	field :pay_key, type: String
	field :receiver_email, type: String

	attr_accessor :return_url, :cancel_url, :ipn_url, :response

	def purchase
		unless paid? || pending?
			if container.valid? && receiver_email && return_url && cancel_url && ipn_url
				req = PaypalAdaptive::Request.new
				self.response = req.pay({
					"returnUrl" => return_url,
					"cancelUrl" => cancel_url,
					"ipnNotificationUrl" => ipn_url,
					"requestEnvelope" => {"errorLanguage" => "en_US"},
					"currencyCode" => "USD",
					"receiverList" => {"receiver" => [
						{"email" => receiver_email, "amount" => container.total}
					]},
					"actionType" => "PAY"
				})
				unless response.success?
					self.messages << response.errors.first['message']
					self.error = true
				end
				return response.success?
			end
		end
	end
	
	def refund
		if pay_key?
			self.response = PaypalAdaptive::Request.new({
				"currencyCode" => "USD",
				"requestEnvelope" => {"errorLanguage" => "en_US"},
				"payKey" => pay_key,
				"receiverList" => {"receiver" => [
					{"email" => receiver_email, "amount" => container.total}
				]}
			})

			if response.success?
				mark_refunded
			else
				self.messages << "(#{Time.now}) PAYPAL REFUND RESPONSE: #{response.errors.first['message']}"
				self.error = true
			end
			
			return response.success?			
		end
	end


	def approve_payment_url(opts = {})
		response.approve_paypal_payment_url opts
	end


end
