require 'matrix'

#KELAS INPUT
class Input
    #Inisialisasi input file dan proses awal
    def initialize(namafile)
        @namafile = namafile
        readfile(@namafile)
        createMatrix()
    end
    #Read file input
    def readfile(namafile)
        @file_data = File.read(namafile).split
        @jumlah_node = Math.sqrt(@file_data.count()).round
    end
    #membuat matriks dari input filenya
    def createMatrix()
        #matriks = Matrix.new
        @matriks_data = Matrix.zero(@jumlah_node)
        for i in 0..@jumlah_node-1
            for j in 0..@jumlah_node-1
                @matriks_data[i,j] = @file_data[i*@jumlah_node+ j]
            end
        end
    end
    # Mengetahui data input yang kita punya
    def printStatus()
        puts "matriks_data: #{@matriks_data}"
        puts "jumlah node sebanyak: #{@jumlah_node}"
    end
    #mendapatkan matriks data
    def getmatriksdata()
        return @matriks_data
    end
    #mendapatkan jumlah node
    def getjumlahnode()
        return @jumlah_node
    end
    private :initialize, :readfile, :createMatrix

end

class ProgramDinamis
    #Inisialisai (Konstruktor)
    def initialize(matriks_data, jumlah_node)
        @matriks_data = matriks_data
        @jumlah_node = jumlah_node
        @visited = Array.new
        @jumlah_node.times do
            @visited.push 0
        end
        @cost = Hash.new
    end
    #Mengembalikan jarak antar 2 kota
    def dist(start,target)
        return @matriks_data[start,target]
    end
    def kombin(a, ukuran)
        arr = []
        arr = arr + a.combination(ukuran).to_a
        return arr
    end
    def tsp(data,start)
        n = @jumlah_node
        @cost.merge!({[start,[start]] => 0})
        for kunci in 0..n
            @cost.merge!({[kunci,[kunci]] => Float::INFINITY})
            @cost.merge!({[kunci,[]] => dist(kunci,start)})
        end
        for s in 2..n-1
            for subsets in kombin(data, s)
                if subsets.include?(start)
                    @cost.merge!({[start,subsets] => Float::INFINITY})
                end
                next if subsets.include?(start)
                subsets.each do |i|
                    next if i==start || subsets.include?(start)
                    #Apabila i = start atau i dan start bukan subsetnya, continue
                    subsets_i = subsets.reject{|a| a == i}
                    csj ||= Float::INFINITY
                    subsets_i.each do |j|
                        s_j = subsets_i.reject { |b| b == j }
                        next if j==i || j==start || dist(i,j) <= 0 || s_j.include?(start)
                        #Penjumlahan dilakukan dengan C(i,j) + f(j,subset-j)
                        temp =  dist(i,j) + @cost.fetch([j, s_j])
                        #puts "{c#{i+1},#{j+1} + f(#{j+1},#{s_j}} = {#{dist(i,j)}+#{@cost.fetch([j, s_j])} = #{temp}}"
                        if temp < csj
                            csj = temp
                        end
                    end
                    @cost.merge!({[i,subsets_i] => csj})
                    #puts "{Hasil akhir c#{i+1},#{subsets_i} = #{csj}}"
                end
            end
        end
        csjfinal ||= Float::INFINITY
        data_final = data.reject { |b| b == start }
        data_final.each do |i|
            s_j = data_final.reject { |a| a == i }
            temp = dist(start,i) + @cost.fetch([i, s_j])
            #puts "{c#{start},#{i} + f(#{i},#{s_j}} = {#{dist(start,i)}+#{@cost.fetch([i, s_j])} = #{temp}}"
            if temp < csjfinal
                csjfinal = temp
            end
        end
        @cost.merge!({[start,data_final]=>csjfinal})
    end
    #Mendapatkan hash table dari cost
    def getcost()
        return @cost
    end
    private :initialize, :dist
end

#main
input = Input.new("test/input3.txt")
main = ProgramDinamis.new(input.getmatriksdata().map(&:to_i), input.getjumlahnode())
data = (0..(input.getjumlahnode()-1)).map(&:to_i)
main.tsp(data, 0)
alpha =  (main.getcost())
kunci = alpha.keys.to_a.last
puts "Jarak rute terpendek yang dapat dilalui sebesar : #{alpha.fetch(kunci)}"