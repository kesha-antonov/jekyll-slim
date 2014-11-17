module Jekyll
  class Layout

    def initialize_with_transform(*args)
      initialize_without_transform(*args)
      self.content = transform
    end

    alias_method :initialize_without_transform, :initialize
    alias_method :initialize, :initialize_with_transform

  end

end
