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
    # Inisialisai (Konstruktor)
    # Pendekatan program dinamis maju (bottom-up approach)
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
    #Mendapatkan hash table dari cost
    def getcost()
        return @cost
    end
    def tsp(s)
        #s adalah start node
        n = @jumlah_node
        #inisialisasi matriks memo
        #memo = Matrix.zero(@jumlah_node, 2**@jumlah_node)
        #memo = Matrix.zero(@jumlah_node, 2**@jumlah_node)
        @memo = Array.new(@jumlah_node) {Array.new(2**@jumlah_node)}
        # m adalah Matrix yang merepresentasikan graph
        m = @matriks_data
        setup(m, @memo, s, n)
        solve(m, @memo, s, n)
        minCost = findMinCost(m, @memo, s, n)
        tour = findOptimalTour(m, @memo, s, n)
        return [minCost,tour]
        #untuk memanggilnya,cukup masukkan a,b = tsp(m, s)
    end
    def setup(m, memo, s, n) 
        # Inisialisasi tabel memo dengan memasukkan seluruh solusi optimal
        # dari node awal ke seluruh node lain
        for i in 0..n-1
            next if i==s
            # Memasukkan solusi optimal dari node start ke setiap node i
            hitung = 1 << s | 1 << i
            memo[i][hitung] = m[s,i]
        end 
    end 
    def notIn(i, subset)
        #mengembalikan true apabila bit ke-i dalam 'subset' bukanlah set
        return ((1<<i) & subset) == 0
    end
    def combinations(r, n)
        #Generate seluruh set bit dari size n
        subsets = []
        combination(0, 0, r, n, subsets)
        return subsets
    end
    def combination(set, at, r, n, subsets)
        if r==0
            subsets.push(set)
        else
            for i in at..n-1
            #flip bit ke-i
                set = set | (1<<i)
                combination(set, i+1, r-1, n, subsets)

                #Backtrack dan flip bit ke i
                set = set & ~(1 << i)
            end
        end
    end
    def findMinCost(m, memo, s, n)
        #State terakhir adalah bit mask dengan Bits n set ke 1
        end_state = (1<<n) - 1

        minTourCost ||= Float::INFINITY

        for e in 0..n-1
            next if e==s

            tourCost = memo[e][end_state] + m[e,s]
            if tourCost < minTourCost
                minTourCost = tourCost
            end
        end
        return minTourCost
    end
    def findOptimalTour(m, memo, s, n)
        lastIndex = s
        state = (1 << n) - 1 #end state
        #membuat array tour baru
        tour = Array.new
        n+1.times do
            tour.push 0
        end
        for i in (n-1).downto(1)
            index = -1
            for j in 0..n
                next if j==s || notIn(j, state)
                if (index == -1)
                    index = j
                end
                prevDist = memo[index][state] + m[index,lastIndex]
                newDist = memo[j][state] + m[j,lastIndex]
                if newDist < prevDist
                    index = j
                end
            end
            tour[i] = index
            state = state ^ (1 << index)
            lastIndex = index
        end
        tour[0] = s
        tour[n] = s
        return tour
    end
    def solve(m, memo, s, n)
        for r in 3..n
        # fungsi kombinasi akan generate semua set bit sebesar size N dengan
        # bit r yang di set ke 1
            for subset in combinations(r, n)
                next if notIn(s, subset)
                for nextnya in 0..n-1
                    next if nextnya==s || notIn(nextnya, subset)
                    #state subset tanpa node berikutnya
                    state = subset ^ (1 << nextnya)
                    minDist ||= Float::INFINITY
                    # e adalah short untuk node akhir
                    for e in 0..n-1
                        next if e==s || e==nextnya || notIn(e, subset)
                        newDistance = memo[e][state] + m[e,nextnya]
                        if newDistance < minDist
                            minDist = newDistance
                        end
                    end
                    memo[nextnya][subset] = minDist
                end
            end
        end
    end
    private :initialize, :dist
end

input = Input.new("test/input3.txt")
#input.printStatus()
#puts input.getjumlahnode()
main = ProgramDinamis.new(input.getmatriksdata().map(&:to_i), input.getjumlahnode())
cost,tour = main.tsp(0)
puts cost
print tour