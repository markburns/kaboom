# coding: utf-8

begin
  require 'rubygems'
rescue LoadError
end

require 'fileutils'
require 'multi_json'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'boom/output'
require 'boom/color'
require 'boom/platform'
require 'boom/command'
require 'boom/config'
require 'boom/item'
require 'boom/list'

require 'boom/storage'
require 'boom/storage/base'
require 'boom/storage/json'
require 'boom/storage/redis'
require 'boom/storage/mongodb'
require 'boom/storage/keychain'
require 'boom/storage/gist'

require 'boom/core_ext/symbol'
require 'boom/remote'

module Boom
  VERSION = '0.2.3'

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
