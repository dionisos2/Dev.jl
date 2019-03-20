# Dev
A package to help my personnal workflow
## How to use
### Starting a new package
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
### Testing package
```console

julia> test()

julia> cover() # You will need the genhtml command(markdown) to see stuffs

```
