module Acme
  class DeliveryRules
    Band = Struct.new(:upto_cents, :fee_cents, keyword_init: true)

    def initialize(bands)
      @bands = bands.map { |b| b.is_a?(Band) ? b : Band.new(**b) }
    end

    def fee_for(subtotal_cents)
      band = @bands.find { |b| subtotal_cents < b.upto_cents }
      band ? band.fee_cents : 0
    end
  end
end
