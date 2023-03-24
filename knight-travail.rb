class Move
    @@moves_collection = []
    @@moves_collection_data = []
    attr_accessor :data, :adjacents
    def initialize(data)
        @data = data
        @adjacents = []
        @@moves_collection_data << data
        @@moves_collection << self
    end

    def self.moves_collection
        @@moves_collection
    end
    def self.moves_collection_data
        @@moves_collection_data
    end
end
class Knight

    def forward_traverse(start, endPoint)
        queue = []
        alreadyTraversed = []
        if Move.moves_collection_data.any?(start)
            nodeStart = Move.moves_collection.select {|node| node.data == start}[0]
        else 
            nodeStart = Move.new(start) 
        end
        queue << nodeStart
        node = nil
        loop do 
            node = queue[0]
            if node.adjacents.empty?
                y = node.data[0]
                x = node.data[1]
                data_array = [[y-1,x-2], [y-1,x+2], [y+1,x-2], [y+1,x+2],
                                [y-2,x-1], [y-2,x+1], [y+2, x-1], [y+2,x+1]]
                board = make_board
                data_array.select! {|data| board.any?(data)}
                data_array.each do |data|
                    if Move.moves_collection_data.any?(data)
                        adjacent = Move.moves_collection.select {|node| node.data == data}[0]
                    else 
                        adjacent = Move.new(data)
                    end
                    node.adjacents << adjacent
                end
            end
            node_adjacents_data = node.adjacents.collect {|adj| adj.data}
            break if node_adjacents_data.include?(endPoint)
            queue.concat(node.adjacents)
            alreadyTraversed << queue.shift
        end  
        result = [node, alreadyTraversed]
    end
    def backward_traverse(arr)
        alreadyTraversed = arr[1]
        path = [arr[0].data]
        until alreadyTraversed.empty? do      
            alreadyTraversed.each_with_index do |node, index|
                node_adjacents_data = node.adjacents.collect {|adj| adj.data}
                if node_adjacents_data.include?(path[0])
                    path.unshift(node.data)
                    alreadyTraversed = alreadyTraversed[0...index]
                    break                        
                end
            end
        end
        path
    end
    
    def make_board
        m = (0..7).to_a
        board = []
        m.repeated_permutation(2) { |permutation| board << permutation }
        board
    end
    def knight_moves(start, endPoint)
        arr = forward_traverse(start, endPoint)
        path = backward_traverse(arr)
        path.push(endPoint)
        p path
    end
end


knight = Knight.new

knight.knight_moves([3,3], [4,3])
knight.knight_moves([0,0], [7,7])