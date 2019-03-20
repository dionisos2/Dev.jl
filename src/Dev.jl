module Dev


export test, cover, init, Pkg

using Revise
using LocalCoverage
using Pkg

function get_module()
    return string(split(pwd(), "/")[end])
end

function create_dir(dir_path::String)
    if !isdir(dir_path)
        println("Create $dir_path")
        mkdir("$dir_path")
    end
end

function create_readme()
    module_name = get_module()
    readme_content = """
    # $module_name
    A really super package/software in julia
    ## How to use
    """

    if !isfile("README.md")
        println("Create README.md file")
        open("README.md", "w") do io
            write(io, readme_content)
        end
    end
end


function create_test()
    module_name = get_module()
    runtests_content = """
    using Test
    using $module_name

    @test 1==1
    """
    create_dir("test")

    if !isfile("test/runtests.jl")
        println("Create test/runtests.jl file")
        open("test/runtests.jl", "w") do io
            write(io, runtests_content)
        end
    end
end

function create_git()
    gitignore_content = """
    coverage
    """

    if !isdir(".git")
        println("Initialise git repository (git init)")
        run(`git init`)
    end
    if !isfile(".gitignore")
        open(".gitignore", "w") do io
            println("Create .gitignore file")
            write(io, gitignore_content)
        end
    end
end


function add_package(package)
    package_s = Symbol(package)
    if !haskey(Pkg.installed(), package)
        println("Pkg.add(\"", package, "\")")
        Pkg.add(package)
    end
end

function add_packages()
    packages = ["Test", "Lazy"]

    for package in packages
        add_package(package)
    end
end

function init()
    println("Let’s go !")
    Pkg.activate(".")

    create_readme()
    create_test()
    create_git()
    add_packages()

    module_name = get_module()
    println("run 'using $module_name'")
end

function test()
    Pkg.test()
end

function cover()
    module_name = get_module()
    generate_coverage(module_name)
    open_coverage(module_name)
end

end # module
