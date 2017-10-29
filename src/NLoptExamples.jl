module NLoptExamples
import NLopt
import ForwardDiff

include("quadratic.jl")
include("data_fit.jl")

export quadratic_ex
export optim_data
end # module
