function sum_a_b(x, y; key1=1, key2=2)
    return sum([x, y, key1, key2])
end

println(sum_a_b(1, 2))
println(sum_a_b(1, 2; key2=5, key1=6))

struct myStruct
    name::String
    age::Int64
end

julio = myStruct("Julio", 48)

typeof(julio)
fieldnames(myStruct)
fieldtypes(myStruct)

