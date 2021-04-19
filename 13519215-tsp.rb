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
    private :initialize, :readfile, :createMatrix

end

class ProgramDinamis
    def initialize(matriks_data, jumlah_node)
        @matriks_data = matriks_data
        @jumlah_node = jumlah_node
        @visited = Array.new
        @jumlah_node.times do
            visited.push 0
        end
        @cost = 0
    end
    def dist(start,target)
        return @matriks_data[start,target]
    end
    def TSP(N,s)
        #inisialisasi array visited
        @visited[s] = 1
        if(N.count() == 2) && k != s
            




    end
end
input = Input.new("test/input.txt")
input.printStatus()

#def dist(start, target)

