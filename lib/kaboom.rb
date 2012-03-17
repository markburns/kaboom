# coding: utf-8

begin
  require 'rubygems'
rescue LoadError
end

require 'fileutils'
require 'multi_json'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'kaboom/output'
require 'kaboom/color'
require 'kaboom/platform'
require 'kaboom/command'
require 'kaboom/config'
require 'kaboom/item'
require 'kaboom/list'

require 'kaboom/storage'
require 'kaboom/storage/base'
require 'kaboom/storage/json'
require 'kaboom/storage/redis'
require 'kaboom/storage/mongodb'
require 'kaboom/storage/keychain'
require 'kaboom/storage/gist'

require 'kaboom/core_ext/symbol'
require 'kaboom/remote'

module Boom
  VERSION = '0.3.2'

  extend self

  def storage
    @storage ||= Boom::Storage.backend
  end

  # Public: tell Boom to use the storage specified in
  # ~/.boom.remote.conf
  # Returns a Config instance.
  def use_remote remote=true
    @config = Boom::Config.new remote
  end

  def config
    @config ||= Boom::Config.new
  end

  def remote?
    config.remote
  end

  def local?
    !remote?
  end
end
