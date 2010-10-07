require 'test_helper'

class ListItemsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => ListItem.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    ListItem.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    ListItem.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to list_item_url(assigns(:list_item))
  end
  
  def test_edit
    get :edit, :id => ListItem.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    ListItem.any_instance.stubs(:valid?).returns(false)
    put :update, :id => ListItem.first
    assert_template 'edit'
  end
  
  def test_update_valid
    ListItem.any_instance.stubs(:valid?).returns(true)
    put :update, :id => ListItem.first
    assert_redirected_to list_item_url(assigns(:list_item))
  end
  
  def test_destroy
    list_item = ListItem.first
    delete :destroy, :id => list_item
    assert_redirected_to list_items_url
    assert !ListItem.exists?(list_item.id)
  end
end
