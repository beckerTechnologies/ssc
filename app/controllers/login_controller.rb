class LoginController < ApplicationController
  def page1
    if params[:email].present? 
      @email = params[:email].tr(' ','').downcase
      if @email.length!=0 
        begin
          @profile = Profile.find_by! email: @email
          if @profile.password != params[:password] # password mismatched
            raise "password mismatch"
          else
            session[:login] = @profile[:id]
            redirect_to :action => :page2
          end
        rescue 
          flash[:error] = "Incorrect username or password."
        end
      end
    else
      flash.clear
    end
  end

  def page2
    if !session[:login]
      redirect_to :action => :page1
    else
      @pid = session[:login]
      if params[:ssc].present? 
        @ssc = params[:ssc].tr(' ','')
        if @ssc.length!=0 
          begin
            @sscVal = SscBank.find_by profile_id: @pid
            if @sscVal.ssc != @ssc || @sscVal[:expiry] < Time.now # ssc mismatched or expired
              raise "ssc mismatch"
            else
              redirect_to :action => :page3
            end
          rescue 
            flash[:error] = "incorrect or expired SSC. use the button below to send yourself a new CT. (for testing, profile_id = #{@pid} and here is ur ssc: #{@sscVal.ssc} #{Time.now} > #{@sscVal[:expiry]}" 
          end
        end
      else
        flash.clear
      end
    end
  end
  def page3
  end
end
