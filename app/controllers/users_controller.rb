class UsersController < ApplicationController

    def create

        user = User.new(user_params)

        if user.save
            render json: {status: 'Usuário criado com sucesso'}, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :bad_request
        end

    end

    def login
        byebug
        user = User.find_by(email: params[:email].to_s.downcase)
        
        if user && user.authenticate(params[:password])
            auth_token = JsonWebToken.encode({user_id: user.id})
            render json: {auth_token: auth_token}, status: :ok
        else 
            render json: {error: 'Senha ou usuário inválido'}, status: :unauthorized
        end
        
    end



    private

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
