module Dev


export test, cover, init, Pkg, start, rs

import Coverage
using Revise
using LocalCoverage
using Pkg

struct ReviseSpawn
end

rs = ReviseSpawn()

function Base.display(_::ReviseSpawn)
    println("reload project")
    revise()
end


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

function create_todo()
    todo_content = """
    * TODO starting the project
    """

    if !isfile("todo.org")
        println("Create todo.org file")
        open("todo.org", "w") do io
            write(io, todo_content)
        end
    end
end

function create_myobject()
    myobject_content = """
    mutable struct MyObject{T <: AbstractString} <: AbstractString
        prop::T
        function MyObject{T}(prop::T) where (T <: AbstractString)
            tmp = new{T}()
            setfield!(tmp, :prop, prop * "plop")
            return tmp
        end
    end

    MyObject() = MyObject{String}("plop")

    Base.getproperty(myobject::MyObject, sym::Symbol) = return _getproperty(myobject, Val(sym))
    _getproperty(myobject::MyObject, ::Val{sym}) where {sym} = getfield(myobject, sym)
    Base.setproperty!(myobject::MyObject, sym::Symbol, value) = _setproperty!(myobject, Val(sym), value)
    _setproperty!(myobject::MyObject, ::Val{sym}, value) where {sym} = setfield!(myobject, sym, value)

    _setproperty!(myobject::MyObject, ::Val{:prop}, value) = error("MyObject.prop is a private member")
    """

    if !isfile("src/myobject.jl")
        println("Create src/myobject.jl file")
        open("src/myobject.jl", "w") do io
            write(io, myobject_content)
        end
    end
end

function create_test()
    module_name = get_module()
    runtests_content = """
    using Test
    using $module_name

    tests = ["myobject_test.jl"]

    for test in tests
      include(test)
    end
    """

    myobject_test_content = """
    using Test

    @testset "MyObject" begin
        @testset "constructors" begin
            myobject = MyObject()
            @test myobject.prop == "plopplop"
        end

        @testset "getters and setters" begin
            myobject = MyObject{String}("bla")
            @test myobject.prop == "blaplop"
            @test_throws ErrorException myobject.prop = "bla"
        end
    end
    """
    create_dir("test")

    if !isfile("test/runtests.jl")
        println("Create test/runtests.jl file")
        open("test/runtests.jl", "w") do io
            write(io, runtests_content)
        end
    end

    if !isfile("test/myobject_test.jl")
        println("Create test/myobject_test.jl file")
        open("test/myobject_test.jl", "w") do io
            write(io, myobject_test_content)
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

    Pkg.add(PackageSpec(url="https://github.com/dionisos2/Utils.jl", rev="master"))
end

function init()
    println("Constructing everything")
    Pkg.activate(".")

    create_readme()
    create_myobject()
    create_test()
    create_git()
    add_packages()

    module_name = get_module()

    println("To add inside $module_name.jl :")
    println("")
    println("""include("myobject.jl")""")
    println("export MyObject")
    println("")

    println("Now use start() each time you come back")

    println("run 'using '$module_name'")
end

function start()
    Pkg.activate(".")
    module_name = Symbol(get_module())
    println("using $module_name")
    eval(Main, :(using $module_name))
end

function test()
    # Pkg.test()
    include("test/runtests.jl")
end

function cover()
    module_name = get_module()
    generate_coverage(module_name)
    Coverage.clean_folder(".")
    open_coverage(module_name)
end

end # module
