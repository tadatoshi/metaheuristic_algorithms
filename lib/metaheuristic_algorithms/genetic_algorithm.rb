module MetaheuristicAlgorithms

  class GeneticAlgorithm
    include MetaheuristicAlgorithms::BaseAlgorithmModule
    include MetaheuristicAlgorithms::Helper

    def initialize(function_wrapper, number_of_variables: 1, objective: :maximization)
      @function_wrapper = function_wrapper
      @number_of_variables = number_of_variables
      @objective_method_name = case objective
                                 when :maximization
                                   :max
                                 when :minimization
                                   :min
                               end        

      ## Decided to use decimal number representation and convert it to binary number by unpack method
      ## because it is difficult to initialize variable within the given range
      # @string_length_in_bits = 16
    end

    def search(population_size: 20, maximum_number_of_generations: 100, number_of_mutation_sites: BigDecimal('2'), crossover_probability: BigDecimal('0.95'), mutation_probability: BigDecimal('0.05'))

      population_size = population_size.to_i unless population_size.kind_of?(Integer)
      maximum_number_of_generations = maximum_number_of_generations.to_i unless maximum_number_of_generations.kind_of?(Integer)
      number_of_mutation_sites = BigDecimal(number_of_mutation_sites.to_s) unless number_of_mutation_sites.kind_of?(BigDecimal)
      crossover_probability = BigDecimal(crossover_probability.to_s) unless crossover_probability.kind_of?(BigDecimal)
      mutation_probability = BigDecimal(mutation_probability.to_s) unless mutation_probability.kind_of?(BigDecimal)

      initialize_population(population_size)

      (0...maximum_number_of_generations).each do |generation_index|

        @population_copy = deep_clone_population

        (0...population_size).each do |individual_index|

          if bigdecimal_rand < crossover_probability

            # Crossover pair:
            crossover_pair_1_index = generate_random_index(population_size)
            crossover_pair_2_index = generate_random_index(population_size)     

            crossover(crossover_pair_1_index, crossover_pair_2_index)

          end

          if bigdecimal_rand < mutation_probability

            mutation_individual_index = generate_random_index(population_size)

            mutate(mutation_individual_index, number_of_mutation_sites)

          end

        end

      end

      objective_function_value = @population_fitness.send(@objective_method_name)
      decision_variable_values = @population[@population_fitness.index(objective_function_value)]

      { best_decision_variable_values: decision_variable_values, best_objective_function_value: objective_function_value }

    end

    private

      def initialize_population(population_size)

        @population = []
        @population_fitness = []

        # 0 to population_size-1
        (0...population_size).each do |individual_index|
          decision_variable_values = (0...@number_of_variables).map do |variable_index|
            get_decision_variable_value_by_randomization(variable_index)
          end
          @population << decision_variable_values
          @population_fitness << @function_wrapper.objective_function_value(decision_variable_values)
        end

      end

      def generate_random_index(population_size)
        (population_size * rand).floor
      end

      def crossover(crossover_pair_1_index, crossover_pair_2_index)

        crossover_pair_1_decimal_values = []
        crossover_pair_2_decimal_values = []

        (0...@number_of_variables).each do |variable_index|

          crossover_pair_1_decimal_value = @population_copy[crossover_pair_1_index][variable_index]
          crossover_pair_2_decimal_value = @population_copy[crossover_pair_2_index][variable_index]

          crossover_pair_1_binary_32_string = decimal_to_binary_32_string(crossover_pair_1_decimal_value)
          crossover_pair_2_binary_32_string = decimal_to_binary_32_string(crossover_pair_2_decimal_value)

          # 32 bits string with the first bit as sign bit. Hence, the length is 32 - 1:
          crossover_point = 31 * rand

          crossover_pair_1_binary_32_string_after_crossover = crossover_pair_1_binary_32_string[0, crossover_point] + 
                                                              crossover_pair_2_binary_32_string[crossover_point+1, 32]
          crossover_pair_2_binary_32_string_after_crossover = crossover_pair_2_binary_32_string[0, crossover_point] + 
                                                              crossover_pair_1_binary_32_string[crossover_point+1, 32] 

          crossover_pair_1_decimal_value_after_crossover = binary_32_string_to_decimal(crossover_pair_1_binary_32_string_after_crossover)
          crossover_pair_2_decimal_value_after_crossover = binary_32_string_to_decimal(crossover_pair_2_binary_32_string_after_crossover)

          if in_the_range?(crossover_pair_1_decimal_value_after_crossover, variable_index) &&
             in_the_range?(crossover_pair_2_decimal_value_after_crossover, variable_index)
            crossover_pair_1_decimal_values << crossover_pair_1_decimal_value_after_crossover
            crossover_pair_2_decimal_values << crossover_pair_2_decimal_value_after_crossover
          else
            crossover_pair_1_decimal_values << crossover_pair_1_decimal_value
            crossover_pair_2_decimal_values << crossover_pair_2_decimal_value
          end

        end 

        new_crossover_pair_1_fitness = @function_wrapper.objective_function_value(crossover_pair_1_decimal_values)
        new_crossover_pair_2_fitness = @function_wrapper.objective_function_value(crossover_pair_2_decimal_values)

        if new_crossover_pair_1_fitness > @population_fitness[crossover_pair_1_index] && 
           new_crossover_pair_2_fitness > @population_fitness[crossover_pair_2_index]

          @population[crossover_pair_1_index] = @population_copy[crossover_pair_1_index] = crossover_pair_1_decimal_values 
          @population[crossover_pair_2_index] = @population_copy[crossover_pair_2_index] = crossover_pair_2_decimal_values 

          @population_fitness[crossover_pair_1_index] = new_crossover_pair_1_fitness
          @population_fitness[crossover_pair_2_index] = new_crossover_pair_2_fitness

        end                                       

      end

      def decimal_to_binary_32_string(decimal_number)
        [decimal_number].pack('g').bytes.map{|n| "%08b" % n}.join
      end

      def binary_32_string_to_decimal(binary_32_string)
        decimal_float_value = [binary_32_string].pack("B*").unpack('g')[0].round(4)
        BigDecimal(decimal_float_value.to_s)
      end

      def mutate(individual_index, number_of_mutation_sites)

        decimal_values = (0...@number_of_variables).map do |variable_index|

          decimal_value = @population_copy[individual_index][variable_index]
          binary_32_string = decimal_to_binary_32_string(decimal_value)

          mutated_binary_32_string = binary_32_string.clone

          (0...number_of_mutation_sites).each do |i|
            mutation_site_index = generate_mutation_site_index
            # Flips 1 to 0 or 0 to 1:
            mutated_binary_32_string[mutation_site_index] = ((binary_32_string[mutation_site_index].to_i + 1).modulo(2)).to_s
          end

          decimal_value_after_mutation = binary_32_string_to_decimal(mutated_binary_32_string)

          if in_the_range?(decimal_value_after_mutation, variable_index)
            decimal_value_after_mutation
          else
            decimal_value
          end

        end

        new_individual_fitness = @function_wrapper.objective_function_value(decimal_values)

        if new_individual_fitness > @population_fitness[individual_index]          

          @population[individual_index] = @population_copy[individual_index] = decimal_values

          @population_fitness[individual_index] = new_individual_fitness

        end          

      end

      def generate_mutation_site_index
        (31 * rand).floor
      end

      def in_the_range?(decimal_value, variable_index)
        decimal_value >= @function_wrapper.miminum_decision_variable_values[variable_index] && decimal_value <= @function_wrapper.maximum_decision_variable_values[variable_index]
      end 

      def deep_clone_population
        @population.map { |individual| individual.clone }
      end

  end

end