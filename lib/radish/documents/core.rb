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

      def set(doc, path, val)
        build_from_path(doc, maybe_parse_path(path), val)
      end

      private

      def maybe_parse_path(path)
        if path.class == Array
          path
        elsif path.class == String
          path.split(/\./).inject([]) do |a, v|
            m = /([^\[]*)\[([0-9]+)\]/.match(v)
            if m
              i = m[2].to_i
              a.concat(m[1].empty? ? [i] : [m[1], i])
            else
              a.concat([v])
            end
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

      def build_from_path(pev, path, val)
        if path.length > 1
          k = path.first
          ev = pev ? pev.fetch(k, nil) : nil
          nv = build_from_path(ev, path[1..-1], val)

          # TODO: factor/consolidate given :merge_values and :make_new_value_for_set
          if k.class == Fixnum || /^[0-9]+$/.match(k)
            rv = []
            rv[k.to_i] = nv
            rv
          else
            { k => merge_values(ev, nv) }
          end
        else
          make_new_value_for_set(pev, path.first, val)
        end
      end

      # TODO: public? in another place?
      def array_to_hash(a)
        a.each_with_index.inject({}) do |o, vi|
          o.merge(vi.last => vi.first)
        end
      end

      def merge_values(ev, nv)
        if ev.class == Hash && nv.class == Hash
          ev.merge(nv)
        elsif ev.class == Hash && nv.class == Array
          ev.merge(array_to_hash(nv))
        elsif ev.class == Array && nv.class == Array
          ev.zip(nv).map do |both|
            both.last ? both.last : both.first
          end
        else
          nv
        end
      end

      def make_new_value_for_set(ev, k, v)
        if (k.class == Fixnum || /^[0-9]+$/.match(k)) && (!ev || ev.class == Array)
          ki = k.to_i
          rv = ev ? ev.dup : []
          rv[ki] = v
          rv
        else
          { k => v }
        end
      end
    end
  end
end
