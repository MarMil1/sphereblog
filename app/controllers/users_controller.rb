class UsersController < ApplicationController
    before_action :logged_in_user, only: [:edit, :update, :destroy]
    before_action :correct_user, only: [:edit, :update, :destroy]

    def show
        @user = User.find(params[:id])
    end


    def new
        @user = User.new
    end


    def create
        @user = User.new(user_params)
        if @user.save
            log_in @user
            flash[:success] = "Welcome to sphere_blog!"
            redirect_to @user
        else
          render 'new'
        end
    end


    def edit
        @user = User.find(params[:id])
    end


    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            flash[:success] = "Profile updated"
            redirect_to @user
        else
          render 'edit'
        end
    end

    # Delete user profile and all posted user articles
    def destroy
        @user = User.find(params[:id])
        @articles = Article.where(:user_id => params[:id])
        
        if @user && @articles
            @articles.destroy_all
            @user.destroy
        else
            @user.destroy
        end

        flash[:success] = "User profile deleted"
        redirect_to articles_path
    end


    private 
    
        def user_params
            params.require(:user).permit(:username, :email, :password, :password_confirmation)
        end
        

        # To confirm that it's the correct user
        def correct_user
            @user = User.find(params[:id])
            if !current_user?(@user) 
                redirect_to(articles_path)
                flash[:danger] = "Unauthorized action on user."
            end
        end


end
