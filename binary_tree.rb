#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry-byebug'
require_relative 'node'

class Tree
  def initialize(arr = [])
    @root = build_tree(arr)
  end

  def build_tree(arr)
    arr.sort!.uniq!
    build_nodes(arr)
  end

  def build_nodes(arr)
    return nil if arr.empty?
    return Node.new(arr.first) if arr.size == 1

    mid_point = arr.size / 2
    mid_node = Node.new(arr[mid_point])
    mid_node.left = build_nodes(arr[0...mid_point])
    mid_node.right = build_nodes(arr[mid_point + 1...arr.size])

    mid_node
  end

  def insert(val)
    prev_node = @root
    cur_node = @root
    new_node = Node.new(val)
    loop do
      if new_node < cur_node
        prev_node = cur_node
        cur_node = cur_node.left
      else
        prev_node = cur_node
        cur_node = cur_node.right
      end

      if cur_node.nil?
       if new_node < prev_node
         prev_node.left = new_node
         break
       else
         prev_node.right = new_node
         break
       end
      end
    end

  end
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

Tree.new(arr).pretty_print
