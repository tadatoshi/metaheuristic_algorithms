require 'bigdecimal'

module MetaheuristicAlgorithms

  module CalculationHelper

    def degree_to_radian(degree)
      # degree * BigDecimal(Math::PI.to_s) / BigDecimal('180')
      degree * Math::PI / 180
    end

    def radian_to_degree(radian)
      # radian * BigDecimal('180') / BigDecimal(Math::PI.to_s)
      radian * 180 / Math::PI
    end

    def bigdecimal_exp(bigdecimal_value)
      BigDecimal(Math.exp(bigdecimal_value.to_f).to_s)
    end

    def bigdecimal_cos(angle_in_radian)
      BigDecimal(Math.cos(angle_in_radian.to_f).to_s)
    end 

    def bigdecimal_sin(angle_in_radian)
      BigDecimal(Math.sin(angle_in_radian.to_f).to_s)
    end

    def bigdecimal_tan(angle_in_radian)
      BigDecimal(Math.tan(angle_in_radian.to_f).to_s)
    end
    
    def bigdecimal_asin(sin_value)
      BigDecimal(Math.asin(sin_value.to_f).to_s)
    end

    def bigdecimal_acos(cos_value)
      BigDecimal(Math.acos(cos_value.to_f).to_s)
    end

    def bigdecimal_atan2(y, x)
      BigDecimal(Math.atan2(y.to_f, x.to_f).to_s)
    end

    def bigdecimal_sqrt(bigdecimal_value)
      BigDecimal(Math.sqrt(bigdecimal_value.to_f).to_s)
    end

  end

end