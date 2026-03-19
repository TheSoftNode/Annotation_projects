module AuthHelper
  def sign_in(user)
    # Simulate session-based authentication
    # In a real app this would set session[:user_id]
    # For testing, we'll use a simple approach
    allow_any_instance_of(ApplicationController).to receive(:session).and_return({ user_id: user.id })
    user
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end
