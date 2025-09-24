module Acme
  Product = Struct.new(:code, :name, :price_cents, keyword_init: true)

  class Catalog
    def initialize(products)
      @by_code = {}
      products.each do |attrs|
        p = attrs.is_a?(Product) ? attrs : Product.new(**attrs)
        @by_code[p.code] = p
      end
      freeze
    end

    def fetch(code)
      @by_code.fetch(code) { raise KeyError, "Unknown product code: #{code}" }
    end
  end
end
