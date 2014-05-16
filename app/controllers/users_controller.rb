class UsersController < ApplicationController
	skip_before_filter :verify_active_session, only: :create
	
	#post /users
	def create

		safe_password = Digest::SHA256.hexdigest(params[:password]).reverse[5..-1]

		user = User.new(
			:login 	  => params[:login],
		 	:password => safe_password,
		 	:email    => params[:email]
		)

		if user.save
			notice = "User created!"
		else
			notice = user.errors.full_messages[0]
		end

		redirect_to :back, :flash => {:notice => notice}
	end

	#get /users/:id
	def show
		#type 1 is search by site name ;D
	  	search_query = "AND site LIKE '%#{params[:search]}%'" if params[:type] == "1"
	  		
  		#type 1 is search by login
  		search_query = "AND login LIKE '%#{params[:search]}%'" if params[:type] == "2"
	  		   	
  		#type 1 is search by password
  		search_query = "AND password LIKE '%#{params[:search]}%'" if params[:type] == "3"
	  	

	  	@passwords = Credential.where("user_id = #{session[:user_id]} #{search_query}")
	  	
	end

end