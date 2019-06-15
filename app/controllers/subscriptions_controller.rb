class SubscriptionsController < ApplicationController
	before_action :authenticate_user!, except: [:new]
	before_action :redirect_to_signup, only: [:new]

	def show
	end

	def new
		@quantity = params[:quantity]
	end

	def create
		#################################
		#################################
		#################################
		# Main logic of stripe subscription handled in this code
		# First i am finding the subscription already subscribed or not
		# and then subscribing based on the quantity entered in form field
		#################################
		#################################
		#################################

		customer = if current_user.stripe_id?
					Stripe::Customer.retrieve(current_user.stripe_id)
				else
					if stripe_plan.present?
						Stripe::Customer.create(
							email: current_user.email,
							source: params[:stripeToken])
					end
				end

		subscription = customer.subscriptions.create(
			plan: stripe_plan.id.to_sym,
			quantity: params[:quantity]
		)
		current_user.update(
			stripe_id: customer.id,
			stripe_subscription_id: subscription.id,
			card_last4: params[:card_last4],
			card_exp_month: params[:card_exp_month],
			card_exp_year: params[:card_exp_year],
			card_type: params[:card_brand]
		)
		redirect_to root_path
	end



	def destroy
		if stripe_subscription.present?
			Stripe::Subscription.delete(stripe_subscription.id.to_sym)
			current_user.update(
			stripe_id: nil,
			stripe_subscription_id: nil,
			card_last4: nil,
			card_exp_month: nil,
			card_exp_year: nil,
			card_type: nil
			)
		redirect_to root_path
		end
	end

	private

		def stripe_plan
			stripe_plan ||= Stripe::Plan.retrieve("vessel")
		end

		def stripe_subscription
			stripe_subscription ||= Stripe::Subscription.retrieve(current_user.stripe_subscription_id)
		end 

		def redirect_to_signup
			if !user_signed_in?
				session["user_return_to"] = new_subscription_path
				redirect_to new_user_registration_path
			end	
		end
end