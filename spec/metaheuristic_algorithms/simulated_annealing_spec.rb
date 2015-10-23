require 'spec_helper'
require 'bigdecimal'

describe MetaheuristicAlgorithms::SimulatedAnnealing do

  it "should find the glocal minimum value for Rosenbrook's Function" do

    # pending('Improve the speed.')

    rosenbrook_function_wrapper = MetaheuristicAlgorithms::FunctionWrappers::RosenbrookFunctionWrapper.new

    simulated_annealing = MetaheuristicAlgorithms::SimulatedAnnealing.new(rosenbrook_function_wrapper, number_of_variables: 2, objective: :minimization)

    temperature = BigDecimal('1.0')
    # minimal_temperature = BigDecimal('1e-10') # Final stopping temperature
    minimal_temperature = BigDecimal('1e-1') # Final stopping temperature
    # minimal_function_value = BigDecimal('-1E+100')
    # maximum_number_of_rejections = 2500
    # maximum_number_of_rejections = 1000
    maximum_number_of_rejections = 100
    # maximum_number_of_runs = 500
    # maximum_number_of_runs = 100
    maximum_number_of_runs = 20
    # maximum_number_of_acceptances = 5
    # maximum_number_of_acceptances = 15
    maximum_number_of_acceptances = 5
    bolzmann_constant = BigDecimal('1')
    cooling_factor = BigDecimal('0.95')
    energy_norm = BigDecimal('1e-1')
    standard_diviation_for_estimation = BigDecimal('1')  
    ratio_of_energy_delta_over_evaluation_delta = BigDecimal('1')

    result = simulated_annealing.search(temperature: temperature, minimal_temperature: minimal_temperature, 
                                        maximum_number_of_rejections: maximum_number_of_rejections, maximum_number_of_runs: maximum_number_of_runs, 
                                        maximum_number_of_acceptances: maximum_number_of_acceptances, bolzmann_constant: bolzmann_constant, 
                                        cooling_factor: cooling_factor, energy_norm: energy_norm, 
                                        standard_diviation_for_estimation: standard_diviation_for_estimation, ratio_of_energy_delta_over_evaluation_delta: ratio_of_energy_delta_over_evaluation_delta)

    # pending('Improve the code to converge toward the expected value')
    expect(result[:best_decision_variable_values][0]).to be_within(1).of(BigDecimal('1.0112'))
    expect(result[:best_decision_variable_values][1]).to be_within(1).of(BigDecimal('0.9988')) 
    expect(result[:best_objective_function_value]).to be_within(1).of(BigDecimal('0.0563'))     

  end

end