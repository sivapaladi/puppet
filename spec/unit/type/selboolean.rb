#!/usr/bin/env ruby

Dir.chdir(File.dirname(__FILE__)) { (s = lambda { |f| File.exist?(f) ? require(f) : Dir.chdir("..") { s.call(f) } }).call("spec/spec_helper.rb") }

describe Puppet::Type.type(:selboolean), "when validating attributes" do
    [:name, :persistent].each do |param|
        it "should have a #{param} parameter" do
            Puppet::Type.type(:selboolean).attrtype(param).should == :param
        end
    end

    it "should have a value property" do
            Puppet::Type.type(:selboolean).attrtype(:value).should == :property
    end
end

describe Puppet::Type.type(:selboolean), "when validating values" do
    before do
        @provider = stub 'provider', :class => Puppet::Type.type(:selboolean).defaultprovider, :clear => nil
        Puppet::Type.type(:selboolean).defaultprovider.expects(:new).returns(@provider)
    end

    it "should support :on as a value to :value" do
        Puppet::Type.type(:selboolean).create(:name => "yay", :value => :on)
    end

    it "should support :off as a value to :value" do
        Puppet::Type.type(:selboolean).create(:name => "yay", :value => :off)
    end

    it "should support :true as a value to :persistent" do
        Puppet::Type.type(:selboolean).create(:name => "yay", :value => :on, :persistent => :true)
    end

    it "should support :false as a value to :persistent" do
        Puppet::Type.type(:selboolean).create(:name => "yay", :value => :on, :persistent => :false)
    end

    after { Puppet::Type.type(:selboolean).clear }
end

