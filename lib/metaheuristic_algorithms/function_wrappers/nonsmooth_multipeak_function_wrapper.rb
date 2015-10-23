# require 'bigdecimal/math'

module MetaheuristicAlgorithms

  module FunctionWrappers
    
    class NonsmoothMultipeakFunctionWrapper < AbstractWrapper

      def maximum_decision_variable_values
        # [BigDecimal('5'), BigDecimal('5')]
        [5, 5]
      end

      def miminum_decision_variable_values
        # [BigDecimal('-5'), BigDecimal('-5')]
        [-5, -5]
      end

      def objective_function_value(decision_variable_values)
        # (decision_variable_values[0].abs + decision_variable_values[1].abs) * BigMath.exp((BigDecimal('-0.0625') * (decision_variable_values[0].power(2) + decision_variable_values[1].power(2))), 10) 
        (decision_variable_values[0].abs + decision_variable_values[1].abs) * Math.exp(-0.0625 * (decision_variable_values[0]**2 + decision_variable_values[1]**2))    
      end

      def initial_decision_variable_value_estimates
        raise "#{__method__} method must be implemented in the subclass"
      end

    end

  end

end