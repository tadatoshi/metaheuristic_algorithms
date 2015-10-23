module MetaheuristicAlgorithms

  class SimplifiedParticleSwarmOptimization
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
    end

    # def search(number_of_particiles: 20, number_of_iterations: 15, social_coefficient: BigDecimal('0.5'), random_variable_coefficient: BigDecimal('0.2'))
    def search(number_of_particiles: 20, number_of_iterations: 15, social_coefficient: 0.5, random_variable_coefficient: 0.2)

      number_of_particiles = number_of_particiles.to_i unless number_of_particiles.kind_of?(Integer)
      number_of_iterations = number_of_iterations.to_i unless number_of_iterations.kind_of?(Integer)
      # social_coefficient = BigDecimal(social_coefficient.to_s) unless social_coefficient.kind_of?(BigDecimal)
      # random_variable_coefficient = BigDecimal(random_variable_coefficient.to_s) unless random_variable_coefficient.kind_of?(BigDecimal)        
      social_coefficient = social_coefficient.to_f unless social_coefficient.kind_of?(Float)
      random_variable_coefficient = random_variable_coefficient.to_f unless random_variable_coefficient.kind_of?(Float)        

      initialize_particles(number_of_particiles)

      global_best_position = nil
      best_function_value = nil

      number_of_iterations.times do |iteration|

        function_values = @particle_locations.map do |particle_location|
          @function_wrapper.objective_function_value(particle_location)
        end 

        best_function_value = function_values.send(@objective_method_name)
        global_best_position = @particle_locations[function_values.index(best_function_value)]

        move_particles(global_best_position, social_coefficient, random_variable_coefficient)

      end

      { best_decision_variable_values: global_best_position, best_objective_function_value: best_function_value }

    end

    private
      def initialize_particles(number_of_particiles)

        @particle_locations = []

        number_of_particiles.times do |individual_index|
          decision_variable_values = (0...@number_of_variables).map do |variable_index|
            get_decision_variable_value_by_randomization(variable_index)
          end
          @particle_locations << decision_variable_values
        end

      end

      def move_particles(global_best_position, social_coefficient, random_variable_coefficient)
       
        # 0 to @particle_locations-1
        @particle_locations = @particle_locations.map do |particle_location|

          (0...@number_of_variables).map do |variable_index|

            # The value out-of-range in order to enter while loop
            # new_particle_location_coordinate = @function_wrapper.miminum_decision_variable_values[variable_index] - BigDecimal('1')
            new_particle_location_coordinate = @function_wrapper.miminum_decision_variable_values[variable_index] - 1

            while new_particle_location_coordinate < @function_wrapper.miminum_decision_variable_values[variable_index] || new_particle_location_coordinate > @function_wrapper.maximum_decision_variable_values[variable_index]
              # new_particle_location_coordinate = (BigDecimal('1') - social_coefficient) * particle_location[variable_index] + social_coefficient * global_best_position[variable_index] + random_variable_coefficient * (bigdecimal_rand - BigDecimal('0.5'))
              new_particle_location_coordinate = (1 - social_coefficient) * particle_location[variable_index] + social_coefficient * global_best_position[variable_index] + random_variable_coefficient * (rand - 0.5)
            end

            new_particle_location_coordinate

          end

        end          

      end

  end

end