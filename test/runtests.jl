using Test

module m1
using Test
using FRFComparisons
function test()
    t = 0:0.1:5
    x = cos.(t)
    y = cos.(t)
    @test cssf(t, x, y) ≈ 1.0
    @test cssf(t, y, x) ≈ 1.0
    @test csac(t, y, x) ≈ 1.0
    @test csac(t, x, y) ≈ 1.0
    @test frfsm(t, y, x) ≈ 1.0
    @test frfsm(t, x, y) ≈ 1.0
end
test()
nothing
end

module m2
using Test
using FRFComparisons
function test()
    t = 0:0.01:2*pi
    x = cos.(t)
    y = sin.(t)
    for f in [cssf, csac, ]
        @test f(t, x, x) ≈ 1.0
        @test f(t, y, y) ≈ 1.0
        @test abs(f(t, x, y))  <  5e-6
        @test abs(f(t, y, x))  <  5e-6
    end
end
test()
nothing
end

module m3
using Test
using FRFComparisons
function test()
    t = 0:0.01:2*pi
    x = cos.(t) .+ 3.4
    y = sin.(t) .+ 1.1
    for f in [frfsm, ]
        @test f(t, x, x) ≈ 1.0
        @test f(t, y, y) ≈ 1.0
    end
end
test()
nothing
end

module m4
using Test
using FRFComparisons
function test()
    t = 0:0.01:2*pi
    x = cos.(t) .+ 3.4
    y = x .+ 0.1 .* rand(length(x))
    for f in [cssf, csac, frfsm, ]
        @test abs(f(t, x, y) - 1) < 1.0e-3
        @test abs(f(t, y, x) - 1) < 1.0e-3
    end
end
test()
nothing
end
