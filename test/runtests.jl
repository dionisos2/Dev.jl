using Test
using Dev

tests = ["myobject_test.jl"]

for test in tests
    include(test)
end
