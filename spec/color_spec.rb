require File.expand_path('spec/spec_helper')

describe Boom::Color do
  it "colorize" do
    assert_equal "\e[35mBoom!\e[0m",
      Boom::Color.colorize("Boom!", :magenta)
  end

  it "magenta" do
    assert_equal "\e[35mMagenta!\e[0m",
      Boom::Color.magenta("Magenta!")
  end

  it "red" do
    assert_equal "\e[31mRed!\e[0m",
      Boom::Color.red("Red!")
  end

  it "yellow" do
    assert_equal "\e[33mYellow!\e[0m",
      Boom::Color.yellow("Yellow!")
  end

  it "cyan" do
    assert_equal "\e[36mCyan!\e[0m",
      Boom::Color.cyan("Cyan!")
  end

end
