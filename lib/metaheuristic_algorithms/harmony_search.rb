module MetaheuristicAlgorithms

  class HarmonySearch
    include MetaheuristicAlgorithms::BaseAlgorithmModule
    include MetaheuristicAlgorithms::Helper

    # objective: :maximization or :minimization
    def initialize(function_wrapper, number_of_variables: 1, objective: :maximization)
      @function_wrapper = function_wrapper
      @number_of_variables = number_of_variables
      @objective_method_name = case objective
                                 when :maximization
                                   :max
                                 when :minimization
                                   :min
                               end
      @objective_comparison_operator = case objective
                               when :maximization
                                 :>
                               when :minimization
                                 :<
                             end 

      @decision_variable_range = [@function_wrapper.miminum_decision_variable_values, @function_wrapper.maximum_decision_variable_values]   
    end

    def search(maximum_attempt: 2500, pitch_adjusting_range: BigDecimal('100'), harmony_search_size: 20, harmony_memory_acceping_rate: BigDecimal('0.95'), pitch_adjusting_rate: BigDecimal('0.7'))

      maximum_attempt = maximum_attempt.to_i unless maximum_attempt.kind_of?(Integer)
      pitch_adjusting_range = BigDecimal(pitch_adjusting_range.to_s) unless pitch_adjusting_range.kind_of?(BigDecimal)
      harmony_search_size = harmony_search_size.to_i unless harmony_search_size.kind_of?(Integer)
      harmony_memory_acceping_rate = BigDecimal(harmony_memory_acceping_rate.to_s) unless harmony_memory_acceping_rate.kind_of?(BigDecimal)
      pitch_adjusting_rate = BigDecimal(pitch_adjusting_rate.to_s) unless pitch_adjusting_rate.kind_of?(BigDecimal)

      initialize_harmony_memory(harmony_search_size)

      # 0 to maximum_attempt-1
      (0...maximum_attempt).each do |count|

        decision_variable_values = (0...@number_of_variables).map do |variable_index|

          if rand > harmony_memory_acceping_rate
            decision_variable_value = get_decision_variable_value_by_randomization(variable_index)
          else
            # Since the array index starts with 0 unlike MatLab, 1 is not added as in the code example in MatLab:
            harmony_memory_random_index = (harmony_search_size * bigdecimal_rand).fix
            decision_variable_value = @harmony_memory[harmony_memory_random_index][variable_index]
            
            if bigdecimal_rand < pitch_adjusting_rate
              pitch_adjusting = (@function_wrapper.maximum_decision_variable_values[variable_index] - @function_wrapper.miminum_decision_variable_values[variable_index]) / pitch_adjusting_range
              decision_variable_value = decision_variable_value + pitch_adjusting * (bigdecimal_rand - BigDecimal('0.5'))
            end
          end

          decision_variable_value

        end

        best_function_value = @function_wrapper.objective_function_value(decision_variable_values) 

        # TODO: Evaluate this logic. It appears that best_function_value_harmony_memory only needs to store the max best_function_value and the corresponding harmony_memory_random_index of harmony_memory. 
        #       The simpler implementation for MatLab doesn't seem to be a good implementation in Ruby here. 
        #       Or MatLab code can use Object-Oriented class as a value object (There is Object-Oriented construct in MatLab).  
        # When objective = :maximization, "if best_function_value > @best_function_value_harmony_memory.max"
        # When objective = :minimization, "if best_function_value < @best_function_value_harmony_memory.min"
        if best_function_value.send(@objective_comparison_operator, @best_function_value_harmony_memory.send(@objective_method_name))
          # If harmony_memory_random_index is not set in the if statement above, it means a new search and use the index for the max best function value: 
          harmony_memory_random_index ||= @best_function_value_harmony_memory.index(@best_function_value_harmony_memory.send(@objective_method_name))
          @harmony_memory[harmony_memory_random_index] = decision_variable_values
          @best_function_value_harmony_memory[harmony_memory_random_index] = best_function_value
        end

      end

      objective_function_value = @best_function_value_harmony_memory.send(@objective_method_name)
      decision_variable_values = @harmony_memory[@best_function_value_harmony_memory.index(objective_function_value)]

      { best_decision_variable_values: decision_variable_values, best_objective_function_value: objective_function_value }

    end

    private
      def initialize_harmony_memory(harmony_search_size)

        @harmony_memory = []
        @best_function_value_harmony_memory = []

        for i in (0...harmony_search_size)

          decision_variable_values = (0...@number_of_variables).map do |variable_index|
            get_decision_variable_value_by_randomization(variable_index)
          end

          @harmony_memory << decision_variable_values
          @best_function_value_harmony_memory << @function_wrapper.objective_function_value(decision_variable_values)

        end

      end

  end

end