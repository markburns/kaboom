# coding: utf-8

# Command is the main point of entry for boom commands; shell arguments are
# passd through to Command, which then filters and parses through indivdual
# commands and reroutes them to constituent object classes.
#
# Command also keeps track of one connection to Storage, which is how new data
# changes are persisted to disk. It takes care of any data changes by calling
# Boom::Command#save.
#
module Boom
  class Command
    class << self
      include Boom::Color
      include Boom::Output

      # Public: accesses the in-memory JSON representation.
      #
      # Returns a Storage instance.
      def storage
        Boom.storage
      end

      # Public: executes a command.
      #
      # args    - The actual commands to operate on. Can be as few as zero
      #           arguments or as many as three.
      # Returns output based on method calls.
      def execute(*args)
        arguments = parse args
        command = arguments.command

        return help if(command and [45, "-"].include?(command[0]))

        mapping = { "-v"        => "version",
                    "--version" => "version",
                    "version"   => "version",
                    "echo"      => "echo",
                    "open"      => "open" ,
                    "w"         => "echo",
                    "o"         => "open",
                    "rand"      => "random",
                    "r"         => "random",
                    "all"       => "all",
                    "edit"      => "edit",
                    "storage"   => "storage",
                    "help"      => "help",
                    "switch"    => "switch"}

        mapped = mapping[command]

        return self.send(mapped, arguments) if mapped

        return overview unless command

        major, minor = arguments.major, arguments.minor

        if(minor == 'delete') and storage.item_exists?(major)
          return delete_item(command, major)
        end


        if list = List.find(command)
          return handle_list list, major, minor
        end

        if item = Item.find(command)
          return say_clipboard item
        end

        create_list command, major, minor
      end

      Arguments = Struct.new :command, :major, :minor

      def parse args
        command = args.shift

        if command == "remote"
          Boom.use_remote
          command = args.shift
        end

        major   = args.shift
        minor   = args.empty? ? nil : args.join(' ')

        minor ||= stdin.read if pipable_input?

        Arguments.new command, major, minor
      end

      private :parse

      def say_clipboard
        output "#{cyan("Boom!")} We just copied #{yellow(Platform.copy item)} to your clipboard."
      end

      def say_set list, key, value
        output "#{c("Boom!")} #{y(key)} in #{y(list)} is #{y(value)}. Got it."
      end

      def handle_list list, major, minor
        return list.delete if major == 'delete'
        return list.detail unless major
        return list.find_item major unless minor

        list.add(Item.new(major,minor))
        say_set list.name, major, minor
        save
      end

      def stdin
        $stdin
      end

      def pipable_input?
        stdin.stat.size > 0
      end

      def overview
        storage.lists.each do |list|
          output "  #{list.name} (#{list.items.size})"
        end
        s = <<-eof
          You don't have anything yet! To start out, create a new list:"
          $ boom <list-name>"
          And then add something to your list!"
          $ boom <list-name> <item-name> <item-value>"
          You can then grab your new item:"
          $ boom <item-name>"
        eof
        output s.gsub(/ {10}/,"") if storage.lists.size == 0
      end

      # Public: prints the detailed view of all your Lists and all their
      # Items.
      #
      # Returns nothing.
      def all
        storage.lists.each do |list|
          output "  #{list.name}"
          list.items.each do |item|
            output "    #{item.short_name}:#{item.spacer} #{item.value}"
          end
        end
      end

      def show_storage
        output "You're currently using #{Boom.config['backend']}."
      end

      def switch(backend)
        Storage.backend = backend
        output "We've switched you over to #{backend}."
      rescue NameError
        output "We couldn't find that storage engine. Check the name and try again."
      end

      def open arguments
        key, value = arguments.major, arguments.minor

        if storage.list_exists?(key)
          list = List.find(key)
          if value
            item = storage.items.detect { |item| item.name == value }
          else
            list.items.each { |item| Platform.open(item) }
            return output "#{cyan("Boom!")} We just opened all of #{yellow(key)} for you."
          end
        else
          item = storage.items.detect { |item| item.name == key }
        end

        return not_found key, value unless item
        output "#{cyan("Boom!")} We just opened #{y(Platform.open(item))} for you."
      end

      def not_found major, minor=nil
        return output "#{yellow(major)} #{red("not found")}" if minor.nil?
        return output "#{yellow(minor)} #{red("not found in")} #{yellow(major)}"
      end

      def random arguments
        major = arguments.major
        if major.nil?
          index = rand(storage.items.size)
          item = storage.items[index]
        elsif storage.list_exists?(major)
          list = List.find(major)
          index = rand(list.items.size)
          item = list.items[index]
        else
          output "We couldn't find that list."
        end
        open(Argument.new item.name) unless item.nil?
      end

      def echo arguments
        major, minor = arguments.major, arguments.minor
        if minor
          list = List.find major
          item = list.find_item minor
        else
          item = storage.items.detect { |i| i.name == major }
        end
        return not_found major, minor unless item
        output item.value
      end

      # Public: add a new List.
      #
      # name  - the String name of the List.
      # item  - the String name of the Item
      # value - the String value of Item
      #
      # Example
      #
      #   Commands.list_create("snippets")
      #   Commands.list_create("hotness", "item", "value")
      #
      # Returns the newly created List and creates an item when asked.
      def create_list(name, item = nil, value = nil)
        lists = (storage.lists << List.new(name))
        storage.lists = lists
        output "#{cyan("Boom!")} Created a new list called #{yellow(name)}."
        save
        add_item(name, item, value) unless value.nil?
      end

      # Public: remove a named List.
      #
      # name - the String name of the List.
      #
      # Example
      #
      #   Commands.delete_list("snippets")
      #
      # Returns nothing.
      def delete_list(name)
        output "You sure you want to delete everything in #{yellow(name)}? (y/n):"
        if $stdin.gets.chomp == 'y'
          List.delete(name)
          output "#{cyan("Boom!")} Deleted all your #{yellow(name)}."
          save
        else
          output "Just kidding then."
        end
      end

      # Public: add a new Item to a list.
      #
      # list  - the String name of the List to associate with this Item
      # name  - the String name of the Item
      # value - the String value of the Item
      #
      # Example
      #
      #   Commands.add_item("snippets","sig","- @holman")
      #
      # Returns the newly created Item.
      def add_item(list,name,value)
        list = List.find(list)
        list.add(Item.new(name,value))
        say_set list.name, name, value
     end

      # Public: remove a named Item.
      #
      # list_name - the String name of the List.
      # name      - the String name of the Item.
      #
      # Example
      #
      #   Commands.delete_item("a-list-name", "an-item-name")
      #
      # Returns nothing.
      def delete_item(list_name,name)
        if storage.list_exists?(list_name)
          list = List.find(list_name)
          if list.delete_item(name)
            output "#{cyan("Boom!")} #{yellow(name)} is gone forever."
            save
          else
            output "#{yellow(name)} #{red("not found in")} #{yellow(list_name)}"
          end
        else
          output "We couldn't find that list."
        end
      end


      # Public: search for an Item in a particular list by name. Drops the
      # corresponding entry into your clipboard if found.
      #
      # list_name - the String name of the List in which to scope the search
      # item_name - the String term to search for in all Item names
      #
      # Returns the matching Item if found.
      def search_list_for_item(list_name, item_name)
        list = List.find(list_name)
        item = list.find_item(item_name)

        if item
          output "#{cyan("Boom!")} We just copied #{yellow(Platform.copy(item))} to your clipboard."
        else
          output "#{yellow(item_name)} #{red("not found in")} #{yellow(list_name)}"
        end
      end

      delegate :save, :to => :storage

      # Public: the version of boom that you're currently running.
      #
      # Returns a String identifying the version number.
      def version
        output "You're running boom #{Boom::VERSION}. Congratulations!"
      end

      # Public: launches JSON file in an editor for you to edit manually.
      #
      # Returns nothing.
      def edit
        require 'ruby-debug'; debugger
        if storage.respond_to?("json_file")
          output "#{cyan("Boom!")} #{Platform.edit(storage.json_file)}"
        else
          output "This storage backend #{red storage.class} does not store #{cyan("Boom!")} data on your computer"
        end
      end

      def y t
        yellow t
      end

      def c t
        cyan t
      end

      def r t
        red t
      end

      # Public: prints all the commands of boom.
      #
      # Returns nothing.
      def help(arguments=nil)
        #this currently looks horrible in code, but nice in output.
        #would be good to make it both

        text = %{
          #{r "BOOM snippets"} ___________________________________________________

          boom                                 display high-level overview
          boom #{y "all"}                             show all items in all lists
          boom #{y "edit"}                            edit the boom JSON file in $EDITOR
          boom #{y "help"}                            this help text
          boom #{y "storage"}                         shows which storage backend you're using
          boom #{y "switch"} #{c "<storage>"}                switches to a different storage backend

          boom #{c "<list>"}                          create a new list
          boom #{c "<list>"}                          show items for a list
          boom #{c "<list>"} #{y "delete"}                   deletes a list

          boom #{c "<list> <name> <value>"}           create a new list item
          boom #{c "<name>"}                          copy item's value to clipboard
          boom #{c "<list> <name>"}                   copy item's value to clipboard
          boom #{y "open"} #{c "<name>"}                     open item's url in browser
          boom #{y "open"} #{c "<list> <name>"}              open all item's url in browser for a list
          boom #{y "random"}                          open a random item's url in browser
          boom #{y "random"} #{c "<list>"}                   open a random item's url for a list in browser
          boom #{y "echo"} #{c "<name>"}                     echo the item's value without copying
          boom #{y "echo"} #{c "<list> <name>"}              echo the item's value without copying
          boom #{c "<list> <name>"} #{y "delete"}            deletes an item

          #{red "KABOOM sharing"} ___________________________________________________

          boom remote #{y "<any command above>"}      using the #{y "~/.boom.remote.conf"} it
          kaboom      #{y "<any command above>"}      connects to an alternative backend
                                               meaning you can pipe to a remote
                                               backend storage

          e.g. to pipe config from a local boom to a remote boom do:

          kaboom #{c("config ackrc")} < boom #{c "config ackrc"}

          ___________________________________________________________________
          all other documentation is located at:
            https://github.com/markburns/kaboom
        }.gsub(/^ {8}/, '') # strip the first eight spaces of every line

          output text
      end

    end
  end
end
