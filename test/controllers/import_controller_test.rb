require "test_helper"

class ImportControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_import_url
    assert_response :success
  end

  test "should get show" do
    get import_url
    assert_response :success
  end

  test "create should redirect to show" do
    path = Rails.root.join('test', 'fixtures', 'files', 'users.csv')
    csv_file = fixture_file_upload(path, 'text/csv')

    post import_url, params: { file: csv_file }
    assert_redirected_to import_url
  end
end
