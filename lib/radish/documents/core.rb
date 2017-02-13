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
        combine_documents(doc, build_from_path(doc, path, val))
      end

      private

      # maybe public?
      def combine_documents(*docs)
        docs.inject({}, &method(:merge_document))
      end

      # maybe public?
      # TODO: complicated, test and simplify
      def merge_document(dest, src)
        src.keys.inject(dest) do |final, k|
          if src[k].class == Hash
            existing = final.fetch(k, {})
            existing = {} if existing.class != Hash
            final.merge(k => merge_document(existing, src[k]))
          elsif src[k].class == Array && dest[k].class == Array
            merged_a = src[k].each_with_index.map do |srco, i|
              dsto = dest[k][i]
              if (srco.class == Array || srco.class == Hash) && (dsto.class == Array || dsto.class == Hash)
                merge_document(dsto, srco)
              else
                srco ? srco : dsto
              end
            end

            final.merge(k => merged_a)
          else
            final.merge(k => src[k])
          end
        end
      end

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

      def build_from_path(ev, path, val)
        if path.length > 1
          nv = build_from_path(ev ? ev.fetch(path.first, nil) : nil, path[1..-1], val)
          { path.first => nv }
        else
          make_new_value_for_set(ev, path.first, val)
        end
      end

      def make_new_value_for_set(ev, k, v)
        if (k.class == Fixnum || /^[0-9]+$/.match(k)) && (!ev || ev.class == Array)
          ki = k.to_i
          rv = Array.new(ev && ev.class == Array ? ev.length : ki + 1)
          rv[ki] = v
          rv
        else
          { k => v }
        end
      end
    end
  end
end
