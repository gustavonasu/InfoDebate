# encoding: UTF-8

module ModelHelper
  
  shared_examples_for "status validation" do |clazz, factory_symbol|
    clazz.target_status.each do |status|
      it "should change status to target '#{status}' status" do
        subject.send(subject.find_action(status))
        assert_status_change(subject, status)
      end
      
      it "should change status to target '#{status}' status with action!" do
        subject.send("#{subject.find_action(status)}!")
        assert_status_change(subject, status)
        subject.reload.status.should eq(status)
      end
    end
    
    clazz.un_target_status.each do |status|
      it "should not change status to un-target '#{status}' status" do
        expect { subject.send(subject.find_action(status)) }.to raise_error(Status::Un_TargetStatusError)
      end
      
      it "should not change status to un-target '#{status}' status with action!" do
        expect { subject.send("#{subject.find_action(status)}!") }.to raise_error(Status::Un_TargetStatusError)
      end
    end
    
    clazz.terminal_status.each do |status|
      it "should not change status from terminal '#{status}' status" do
        set_terminal_status(subject)
        action = subject.find_action(subject.target_status.first)
        expect { subject.send(action) }.to raise_error(Status::TerminalStatusError)
      end
      
      it "should not change status from terminal '#{status}' status with action!" do
        set_terminal_status(subject)
        action = subject.find_action(subject.target_status.first)
        expect { subject.send("#{action}!") }.to raise_error(Status::TerminalStatusError)
      end
    end
    
    clazz.invalid_status.each do |status|
      it "should not change status to invalid '#{status}' status" do
        expect { subject.send(subject.find_action(status)) }.to raise_error(Status::InvalidStatusError)
      end
      
      it "should not change status to invalid '#{status}' status with action!" do
        expect { subject.send("#{subject.find_action(status)}!") }.to raise_error(Status::InvalidStatusError)
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
    
    def set_terminal_status(obj)
      action = obj.find_action(obj.terminal_status.first)
      obj.send(action)
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

RSpec::Matchers.define :must_has_same_parents_thread do
  match do |actual|
    actual.index{ |msg| msg =~ /thread deve ser a mesma do comentário pai/ }
  end
end