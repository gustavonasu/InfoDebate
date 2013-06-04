require "spec_helper"

describe Admin::ComplaintsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/complaints").should route_to("admin/complaints#index")
    end

    it "routes to #new" do
      get("/admin/complaints/new").should route_to("admin/complaints#new")
    end

    it "routes to #show" do
      get("/admin/complaints/1").should route_to("admin/complaints#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/complaints/1/edit").should route_to("admin/complaints#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/complaints").should route_to("admin/complaints#create")
    end

    it "routes to #update" do
      put("/admin/complaints/1").should route_to("admin/complaints#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/complaints/1").should route_to("admin/complaints#destroy", :id => "1")
    end

    it "routes to #change_status" do
      put("/admin/complaints/1/change_status/active").should route_to("admin/complaints#change_status",
                                                                    :id => "1", :status_action => 'active')
    end
    
    it "routes to #show_modal" do
      get("/admin/complaints/1/show_modal").should route_to("admin/complaints#show_modal", :id => "1")
    end
    
    it "routes to #answers" do
      get("/admin/complaints/1/answers").should_not route_to("admin/complaints#answers", :id => "1")
    end
    
    it "routes to #complaints" do
      get("/admin/comments/1/complaints").should route_to("admin/complaints#complaints", :id => "1")
      get("/admin/comments/1/complaints/divclass").should route_to("admin/complaints#complaints",
                                                                    :id => "1", :div_class => "divclass")
    end
  end
end
