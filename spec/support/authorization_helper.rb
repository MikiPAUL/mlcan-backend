module AuthorizationHelper
    def authorization user
        post '/api/auth/login', params: {email: user.email, password: user.password}, as: :json

        token = JSON.parse(response.body)["token"]

        return token
    end

    def reset_token user
        
        reset_token_params = {
            user: {
                email: user.email
            }
        }
        post '/api/auth/password/new', params: reset_token_params
        return JSON.parse(response.body)["reset_password_token"]
    end
end