module ControllerHelper
  
  shared_examples_for "Controller js Search" do
    it "response all as json" do
      get :index, {:format => :js}
      result = subject.map{|obj| {:id => obj.id, :text => obj.name}}.as_json
      json_response.should eq(result)
    end
  
    it "response correct instance as json" do
      obj = subject[-1]
      get :index, {:format => :js, :name => obj.name}
      json_response[0]["id"].should eq(obj.id)
      json_response[0]["text"].should eq(obj.name)
    end
  end

  shared_examples_for "Controller js Show" do
    it "response instance as json" do
      get :show, {:id => subject.to_param, :format => :js}
      json_response["id"].should eq(subject.id)
      json_response["text"].should eq(subject.name)
    end
  end
  
  shared_examples_for "Controller Standard Search" do
    it "assigns all instances" do
      get :index, {}
      assigns(instances_symbol).should eq(instances)
    end
    
    it "assigns right instances searching by q" do
      instance.class.default_search_fields.keys.each do |attr|
        get :index, {:q => instance.read_attribute(attr)}
        assigns(instances_symbol).should include(instance)
      end
    end
    
    it "assigns right instances searching by status" do
      status = instance.target_status.find {|s| s != instance.status}
      instance.send("#{instance.find_action(status)}!")
      get :index, {:status => status}
      assigns(instances_symbol).should include(instance)
    end
  end
  
  shared_examples_for "status change validation" do |clazz|
    clazz.target_status.each do |status|
      it "should change status to #{status}" do
        execute_and_validate_status_change(subject, status)
        subject.reload.send("#{status}?").should be_true
        flash[:notice].should_not be_nil
      end
    end
    
    (clazz.invalid_status + clazz.un_target_status).each do |status|
      it "should not change status to #{status}" do
        execute_and_validate_status_change(subject, status)
        subject.reload.send("#{status}?").should be_false
        flash[:error].should_not be_nil
      end
    end
  end
  
  def execute_and_validate_status_change(obj, s)
    status = obj.target_status.find {|s| s != obj.status}
    obj.send(obj.find_action(status))
    get :change_status, {:id => obj.id, :status_action => obj.find_action(s)}
    obj.should redirect_to(:action => :show)
  end
  
  shared_examples_for "show_modal validation" do
    it "assigns the requested object and return js format" do
      xhr :get, :show_modal, {:id => subject.to_param, :call_from => 'show'}
      assigns(request_variable).should eq(subject)
      response.content_type.should == Mime::JS
    end
    
    it "should return not_found to html format" do
      get :show_modal, {:id => subject.to_param, :call_from => 'show'}
      response.should be_not_found
    end
  end
end