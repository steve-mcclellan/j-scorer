require 'test_helper'

# rubocop:disable ClassLength
class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: 'user@example.com',
                     password: 'foobar',
                     password_confirmation: 'foobar',
                     shared_stats_name: 'new_user')
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

  test 'filter validator should allow valid data' do
    @user.show_date_reverse = true
    @user.show_date_preposition = 'sinceBeg'
    @user.show_date_beginning = Date.new(2017, 9, 11)
    @user.show_date_last_number = 5
    @user.show_date_last_unit = 'y'
    @user.show_date_from = Date.new(1983, 7, 18)
    @user.show_date_to = Date.new(2083, 7, 18)
    @user.date_played_reverse = false
    @user.date_played_preposition = 'inLast'
    @user.date_played_beginning = Date.new(2016, 9, 12)
    @user.date_played_last_number = 365
    @user.date_played_last_unit = 'd'
    @user.date_played_from = Date.new(1, 1, 1)
    @user.date_played_to = Date.new(9999, 12, 31)
    @user.rerun_status = 'first'
    assert @user.valid?
  end

  test 'filter validator should fail on bad preposition' do
    @user.show_date_preposition = 'across'
    assert_not @user.valid?
  end

  test 'filter validator should fail on bad date' do
    @user.date_played_beginning = 'not-a-date'
    assert_nil @user.date_played_beginning
    assert @user.valid?
    @user.show_date_from = Date.new(10_000, 1, 1)
    assert_not @user.valid?
  end

  test 'filter validator should fail on bad unit' do
    @user.show_date_last_unit = 'millenia'
    assert_not @user.valid?
    @user.show_date_last_unit = nil
    assert @user.valid?
    @user.date_played_last_unit = 'q'
    assert_not @user.valid?
  end

  test 'shared stats name should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = 'someotheremail@example.com'
    duplicate_user.shared_stats_name = @user.shared_stats_name.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'shared stats name should be saved as entered' do
    mixed_case_name = 'aWeSoMeStAtSgUy'
    @user.shared_stats_name = mixed_case_name
    @user.save
    assert_equal mixed_case_name, @user.reload.shared_stats_name
  end

  test 'multiple nils should be allowed for shared stats name' do
    duplicate_user = @user.dup
    duplicate_user.email = 'someotheremail@example.com'
    @user.shared_stats_name = nil
    @user.save
    duplicate_user.shared_stats_name = nil
    assert duplicate_user.valid?
  end
end
# rubocop:enable ClassLength
