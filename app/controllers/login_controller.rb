class LoginController < ApplicationController
  @person = nil
  def page1
    if params[:email].present? 
      @email = params[:email].tr(' ','').downcase
      if @email.length!=0 
        begin
          @person = Profile.find_by! email: @email
          if @person.password != params[:password] # password mismatched
            raise "password mismatch"
          end
        rescue 
          flash[:error] = "Incorrect username or password."
          #render :page2 # delete this line after debugging. 
        else
          render :page2
        end
      end
    else
      flash.clear
      #flash[:error] = "No error message "
    end
  end

  def page2
    #@person = Profile.new # uncomment to check ssc func. 
    if @person==nil
      flash[:error] = "No profile selected"
    else
      if params[:ssc].present? 
        @ssc = params[:ssc].tr(' ','')
        if @ssc.length!=0 
          begin
            @sscVal = SscBank.find(@person.id)
            if @sscVal.ssc != @ssc # ssc mismatched
              raise "ssc mismatch"
            end
          rescue 
            flash[:error] = "incorrect SSC" 
            #render :page3 # delete this line after debugging. 
          else
            render :page3
          end
        end
      else
      flash.clear
        #flash[:error] = "no SSC entered"
      end
    end
  end
end
