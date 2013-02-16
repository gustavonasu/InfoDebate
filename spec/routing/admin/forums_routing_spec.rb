require "spec_helper"

describe Admin::ForumsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/forums").should route_to("admin/forums#index")
    end

    it "routes to #new" do
      get("/admin/forums/new").should route_to("admin/forums#new")
    end

    it "routes to #show" do
      get("/admin/forums/1").should route_to("admin/forums#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/forums/1/edit").should route_to("admin/forums#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/forums").should route_to("admin/forums#create")
    end

    it "routes to #update" do
      put("/admin/forums/1").should route_to("admin/forums#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/forums/1").should route_to("admin/forums#destroy", :id => "1")
    end
    
    it "routes to #change_status" do
      get("/admin/forums/1/change_status/active").should route_to("admin/forums#change_status",
                                                                    :id => "1", :status_action => 'active')
    end
  end
end
