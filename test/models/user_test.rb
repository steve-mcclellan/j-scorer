require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: 'user@example.com', password: 'foobar',
                     password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'email should be present' do
    @user.email = '     '
    assert_not @user.valid?
  end

  test 'email should not exceed 50 characters' do
    @user.email = 'a' * 38 + '@example.com'
    assert @user.valid?
    @user.email = 'a' * 39 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email addresses should be saved as lower-case' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should be at least 6 characters' do
    @user.password = @user.password_confirmation = 'a' * 6
    assert @user.valid?
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'associated games should be destroyed' do
    @user.save
    @user.games.create!(show_date: Date.new(2016, 1, 18), date_played: Time.zone.now)
    assert_difference 'Game.count', -1 do
      @user.destroy
    end
  end
end
