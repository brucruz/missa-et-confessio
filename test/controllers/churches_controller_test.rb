require "test_helper"

class ChurchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @church = churches(:santo_antonio_de_piracicaba)
    Geocoder.configure(lookup: :test, ip_lookup: :test)
  end

  test "should get index" do
    get churches_url
    assert_response :success
  end

  # TODO: Fix this test
  # test "should get index with location" do
  #   location = "São Paulo"
  #   geocoded_location = [ -23.550520, -46.633308 ] # Coordinates for São Paulo

  #   # Mock the Geocoder to return the coordinates for the given location
  #   Geocoder::Lookup::Test.add_stub(
  #     location, [
  #       {
  #         "latitude"     => geocoded_location[0],
  #         "longitude"    => geocoded_location[1],
  #         "address"      => location,
  #         "state"        => "São Paulo",
  #         "state_code"   => "SP",
  #         "country"      => "Brazil",
  #         "country_code" => "BR"
  #       }
  #     ]
  #   )

  #   get churches_url, params: { location: location }
  #   assert_response :success

  #   # Ensure the churches are filtered by the location
  #   assert assigns(:churches).all? { |church| church.distance.present? }
  # end

  test "should get new" do
    get new_church_url
    assert_response :success
  end

  test "should create church" do
    params = {
      church: {
        name: "Test Church",
        address: "Test Address",
        place_id: "unique_place_id_123"
      }
    }
    assert_difference("Church.count") do
      post churches_url, params: params
    end

    church = Church.last
    assert_equal params[:church][:place_id], church.place_id
    assert_redirected_to church_url(church)
    assert_equal "Igreja criada com sucesso, adicione agora os horários de missas.", flash[:notice]
  end

  test "should not create duplicate church with same place_id" do
    assert_no_difference("Church.count") do
      post churches_url, params: {
        church: {
          name: @church.name,
          address: @church.address,
          place_id: @church.place_id
        }
      }
    end

    assert_redirected_to church_url(@church)
    assert_equal "Igreja já existe, adicione agora os horários de missas.", flash[:notice]
  end

  test "should show church" do
    get church_url(@church)
    assert_response :success
  end
end
