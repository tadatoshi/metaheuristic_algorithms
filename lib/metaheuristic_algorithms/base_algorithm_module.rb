module MetaheuristicAlgorithms

  module BaseAlgorithmModule

    def get_decision_variable_value_by_randomization(decision_variable_index)
      # @function_wrapper.minimum_decision_variable_values[decision_variable_index] 
      # + (@function_wrapper.maximum_decision_variable_values[decision_variable_index] - @function_wrapper.minimum_decision_variable_values[decision_variable_index]) * bigdecimal_rand
      @function_wrapper.minimum_decision_variable_values[decision_variable_index].to_f 
      + (@function_wrapper.maximum_decision_variable_values[decision_variable_index].to_f - @function_wrapper.minimum_decision_variable_values[decision_variable_index].to_f) * rand
    end

    # Based on the code by antonakos on http://stackoverflow.com/questions/5825680/code-to-generate-gaussian-normally-distributed-random-numbers-in-ruby
    # His code is under CC0 1.0 Universal (CC0 1.0)
    def gaussian(mean, stddev)
      theta = 2 * Math::PI * Kernel.rand
      rho = Math.sqrt(-2 * Math.log(1 - Kernel.rand))
      scale = stddev * rho
      x = mean + scale * Math.cos(theta)
      # y = mean + scale * Math.sin(theta)
      return x
    end  

  end

end