# require 'bigdecimal/math'

module MetaheuristicAlgorithms

  module FunctionWrappers
    
    class EasomFunctionWrapper < AbstractWrapper
      include MetaheuristicAlgorithms::CalculationHelper

      def maximum_decision_variable_values
        # [BigDecimal('10')]
        [10]
      end

      def miminum_decision_variable_values
        # [BigDecimal('-10')]
        [-10]
      end

      def objective_function_value(decision_variable_values)
        # -bigdecimal_cos(decision_variable_values[0]) * BigMath.exp((-(decision_variable_values[0] - BigMath.PI(10)).power(2)), 10)
        -Math.cos(decision_variable_values[0]) * Math.exp(-(decision_variable_values[0] - Math::PI)**2)
      end

      def initial_decision_variable_value_estimates
        raise "#{__method__} method must be implemented in the subclass"
      end

    end

  end

end