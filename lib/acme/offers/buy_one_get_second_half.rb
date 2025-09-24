require_relative "../money"

module Acme
  module Offers
    class BuyOneGetSecondHalf
      def initialize(target_code)
        @target_code = target_code
      end
      def discount_cents(items)
        entry = items[@target_code]
        return 0 unless entry && entry[:product] 

        qty = entry[:qty].to_i
        pairs = qty / 2
        unit = entry[:product].price_cents
        half = Acme::Money.rounded_div(unit, 2)
        pairs * half
      end
    end
  end
end
