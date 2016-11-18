class OnlineLendingController < ApplicationController
  def register
  end
  def login
  end


  def createlender
    lender = Lender.create(first_name:params[:first_name], last_name:params[:last_name], email:params[:email], password:params[:password], money:params[:money])
    if lender.errors.full_messages.empty?
      session[:lender_id]=lender.id
      redirect_to "/online_lending/lender/"+session[:lender_id].to_s
    else
      flash[:errors] = lender.errors.full_messages
      redirect_to "/online_lending/register"
    end
  end

  def createborrower
    borrower = Borrower.create(first_name:params[:first_name], last_name:params[:last_name], email:params[:email], password:params[:password], money:params[:money], purpose:params[:purpose], description:params[:description], raised:0)
    if borrower.errors.full_messages.empty?
      session[:borrower_id]=borrower.id
      redirect_to "/online_lending/borrower/"+session[:borrower_id].to_s
    else
      flash[:errors] = borrower.errors.full_messages
      redirect_to "/online_lending/register"
    end
  end

  def login_auth
    if Lender.find_by_email(params[:email])
      lender = Lender.find_by_email(params[:email])
      if lender.password == params[:password]
        session[:lender_id] = lender.id
        redirect_to '/online_lending/lender/'+session[:lender_id].to_s
      else
      flash[:errors]= ["Invalid Password or Email! "]
      redirect_to "/online_lending/login"
      end
    elsif Borrower.find_by_email(params[:email])
      borrower = Borrower.find_by_email(params[:email])
      if borrower.password == params[:password]
        session[:borrower_id] = borrower.id
        redirect_to '/online_lending/borrower/'+session[:borrower_id].to_s
      else
      flash[:errors]= ["Invalid Password or Email! "]
      redirect_to "/online_lending/login"
      end
    elsif not Lender.find_by_email(params[:email]) && Borrower.find_by_email(params[:email])
      flash[:errors]= ["Email or Password Cannot Be Blank"]
      redirect_to "/online_lending/login"
    end
  end


  def logout
    session[:lender_id]=nil
    session[:borrower_id]=nil
    redirect_to '/online_lending/login'
  end

  def bpage
    @borrower = Borrower.find(session[:borrower_id])
    @histories = History.where(borrower_id:session[:borrower_id])
  end

  def lpage
    @lender = Lender.find(params[:id])
    @borrowers = Borrower.all
    @histories = History.where(lender_id:session[:lender_id])
  end


  def lend_money
    @lender = Lender.find(session[:lender_id])
    @borrower = Borrower.find(params[:id])

    money_left = @lender.money.to_i - params[:amount].to_i
    money_added = @borrower.raised.to_i + params[:amount].to_i
    if money_left < 0
      flash[:errors]=["Insufficient Funds"]
      redirect_to :back
    elsif money_added >= @borrower.money
      flash[:errors]=["the borrower has enough money! "]
      redirect_to :back
    else
      @lender.update(money:money_left)
      @borrower.update(raised:money_added)
      his = @lender.histories.find_by_borrower_id(params[:id])
      if his
        his.amount+=params[:amount].to_i
        his.save
      else
        his = History.create(amount:params[:amount],lender:@lender, borrower:@borrower)
      end
      redirect_to :back
    end
  end
end
