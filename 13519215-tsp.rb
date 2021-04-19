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
        puts dist(0,1)
    end
    #Mengembalikan jarak antar 2 kota
    def dist(start,target)
        return @matriks_data[start,target]
    end
    def TSP(n,s)
        #inisialisasi array visited
        @visited[s] = 1
        if n.count()==2 && n[1] != s
            @cost.merge!({[n,n[1]] => dist(n[1],n[0])})
            return @cost.fetch([n,n[1]])
        else
            for i in 0..n.count()-1
                for j in 0..n.count()-1
                    if @visited[i]==0 && j!=i && j!=s
                        @cost[[n,j]] = min(TSP((n.reject { |a| a == i }), j) + dist(j,i))
                        @visited[j] = 1
                    end
                end
            end
        end
        return @cost.fetch([n,j])
    end
    #Mendapatkan hash table dari cost
    def getcost()
        return @cost
    end
    private :initialize, :dist
end

input = Input.new("test/input.txt")
#input.printStatus()
#puts input.getjumlahnode()
main = ProgramDinamis.new(input.getmatriksdata(), input.getjumlahnode())
data = (0..(input.getjumlahnode()-1)).to_a
data = data.map(&:to_i)
#puts data.count()
#data = data.reject { |a| a == 2 }
main.TSP(data, 0)
alpha =  (main.getcost())
puts alpha
puts (alpha[[[0,1],1]])
print alpha.fetch([[0,1],1])