module MetaheuristicAlgorithms

  module FunctionWrappers
    
    class RosenbrookFunctionWrapper < AbstractWrapper

      def maximum_decision_variable_values
        # [BigDecimal('5'), BigDecimal('5')]
        [5, 5]
      end

      def minimum_decision_variable_values
        # [BigDecimal('-5'), BigDecimal('-5')]
        [-5, -5]
      end

      def objective_function_value(decision_variable_values)
        # (BigDecimal('1') - decision_variable_values[0]).power(2) + BigDecimal('100') * (decision_variable_values[1] - decision_variable_values[0].power(2)).power(2)
        (1 - decision_variable_values[0])**2 + 100 * (decision_variable_values[1] - decision_variable_values[0]**2)**2
      end

      def initial_decision_variable_value_estimates
        # [BigDecimal('2'), BigDecimal('2')]
        [2, 2]
      end

    end

  end

end