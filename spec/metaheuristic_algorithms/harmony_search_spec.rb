require 'spec_helper'
require 'bigdecimal'

describe MetaheuristicAlgorithms::HarmonySearch do

  it "should find the glocal minimum value for Rosenbrook's Function" do

    rosenbrook_function_wrapper = MetaheuristicAlgorithms::FunctionWrappers::RosenbrookFunctionWrapper.new

    harmony_search = MetaheuristicAlgorithms::HarmonySearch.new(rosenbrook_function_wrapper, number_of_variables: 2, objective: :minimization)

    maximum_attempt = 25000
    pitch_adjusting_range = BigDecimal('100')
    harmony_search_size = 20
    harmony_memory_acceping_rate = BigDecimal('0.95')
    pitch_adjusting_rate = BigDecimal('0.7')    

    result = harmony_search.search(maximum_attempt: maximum_attempt, pitch_adjusting_range: pitch_adjusting_range, 
                                   harmony_search_size: harmony_search_size, harmony_memory_acceping_rate: harmony_memory_acceping_rate, 
                                   pitch_adjusting_rate: pitch_adjusting_rate)

    expect(result[:best_decision_variable_values][0]).to be_within(1).of(BigDecimal('1.0112'))
    expect(result[:best_decision_variable_values][1]).to be_within(1).of(BigDecimal('0.9988')) 
    expect(result[:best_objective_function_value]).to be_within(1).of(BigDecimal('0.0563'))      

  end

end