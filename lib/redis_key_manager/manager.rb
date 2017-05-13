module RedisKeyManager::Manager

  def self.included(base)

    # Set up `.key` class method on the including class/module, enabling us to do one-liner declarations of
    # named key patterns at the top of that class/module.
    def base.key(key, pattern)
      class_name = self.name
      placeholders = pattern.scan(/(?<=\[)[^\]]+(?=\])/).uniq.map(&:to_sym)

      # Set up a singleton method on the including class/module, with which the key can be retrieved.
      define_singleton_method(key) do |options = {}|
        passed_option_keys = options.keys
        required_option_keys = placeholders
        if passed_option_keys.sort != required_option_keys.sort
          raise ArgumentError, "Invalid arguments for #{class_name}.#{key}"
        end

        placeholders.inject(pattern) do |revised_pattern, placeholder|
          value = options[placeholder]
          if value.nil?
            raise RedisKeyManager::InvalidKeyComponentError, "Invalid Redis key component passed to #{class_name}.#{key}"
          end
          revised_pattern.gsub("[#{placeholder}]", value.to_s)
        end
      end
    end
  end
end
