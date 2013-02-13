module StandardSearchHelper
  
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
    
    it "should return correctly searching by name" do
      results = type.search({:term => subject.name})
      results.should include(subject)
    end
    
    it "should return correctly searching by description" do
      results = type.search({:term => subject.description})
      results.should include(subject)
    end
    
    it "should return correctly searching by status" do
      subject.inactive
      subject.save
      results = type.search({:status => :inactive})
      results.should include(subject)
    end
  end
end