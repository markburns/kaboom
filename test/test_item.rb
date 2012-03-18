# coding: utf-8

require 'helper'

class TestItem < Test::Unit::TestCase

  before do
    @item = Boom::Item.new('github','https://github.com')
  end

  it "name" do
    @item.name.should == 'github'
  end

  it "value" do
    @item.value.should == 'https://github.com'
  end

  it "short name" do
    @item.short_name.should == 'github'
  end

  it "short name" do
    @item.name = 'github github github lol lol lol'
    @item.short_name.should == 'github github g…'
  end

  it "spacer none" do
    @item.name = 'github github github lol lol lol'
    @item.spacer.should == ''
  end

  it "spacer tons" do
    @item.spacer.should == '          '
  end

  it "to hash" do
    @item.to_hash.size.should == 1
  end

  it "url" do
    @item.url.should == 'https://github.com'
  end
  
  it "url with additional description" do
    @item = Boom::Item.new('github', 'social coding https://github.com')
    @item.url.should == 'https://github.com'
  end
  
  it "url without url" do
    @item = Boom::Item.new('didum', 'dadam lol omg')
    @item.url.should == 'dadam lol omg'
  end
end
