require "spec_helper"

describe Admin::CommentersController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/commenters").should route_to("admin/commenters#index")
    end

    it "routes to #new" do
      get("/admin/commenters/new").should route_to("admin/commenters#new")
    end

    it "routes to #show" do
      get("/admin/commenters/1").should route_to("admin/commenters#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/commenters/1/edit").should route_to("admin/commenters#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/commenters").should route_to("admin/commenters#create")
    end

    it "routes to #update" do
      put("/admin/commenters/1").should route_to("admin/commenters#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/commenters/1").should route_to("admin/commenters#destroy", :id => "1")
    end

  end
end
