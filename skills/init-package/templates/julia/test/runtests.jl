using {{PACKAGE_NAME_PASCAL}}
using Test

@testset "{{PACKAGE_NAME_PASCAL}}.jl" begin
    @testset "main_function" begin
        x = [1.0, 2.0, 3.0]
        @test main_function(x) == x
    end
end
