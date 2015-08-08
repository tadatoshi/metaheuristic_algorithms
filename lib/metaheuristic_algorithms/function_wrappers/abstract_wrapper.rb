module MetaheuristicAlgorithms

  module FunctionWrappers
    
    class AbstractWrapper

      # Return value: Array
      def maximum_decision_variable_values
        raise "#{__method__} method must be implemented in the subclass"
      end

      # Return value: Array
      def miminum_decision_variable_values
        raise "#{__method__} method must be implemented in the subclass"
      end    

      # Input value: Array
      def objective_function_value(decision_variable_values)
        raise "#{__method__} method must be implemented in the subclass"
      end

      # For the algorithm that requires initial estimate that is depending on the particular objective function:
      # Return value: Array
      def initial_decision_variable_value_estimates
        raise "#{__method__} method must be implemented in the subclass"
      end

    end

  end

end