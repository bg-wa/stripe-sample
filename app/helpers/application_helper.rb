module ApplicationHelper
	def current_user_subscribed?
		user_signed_in? && current_user.subscribed?
	end
end
