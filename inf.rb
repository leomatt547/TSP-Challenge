csjfinal ||= Float::INFINITY
data_final = data.reject { |b| b == start }
for i in data_final
    s_j = data.reject { |a| a == i }
    temp = @cost.fetch([i,s_j]) + dist(start,i)
    if temp < csjfinal
        csjfinal = temp
    end
end