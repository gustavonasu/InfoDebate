require 'spec_helper'

describe "Admin::Complaints" do
  describe "GET /admin_complaints" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get admin_complaints_path
      response.status.should be(200)
    end
  end
end
