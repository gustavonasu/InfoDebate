module StandardSearchHelper
  
  shared_examples_for "Standard Search By Name" do
    it "should limit page" do
      limit = num_instances / 3
      results = type.search_by_name("%", 1, limit)
      results.length.should eq(limit)
    end
    
    it "should paginate" do
      limit = (num_instances / 2) + 1
      results = type.search_by_name("%", 2, limit)
      results.length.should eq(num_instances - limit)
    end
    
    it "should return correctly" do
      results = type.search_by_name(subject.name)
      results.should include(subject)
    end
    
    it "should return nothing for blank search" do
      results = type.search_by_name("")
      results.should be_empty
    end
  end
  
  shared_examples_for "Standard Search" do
    it "should limit page" do
      limit = num_instances / 3
      results = type.search({:term => "%"}, 1, limit)
      results.length.should eq(limit)
    end
    
    it "should paginate" do
      limit = (num_instances / 2) + 1
      results = type.search({:term => "%"}, 2, limit)
      results.length.should eq(num_instances - limit)
    end
    
    it "should return correctly searching by fields" do
      type.default_search_fields.each do |field|
        results = type.search({:term => subject.read_attribute(field)})
        results.should include(subject)
      end
    end
    
    it "should return correctly searching by status" do
      status = subject.target_status.find {|s| s != subject.status}
      subject.send("#{subject.find_action(status)}!")
      results = type.search({:status => status})
      results.should include(subject)
    end
  end
end