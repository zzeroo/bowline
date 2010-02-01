module Bowline
  class AppConfig
    attr_reader :keys, :path
    def initialize(path)
      @path = path
      @keys = {}
      load!
    end
    
    def load!
      return unless File.exist?(path)
      @keys = YAML::load(File.read(path))
    end
    
    def dump!
      File.open(path, "w+") {|f| f.write(YAML::dump(keys)) }
    end
    
    def delete(key)
      @keys.delete(key)
      dump!
    end
    
    def method_missing(sym, *args)
      method_name = sym.to_s
      
      if method_name =~ /(=|\?)$/
        case $1
        when "="
          keys[$`] = args.first
          dump!
        when "?"
          keys[$`]
        end
      else
        return keys[method_name] if keys.include?(method_name)
        super
      end
    end
  end
end