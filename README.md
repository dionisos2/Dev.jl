# Dev
A package to help my personnal workflow
## How to use
### Install
```console

shell> julia

julia> ]

pkg> add https://github.com/dionisos2/Utils.jl

pkg> add https://github.com/dionisos2/Dev.jl

```
### Building a new package
```console

shell> cd /path/to/julia/projects

shell> julia

julia> ]

pkg> generate Tmp

julia> ;

shell> cd Tmp

julia> using Dev

julia> init()
```
### Starting a new session
```console

shell> cd /path/to/package

shell> julia

julia> using Dev

julia> start()
```
### Testing package
```console

julia> test()

julia> cover() # You will need the genhtml command(markdown) to see stuffs

```
