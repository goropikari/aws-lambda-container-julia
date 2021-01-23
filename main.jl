using JuliaLambdaExample

# Parsing input (this is more commonly structured as JSON string)
parse_data(event_data) = parse(Int, event_data)

# Formatting result (this is more commonly structured as JSON string)
format_result(value) = "$value"

# Define a handler function that is called by the lambda runtime
function handle_event(event_data, headers)
    @info "Handling request" event_data headers
    simulations = parse_data(event_data)
    my_pi = monte_carlo_pi(simulations)
    return format_result(my_pi)
end
