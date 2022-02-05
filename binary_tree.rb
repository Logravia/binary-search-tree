#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'node'
require 'pry-byebug'

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

      next unless cur_node.nil?

      if new_node < prev_node
        prev_node.left = new_node
      else
        prev_node.right = new_node
      end
      break
    end
  end

  def find_node(val)
    prev_node = @root
    cur_node = @root
    val = Node.new(val)

    until cur_node.leaf?
      return cur_node, prev_node if cur_node == val

      if val < cur_node
        prev_node = cur_node
        cur_node = cur_node.left
      else
        prev_node = cur_node
        cur_node = cur_node.right
      end
    end

    [cur_node, prev_node] if cur_node == val
  end

  def min_largest(root)
    return nil if root.right.nil?

    prev_node = root
    cur_node = root.right
    until cur_node.leaf?
      prev_node = cur_node
      cur_node = cur_node.left
    end
    [prev_node, cur_node]
  end

  def remove_node(to_remove, prev_node)
    if to_remove.leaf?
      prev_node.left == to_remove ? prev_node.left = nil : prev_node.right = nil
      to_remove
    elsif to_remove.single_child?
      child = to_remove.the_child
      prev_node.left == to_remove ? prev_node.left = child : prev_node.right = child
      to_remove
    else
      parent, min_bigger_node = min_largest(to_remove)
      to_remove.data = min_bigger_node.data
      remove_node(min_bigger_node, parent)
    end
  end

  def remove(val)
    to_remove, parent = find_node(val)
    return nil if to_remove.nil?

    remove_node(to_remove, parent)
    to_remove
  end

  def level_order(root = @root)
    node_queue = [root]
    values = []
    until node_queue.empty?
      node = node_queue.shift
      node_queue << node.left unless node.left.nil?
      node_queue << node.right unless node.right.nil?
      block_given? ? yield(node) : values << node.data
    end
    block_given? ? nil : values
  end

  def inorder(root = @root, values = [])
    return if root.nil?

    inorder(root.left, values)
    values << root.data
    inorder(root.right, values)
    values
  end

  def preorder(root = @root, values = [])
    return if root.nil?

    values << root.data
    preorder(root.left, values)
    preorder(root.right, values)
    values
  end

  def postorder(root = @root, values = [])
    return if root.nil?

    postorder(root.left, values)
    postorder(root.right, values)
    values << root.data
    values
  end

  def height(node=@root)
    return -1 if node.nil?
    l_height = height(node.left)
    r_height = height(node.right)
    [l_height, r_height].max + 1
  end

  def depth(node)
    cur_node = @root
    depth = 0
    until cur_node.nil?
      return depth if cur_node == node
      cur_node = node < cur_node ? cur_node.left : cur_node.right
      depth += 1
    end
    nil
  end

  def balanced?
    level_order do |node|
      return false if not node_balanced?(node)
    end
    true
  end

  def node_balanced?(root=@root)
    l_height = height(root.left)
    r_height = height(root.right)
    diff = (l_height.abs - r_height.abs).abs
    is_balanced = diff <= 1
    is_balanced
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
