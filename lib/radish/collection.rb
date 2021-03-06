module Radish
  module Collection
    def each(c, &bl)
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

    def map(c, &bl)
      if c.class == Array
        bl ? c.each_with_index.map { |v, i| bl.call(v, i, c) } : c
      elsif c.class == Hash
        bl ? c.map { |k, v| bl.call(v, k, c) } : c.values
      else
        []
      end
    end

    def filter(c, &bl)
      if c.class == Array
        bl ? c.each_with_index.select { |v, i| bl.call(v, i, c) }.map { |pair| pair.first } : c
      elsif c.class == Hash
        bl ? c.select { |k, v| bl.call(v, k, c) } : c.values
      else
        []
      end
    end
  end
end
