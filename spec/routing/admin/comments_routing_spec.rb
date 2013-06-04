require "spec_helper"

describe Admin::CommentsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/comments").should route_to("admin/comments#index")
    end

    it "routes to #new" do
      get("/admin/comments/new").should route_to("admin/comments#new")
    end

    it "routes to #show" do
      get("/admin/comments/1").should route_to("admin/comments#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/comments/1/edit").should route_to("admin/comments#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/comments").should route_to("admin/comments#create")
    end

    it "routes to #update" do
      put("/admin/comments/1").should route_to("admin/comments#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/comments/1").should route_to("admin/comments#destroy", :id => "1")
    end

    it "routes to #change_status" do
      put("/admin/comments/1/change_status/active").should route_to("admin/comments#change_status",
                                                                    :id => "1", :status_action => 'active')
    end
    
    it "routes to #show_modal" do
      get("/admin/comments/1/show_modal").should route_to("admin/comments#show_modal", :id => "1")
    end
    
    it "routes to #answers" do
      get("/admin/comments/1/answers").should route_to("admin/comments#answers", :id => "1")
      get("/admin/comments/1/answers/divclass").should route_to("admin/comments#answers", :id => "1", :div_class => "divclass")
    end
    
    it "routes to #complaints" do
      get("/admin/comments/1/complaints").should_not route_to("admin/comments#complaints", :id => "1")
    end
  end
end
