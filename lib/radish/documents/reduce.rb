module Radish
  module Documents
    module Reduce
      def omit(doc, paths=[], path=[])
        only_hash(doc) do
          doc.inject({}) do |ndoc, (k, v)|
            nk = (path + [k]).join('.')
            included = paths.include?(nk)
            if v.class == Hash && !included
              ndoc.merge(k => omit(doc[k], paths, path + [k]))
            else
              included ? ndoc : ndoc.merge(k => v)
            end
          end
        end
      end
      
      def flatten_broadly(doc, path=[])
        only_hash(doc) do
          doc.inject({}) do |ndoc, (k, v)|
            if v.class == Hash
              ndoc.merge(flatten_broadly(v, path + [k]))
            else
              nk = (path + [k]).join('.')
              ndoc.merge(nk => v)
            end
          end
        end
      end

      private

      def only_hash(doc)
        if doc && doc.class == Hash
          yield
        else
          doc
        end
      end
    end
  end
end
