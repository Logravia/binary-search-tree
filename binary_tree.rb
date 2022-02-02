#!/usr/bin/env ruby

require 'pry-byebug'
require_relative 'node'

class Tree
  def initialize(arr=[])
    @root = build_tree(arr)
  end
  def build_tree(arr)
    arr.sort!.uniq!
    build_nodes(arr)
  end
  def build_nodes(arr)
    return Node.new(arr.first) if arr.size < 2
    mid_point = arr.size/2
    mid_node = Node.new(arr[mid_point])
    mid_node.left = build_nodes(arr[0...mid_point])
    mid_node.right = build_nodes(arr[mid_point+1..arr.size])
    mid_node
  end
end

pp Tree.new([1,2,3,4,5,6,7])
