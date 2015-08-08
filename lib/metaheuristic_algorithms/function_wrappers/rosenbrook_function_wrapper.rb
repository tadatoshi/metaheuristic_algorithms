module MetaheuristicAlgorithms

  module FunctionWrappers
    
    class RosenbrookFunctionWrapper < AbstractWrapper

      def maximum_decision_variable_values
        [BigDecimal('5'), BigDecimal('5')]
      end

      def miminum_decision_variable_values
        [BigDecimal('-5'), BigDecimal('-5')]
      end

      def objective_function_value(decision_variable_values)
        (BigDecimal('1') - decision_variable_values[0]).power(2) + BigDecimal('100') * (decision_variable_values[1] - decision_variable_values[0].power(2)).power(2)
      end

      def initial_decision_variable_value_estimates
        raise "#{__method__} method must be implemented in the subclass"
      end

    end

  end

end