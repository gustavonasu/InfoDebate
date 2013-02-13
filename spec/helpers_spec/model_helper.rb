# encoding: UTF-8

module ModelHelper
  
  def self.all_status
    ModelStatus.all_status
  end
  
  def self.action(status)
    ModelStatus.find_action(status)
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
        expect { subject.send(ModelHelper.action(status)) }.to raise_error(InvalidStatus)  
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