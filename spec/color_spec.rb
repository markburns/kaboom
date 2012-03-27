require File.expand_path('spec/spec_helper')

describe Boom::Color do
  it "colorize" do
    Boom::Color.colorize("Boom!", :magenta).should =="\e[35mBoom!\e[0m"
  end

  it "magenta" do
    Boom::Color.magenta("Magenta!").should == "\e[35mMagenta!\e[0m"
  end

  it "red" do
    Boom::Color.red("Red!").should == "\e[31mRed!\e[0m"
  end

  it "yellow" do
    Boom::Color.yellow("Yellow!").should == "\e[33mYellow!\e[0m"
  end

  it "cyan" do

    Boom::Color.cyan("Cyan!").should == "\e[36mCyan!\e[0m"
  end

end
