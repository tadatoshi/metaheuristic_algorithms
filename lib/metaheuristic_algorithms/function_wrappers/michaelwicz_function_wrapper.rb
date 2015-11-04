# require 'bigdecimal/math'

module MetaheuristicAlgorithms

  module FunctionWrappers
    
    class MichaelwiczFunctionWrapper < AbstractWrapper
      include MetaheuristicAlgorithms::CalculationHelper

      def maximum_decision_variable_values
        # [BigDecimal('4'), BigDecimal('4')]
        [4, 4]
      end

      def miminum_decision_variable_values
        # [BigDecimal('0'), BigDecimal('0')]
        [0, 0]
      end

      def objective_function_value(decision_variable_values)
        # -bigdecimal_sin(decision_variable_values[0]) * bigdecimal_sin(decision_variable_values[0].power(2) / BigMath.PI(10)).power(20) - 
        # bigdecimal_sin(decision_variable_values[1]) * bigdecimal_sin(decision_variable_values[1].power(2) / BigMath.PI(10)).power(20)
        -Math.sin(decision_variable_values[0]) * (Math.sin(decision_variable_values[0]**2 / Math::PI))**20 - 
        Math.sin(decision_variable_values[1]) * (Math.sin(decision_variable_values[1]**2 / Math::PI))**20
      end

      def initial_decision_variable_value_estimates
        raise "#{__method__} method has no definition"
      end

    end

  end

end