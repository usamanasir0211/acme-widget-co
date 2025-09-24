require_relative "money"

module Acme
  class Basket
    def initialize(catalog:, delivery_rules:, offers: [])
      @catalog = catalog
      @delivery_rules = delivery_rules
      @offers = offers
      @items = Hash.new { |h, k| h[k] = { product: nil, qty: 0 } }
    end

    def add(code)
      product = @catalog.fetch(code)
      slot = @items[product.code]
      slot[:product] ||= product
      slot[:qty] += 1
      self
    end

    def total
      subtotal = @items.values.sum { |e| e[:product].price_cents * e[:qty] }
      discounts = @offers.sum { |offer| offer.discount_cents(@items) }
      discounted = subtotal - discounts
      shipping = @delivery_rules.fee_for(discounted)
      discounted + shipping
    end

    def total_formatted
      Acme::Money.format(total)
    end
  end
end
