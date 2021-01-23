module JuliaLambdaExample
export monte_carlo_pi

# Calculate π using Monte Carlo simulation
function monte_carlo_pi(n)
    inside((x, y)) = x * x + y * y < 1.0
    points = rand(2, n)
    hits = count(inside(points[:, v]) for v in 1:n)
    return hits / n * 4
end

end
