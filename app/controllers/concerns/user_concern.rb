module UserConcern extend ActiveSupport::Concern 

    def generate_token(user)
        Doorkeeper::AccessToken.create!(
            resource_owner_id: user.id,
            expires_in: Doorkeeper.configuration.access_token_expires_in,
            scopes: Doorkeeper.configuration.default_scopes
        )
    end
end
