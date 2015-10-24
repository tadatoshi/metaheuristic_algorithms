require 'spec_helper'
# require 'bigdecimal'

describe MetaheuristicAlgorithms::AntColonyOptimization do

  it "should find the glocal minimum value for Rosenbrook's Function" do

    pending('Evaluate the sample pseudo code.')

    rosenbrook_function_wrapper = MetaheuristicAlgorithms::FunctionWrappers::RosenbrookFunctionWrapper.new

    ant_colony_optimization = MetaheuristicAlgorithms::AntColonyOptimization.new(rosenbrook_function_wrapper, number_of_variables: 1, objective: :maximization)

    result = ant_colony_optimization.search

    # expect(result[:best_decision_variable_values][0]).to be_within(1).of(BigDecimal('1.0112'))
    # expect(result[:best_decision_variable_values][1]).to be_within(1).of(BigDecimal('0.9988')) 
    # expect(result[:best_objective_function_value]).to be_within(1).of(BigDecimal('0.0563'))   
    expect(result[:best_decision_variable_values][0]).to be_within(1).of(1.0112)
    expect(result[:best_decision_variable_values][1]).to be_within(1).of(0.9988) 
    expect(result[:best_objective_function_value]).to be_within(1).of(0.0563)   

  end

end