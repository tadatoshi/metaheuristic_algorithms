require 'bigdecimal'

module MetaheuristicAlgorithms

  class VirtualBeeAlgorithm
    include MetaheuristicAlgorithms::Helper

    def initialize(function_wrapper, number_of_variables: 1, objective: :maximization)
      @function_wrapper = function_wrapper


    end

    def search(number_of_virtual_bees: 20, number_of_foraging_explorations: 600)

      number_of_virtual_bees = number_of_virtual_bees.to_i unless number_of_virtual_bees.kind_of?(Integer)
      number_of_foraging_explorations = number_of_foraging_explorations.to_i unless number_of_foraging_explorations.kind_of?(Integer)

      solution_estimates = @function_wrapper.initial_decision_variable_value_estimates



    end

  end

end