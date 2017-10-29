# using a closure to keep count local
function func_gen()
    count = 0
    return function(x::Vector,g::Vector)
        if length(g) > 0
            g[1] = 0 # objective function is just the value of x2
            g[2] = 1 # objective function is just the value of x2
        end
        count::Int += 1
        println("f_$count($x)")
        return x[2]
    end
end

#inequality constraint 1
function ic1(x::Vector, g::Vector)
    if length(g) > 0
        g[1] = 0
        g[2] = -1
    end
    return 1-x[2]
end

#inequality constraint 2
function ic2(x::Vector, g::Vector)
    if length(g) > 0
        g[1] = -1
        g[2] = 0
    end
    return -x[1]
end

#equality constraint 1 (empty)
function ec1(x::Vector, g::Vector)
    if length(g) > 0
        g[1] = -2*x[1]
        g[2] = 1
    end
    return x[2]-x[1]^2
end

function quadratic_ex()
    opt = NLopt.Opt(:LD_SLSQP, 2)
    NLopt.lower_bounds!(opt, [-Inf, 0.])
    NLopt.xtol_rel!(opt, 1e-4)

    NLopt.min_objective!(opt, func_gen())
    NLopt.inequality_constraint!(opt, ic1)
    NLopt.inequality_constraint!(opt, ic2)
    NLopt.equality_constraint!(opt, ec1, 0)

    (minf, minx, ret) = NLopt.optimize(opt, [5, 20])
    println("got $minf at $minx.")
end
