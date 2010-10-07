require 'test_helper'

class PackingSlipsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => PackingSlip.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    PackingSlip.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    PackingSlip.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to packing_slip_url(assigns(:packing_slip))
  end
  
  def test_edit
    get :edit, :id => PackingSlip.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    PackingSlip.any_instance.stubs(:valid?).returns(false)
    put :update, :id => PackingSlip.first
    assert_template 'edit'
  end
  
  def test_update_valid
    PackingSlip.any_instance.stubs(:valid?).returns(true)
    put :update, :id => PackingSlip.first
    assert_redirected_to packing_slip_url(assigns(:packing_slip))
  end
  
  def test_destroy
    packing_slip = PackingSlip.first
    delete :destroy, :id => packing_slip
    assert_redirected_to packing_slips_url
    assert !PackingSlip.exists?(packing_slip.id)
  end
end
