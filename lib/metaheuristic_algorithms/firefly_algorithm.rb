# require 'bigdecimal'
# require 'bigdecimal/math'

module MetaheuristicAlgorithms

  class FireflyAlgorithm
    include MetaheuristicAlgorithms::BaseAlgorithmModule
    include MetaheuristicAlgorithms::Helper

    # Note: May be able to use Struct for this purpose, moving update_light_intensity method to FireflyAlgorithm class.
    class Firefly

      attr_accessor :location_coordinates
      attr_accessor :light_intensity

      def initialize(function_wrapper, location_coordinates, light_intensity)
        @function_wrapper = function_wrapper
        @location_coordinates = location_coordinates
        @light_intensity = light_intensity
      end

      def update_light_intensity
        @light_intensity = @function_wrapper.objective_function_value(@location_coordinates).to_f
      end

      def deep_clone
        clone_object = self.clone
        clone_object.location_coordinates = self.location_coordinates.clone
        clone_object
      end

    end

    def initialize(function_wrapper, number_of_variables: 1, objective: :maximization)
      @function_wrapper = function_wrapper
      @number_of_variables = number_of_variables
      @objective_method_name = case objective
                                 when :maximization
                                   :max_by
                                 when :minimization
                                   :min_by
                               end
    end

    # def search(number_of_fireflies: 10, maximun_generation: 10, randomization_parameter_alpha: BigDecimal('0.2'), absorption_coefficient_gamma: BigDecimal('1.0'))
    def search(number_of_fireflies: 10, maximun_generation: 10, randomization_parameter_alpha: 0.2, absorption_coefficient_gamma: 1.0)

      number_of_fireflies = number_of_fireflies.to_i unless number_of_fireflies.kind_of?(Integer)
      maximun_generation = maximun_generation.to_i unless maximun_generation.kind_of?(Integer)
      # randomization_parameter_alpha = BigDecimal(randomization_parameter_alpha.to_s) unless randomization_parameter_alpha.kind_of?(BigDecimal)
      # absorption_coefficient_gamma = BigDecimal(absorption_coefficient_gamma.to_s) unless absorption_coefficient_gamma.kind_of?(BigDecimal)
      randomization_parameter_alpha = randomization_parameter_alpha.to_f unless randomization_parameter_alpha.kind_of?(Float)
      absorption_coefficient_gamma = absorption_coefficient_gamma.to_f unless absorption_coefficient_gamma.kind_of?(Float)

      initialize_fireflies(number_of_fireflies)

      maximun_generation.times do |generation|

        @fireflies.each { |firefly| firefly.update_light_intensity }

        move_fireflies(randomization_parameter_alpha, absorption_coefficient_gamma)

      end

      solution_firefly = @fireflies.send(@objective_method_name) { |firefly| firefly.light_intensity }

      { best_decision_variable_values: solution_firefly.location_coordinates, best_objective_function_value: solution_firefly.light_intensity }

    end

    private
      def initialize_fireflies(number_of_fireflies)

        @fireflies = []

        for i in (0...number_of_fireflies)
          decision_variable_values = (0...@number_of_variables).map do |variable_index|
            get_decision_variable_value_by_randomization(variable_index)
          end

          # firefly = Firefly.new(@function_wrapper, decision_variable_values, BigDecimal('0'))
          firefly = Firefly.new(@function_wrapper, decision_variable_values, 0)
          @fireflies << firefly
        end

      end

      def move_fireflies(randomization_parameter_alpha, absorption_coefficient_gamma)

        # attractiveness_beta_at_distance_0 = BigDecimal('1')
        attractiveness_beta_at_distance_0 = 1

        fireflies_copy = @fireflies.map(&:deep_clone)

        @fireflies.each do |firefly_i|

          fireflies_copy.delete(firefly_i)

          fireflies_copy.each do |firefly_j|

            if firefly_i.light_intensity < firefly_j.light_intensity

              distance_of_two_fireflies = distance_of_two_fireflies(firefly_i, firefly_j)

              # attractiveness_beta = attractiveness_beta_at_distance_0 * BigMath.exp(-absorption_coefficient_gamma * distance_of_two_fireflies.power(2), 10)
              attractiveness_beta = attractiveness_beta_at_distance_0 * Math.exp(-absorption_coefficient_gamma * distance_of_two_fireflies**2)

              @number_of_variables.times do |variable_index|
                # new_location_coordinate = firefly_i.location_coordinates[variable_index] * (BigDecimal('1') - attractiveness_beta) 
                #                           + firefly_j.location_coordinates[variable_index] * attractiveness_beta 
                #                           + randomization_parameter_alpha * (bigdecimal_rand - BigDecimal('0.5'))
                new_location_coordinate = firefly_i.location_coordinates[variable_index] * (1 - attractiveness_beta) 
                                          + firefly_j.location_coordinates[variable_index] * attractiveness_beta 
                                          + randomization_parameter_alpha * (rand - 0.5)                
                new_location_coordinate = constrain_within_range(new_location_coordinate, variable_index)

                firefly_i.location_coordinates[variable_index] = new_location_coordinate
              end

            end

          end

        end

      end

      def constrain_within_range(location_coordinate, variable_index)
        if location_coordinate < (minimum_decision_variable_values = @function_wrapper.minimum_decision_variable_values[variable_index].to_f)
          minimum_decision_variable_values
        elsif location_coordinate > (maximum_decision_variable_values = @function_wrapper.maximum_decision_variable_values[variable_index].to_f)
          maximum_decision_variable_values
        else
          location_coordinate
        end
      end

      def distance_of_two_fireflies(firefly_1, firefly_2)

        # sum_of_squares = (0...@number_of_variables).inject(BigDecimal('0')) do |sum, variable_index|
        sum_of_squares = (0...@number_of_variables).inject(0) do |sum, variable_index|
          sum + (firefly_1.location_coordinates[variable_index] - firefly_2.location_coordinates[variable_index])**2
        end

        Math.sqrt(sum_of_squares)

      end       

  end

end