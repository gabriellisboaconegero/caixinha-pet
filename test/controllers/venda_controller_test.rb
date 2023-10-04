require "test_helper"

class VendaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get venda_index_url
    assert_response :success
  end
end
