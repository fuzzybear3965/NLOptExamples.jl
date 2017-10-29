#closure to keep data local
function func_gen(f::Function, xs::Vector, ys::Vector)
    return function(x::Vector, g::Vector)
        if length(g) > 0
            g = ForwardDiff.Gradient(f,x)
        end
        for i = 1:length(x)
            print("x[$i]: ",x[i], ", ")
            if i == length(x)
                print("\n")
            end
        end
        return sum(abs2.(f(x).(xs)-ys))
    end
end

##### Positional arguments
# xs::Vector - x values to be passed to f in objective
# ys::Vector - y values to be used in objective
# f::function - function whose parameters should be determined
# alg::Symbol - algorithm
# n::Int - dimension of optimization space
# lbs::Vector - lower bounds
# x0::Vector - initial guess
##### Keyword arguments
# ecs::Vector{Function} - equality constraints
function optim_data(f, xs, ys, alg, n, lbs, ubs, x0; ecs=Vector{}(), ics=Vector{}())
    opt = NLopt.Opt(alg, n)
    NLopt.lower_bounds!(opt, lbs)
    NLopt.upper_bounds!(opt, ubs)

    NLopt.min_objective!(opt, func_gen(f,xs,ys))
    for i=1:length(ecs)
        NLopt.equality_constraint!(opt, ecs[i])
    end
    for i=1:length(ics)
        NLopt.equality_constraint!(opt, ics[i])
    end

    return NLopt.optimize(opt, x0)
end
