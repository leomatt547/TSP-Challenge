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
    #membuat matriks darir input filenya
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
        for kunci in 0..n-1
            @cost.merge!({[kunci,[kunci]] => Float::INFINITY})
            @cost.merge!({[kunci,[]] => dist(kunci,start)})
        end
        for s in 2..n-1
            for subsets in kombin(data, s)
                if subsets.include?(start)
                    @cost.merge!({[start,subsets] => Float::INFINITY})
                end
                next if subsets.include?(start)
                subsets.each do |j|
                    next if j==start || subsets.include?(start)
                    csj ||= Float::INFINITY
                    subsets.each do |i|
                        next if i==j || i==start || dist(i,j) <= 0
                        s_j = subsets.reject { |a| a == i }
                        temp = @cost.fetch([j, s_j.reject { |a| a == j }]) + dist(i,j)
                        if temp < csj
                            csj = temp
                        end
                    end
                    @cost.merge!({[j,subsets.reject { |a| a == j }] => csj})
                end
            end
        end
        csjfinal ||= Float::INFINITY
        data_final = data.reject { |b| b == start }
        data_final.each do |i|
            s_j = data_final.reject { |a| a == i }
            temp = @cost.fetch([i,s_j.reject{|s| s==i}]) + dist(start,i)
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

input = Input.new("test/input3.txt")
#input.printStatus()
#puts input.getjumlahnode()
main = ProgramDinamis.new(input.getmatriksdata().map(&:to_i), input.getjumlahnode())
#print input.getmatriksdata().map(&:to_i)
data = (0..(input.getjumlahnode()-1)).map(&:to_i)
#data = data.map(&:to_i)
#puts data.count()
#data = data.reject { |a| a == 2 }
main.tsp(data, 0)
alpha =  (main.getcost())
print alpha.to_a.last
#puts alpha.fetch([0, [1, 2, 3]])