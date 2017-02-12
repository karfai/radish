module Radish
  module Documents
    module Core
      def has(doc, path)
        rp = maybe_parse_path(path)
        h = has_check(doc, rp.first)
        h && rp.length > 1 ? has(doc.fetch(rp.first), rp[1..-1]) : h
      end

      def get(doc, path, dv=nil)
        rp = maybe_parse_path(path)
        rv = dv

        if (has_check(doc, rp.first))
          v = doc.fetch(rp.first)
          rv = rp.length == 1 ? v : get(v, rp[1..-1], dv)
        end

        rv
      end

      private

      def maybe_parse_path(path)
        if path.class == Array
          path
        elsif path.class == String
          path.split(/\./).inject([]) do |a, v|
            m = /(.+)\[([0-9]+)\]/.match(v)
            a.concat(m ? [m[1], m[2].to_i] : [v])
          end
        else
          []
        end
      end

      def has_check(doc, k)
        rv = false

        if doc.class == Array
          rv = k.to_i < doc.length
        elsif doc.class == Hash
          rv = doc.key?(k)
        end

        rv
      end
    end
  end
end
