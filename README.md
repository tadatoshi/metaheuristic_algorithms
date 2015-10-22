# MetaheuristicAlgorithms

Various metaheuristic algorithms implemented in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'metaheuristic_algorithms'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metaheuristic_algorithms

## Supported Platforms

* MRI Ruby 2.2 or above. 

* JRuby 9.0.0.0 or above. (In an attempt to have better speed, if not fast.)

## Available Algorithms

In alphabetical order:

* Firefly Algorithm
        MetaheuristicAlgorithms::FireflyAlgorithm
* Genetic Algorithm
        MetaheuristicAlgorithms::GeneticAlgorithm
* Harmony Search
        MetaheuristicAlgorithms::HarmonySearch
* Simplified Particle Swarm Optimization
        MetaheuristicAlgorithms::SimplifiedParticleSwarmOptimization
* Simulated Annealing
        MetaheuristicAlgorithms::SimulatedAnnealing

Algorithms under construction:

* Ant Colony Optimization
* Virtual Bee Algorithm

## Usage

Step 1. Create a Function Wrapper for your objective function by extending MetaheuristicAlgorithms::FunctionWrappers::AbstractWrapper

   Example: Rosenbrook's Function: f(x,y) = (1 - x)^2 + 100(y - x^2)^2

```ruby
   require 'metaheuristic_algorithms'
   require 'bigdecimal'

   class RosenbrookFunctionWrapper < MetaheuristicAlgorithms::FunctionWrappers::AbstractWrapper

      def maximum_decision_variable_values
        [BigDecimal('5'), BigDecimal('5')]
      end

      def miminum_decision_variable_values
        [BigDecimal('-5'), BigDecimal('-5')]
      end

      def objective_function_value(decision_variable_values)
        (BigDecimal('1') - decision_variable_values[0]).power(2) + BigDecimal('100') * (decision_variable_values[1] - decision_variable_values[0].power(2)).power(2)
      end

      # For the algorithm that requires initial estimate that is depending on the particular objective function:
      def initial_decision_variable_value_estimates
        [BigDecimal('2'), BigDecimal('2')]
      end

    end
```

Step 2. Instantiate the created Function Wrapper and pass it as the first argument of the Algorithm instantiation. 
        Also specify the number of variables and objective (:maximization or :minimization)
        Then call the search method passing the algorithm specific parameters. 

   Example: Harmony Search for the glocal minimum value for Rosenbrook's Function

```ruby
   require 'metaheuristic_algorithms'
   require 'bigdecimal'

   rosenbrook_function_wrapper = RosenbrookFunctionWrapper.new

   harmony_search = MetaheuristicAlgorithms::HarmonySearch.new(rosenbrook_function_wrapper, number_of_variables: 2, objective: :minimization)

   maximum_attempt = 25000
   pitch_adjusting_range = BigDecimal('100')
   harmony_search_size = 20
   harmony_memory_acceping_rate = BigDecimal('0.95')
   pitch_adjusting_rate = BigDecimal('0.7')    

   result = harmony_search.search(maximum_attempt: maximum_attempt, pitch_adjusting_range: pitch_adjusting_range, 
                                  harmony_search_size: harmony_search_size, harmony_memory_acceping_rate: harmony_memory_acceping_rate, 
                                  pitch_adjusting_rate: pitch_adjusting_rate)

   puts result[:best_decision_variable_values][0] # x value: Example: BigDecimal('1.0112')
   puts result[:best_decision_variable_values][1] # y value: Example: BigDecimal('0.9988')
   puts result[:best_objective_function_value]    # f(x,y) value: Example: BigDecimal('0.0563')    
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tadatoshi/metaheuristic_algorithms. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

