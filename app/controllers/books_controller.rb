class BooksController < ApplicationController

  def show
    @bookidv = Book.find(params[:id])
    @user = @bookidv.user
    @book =Book.new
  end

  def index
    @book = Book.new
    @books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @user = current_user

  end

  def create
    @book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @book.user_id = current_user.id
    if @book.save #入力されたデータをdbに保存する。
      redirect_to book_path(@book.id), notice: "successfully created book!"#保存された場合の移動先を指定。
    else
       # flash[:message] = ' error ! can not be blank '
      @books = Book.all
      @user = current_user
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    @bookfail = Book.new
      if current_user != @book.user
      redirect_to books_path
    end
  end


  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "successfully updated book!"
    else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
       # flash[:message] = ' error ! can not be blank '
      @bookfail = @book
      @book = Book.find(params[:id])
      render :edit
    
    end
 end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path, notice: "successfully delete book!"
  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end

end