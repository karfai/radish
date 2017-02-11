module Radish
  class Collection
    def self.each(c, &bl)
      if c.class == Array
        c.each_with_index do |v, i|
          bl.call(v, i, c)
        end if bl
      elsif c.class == Hash
        c.each do |k, v|
          bl.call(v, k, c)
        end if bl
      end

      c
    end

    def self.map(c, &bl)
      if c.class == Array
        bl ? c.each_with_index.map { |v, i| bl.call(v, i, c) } : c
      elsif c.class == Hash
        bl ? c.map { |k, v| bl.call(v, k, c) } : c.values
      else
        []
      end
    end
  end
end
