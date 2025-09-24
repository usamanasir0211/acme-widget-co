# Acme Widget Co — (Ruby)

## This project is a tiny, extensible checkout engine for e-commerce. It uses a clean separation of concerns and dependency injection to cleanly model and manage products, special offers, and delivery rules. It's designed for developers who need a flexible, lightweight, and customizable checkout system.

---

## How it works

### Design
- **Catalog**: immutable product list (`code`, `name`, `price_cents`).
- **Basket**: accepts dependencies (catalog, delivery rules, offers). It exposes `add(code)` and `total`.
- **Offers (Strategy Pattern)**: each offer responds to `discount_cents(items)` and returns the **discount** (in cents) it applies.
  - Initial offer implemented: **Buy one R01, get the second half price**.
- **Delivery Rules**: a banded calculator that maps **subtotal after discounts** to a shipping fee.

All money is handled in **integer cents** to avoid floating-point errors. Where half cents occur (e.g. 50% of $32.95), we round **half up** to the nearest cent (e.g. $16.475 → $16.48).

### Assumptions
- Currency is USD. No tax/VAT.

- Delivery fee depends on the **discounted subtotal**.

- Offers are additive and applied on top of each other (if more were added later). Order doesn't matter as they compute **discounts**, not mutated prices.

- Unknown product codes raise an error.


### Example
Given products:
- R01 (Red) — $32.95
- G01 (Green) — $24.95
- B01 (Blue) — $7.95

Delivery rules:
- subtotal **under $50** → **$4.95**
- subtotal **under $90** → **$2.95**
- subtotal **$90 or more** → **free**

Offer:
- **Buy one R01, get the second half price**

### Expected totals
| Items                             | Expected |
|----------------------------------|---------:|
| B01, G01                         | $37.85   |
| R01, R01                         | $54.37   |
| R01, G01                         | $60.85   |
| B01, B01, R01, R01, R01          | $98.27   |

---

## Run it

```bash
# Ruby 3.x is fine
bundle install
bin/checkout B01 G01
bin/checkout R01 R01
bin/checkout R01 G01
bin/checkout B01 B01 R01 R01 R01
```

Or run tests:

```bash
bundle exec rspec
```

---

## Project structure

```
.
├── Gemfile
├── bin/
│   └── checkout         
├── lib/
│   └── acme/
│       ├── basket.rb
│       ├── catalog.rb
│       ├── delivery_rules.rb
│       ├── money.rb
│       └── offers/
│           └── buy_one_get_second_half.rb
└── spec/
    ├── basket_spec.rb
    └── spec_helper.rb
```

---

## Notes on extensibility

- Add new promotion types by creating more classes in `lib/acme/offers/` that implement `discount_cents(items)`.
- Swap delivery logic by passing a different object that responds to `fee_for(subtotal_cents)`.
- `Basket` has a **tiny interface** and uses **dependency injection** to keep it testable and open for extension.

---
