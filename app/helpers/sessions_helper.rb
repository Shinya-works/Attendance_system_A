module SessionsHelper
    
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def remember(user)
    # userの情報で永続為ハッシュ化したトークンをデータベースに記憶
    user.remember
    # ２０年の有効期限をつけてクッキーの:user_idキーにuser.idを代入する
    cookies.permanent.signed[:user_id] = user.id
    # ２０年の有効期限をつけてクッキーの:remember_token属性にuserの:password_tokenの値を代入する
    cookies.permanent[:remember_token] = user.remember_token
  end
  # クッキーの情報と永続セッションを削除するメソッド
  def forget(user)
    # forgetメソッドで:remember_digestをnilに更新保存
    user.forget
    # クッキーの:user_idと:remember_tokenを削除
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user)
    # 一時セッションの:user_idキーの情報を削除
    session.delete(:user_id)
    # あわせて@current_userに代入されたidを削除する
    @current_user = nil
  end
  
  # ログインしているユーザー、もしくは永続セッションに保存されているログインユーザーの情報を代入するメソッド
  def current_user
    if (user_id = session[:user_id])
      # @current_userがあった場合(二回目の処理)current_userメソッドの戻り理に@current_userを入れる||ログインで定義したsession[:user_id]をつかってUser内の情報を取得し@current_userに代入
      @currrnt_user ||= User.find_by(id: user_id)
      # cookies.signed[:user_idが存在するときuser_idに代入
    elsif (user_id = cookies.signed[:user_id]
      # 代入されたuser_idを使ってUserモデルから情報を取得しuserに代入
      user = User.find_by(id: user_id))
      # cookies.signed[:user_id]が存在し、Userモデルにcookies.signed[:user_id]番のidから情報が取得でき、かつ、その取得した情報のパスワードとクッキーに保存されているトークンが一致した場合
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
      @current_user = user
      end
    end
  end
  
  # 渡されたユーザーがログイン済みのユーザーであればtrueを返します。
  def current_user?(user)
    user == current_user
  end
  
  def logged_in?
    # current_userメソッドを使用しそれがnilであった場合を否定している
    !current_user.nil?
  end
  
  # 記憶しているURL(またはデフォルトURL)にリダイレクトします。
  def redirect_back_or(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたURLを記憶します。
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  
end
