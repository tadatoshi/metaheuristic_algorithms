require 'spec_helper'
require 'bigdecimal'

describe MetaheuristicAlgorithms::VirtualBeeAlgorithm do

  it "should find the glocal minimum value for Rosenbrook's Function" do

    pending('Evaluate the sample pseudo code.')

    rosenbrook_function_wrapper = MetaheuristicAlgorithms::FunctionWrappers::RosenbrookFunctionWrapper.new

    virtual_bee_algorithm = MetaheuristicAlgorithms::VirtualBeeAlgorithm.new(rosenbrook_function_wrapper, number_of_variables: 1, objective: :maximization)

    number_of_virtual_bees = 20
    number_of_foraging_explorations = 600    

    result = virtual_bee_algorithm.search(number_of_virtual_bees: number_of_virtual_bees, number_of_foraging_explorations: number_of_foraging_explorations)

    expect(result[:best_decision_variable_values][0]).to be_within(0.1).of(BigDecimal('1.0112'))
    expect(result[:best_decision_variable_values][1]).to be_within(0.1).of(BigDecimal('0.9988')) 
    expect(result[:best_objective_function_value]).to be_within(0.1).of(BigDecimal('0.0563'))      

  end

end