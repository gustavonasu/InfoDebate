module ControllerHelper
  
  shared_examples_for "Controller Standard Search" do    
    it "assigns all admin_forum_threads as @forum_threads" do
      get :index, {}
      assigns(instances_symbol).should eq(instances)
    end
    
    it "assigns forums searching by q" do
      get :index, {:q => instance.name}
      assigns(instances_symbol).should eq([instance])
    end
    
    it "assigns forums searching by status" do
      instance.inactive
      instance.save
      get :index, {:status => 'inactive'}
      assigns(instances_symbol).should eq([instance])
    end
  end
end