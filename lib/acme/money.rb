module Acme
  module Money
    module_function
    def format(cents)
      sign = cents < 0 ? "-" : ""
      abs = cents.abs
      dollars = abs / 100
      remainder = abs % 100
      format_str = "%s$%d.%02d"
      Kernel.format(format_str, sign, dollars, remainder)  
    end

    def rounded_div(value, denominator)
      (value + denominator / 2) / denominator
    end
  end
end
