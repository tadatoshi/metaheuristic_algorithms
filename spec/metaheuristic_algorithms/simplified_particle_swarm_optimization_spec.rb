require 'spec_helper'
# require 'bigdecimal'

describe MetaheuristicAlgorithms::SimplifiedParticleSwarmOptimization do

  it "should find the glocal minimum value for Michaelwicz's Function" do

    michaelwicz_function_wrapper = MetaheuristicAlgorithms::FunctionWrappers::MichaelwiczFunctionWrapper.new

    simplified_particle_swarm_optimization = MetaheuristicAlgorithms::SimplifiedParticleSwarmOptimization.new(michaelwicz_function_wrapper, number_of_variables: 2, objective: :minimization)

    number_of_particiles = 20
    number_of_iterations = 15
    # social_coefficient = BigDecimal('0.5')
    social_coefficient = 0.5
    # random_variable_coefficient = BigDecimal('0.2')
    random_variable_coefficient = 0.2

    result = simplified_particle_swarm_optimization.search(number_of_particiles: number_of_particiles, number_of_iterations: number_of_iterations, 
                                                           social_coefficient: social_coefficient, random_variable_coefficient: random_variable_coefficient)

    # expect(result[:best_decision_variable_values][0]).to be_within(0.001).of(BigDecimal('2.20319'))
    # expect(result[:best_decision_variable_values][1]).to be_within(0.001).of(BigDecimal('1.57049')) 
    # expect(result[:best_objective_function_value]).to be_within(0.001).of(BigDecimal('-1.801'))
    # Values of one execution of the equivalent MatLab code: 
    # expect(result[:best_decision_variable_values][0]).to be_within(1).of(BigDecimal('2.1701'))
    # expect(result[:best_decision_variable_values][1]).to be_within(1).of(BigDecimal('1.5703')) 
    # expect(result[:best_objective_function_value]).to be_within(1).of(BigDecimal('-1.7843')) 
    expect(result[:best_decision_variable_values][0]).to be_within(1).of(2.1701)
    expect(result[:best_decision_variable_values][1]).to be_within(1).of(1.5703) 
    expect(result[:best_objective_function_value]).to be_within(1).of(-1.7843)          

  end

end