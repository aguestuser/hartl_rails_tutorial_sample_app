require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = Micropost.new(content: 'Lorem ipsum', user_id: user.id) }

  subject { @micropost }

  describe "attributes" do
    it { should respond_to(:content) }
    it { should respond_to(:user_id) }    
  end

  describe "validation" do

    it { should be_valid }

    describe "when user_id is not present" do
      before { @micropost.user_id = nil }
      it { should_not be_valid }
    end
  end
end
