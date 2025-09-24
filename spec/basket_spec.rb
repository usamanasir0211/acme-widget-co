# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "acme/catalog"
require "acme/delivery_rules"
require "acme/offers/buy_one_get_second_half"
require "acme/basket"

RSpec.describe Acme::Basket do
  let(:catalog) do
    Acme::Catalog.new([
      { code: "R01", name: "Red Widget",   price_cents: 3295 },
      { code: "G01", name: "Green Widget", price_cents: 2495 },
      { code: "B01", name: "Blue Widget",  price_cents:  795 }
    ])
  end

  let(:delivery) do
    Acme::DeliveryRules.new([
      { upto_cents: 5000, fee_cents: 495 },
      { upto_cents: 9000, fee_cents: 295 },
      { upto_cents: Float::INFINITY, fee_cents: 0 }
    ])
  end

  let(:offers) { [Acme::Offers::BuyOneGetSecondHalf.new("R01")] }

  subject(:basket) { described_class.new(catalog: catalog, delivery_rules: delivery, offers: offers) }

  it "B01, G01 => $37.85" do
    basket.add("B01").add("G01")
    expect(basket.total_formatted).to eq("$37.85")
  end

  it "R01, R01 => $54.37" do
    basket.add("R01").add("R01")
    expect(basket.total_formatted).to eq("$54.37")
  end

  it "R01, G01 => $60.85" do
    basket.add("R01").add("G01")
    expect(basket.total_formatted).to eq("$60.85")
  end

  it "B01, B01, R01, R01, R01 => $98.27" do
    basket.add("B01").add("B01").add("R01").add("R01").add("R01")
    expect(basket.total_formatted).to eq("$98.27")
  end
end
