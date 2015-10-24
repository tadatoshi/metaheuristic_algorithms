# require 'bigdecimal/math'
# In order to support JRuby, decided not to use distribution gem:
# require 'distribution'

module MetaheuristicAlgorithms

  class SimulatedAnnealing
    include MetaheuristicAlgorithms::Helper
    include MetaheuristicAlgorithms::BaseAlgorithmModule

    def initialize(function_wrapper, number_of_variables: 1, objective: :maximization)
      @function_wrapper = function_wrapper
      @number_of_variables = number_of_variables
      @objective_comparison_operator = case objective
                               when :maximization
                                 :>
                               when :minimization
                                 :<
                             end        
    end

    # def search(temperature: BigDecimal('100.0'), minimal_temperature: BigDecimal('1'), maximum_number_of_rejections: 2500, 
    #            maximum_number_of_runs: 500, maximum_number_of_acceptances: 15, 
    #            bolzmann_constant: BigDecimal('1'), cooling_factor: BigDecimal('0.95'), energy_norm: BigDecimal('10'), 
    #            standard_diviation_for_estimation: BigDecimal('6'), ratio_of_energy_delta_over_evaluation_delta: BigDecimal('10'))
    def search(temperature: 100.0, minimal_temperature: 1, maximum_number_of_rejections: 2500, 
               maximum_number_of_runs: 500, maximum_number_of_acceptances: 15, 
               bolzmann_constant: 1, cooling_factor: 0.95, energy_norm: 10, 
               standard_diviation_for_estimation: 6, ratio_of_energy_delta_over_evaluation_delta: 10)

      # temperature = BigDecimal(temperature.to_s) unless temperature.kind_of?(BigDecimal)
      # minimal_temperature = BigDecimal(minimal_temperature.to_s) unless minimal_temperature.kind_of?(BigDecimal)
      temperature = temperature.to_f unless temperature.kind_of?(Float)
      minimal_temperature = minimal_temperature.to_f unless minimal_temperature.kind_of?(Float)      
      maximum_number_of_rejections = maximum_number_of_rejections.to_i unless maximum_number_of_rejections.kind_of?(Integer)
      maximum_number_of_runs = maximum_number_of_runs.to_i unless maximum_number_of_runs.kind_of?(Integer)
      maximum_number_of_acceptances = maximum_number_of_acceptances.to_i unless maximum_number_of_acceptances.kind_of?(Integer)
      # bolzmann_constant = BigDecimal(bolzmann_constant.to_s) unless bolzmann_constant.kind_of?(BigDecimal)
      # cooling_factor = BigDecimal(cooling_factor.to_s) unless cooling_factor.kind_of?(BigDecimal)
      # energy_norm = BigDecimal(energy_norm.to_s) unless energy_norm.kind_of?(BigDecimal)
      # standard_diviation_for_estimation = BigDecimal(standard_diviation_for_estimation.to_s) unless standard_diviation_for_estimation.kind_of?(BigDecimal)
      # ratio_of_energy_delta_over_evaluation_delta = BigDecimal(ratio_of_energy_delta_over_evaluation_delta.to_s) unless ratio_of_energy_delta_over_evaluation_delta.kind_of?(BigDecimal)
      bolzmann_constant = bolzmann_constant.to_f unless bolzmann_constant.kind_of?(Float)
      cooling_factor = cooling_factor.to_f unless cooling_factor.kind_of?(Float)
      energy_norm = energy_norm.to_f unless energy_norm.kind_of?(Float)
      standard_diviation_for_estimation = standard_diviation_for_estimation.to_f unless standard_diviation_for_estimation.kind_of?(Float)
      ratio_of_energy_delta_over_evaluation_delta = ratio_of_energy_delta_over_evaluation_delta.to_f unless ratio_of_energy_delta_over_evaluation_delta.kind_of?(Float)

      number_of_runs = 0
      number_of_rejections = 0
      number_of_acceptances = 0
      total_evaluations = 0

      initial_estimates = @function_wrapper.initial_decision_variable_value_estimates

      best_evaluation = @function_wrapper.objective_function_value(initial_estimates)

      best_solution = initial_estimates      

      # TODO: Add the code to check with minimal_function_value if looking for the minimal value: 
      while temperature > minimal_temperature && number_of_rejections <= maximum_number_of_rejections

        number_of_runs = number_of_runs + 1

        if number_of_runs >= maximum_number_of_runs || number_of_acceptances > maximum_number_of_acceptances

          temperature = cooling_factor * temperature
          total_evaluations = total_evaluations + 1
          number_of_runs = 1
          number_of_acceptances = 1

        end

        new_estimates = estimate_solution(initial_estimates, standard_diviation_for_estimation)
        new_evaluation = @function_wrapper.objective_function_value(new_estimates)

        evaluation_delta = ratio_of_energy_delta_over_evaluation_delta * (new_evaluation - best_evaluation)

        # Accept if improved:
        # When objective = :maximization, "if evaluation_delta > 0 && evaluation_delta > energy_norm"
        # When objective = :minimization, "if evaluation_delta < 0 && -evaluation_delta > energy_norm"
        # if evaluation_delta.send(@objective_comparison_operator, BigDecimal('0')) && evaluation_delta.abs > energy_norm
        if evaluation_delta.send(@objective_comparison_operator, 0) && evaluation_delta.abs > energy_norm
          best_solution = new_estimates
          best_evaluation = new_evaluation
          number_of_acceptances = number_of_acceptances + 1
          number_of_rejections = 0
        # Accept with a small probability if not improved
        # elsif acceptance_probability(evaluation_delta, temperature, bolzmann_constant) > bigdecimal_rand
      elsif acceptance_probability(evaluation_delta, temperature, bolzmann_constant) > rand
          best_solution = new_estimates
          best_evaluation = new_evaluation
          number_of_acceptances = number_of_acceptances + 1            
        else
          number_of_rejections = number_of_rejections + 1
        end

      end

      { best_decision_variable_values: best_solution, best_objective_function_value: best_evaluation }

    end

    private
      def estimate_solution(previous_estimates, standard_diviation_for_estimation)

        (0...@number_of_variables).map do |variable_index|

          # The value out-of-range in order to enter while loop
          # new_estimate = @function_wrapper.miminum_decision_variable_values[variable_index] - BigDecimal('1')
          new_estimate = @function_wrapper.miminum_decision_variable_values[variable_index] - 1

          while new_estimate < @function_wrapper.miminum_decision_variable_values[variable_index] || new_estimate > @function_wrapper.maximum_decision_variable_values[variable_index]

            # MatLab example code uses newGuess = initialGuess + rand(1,2) * randn;
            # But in our case, the value range is different. 
            # In order to support JRuby, decided not to use Distribution::Normal.rng:
            # new_estimate = BigDecimal(Distribution::Normal.rng(previous_estimates[variable_index], standard_diviation_for_estimation).call.to_s)
            # new_estimate = BigDecimal(gaussian(previous_estimates[variable_index], standard_diviation_for_estimation).to_s)
            new_estimate = gaussian(previous_estimates[variable_index], standard_diviation_for_estimation)

          end

          new_estimate

        end

      end

      def acceptance_probability(evaluation_delta, temperature, bolzmann_constant)
        BigMath.exp((-evaluation_delta / (bolzmann_constant * temperature)), 10)
      end

  end

end