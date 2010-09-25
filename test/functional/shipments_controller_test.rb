require 'test_helper'

class ShipmentsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Shipment.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Shipment.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Shipment.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to shipment_url(assigns(:shipment))
  end
  
  def test_edit
    get :edit, :id => Shipment.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Shipment.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Shipment.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Shipment.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Shipment.first
    assert_redirected_to shipment_url(assigns(:shipment))
  end
  
  def test_destroy
    shipment = Shipment.first
    delete :destroy, :id => shipment
    assert_redirected_to shipments_url
    assert !Shipment.exists?(shipment.id)
  end
end
