require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  #ユーザーの名前はサンプルWebサイトに表示されるものなので、名前の長さにも制限を与える必要があります。
  #単に50を上限として手頃な値を使うことにします。ここでは51文字の名前は長すぎることを検証します
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  #問題になる可能性もあるので長すぎるメールアドレスに対してもバリデーションを掛けましょう。
  #ほとんどのデータベースでは文字列の上限を255としているので、それに合わせて255文字を上限とします
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  #メールアドレスのバリデーションは扱いが難しく、エラーが発生しやすい部分なので、有効なメールアドレスと
  #無効なメールアドレスをいくつか用意して、バリデーション内のエラーを検知していきます。
  #具体的には、user@example,comのような無効なメールアドレスが弾かれることと、user@example.comのような有効なメールアドレスが通ることを確認しながら、バリデーションを実装していきます
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      #ここでは、assertメソッドの第2引数にエラーメッセージを追加していることに注目してください。これによって、どのメールアドレスでテストが失敗したのかを特定できるようになります。
      #4.3.3で紹介したinspectメソッドを使っています。) どのメールアドレスで失敗したのかを知ることは非常に便利です。
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  #次に、user@example,com (ドットではなくカンマになっている) やuser_at_foo.org (アットマーク ‘@’ がない) といった無効なメールアドレスを使って 「無効性 (Invalidity)」についてテストしていきます。
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  #@userと同じメールアドレスのユーザーは作成できないことを、@user.dupを使ってテストしています。
  #dupは、同じ属性を持つデータを複製するためのメソッドです。@userを保存した後では、複製されたユーザーのメールアドレスが既にデータベース内に存在するため、ユーザの作成は無効になるはずです。
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    #メールアドレスでは大文字小文字が区別されません。すなわち、foo@bar.comはFOO@BAR.COMやFoO@BAr.coMと書いても扱いは同じです。したがって、メールアドレスの検証ではこのような場合も考慮する必要があります15。この性質のため、大文字を区別しないでテストすることが重要になり、
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  #次のような多重代入 (Multiple Assignment) を使っていることに注目してください。
  #パスワードとパスワード確認に対して同時に代入をしています
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # test "the truth" do
  #   assert true
  # end
end
