require 'test_helper'

class CarriersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Carrier.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Carrier.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Carrier.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to carrier_url(assigns(:carrier))
  end
  
  def test_edit
    get :edit, :id => Carrier.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Carrier.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Carrier.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Carrier.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Carrier.first
    assert_redirected_to carrier_url(assigns(:carrier))
  end
  
  def test_destroy
    carrier = Carrier.first
    delete :destroy, :id => carrier
    assert_redirected_to carriers_url
    assert !Carrier.exists?(carrier.id)
  end
end
