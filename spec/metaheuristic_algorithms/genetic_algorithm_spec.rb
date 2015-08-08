require 'spec_helper'
require 'bigdecimal'

describe MetaheuristicAlgorithms::GeneticAlgorithm do

  before(:each) do
    easom_function_wrapper = MetaheuristicAlgorithms::FunctionWrappers::EasomFunctionWrapper.new

    @genetic_algorithm = MetaheuristicAlgorithms::GeneticAlgorithm.new(easom_function_wrapper, number_of_variables: 1, objective: :maximization)
  end

  it 'should find the glocal maximum value for Easom Function' do

    population_size = 20
    maximum_number_of_generations = 100
    number_of_mutation_sites = BigDecimal('2')
    crossover_probability = BigDecimal('0.95')
    mutation_probability = BigDecimal('0.05')

    result = @genetic_algorithm.search(population_size: population_size, maximum_number_of_generations: maximum_number_of_generations, 
                                       number_of_mutation_sites: number_of_mutation_sites, crossover_probability: crossover_probability, 
                                       mutation_probability: mutation_probability)

    expect(result[:best_decision_variable_values][0]).to be_within(0.001).of(BigDecimal('3.1416'))
    expect(result[:best_objective_function_value]).to be_within(0.001).of(BigDecimal('1.000'))   

  end

  context 'Conversion between decimal number and binary 0s and 1s string' do

    it 'should convert decimal number to binary 0s and 1s string' do

      decimal_number = BigDecimal('45.2333')
      binary_0s_and_1s_string = '01000010001101001110111011100110'

      expect(@genetic_algorithm.send(:decimal_to_binary_32_string, decimal_number)).to eq(binary_0s_and_1s_string)

    end

    it 'should convert binary 0s and 1s string to decimal number' do

      decimal_number = BigDecimal('45.2333')
      binary_0s_and_1s_string = '01000010001101001110111011100110'

      expect(@genetic_algorithm.send(:binary_32_string_to_decimal, binary_0s_and_1s_string)).to eq(decimal_number)

    end

  end

end