require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "cannot save without name" do
    user = User.new(password: "Aqpfk1swods")
    assert_not user.save
  end

  test "cannot save without password" do
    user = User.new(name: "Foo", password: nil)
    assert_not user.save
  end

  test "cannot save with password that is too short, i.e. len < 10" do
    user = User.new(name: "Foo", password: "short")
    assert_not user.save
  end

  test "cannot save with password that is too long, i.e. len > 16" do
    user = User.new(name: "Foo", password: "thispasswordisloooooong")
    assert_not user.save
  end

  test "cannot save with password that does not have at least one lowercase character" do
    user = User.new(name: "Foo", password: "ALMOSTVALID1")
    assert_not user.save
  end

  test "cannot save with password that does not have at least one uppercase character" do
    user = User.new(name: "Foo", password: "almostvalid1")
    assert_not user.save
  end

  test "cannot save with password that does not have at least one digit" do
    user = User.new(name: "Foo", password: "Almostvalid")
    assert_not user.save
  end

  test "cannot save with password that has 3 consecutive repeating characters, i.e. aaa" do
    user = User.new(name: "Foo", password: "AAAlmostvalid1")
    assert_not user.save
  end

  test "can save with user and valid password" do
    user = User.new(name: "Foo", password: "Validpassword123")
    assert user.save!
  end

  test "returns correct no. of changes until password is long enough" do
    user = User.new(name: "Foo", password: "short")
    assert user.invalid?
    assert_equal 5, user.changes_until_valid_password
  end

  test "returns correct no. of changes until password is short enough" do
    user = User.new(name: "Foo", password: "thispasswordisverylong")
    assert user.invalid?
    assert_equal 6, user.changes_until_valid_password
  end

  test "returns correct no. of changes until password has one lowercase character" do
    user = User.new(name: "Foo", password: "PASSWORD123")
    assert user.invalid?
    assert_equal 1, user.changes_until_valid_password
  end

  test "returns correct no. of changes until password has one uppercase character" do
    user = User.new(name: "Foo", password: "password123")
    assert user.invalid?
    assert_equal 1, user.changes_until_valid_password
  end

  test "returns correct no. of changes until password does not have 3 consecutive repeating characters" do
    user = User.new(name: "Foo", password: "PPPwwwwww111")
    assert user.invalid?
    assert_equal 4, user.changes_until_valid_password
  end
end
