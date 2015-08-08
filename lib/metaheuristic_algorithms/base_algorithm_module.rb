module MetaheuristicAlgorithms

  module BaseAlgorithmModule

    def get_decision_variable_value_by_randomization(decision_variable_index)
      @function_wrapper.miminum_decision_variable_values[decision_variable_index] 
      + (@function_wrapper.maximum_decision_variable_values[decision_variable_index] - @function_wrapper.miminum_decision_variable_values[decision_variable_index]) * bigdecimal_rand
    end

  end

end