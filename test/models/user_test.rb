require "test_helper"

class UserTest < ActiveSupport::TestCase
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

  test "can save with name and valid password" do
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

  test "returns 0 no. of change when password is already valid" do
    user = User.new(name: "Foo", password: "Password123")
    assert user.valid?
    assert_equal 0, user.changes_until_valid_password
  end

  test "can import from csv" do
    assert_equal 2, User.count

    path = Rails.root.join('test', 'fixtures', 'files', 'users.csv')
    csv_file = Rack::Test::UploadedFile.new(path)

    result = User.import_csv(csv_file)

    assert_match /was successfully saved/, result.first
    assert_match /Change 1 character/, result.second

    assert_equal 3, User.count
  end
end
