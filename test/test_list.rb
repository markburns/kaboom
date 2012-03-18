# coding: utf-8

require 'helper'

class TestList < Test::Unit::TestCase

  before do
    @list = Boom::List.new('urls')
    @item = Boom::Item.new('github','https://github.com')
    boom_json :urls
  end

  it "name" do
    @list.name.should == 'urls'
  end

  it "add items" do
    @list.items.size.should == 0
    @list.add_item(@item)
    @list.items.size.should == 1
  end

  it "add item with duplicate name" do
    @list.add_item(@item)
    @list.items.size.should == 1
    @list.find_item('github').value.should == 'https://github.com'
    @diff_item = Boom::Item.new('github', 'https://github.com/home')
    @list.add_item(@diff_item)
    @list.items.size.should == 1
    @list.find_item('github').value.should == 'https://github.com/home'
  end

  it "to hash" do
    @list.to_hash[@list.name].size.should == 0
    @list.add_item(@item)
    @list.to_hash[@list.name].size.should == 1
  end

  it "find" do
    Boom::List.find('urls').name.should == 'urls'
  end

  it "find item" do
    @list.add_item(@item)
    @list.find_item('github').value.should == 'https://github.com'
  end

  it "find item long name" do
    @item = Boom::Item.new('long-long-long-name','longname')
    @list.add_item(@item)
    @list.find_item('long-long-long-').value.should == 'longname'
    @list.find_item('long-long-long-…').value.should == 'longname'
  end

  it "delete success" do
    Boom.storage.lists.size.should == 1
    Boom::List.delete('urls').should.not == nil
    Boom.storage.lists.size.should == 0
  end

  it "delete fail" do
    Boom.storage.lists.size.should == 1
    Boom::List.delete('robocop').should.not == true
    Boom.storage.lists.size.should == 1
  end

  it "deletes scoped to list" do
    @list.add_item(@item)

    @list_2 = Boom::List.new('sexy-companies')
    @item_2 = Boom::Item.new(@item.name, @item.value)
    @list_2.add_item(@item_2)

    @list.delete_item(@item.name)
    @list.items.size.should == 0
    @list_2.items.size.should == 1
  end

end
