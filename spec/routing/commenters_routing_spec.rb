require "spec_helper"

describe CommentersController do
  describe "routing" do

    it "routes to #index" do
      get("/commenters").should route_to("commenters#index")
    end

    it "routes to #new" do
      get("/commenters/new").should route_to("commenters#new")
    end

    it "routes to #show" do
      get("/commenters/1").should route_to("commenters#show", :id => "1")
    end

    it "routes to #edit" do
      get("/commenters/1/edit").should route_to("commenters#edit", :id => "1")
    end

    it "routes to #create" do
      post("/commenters").should route_to("commenters#create")
    end

    it "routes to #update" do
      put("/commenters/1").should route_to("commenters#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/commenters/1").should route_to("commenters#destroy", :id => "1")
    end

  end
end
