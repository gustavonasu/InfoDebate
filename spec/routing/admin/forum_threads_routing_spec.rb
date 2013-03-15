require "spec_helper"

describe Admin::ForumThreadsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/forum_threads").should route_to("admin/forum_threads#index")
    end

    it "routes to #new" do
      get("/admin/forum_threads/new").should route_to("admin/forum_threads#new")
    end

    it "routes to #show" do
      get("/admin/forum_threads/1").should route_to("admin/forum_threads#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/forum_threads/1/edit").should route_to("admin/forum_threads#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/forum_threads").should route_to("admin/forum_threads#create")
    end

    it "routes to #update" do
      put("/admin/forum_threads/1").should route_to("admin/forum_threads#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/forum_threads/1").should route_to("admin/forum_threads#destroy", :id => "1")
    end

    it "routes to #change_status" do
      get("/admin/forum_threads/1/change_status/active").should route_to("admin/forum_threads#change_status",
                                                                    :id => "1", :status_action => 'active')
    end
    
    it "routes to #show_modal" do
      get("/admin/forum_threads/1/show_modal").should route_to("admin/forum_threads#show_modal", :id => "1")
    end
    
    it "routes to #change_status with call_from" do
      get("/admin/forum_threads/1/change_status/active/forum_thread_list").should route_to("admin/forum_threads#change_status",
                                                      :id => "1", :status_action => 'active', :call_from => 'forum_thread_list')
    end
  end
end
