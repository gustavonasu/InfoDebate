require 'spec_helper'

describe "Admin::ForumThreads" do
  describe "GET /admin_forum_threads" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get admin_forum_threads_path
      response.status.should be(200)
    end
  end
end
