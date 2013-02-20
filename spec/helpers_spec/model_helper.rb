# encoding: UTF-8

module ModelHelper
  
  Status::ModelStatus.all_status.each do |status|
    shared_examples_for "valid #{status} status validation" do
      it "should change status to #{status}" do
        subject.send(subject.find_action(status))
        assert_status_change(subject, status)
        
      end
    end
    
    shared_examples_for "valid #{status} status validation with persistence" do
      it "should change status to #{status}" do
        subject.send("#{subject.find_action(status)}!")
        assert_status_change(subject, status)
        subject.reload.status.should eq(status)
      end
    end
    
    shared_examples_for "invalid #{status} status validation" do
      it "should not change status to #{status}" do
        expect { subject.send(subject.find_action(status)) }.to raise_error(Status::InvalidStatus)
      end
    end
    
    shared_examples_for "invalid #{status} status validation with persistence" do
      it "should not change status to #{status}" do
        expect { subject.send("#{subject.find_action(status)}!") }.to raise_error(Status::InvalidStatus)
      end
    end
  end
  
  shared_examples_for "destroy ModelStatus instance" do
    it "should not destroy instance" do
      init_count = type.unscoped.count
      subject.destroy
      type.unscoped.count.should eq(init_count)
      type.unscoped.find(subject.id).deleted?.should be_true
    end
  end
  
  shared_examples_for "define status methods" do
    it "should define status methods" do
      [:all_status, :valid_status, :invalid_status, :un_target_status, :target_status, :terminal_status].each do |attribute|
        subject.should respond_to(attribute)
        subject.class.should respond_to(attribute)
      end
    end
  end
  
  private
  
    def assert_status_change(obj, status)
      obj.send("#{status}?").should be_true
      obj.invalid_status.each do |another_status|
        obj.send("#{another_status}?").should be_false
      end
    end
end


# TODO arrumar mensagem de erro.
RSpec::Matchers.define :cannot_be_blank do
  match do |actual|
    actual.index{ |msg| msg =~ /não pode ficar em branco/ }
  end
end

RSpec::Matchers.define :too_long do
  match do |actual|
    actual.index{ |msg| msg =~ /é muito longo/ }
  end
end

RSpec::Matchers.define :too_short do
  match do |actual|
    actual.index{ |msg| msg =~ /é muito curto/ }
  end
end

RSpec::Matchers.define :be_unique do
  match do |actual|
    actual.index{ |msg| msg =~ /já está em uso/ }
  end
end

RSpec::Matchers.define :not_match_confirmation do
  match do |actual|
    actual.index{ |msg| msg =~ /não está de acordo com a confirmação/ }
  end
end

RSpec::Matchers.define :invalid_email do
  match do |actual|
    actual.index{ |msg| msg =~ /não é um email válido/ }
  end
end