class Move
    @@moves_collection = []
    attr_accessor :data, :adjacents
    def initialize(data)
        @data = data
        @adjacents = []
        @@moves_collection << data
    end

    def self.moves_collection
        @@moves_collection
    end
end
class Knight
    def initialize(data=[0,0])
        @moves = possible_moves(data)
    end

    def possible_moves(data, collection=[])
        move = Move.new(data)
        collection << move
        y = data[0]
        x = data[1]
        data_array = [[y-1,x-2], [y-1,x+2], [y+1,x-2], [y+1,x+2],
                        [y-2,x-1], [y-2,x+1], [y+2, x-1], [y+2,x+1]]
        board = make_board
        data_array.select! {|data| board.any?(data)}
        data_array.each do |data|
            if Move.moves_collection.any?(data)
                adjacent = collection.select {|node| node.data == data}
            else  
                adjacent = possible_moves(data, collection)
            end
            move.adjacents << adjacent
        end
        move
        #return a Move object
    end
    def make_board
        m = (0..7).to_a
        m = m.zip(m).flatten
        board = []
        m.repeated_permutation(2) { |permutation| board << permutation }
        board
    end
    def knight_moves(start, endPoint)
        nodeStart = find_breadth(start)
        queue = [nodeStart]
        alreadyTraversed = []
        path = []
        until path.length > 0 do 
            queue.each do |node|
                adjacents_data = node.adjacents.collect {|adj| adj.data}
                if adjacents_data.include?(endPoint)
                    path.push(node.data)
                    break
                else 
                    alreadyTraversed << queue.shift
                    queue.concat(node.adjacents)
                end
            end
        end
        if alreadyTraversed.length > 0 
            flagStop = false
            until flagStop == true || alreadyTraversed.empty? do      
                alreadyTraversed.each do |node|
                    node_adjacents_data = node.adjacents.collect {|adj| adj.data}
                    if node_adjacents_data.include?(path[0])
                        path.unshift(node.data)
                        alreadyTraversed.delete(node)
                    else 
                        flagStop = true
                        break
                    end
                end
            end
        end
        path.push(endPoint)
        path
    end
    def find_depth(move, node = @moves, alreadyTraversed =[])
        unless node.data == move
            alreadyTraversed << node.data
            result = ''
            node.adjacents.each do |adjacent|
                next if alreadyTraversed.any?(adjacent.data) 
                result = find_depth(move, adjacent, alreadyTraversed)
                break unless result.empty?
            end
        else 
            return node 
        end
        result
    end

    def find_breadth(move, parents = [@moves], alreadyTraversed = [])
        result = ''
        parents_data = parents.collect {|parent| parent.data}
        unless parents_data.any?(move)
            alreadyTraversed.concat(parents_data) 
            children = []
            parents.each do |parent|
                next if alreadyTraversed.include?(parent.data)
                children.concat(parent.adjacents)
            end
            return find_breadth(move, children, alreadyTraversed)
        else 
            result = parents.select {|parent| parent.data == move}[0]
        end
    end
end

knight = Knight.new
p knight.knight_moves([0,0],[1,2])