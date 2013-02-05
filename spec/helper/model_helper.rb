module ModelHelper
  
  def self.all_status
    Infodebate::Status.all_status
  end
  
  def self.action(status)
    Infodebate::Status.find_action(status)
  end
  
  all_status.each do |status|
    shared_examples_for "valid #{status} status validation" do
      it "should change status to #{status}" do
        subject.send(ModelHelper.action(status))
        subject.send("#{status}?").should be_true
        (ModelHelper.all_status - [status]).each do |another_status|
          subject.send("#{another_status}?").should be_false
        end
      end
    end
  end
  
  all_status.each do |status|
    shared_examples_for "invalid #{status} status validation" do
      it "should not change status to #{status}" do
        expect { subject.send(ModelHelper.action(status)) }.to raise_error(Infodebate::InvalidStatus)  
      end
    end
  end
end


RSpec::Matchers.define :cannot_be_blank do
  match do |actual|
    actual.include? "can't be blank"
  end
end
