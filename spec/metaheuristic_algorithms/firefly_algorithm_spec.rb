require 'spec_helper'
# require 'bigdecimal'

describe MetaheuristicAlgorithms::FireflyAlgorithm do

  it 'should find the glocal maximum value for Non-smooth Multi-peak Function' do

    nonsmooth_multipeak_function_wrapper = MetaheuristicAlgorithms::FunctionWrappers::NonsmoothMultipeakFunctionWrapper.new

    firefly_algorithm = MetaheuristicAlgorithms::FireflyAlgorithm.new(nonsmooth_multipeak_function_wrapper, number_of_variables: 2, objective: :maximization)

    # number_of_fireflies = 25
    number_of_fireflies = 10
    # maximun_generation = 20
    maximun_generation = 10
    # randomization_parameter_alpha = BigDecimal('0.2')
    randomization_parameter_alpha = 0.2
    # absorption_coefficient_gamma = BigDecimal('1.0') 
    absorption_coefficient_gamma = 1.0  

    result = firefly_algorithm.search(number_of_fireflies: number_of_fireflies, maximun_generation: maximun_generation, 
                                      randomization_parameter_alpha: randomization_parameter_alpha, absorption_coefficient_gamma: absorption_coefficient_gamma)

    # It was too slow with number of fireflies 25 and maximum generation 20. 
    # Hence, less precision with number of fireflies 10 and maximum generation 10 is used. 
    # expect(result[:best_decision_variable_values][0]).to be_within(3).of(BigDecimal('2.8327'))
    # expect(result[:best_decision_variable_values][1]).to be_within(3).of(BigDecimal('-0.0038'))
    # expect(result[:best_objective_function_value]).to be_within(3).of(BigDecimal('3.4310'))
    expect(result[:best_decision_variable_values][0]).to be_within(3).of(2.8327)
    expect(result[:best_decision_variable_values][1]).to be_within(3).of(-0.0038)
    expect(result[:best_objective_function_value]).to be_within(3).of(3.4310)      

  end

end