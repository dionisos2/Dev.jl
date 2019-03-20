module Dev


export test, cover
using Revise
using LocalCoverage
using Pkg

function test()
    Pkg.test()
end

function cover()
    module_name = split(pwd(), "/")[end]
    generate_coverage(module_name)
    open_coverage(module_name)
end

end # module
